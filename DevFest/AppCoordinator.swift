//
//  AppCoordinator.swift
//  DevFest
//
//  Created by Brendon Justin on 11/23/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit

import GoogleSignIn

/**
 "Owns" the app in a way that the UIApplicationDelegate often does in other apps.
 */
class AppCoordinator {
    fileprivate let firebaseCoordinator = FirebaseCoordinator()
    fileprivate let settingsCoordinator: SettingsCoordinator
    
    private let signInNotifier = GoogleSignInNotifier()
    
    // View controllers
    private let tabBarController: UITabBarController
    private let sessionsViewController: SessionsViewController
    private let starredSessionsViewController: SessionsViewController
    private let speakersViewController: SpeakersViewController
    private let mapViewController: MapViewController
    // Rely on the `settingsCoordinator` to manage the settings view controller.
    // We do need a reference to the settings view controller's nav controller though.
    fileprivate let settingsNavigationController: UINavigationController
    
    private let firebaseDateFormatter = DateFormatter()
    private let sectionHeaderDateFormatter = DateFormatter()
    
    private let multiSessionStarsDataSourceDelegate = MultiSessionStarsDataSourceDelegate()
    
    private let faceDetector: ImageFaceDetector
    
    /**
     The object to manage downloading and providing images for speakers.
     */
    private let imageRepository: ImageRepository
    
    /**
     We can't create this until we've `start`ed our `firebaseCoordinator`,
     since Firebase may otherwise not yet be ready.
     */
    fileprivate var firebaseStarsDataSource: FirebaseStarsDataSource!
    
    /**
     Set this just before attempting to sign in silently with GIDSignIn in `start`,
     and unset it after we get a success or failure.
     */
    fileprivate var isSigningInSilently = false
    
    /**
     The user's Firebase user ID, if they have signed in. Uses the `firebaseCoordinator`,
     so do not use this property until our child coordinators are `start`ed.
     */
    private var firebaseUserID: String? {
        return firebaseCoordinator.firebaseUserID
    }
    
    /**
     The user's Google user ID, if they have signed in. Uses the `GIDSignIn` shared instance,
     which may not be safe before all of our child coordinators are `start`ed.
     */
    private var googleUserID: String? {
        return GIDSignIn.sharedInstance().currentUser?.userID
    }
    
    init(tabBarController: UITabBarController) {
        sessionsViewController = tabBarController.tabInNavigationController(atIndex: 0) as SessionsViewController
        starredSessionsViewController = tabBarController.tabInNavigationController(atIndex: 1) as SessionsViewController
        speakersViewController = tabBarController.tabInNavigationController(atIndex: 2) as SpeakersViewController
        mapViewController = tabBarController.tab(atIndex: 3) as MapViewController
        settingsNavigationController = tabBarController.tab(atIndex: 4) as UINavigationController
        
        let settingsViewController = tabBarController.tabInNavigationController(atIndex: 4) as SettingsViewController
        settingsCoordinator = SettingsCoordinator(viewController: settingsViewController)
        
        self.tabBarController = tabBarController
        
        self.faceDetector = ImageFaceDetector()
        
        let urlSession = URLSession.shared
        let cacheDirectory = { () -> URL in
            let fileManager = FileManager.default
            // TODO: Work out a recovery strategy for when this doesn't work
            let directory = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return directory
        }()
        self.imageRepository = ImageRepository(urlSession: urlSession, cacheDirectory: cacheDirectory, faceDetector: self.faceDetector)
        
        firebaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        sectionHeaderDateFormatter.dateFormat = "hh:mm a"
    }
    
    func start() {
        firebaseCoordinator.start()
        settingsCoordinator.start()
        
        // Make sure the AppearanceNotifier singleton has been created by now.
        _ = AppearanceNotifier.shared
        
        
        // Set up Google auth using the client ID that Firebase made when we created this app
        // in the Firebase console.
        let signIn = GIDSignIn.sharedInstance()!
        signIn.clientID = firebaseCoordinator.googleClientID
        signIn.delegate = signInNotifier
        
        // If the user has signed in once already and has not signed out, then we have
        // to attempt to sign in silently on every launch to have the Google library
        // continue to let us use that sign in.
        signIn.signInSilently()
        
        
        // Wait until after we've `start`ed our child coordinators before we access `googleUserID`,
        // since its comment says it may not be safe before then.
        settingsCoordinator.isSignedIn = googleUserID != nil
        
        signInNotifier.didSignIn = { [unowned self] (signIn, user, error) in
            defer {
                self.isSigningInSilently = false
            }
            
            if self.isSigningInSilently, let firebaseUserID = self.firebaseUserID {
                self.didSignIn(firebaseUserID: firebaseUserID)
                return
            }
            
            if let user = user {
                self.firebaseCoordinator.signIn(forGoogleUser: user)
            }
        }
        
        signInNotifier.didDisconnectSignIn = { [unowned self] (signIn, user, error) in
            self.isSigningInSilently = false
            
            if let user = user {
                self.firebaseCoordinator.disconnectSignIn(forGoogleUser: user)
            }
            self.didDisconnectSignIn()
        }

        
        firebaseCoordinator.signInCallback = { [unowned self] (user, error) in
            if let _ = error {
                GIDSignIn.sharedInstance().signOut()
                return
            }
            
            guard let firebaseUserID = self.firebaseUserID else {
                NSLog("No Firebase user ID available when Firebase sign in succeeded.")
                return
            }
            
            self.didSignIn(firebaseUserID: firebaseUserID)
        }
        
        
        // Set titles for our view controllers in code to avoid having many localizable strings
        // in our storyboards.
        sessionsViewController.title = NSLocalizedString("Sessions", comment: "tab title")
        starredSessionsViewController.title = NSLocalizedString("Your Schedule", comment: "tab title")
        speakersViewController.title = NSLocalizedString("Speakers", comment: "tab title")
        mapViewController.title = NSLocalizedString("Map", comment: "tab title")
        // Rely on `settingsCoordinator` to set `settingsViewController`'s title.
        
        
        // Set data sources on our view controllers
        firebaseStarsDataSource = FirebaseStarsDataSource()
        firebaseStarsDataSource.sessionStarsDataSourceDelegate = multiSessionStarsDataSourceDelegate
        
        
        // introduce new scopes to avoid similar-sounding variables being available to cause confusion later
        do {
            let firebaseSessionsDataSource = FirebaseSessionDataSource(firebaseDateFormatter: firebaseDateFormatter, sectionHeaderDateFormatter: sectionHeaderDateFormatter)
            
            let sessionDataSource = CombinedSessionDataSource(dataSource: firebaseSessionsDataSource, starsDataSource: firebaseStarsDataSource)
            firebaseSessionsDataSource.sessionDataSourceDelegate = sessionDataSource
            multiSessionStarsDataSourceDelegate.broadcastDelegates.append(sessionDataSource)
            
            sessionsViewController.dataSource = sessionDataSource
            
            let speakerDataSource = FirebaseSpeakerDataSource()
            sessionsViewController.speakerDataSource = speakerDataSource
        }
        
        
        do {
            let starredSessionsFirebaseDataSource = FirebaseSessionDataSource(firebaseDateFormatter: firebaseDateFormatter, sectionHeaderDateFormatter: sectionHeaderDateFormatter)
            
            let starredSessionsDataSource = CombinedSessionDataSource(dataSource: starredSessionsFirebaseDataSource, starsDataSource: firebaseStarsDataSource)
            starredSessionsDataSource.shouldIncludeOnlyStarred = true
            multiSessionStarsDataSourceDelegate.broadcastDelegates.append(starredSessionsDataSource)
            
            starredSessionsViewController.dataSource = starredSessionsDataSource
        }
        
        
        do {
            let speakerDataSource = FirebaseSpeakerDataSource()
            speakerDataSource.speakerDataSourceDelegate = speakersViewController
            
            speakersViewController.speakerDataSource = speakerDataSource
        }
        
        
        // Provide the image repository
        sessionsViewController.imageRepository = imageRepository
        speakersViewController.imageRepository = imageRepository
    }
}

private extension AppCoordinator {
    func didSignIn(firebaseUserID: String) {
        let shouldMerge = !isSigningInSilently
        firebaseStarsDataSource.setFirebaseUserID(firebaseUserID, shouldMergeLocalAndRemoteStarsOnce: shouldMerge)
        settingsCoordinator.isSignedIn = true
        
        // Pop out of any settings the user was looking at if they signed in,
        // since the settings tab is the only place we let them sign in manually.
        if !isSigningInSilently {
            settingsNavigationController.popToRootViewController(animated: true)
        }
    }
    
    func didDisconnectSignIn() {
        firebaseStarsDataSource.setFirebaseUserID(nil, shouldMergeLocalAndRemoteStarsOnce: false)
        settingsCoordinator.isSignedIn = false
        // Pop out of any settings the user was looking at if they get signed out.
        settingsNavigationController.popToRootViewController(animated: true)
    }
}


/**
 Exposes GIDSignInDelegate methods as blocks. Having a separate class for this allows
 `AppCoordinator` to not subclass `NSObject`.
 */
private class GoogleSignInNotifier: NSObject, GIDSignInDelegate {
    var didSignIn: (GIDSignIn?, GIDGoogleUser?, Error?) -> Void = { _ in }
    var didDisconnectSignIn: (GIDSignIn?, GIDGoogleUser?, Error?) -> Void = { _ in }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            NSLog("Error signing in to Google: \(error)")
            return
        }
        
        didSignIn(signIn, user, error)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        didDisconnectSignIn(signIn, user, error)
    }
}


private extension UITabBarController {
    func tab<ViewController: UIViewController>(atIndex index: Int) -> ViewController {
        let vc = viewControllers![index] as! ViewController
        return vc
    }
    
    func tabInNavigationController<ViewController: UIViewController>(atIndex index: Int) -> ViewController {
        let navController = viewControllers![index] as! UINavigationController
        let vc = navController.viewControllers[0] as! ViewController
        return vc
    }
}

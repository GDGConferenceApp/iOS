//
//  DevFestScreenshots.swift
//  DevFest Screenshots
//
//  Created by Brendon Justin on 1/31/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import XCTest

class DevFestScreenshots: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        XCUIDevice.shared().orientation = UIDeviceOrientation.portrait
    }
    
    func testTakeScreenshots() {
        let app = XCUIApplication()
        
        // Wait until Firebase has downloaded data and we're displaying it.
        // This code depends only a little (this "Registration" string) on DevFest MN 2017 data.
        // It would be better to not depend on specific data at all, if possible.
        // This code also depends on English strings, where it should use localized strings instead.
        // Some screenshots may be taken before inages can load in the target view.
        // This is another property of this code that should be changed.
        let label = app.staticTexts["Registration"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        snapshot("01-Sessions", waitForLoadingIndicator: false)
        
        let sessionsCollectionViewsQuery = app.collectionViews
        // Try to tap the third collection view cell
        sessionsCollectionViewsQuery.children(matching: .cell).element(boundBy: 2).tap()
        
        snapshot("02-Single_Session", waitForLoadingIndicator: false)
        
        app.tabBars.buttons["Speakers"].tap()
        
        snapshot("03-Speakers", waitForLoadingIndicator: false)
        
        let speakersCollectionViewsQuery = app.collectionViews
        speakersCollectionViewsQuery.children(matching: .cell).element(boundBy: 0).tap()
        
        snapshot("04-Single_Speaker", waitForLoadingIndicator: false)
        
        /*
         // We don't have a map yet, so don't take a screenshot on the map view.
        app.tabBars.buttons["Info"].tap()
        app.staticTexts["Map"].tap()
        
        snapshot("05-Map", waitForLoadingIndicator: false)
        */
    }
}

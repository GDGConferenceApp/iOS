//
//  SettingsViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 1/8/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    weak var delegate: SettingsDelegate?
    
    var mapFileURL: URL?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use static cells defined in the storyboard
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.font = .dev_reusableItemTitleFont
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.destination {
        case let signInVC as GoogleSignInViewController:
            delegate?.prepareGoogleSignInViewController(signInVC)
        case let mapVC as VenueMapViewController:
            mapVC.mapFileURL = mapFileURL
        default:
            NSLog("Unhandled segue")
        }
    }
}

protocol SettingsDelegate: class {
    func prepareGoogleSignInViewController(_ viewController: GoogleSignInViewController)
}

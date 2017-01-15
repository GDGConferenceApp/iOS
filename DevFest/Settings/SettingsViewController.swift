//
//  SettingsViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 1/8/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use static cells defined in the storyboard
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.font = .dev_reusableItemTitleFont
        return cell
    }
}

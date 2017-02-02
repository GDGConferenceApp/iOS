//
//  VenueMapViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 2/1/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit
import QuickLook

class VenueMapViewController: UIViewController, QLPreviewControllerDataSource {
    var mapFileURL: URL?
    
    private var activeMapIndex: Int = 0 {
        didSet {
            previewController.reloadData()
        }
    }
    
    let previewController = QLPreviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Map", comment: "Venue map view controller title")
        
        previewController.dataSource = self
        previewController.automaticallyAdjustsScrollViewInsets = true
        
        previewController.view.backgroundColor = UIColor.clear
        view.dev_addSubview(previewController.view)
        
        let constraints: [NSLayoutConstraint] = [
            previewController.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            previewController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            previewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        addChildViewController(previewController)
        
        previewController.currentPreviewItemIndex = 0
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        if let _ = mapFileURL {
            return 1
        } else {
            return 0
        }
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        // `URL` doesn't conform to `QLPreviewItem`, but `NSURL` does.
        return mapFileURL! as NSURL
    }
}

//
//  DataSource.swift
//  DevFest
//
//  Created by Brendon Justin on 12/22/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import Foundation

protocol DataSource {
    var sections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
}

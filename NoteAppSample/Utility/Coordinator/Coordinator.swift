//
//  Coordinator.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

/// Protocol which defines required functionality for all coordinator classes.
protocol Coordinator: class {

    /// The root view controller.
    var rootViewController: UIViewController { get }

    /// Starts the navigation of the coordinator.
    func start()
}

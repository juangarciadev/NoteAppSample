//
//  CreateNoteViewDelegate.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// ViewDelegate for CreateNoteViewController.
protocol CreateNoteViewDelegate: class {

    /// View model.
    var viewModel: CreateNoteViewModelProtocol { get set }

    /// Update UI.
    func updateUI()
}

//
//  NotesViewDelegate.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

/// ViewDelegate for NotesViewController.
protocol NotesViewDelegate: class {

    /// View model.
    var viewModel: NotesViewModelProtocol { get set }

    /// Update UI.
    func updateUI()
    
    /// Scroll table view to bottom.
    func scrollTableViewToBottom()
}

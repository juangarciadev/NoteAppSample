//
//  CreateNoteViewModelProtocol.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// This protocol describes the functionalities for CreateNoteViewModel.
protocol CreateNoteViewModelProtocol: class {
    
    /// Image Data used to store the image selected.
    var imageSelectedData: Data? { get set }
    
    /// View delegate
    var viewDelegate: CreateNoteViewDelegate? { get set }
    
    /// The coordinator.
    var coordinator: CreateNoteCoordinatorProtocol? { get set }
    
    /// The view has been loaded
    func viewDidLoad()
    
    /// Called when user taps to dismiss.
    func didTapDismiss()
    
    /// Create note.
    ///
    /// - Parameters:
    ///   - title: The title text.
    func createNote(with title: String)
    
    /// Called when user taps to choose an image from device library.
    func didTapChooseImage()
}

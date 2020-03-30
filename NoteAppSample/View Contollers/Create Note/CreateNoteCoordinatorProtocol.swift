//
//  CreateNoteCoordinatorProtocol.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

/// The functions that the coordinator needs to implement in order to handle the navigation for the create note view.
protocol CreateNoteCoordinatorProtocol: Coordinator {
    
    /// Tells the coordinator that it has finished.
    ///
    /// - Parameters:
    ///   - vm: The view model making the call.
    func createNoteDidFinish(_ vm: CreateNoteViewModelProtocol)
    
    /// Choose image.
    ///
    /// - Parameters:
    ///   - vm: The view model making the call.
    func createNoteChooseImage(_ vm: CreateNoteViewModelProtocol)
    
    /// Show error alert.
    ///
    /// - Parameters:
    ///   - vm: The view model making the call.
    ///   - message: The alert message text.
    func createNoteShowErrorAlert(_ vm: CreateNoteViewModelProtocol, message: String)
    
    /// Tells the coordinator that it has created a note.
    ///
    /// - Parameters:
    ///   - vm: The view model making the call.
    func createNoteDidCreateNote(_ vm: CreateNoteViewModelProtocol)
}

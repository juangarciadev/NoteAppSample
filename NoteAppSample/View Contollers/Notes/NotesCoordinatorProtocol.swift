//
//  NotesCoordinatorProtocol.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

/// The functions that the coordinator needs to implement in order to handle the navigation for the notes view.
protocol NotesCoordinatorProtocol: Coordinator {
    
    /// Show create note view.
    ///
    /// - Parameters:
    ///   - vm: The view model making the call.
    func notesShowCreateNoteView(_ vm: NotesViewModelProtocol)
}

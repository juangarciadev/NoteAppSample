//
//  NotesViewModelProtocol.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

/// This protocol describes the functionalities for NotesViewModel.
protocol NotesViewModelProtocol: class {
    
    /// View delegate
    var viewDelegate: NotesViewDelegate? { get set }
    
    // View state
    var viewState: NotesViewState { get }
    
    /// The coordinator.
    var coordinator: NotesCoordinatorProtocol? { get set }
    
    /// The view has been loaded
    func viewDidLoad()

    /// Show create note view.
    func showCreateNoteView()
    
    /// Refresh notes.
    func refreshNotes()
    
    /// Get the number of sections to show.
    ///
    /// - Returns: The number of sections.
    func numberOfSections() -> Int

    /// Get the number of rows to show in a section.
    ///
    /// - Parameter section: The section to obtain the rows for.
    /// - Returns: The number of rows for the given section.
    func numberOfRows(in section: Int) -> Int
    
    /// Get a note.
    ///
    /// - Parameter indexRow: The row to obtain the note for.
    /// - Returns: An Note object.
    func getNote(at indexRow: Int) -> Note?
    
    /// Note created.
    func noteCreated()
    
    /// Get note image cache.
    ///
    /// - Parameters:
    ///   - indexRow: The row to obtain the note for.
    ///   - imagePath: The image file path.
    /// - Returns: An NoteImageCache object.
    func getNoteImageCache(at indexRow: Int, imagePath: String) -> NoteImageCache
    
    /// Removes all  noteimage cache.
    func removeAllNoteImageCache()
}

/// View state options.
enum NotesViewState {
    case view
    case loading
}

//
//  NotesViewModel.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Reachability

/// Defines view model for NotesViewController.
final class NotesViewModel: NotesViewModelProtocol {
    
    // MARK: - Properties
    
    weak var viewDelegate: NotesViewDelegate?
    weak var coordinator: NotesCoordinatorProtocol?
    var viewState: NotesViewState = .view {
        didSet {
            viewDelegate?.updateUI()
        }
    }
    private var noteImageCache: [Int: NoteImageCache] = [:]
    private var notes: [Note]?
    private var reachability: Reachability?
    private var gettingNotes = false
    private var uploadingNotes = false
    
    // MARK: - Initializer
    
    required init(coordinator: NotesCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public Functions
    
    func viewDidLoad() {
        // Load note stored.
        try? addReachabilityObserver()
        getAllNotes()
        updateStoredNotes(reloadTable: true)
    }
    
    func showCreateNoteView() {
        coordinator?.notesShowCreateNoteView(self)
    }
    
    func refreshNotes() {
        getAllNotes()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let notes = notes else {
            return 0
        }
        return notes.count
    }
    
    func getNote(at indexRow: Int) -> Note? {
        guard let notes = notes else {
            assertionFailure("notes instance could not be nil")
            return nil
        }
        guard indexRow >= 0,
            indexRow < notes.count else {
                assertionFailure("indexRow out of range")
                return nil
        }
        return notes[indexRow]
    }
    
    func noteCreated() {
        // Notice: Reload the table view before call `scrollTableViewToBottom`.
        updateStoredNotes(reloadTable: true)
        getAllNotes()
        viewDelegate?.scrollTableViewToBottom()
    }
    
    func getNoteImageCache(at indexRow: Int, imagePath: String) -> NoteImageCache {
        guard let imageCacheStored = noteImageCache[indexRow] else {
            let imageCache = NoteImageCache(id: indexRow, imagePath: imagePath)
            noteImageCache[indexRow] = imageCache
            return imageCache
        }
        return imageCacheStored
    }
    
    func removeAllNoteImageCache() {
        noteImageCache.removeAll()
    }
    
    // MARK: - Private Functions
    
    private func getAllNotes() {
        guard let reachability = reachability else {
            assertionFailure("reachability instance could not be nil")
            return
        }
        guard reachability.connection != .unavailable,
            !gettingNotes else {
                return
        }
        gettingNotes = true
        
        syncNotes()
        NoteAPI.getAllNotes { [weak self] result in
            switch result {
            case .success():
                self?.updateStoredNotes(reloadTable: false)
            case .failure(let error):
                // TODO: Implement an error logger.
                print(error)
            }
            if let uploadingNotes = self?.uploadingNotes {
                self?.viewState = uploadingNotes ? .loading : .view
            }
            self?.gettingNotes = false
        }
    }
    
    private func syncNotes() {
        // Sync  notes between local and remote data base.
        guard let notesToUpload = NoteStore.notesToUpload(),
            notesToUpload.count > 0,
            !uploadingNotes else {
                return
        }
        uploadingNotes = true
        viewState = .loading
        
        let syncGroup = DispatchGroup()
        for note in notesToUpload {
            syncGroup.enter()
            
            if note.imageId.isEmpty {
                let fileManager = FileManager.default
                if let filePath = fileManager.filePath(forKey: note.imagePath),
                    let imageData = fileManager.contents(atPath: filePath.path) {
                    uploadImage(with: imageData, note: note) {
                        syncGroup.leave()
                    }
                }
            } else {
                createNote(with: note.imageId, note: note) {
                    syncGroup.leave()
                }
            }
        }
        syncGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.uploadingNotes = false
            self?.getAllNotes()
        }
    }
    
    private func uploadImage(with imageDate: Data, note: Note, completion: @escaping () -> Void) {
        NoteAPI.uploadNote(with: imageDate) { [note, weak self] result in
            switch result {
            case .success(let imageUploaded):
                try? NoteStore.updateNoteImageId(note, imageId: imageUploaded.id)
                self?.createNote(with: imageUploaded.id, note: note, completion: completion)
            case .failure:
                completion()
            }
        }
    }
    
    private func createNote(with imageId: String, note: Note, completion: @escaping () -> Void) {
        NoteAPI.createNote(with: imageId, title: note.title) { [note] result in
            switch result {
            case .success:
                try? NoteStore.delete(note)
                completion()
            case .failure:
                completion()
            }
        }
    }
    
    private func updateStoredNotes(reloadTable: Bool) {
        notes = NoteStore.notes()
        if reloadTable {
            viewDelegate?.updateUI()
        }
    }
    
    private func addReachabilityObserver() throws {
        let reachability = try Reachability()
        reachability.whenReachable = { [weak self] reachability in
            self?.getAllNotes()
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.viewState = .view
        }
        try reachability.startNotifier()
        self.reachability = reachability
    }
}

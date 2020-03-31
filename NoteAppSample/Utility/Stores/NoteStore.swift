//
//  NoteStore.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/29/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import RealmSwift

/// A data store for interacting with info related resources.
struct NoteStore {
    
    // MARK: - Initializers
    // Use static functions.
    private init() {}
    
    // MARK: - Public Functions
    
    static func notes() -> [Note]? {
        do {
            let realm = try Realm()
            let notes = realm.objects(Note.self)
            return Array(notes)
        } catch {
            return nil
        }
    }
    
    static func save(_ notes: [Note]) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(notes, update: .modified)
        }
    }
    
    static func createNote(with imageData: Data, title: String) throws {
        // Create a new note instance.
        let note = Note()
        // Set a random number as `id` due it is set as primary key for Realm.
        note.id = Int(arc4random_uniform(50000))
        note.title = title
        note.uploaded = false
        // Generate unique image name to set as file path suffix.
        let fileIdentifier = UUID().uuidString
        // Set the image file path.
        note.imagePath = fileIdentifier
        guard let filePath = FileManager.default.filePath(forKey: fileIdentifier) else {
            throw NoteStoreError.documentDirectoryUnavailable
        }
        // Store the image locally.
        try imageData.write(to: filePath, options: .atomic)
        // Persist the new note.
        let realm = try Realm()
        try realm.write {
            realm.add(note)
        }
    }
    
    static func notesToUpload() -> [Note]? {
        do {
            let realm = try Realm()
            return Array(realm.objects(Note.self).filter("uploaded == false"))
        } catch {
            // TODO: Implement an error logger.
            print(error)
            return nil
        }
    }
    
    static func delete(_ note: Note) throws {
        let realm = try Realm()
        try realm.write {
            realm.delete(note)
        }
    }
    
    static func updateNoteImageId(_ note: Note, imageId: String) throws {
        let realm = try Realm()
        try realm.write {
            note.imageId = imageId
        }
    }
}

/// Note store error.
enum NoteStoreError: Error {
    case documentDirectoryUnavailable
}

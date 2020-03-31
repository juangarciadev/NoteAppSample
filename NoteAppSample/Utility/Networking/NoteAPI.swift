//
//  NoteAPI.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// Network provider for note.
struct NoteAPI {
    
    // MARK: - Initializers
    // Use static functions.
    private init() {}
    
    // MARK: - Public Functions
    
    /// Get All Notes.
    ///
    /// - Parameters:
    ///   - completion: Call-back upon successful response.
    static func getAllNotes(_ completion: @escaping (Result<[Note], Error>) -> Void) {
        guard let getAllNoteURL = GlobalConfiguration.getAllNoteURL else {
            completion(.failure(NetworkError.badURL))
            assertionFailure("Invalid URL")
            return
        }
        BaseAPI.request(getAllNoteURL) { response in
            switch response.result {
            case .success:
                guard let responseData = response.data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                do {
                    let notes = try JSONDecoder().decode([Note].self, from: responseData)
                    completion(.success(notes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Upload note image.
    ///
    /// - Parameters:
    ///   - imagaData: Image data to upload.
    ///   - completion: Call-back upon successful response.
    static func uploadNote(with imageData: Data, completion: @escaping (Result<ImageUploaded, Error>) -> Void) {
        guard let uploadImageNoteURL = GlobalConfiguration.uploadImageNoteURL else {
            completion(.failure(NetworkError.badURL))
            assertionFailure("Invalid URL")
            return
        }
        BaseAPI.uploadImage(data: imageData,
                            url: uploadImageNoteURL) { response in
                                switch response.result {
                                case .success:
                                    guard let responseData = response.data else {
                                        completion(.failure(NetworkError.noData))
                                        return
                                    }
                                    do {
                                        let imageUploaded = try JSONDecoder().decode(ImageUploaded.self, from: responseData)
                                        completion(.success(imageUploaded))
                                    } catch {
                                        completion(.failure(error))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                }
        }
    }
    
    /// Create a note.
    ///
    /// - Parameters:
    ///   - imageId: Image uploaded id .
    ///   - completion: Call-back upon successful response.
    static func createNote(with imageId: String, title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let createNoteURL = GlobalConfiguration.createNoteURL else {
            completion(.failure(NetworkError.badURL))
            assertionFailure("Invalid URL")
            return
        }
        let parameters: [String: Any] = [
            GlobalConfiguration.noteTitle: title,
            GlobalConfiguration.noteImageId: imageId
        ]
        
        BaseAPI.request(createNoteURL, method: .post, parameters: parameters, encoding: .jsonEncodingDefault) { response in
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

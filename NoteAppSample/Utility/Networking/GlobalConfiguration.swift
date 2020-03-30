//
//  GlobalConfiguration.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/28/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// Constant used for get networking keys.
struct GlobalConfiguration {
    
    // MARK: - URLs
    
    private static let baseURLString = "https://env-develop.saturn.engineering/api/v2/test-notes"
    static let uploadImageNoteURL = URL(string: "\(baseURLString)/photo")
    static let createNoteURL = URL(string: baseURLString)
    static let getAllNoteURL = URL(string: baseURLString)
    
    // MARK: - Keys
    
    static let imageName = "file"
    static let imageFileName = "file.jpg"
    static let imageMimeType = "image/jpg"
    static let imageJPGSuffix = ".jpg"
    static let imageUploadedId = "id"
    static let noteTitle = "title"
    static let noteImageId = "image_id"
}

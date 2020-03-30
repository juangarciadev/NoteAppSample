//
//  FileManagerExtension.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/29/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// File manager helper functions.
extension FileManager {
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            return nil
            
        }
        return documentURL.appendingPathComponent(key + GlobalConfiguration.imageJPGSuffix)
    }
}

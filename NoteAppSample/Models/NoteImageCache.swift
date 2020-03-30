//
//  NoteImageCache.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/30/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import UIKit

final class NoteImageCache {
    
    // MARK: - Properties
    
    let id: Int
    let imagePath: String
    lazy var imageStoredLocally: UIImage? = {
        let fileManager = FileManager.default
        if let filePath = fileManager.filePath(forKey: imagePath),
            let fileData = fileManager.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        } else {
            return nil
        }
    }()
    
    // MARK: - Initializers
    
    init(id: Int, imagePath: String) {
        self.id = id
        self.imagePath = imagePath
    }
}

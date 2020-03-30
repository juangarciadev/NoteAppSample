//
//  ImageUploaded.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/29/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation

/// Model representing the image uploaded.
struct ImageUploaded: Codable {
    
    // MARK: - Properties
    
    var id: String = ""
    var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case type = "image_type"
    }
}

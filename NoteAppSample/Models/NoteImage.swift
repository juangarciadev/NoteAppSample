//
//  NoteImage.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/29/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation
import RealmSwift

/// Model representing a Note Image.
@objcMembers class NoteImage: Object, Decodable {
    
    // MARK: - Properties
    
    @objc dynamic var id: String = ""
    @objc dynamic var small: String = ""
    @objc dynamic var medium: String = ""
    @objc dynamic var large: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case small
        case medium
        case large
    }
    
    // MARK: - Initializers
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let urls = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .urls)
        small = try urls.decode(String.self, forKey: .small)
        medium = try urls.decode(String.self, forKey: .medium)
        large = try urls.decode(String.self, forKey: .large)
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - Public Functions
    
    override static func primaryKey() -> String? {
        return CodingKeys.id.rawValue
    }
}

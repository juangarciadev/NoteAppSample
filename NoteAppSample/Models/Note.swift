//
//  Note.swift
//  NoteAppSample
//
//  Created by Juan Garcia on 3/29/20.
//  Copyright © 2020 Juan Garcia. All rights reserved.
//

import Foundation
import RealmSwift

/// Model representing a Note.
@objcMembers class Note: Object, Decodable {
    
    // MARK: - Properties
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var image: NoteImage?
    @objc dynamic var uploaded: Bool = true
    @objc dynamic var imagePath: String = ""
    @objc dynamic var imageId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
    }
    
    // MARK: - Initializers
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decodeIfPresent(NoteImage.self, forKey: .image)
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - Public Functions
    
    override static func primaryKey() -> String? {
        return CodingKeys.id.rawValue
    }
}

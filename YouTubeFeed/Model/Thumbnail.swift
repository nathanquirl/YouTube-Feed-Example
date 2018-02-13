//
//  Thumbnail.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct Thumbnail: Codable {
    // Height of thumbnail image
    var height: Int?
    
    // Width of thumbnail image
    var width: Int?
    
    // URL location of thumbnail image
    var url: String?
}

struct Thumbnails: Codable {
    // YouTube feeds usually store the smallest thumbnail in the "default" property
    var defaultSize: Thumbnail?
    
    // Next larger size to default
    var medium: Thumbnail?
    
    // Largest thumbnail size available from feed
    var high: Thumbnail?
    
    // MARK: - Custom coding keys
    
    // Since "default" is a reserved keyword, we override
    //  the coding key mapping here
    enum CodingKeys: String, CodingKey {
        case defaultSize = "default"
        case high
        case medium
    }
}

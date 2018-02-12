//
//  Thumbnail.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct Thumbnail: Codable {
    var height: Int?
    var width: Int?
    var url: String?
}

struct Thumbnails: Codable {
    var defaultSize: Thumbnail?
    var medium: Thumbnail?
    var high: Thumbnail?
    
    // MARK: - Custom coding keys
    
    enum CodingKeys: String, CodingKey {
        case defaultSize = "default"
        case high
        case medium
    }
}

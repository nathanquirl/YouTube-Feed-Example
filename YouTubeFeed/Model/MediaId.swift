//
//  MediaId.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct MediaId: Codable {
    /// Type of content; ie: youtube/video
    var kind: String?
    
    /// Unique identifier used for embedding into video links
    var videoId: String?
}

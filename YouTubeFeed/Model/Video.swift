//
//  Video.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct Snippet: Codable {
    var title: String?
    var description: String?
    var thumbnails: Thumbnails?
}

struct Video: Codable {
    var id: MediaId?
    var snippet: Snippet?
    
    // MARK: - Convenience methods
    
    func smallThumbnail() -> Thumbnail? {
        return snippet?.thumbnails?.defaultSize
    }
    
    func largeThumbnail() -> Thumbnail? {
        return snippet?.thumbnails?.high
    }
    
    func videoDescription() -> String? {
        return snippet?.description
    }
    
    func title() -> String? {
        return snippet?.title
    }
    
    func videoUrl() -> URL? {
        if let videoId = id?.videoId {
            let format = "http://www.youtube.com/watch?v=\(videoId)"
            return URL(string: format)
        }
        
        return nil
    }
}

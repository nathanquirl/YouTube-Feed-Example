//
//  Video.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct Snippet: Codable {
    /// Main title of content
    var title: String?
    
    /// Usually a short about section for a video
    /// Entire description is not usually available in this property and may appear truncated
    var description: String?
    
    /// Assortment of video thumbnail images in multiple sizes
    var thumbnails: Thumbnails?
}

struct Video: Codable {
    /// Structure for identifying type of content and for locating this video resource
    var id: MediaId?
    
    /// Uses YouTube naming convention; This contains detail information about this content
    var snippet: Snippet?
    
    // MARK: - Convenience methods
    
    /// Convenience accessor for retrieving default size from child structures
    func smallThumbnail() -> Thumbnail? {
        return snippet?.thumbnails?.defaultSize
    }
    
    /// Convenience accessor for retrieving largest size from child structures
    func largeThumbnail() -> Thumbnail? {
        return snippet?.thumbnails?.high
    }
    
    /// Convenience accessor for retrieving the video summary; May be truncated for brevity
    func videoDescription() -> String? {
        return snippet?.description
    }
    
    /// Convenience accessor for retrieving the main video title
    func title() -> String? {
        return snippet?.title
    }
    
    /// YouTube formatted embedded video link
    func videoUrl() -> URL? {
        // Formats an embedded YouTube video link, suitable for using from which an HTML iframe
        if let videoId = id?.videoId {
            let format = "http://www.youtube.com/embed/\(videoId)"
            return URL(string: format)
        }
        
        return nil
    }
    
    /// Formats an embedded YouTube player string for display in an HTML display
    func videoEmbedCode() -> String? {
        
        // Fprmatted HTML to display an embedded YouTube link.
        // Properties:
        // style=\"width:100%;height:100% : This sets the video frame to fill the entire available view port
        // allowfullscreen : Allows playback to enter fullscreen player mode. Closing the player will take you
        // back to the previous screen
        if let link = videoUrl() {
            let code = "<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body>" +
                "<iframe class=\"youtube-player\" type=\"text/html\" style=\"width:100%;height:100%;\"" +
            "src=\"\(link)\" allowfullscreen frameborder=\"0\"></iframe></body></html>"
            
            return code
        }
        
        return nil
    }
}

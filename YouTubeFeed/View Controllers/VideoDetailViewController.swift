//
//  VideoDetailViewController.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit
import WebKit
import YouTubePlayer

class VideoDetailViewController: UIViewController {

    // Accepts a YouTube video id and plays it within the view
    @IBOutlet var playerView: YouTubePlayerView!
    
    // Displays video summary; Info may be truncated from feed
    @IBOutlet var videoDescriptionLabel: UILabel!
    
    // Main video title
    @IBOutlet var videoTitleLabel: UILabel!
    
    // Video content information for display in this view
    var videoContentInfo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let video = videoContentInfo {
            
            // Setup detail properties from video instance
            videoTitleLabel.text = video.title()
            videoDescriptionLabel.text = video.videoDescription()
            
            if let videoId = video.id?.videoId {
                playerView.loadVideoID(videoId)
            }
        }
    }
}

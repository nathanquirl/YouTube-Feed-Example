//
//  VideoDetailViewController.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailViewController: UIViewController {

    // Embeds YouTube video content using formatted html
    @IBOutlet var videoWebView: WKWebView!
    
    // Displays video summary; Info may be truncated from feed
    @IBOutlet var videoDescriptionLabel: UILabel!
    
    // Main video title
    @IBOutlet var videoTitleLabel: UILabel!
    
    // Video content information for display in this view
    var videoContentInfo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let video = videoContentInfo {
            
            videoTitleLabel.text = video.title()
            videoDescriptionLabel.text = video.videoDescription()
            
            // We want to avoid a blank screen while loading so we setup a default
            // color for the WebView while it loads the embedded content
            videoWebView.backgroundColor = UIColor.black
            videoWebView.scrollView.backgroundColor = UIColor.black

            // Retrieves the formatted HTML code for embedding a YouTube video in a WebView
            if let embedCode = video.videoEmbedCode() {
                videoWebView.loadHTMLString(embedCode, baseURL: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update description here to ensure that it top justifies to the title block
        videoDescriptionLabel.sizeToFit()
    }
}

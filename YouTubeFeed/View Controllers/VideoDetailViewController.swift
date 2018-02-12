//
//  VideoDetailViewController.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {

    @IBOutlet var videoPosterImageView: UIImageView!
    @IBOutlet var videoDescriptionLabel: UILabel!
    @IBOutlet var videoTitleLabel: UILabel!
    
    var videoContentInfo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let video = videoContentInfo {
            
            videoTitleLabel.text = video.title()
            videoDescriptionLabel.text = video.videoDescription()
            
            if let address = video.largeThumbnail()?.url, let url = URL(string: address) {
                videoPosterImageView.download(url: url)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update description here to ensure that it top justifies to the title block
        videoDescriptionLabel.sizeToFit()
    }
}

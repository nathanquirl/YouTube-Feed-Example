//
//  FeedTableViewCell.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    // Main content thumbnail poster image; Usually the smallest size in the feed
    @IBOutlet var thumbnailImageView: UIImageView?
    
    // Main video title
    @IBOutlet var mediaTitle: UILabel?
}

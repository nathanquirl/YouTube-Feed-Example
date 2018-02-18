//
//  FeedCollectionViewCell.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/17/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

class FeedCollectionViewCell: CollectionViewSlantedCell {
    // Main video poster image view
    @IBOutlet var imageView: UIImageView!
    
    // Main video title
    @IBOutlet var mediaTitle: UILabel?

    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? 0.0
    }
    
    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? 0.0
    }
    
    // Offsets the image view relative to the cell frame which gives a parallax effect
    func offsetImage(_ offset: CGPoint) {
        imageView.frame = self.imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}

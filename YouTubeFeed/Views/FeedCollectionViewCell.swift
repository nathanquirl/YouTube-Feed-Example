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
    private let yOffsetSpeed: CGFloat = 30
    private let xOffsetSpeed: CGFloat = 50
    
    // Main video poster image view
    @IBOutlet var imageView: UIImageView!
    
    // Main video title
    @IBOutlet var mediaTitle: UILabel?

    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? imageView.bounds.size.height
    }
    
    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? imageView.bounds.size.width
    }
    
    // Offsets the image view relative to the cell frame which gives a parallax effect
    func offsetImage(offset: CGPoint) {
        imageView.frame = self.imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    func updateParallax(offset: CGPoint) {
        let yOffset = ((offset.y - frame.origin.y) / imageHeight) * yOffsetSpeed
        let xOffset = ((offset.x - frame.origin.x) / imageWidth) * xOffsetSpeed
        
        offsetImage(offset: CGPoint(x: xOffset, y: yOffset))
    }
}

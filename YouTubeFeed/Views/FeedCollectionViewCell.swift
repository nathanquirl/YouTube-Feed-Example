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
    /// Constant to control scrolling parallax speed in x direction
    private let yOffsetSpeed: CGFloat = 30
    
    /// Constant to control scrolling parallax speed in y direction
    private let xOffsetSpeed: CGFloat = 50
    
    /// Main video poster image view
    @IBOutlet var imageView: UIImageView!
    
    /// Main video title
    @IBOutlet var mediaTitle: UILabel?

    /// Retrieves height from image property
    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? imageView.bounds.size.height
    }
    
    /// Retrieves width from image property
    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? imageView.bounds.size.width
    }
    
    /// Offsets the image view relative to the cell frame which gives a parallax effect
    func offsetImage(offset: CGPoint) {
        imageView.frame = self.imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    /// Offsets the image view in relation to the cell content to give a shifting parallax effect
    func updateParallax(offset: CGPoint) {
        let yOffset = ((offset.y - frame.origin.y) / imageHeight) * yOffsetSpeed
        let xOffset = ((offset.x - frame.origin.x) / imageWidth) * xOffsetSpeed
        
        offsetImage(offset: CGPoint(x: xOffset, y: yOffset))
    }
}

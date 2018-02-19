//
//  FeedCollectionViewController.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/17/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

private let reuseIdentifier = "poster-cell"

class FeedCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    let slantedLayout = CollectionViewSlantedLayout()
        
    // This is used to process and retrieve a YouTube channel feed
    // Performs a aynchronous REST API call internally
    let contentFeed : ContentFeed = ContentFeed()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.reloadData()
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func setupCollectionView() {
        self.collectionView?.collectionViewLayout = slantedLayout
        
        // These settings affect the parallax effect when scrolling
        slantedLayout.slantingSize = 20
        
        // Performs asynchronous REST API call to load a YouTube content feed
        contentFeed.loadVideoFeed { (error) in
            
            if (error != nil) {
                print("Unable to load video feed")
                return
            }
            
            // Ensure that UI operations are called on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
                self?.slantedLayout.invalidateLayout()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Prepare detail view controller by setting it's video property using current table view selection
        if let controller = segue.destination as? VideoDetailViewController {
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPath(for: cell) {
                    controller.videoContentInfo = contentFeed.video(atIndex: indexPath.row)
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentFeed.videoCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.black
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }
        
        // Setup cell properties from video feed item
        if let video = contentFeed.video(atIndex: indexPath.row) {
            
            cell.mediaTitle?.text = video.title()
            
            // Asynchronously load image into thumbnail
            if let address = video.largeThumbnail()?.url, let url = URL(string: address) {
                cell.imageView?.download(url: url)
            }
        }
    
        return cell
    }
    
    func updateParallax() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        guard let visibleCells = collectionView.visibleCells as? [FeedCollectionViewCell] else {
            return
        }
        
        // Create parallax effect by calculating image offset during scrolling
        for parallaxCell in visibleCells {
            parallaxCell.updateParallax(offset: collectionView.contentOffset)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateParallax()
    }
}

extension FeedCollectionViewController: CollectionViewDelegateSlantedLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionViewLayout.scrollDirection == .vertical ? 175 : 346
    }
}



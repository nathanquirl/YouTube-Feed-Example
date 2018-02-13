//
//  FeedViewController.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    
    // MARK: - Constants
    
    // Default cell identifier for video feed cells
    let feedCellIdentifier = "video-feed-cell"
    
    // Default row cell height used for displaying video feed cells
    let rowCellHeight: CGFloat = 85.0

    // MARK: - Properties
    
    // This is used to process and retrieve a YouTube channel feed
    // Performs a aynchronous REST API call internally
    let contentFeed : ContentFeed = ContentFeed();
    
    // MARK: - Startup / Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        
        // Table view footer not needed for this view
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Performs asynchronous REST API call to load a YouTube content feed
        contentFeed.loadVideoFeed { (error) in
            
            if (error != nil) {
                print("Unable to load video feed")
                return
            }
            
            // Ensure that UI operations are called on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowCellHeight;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentFeed.videoCount();
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellIdentifier, for: indexPath)

        if let cell = cell as? FeedTableViewCell {
            
            // Setup cell properties from video feed item
            if let video = contentFeed.video(atIndex: indexPath.row) {

                cell.mediaTitle?.text = video.title()

                // Asynchronously load image into thumbnail
                if let address = video.smallThumbnail()?.url, let url = URL(string: address) {
                    cell.thumbnailImageView?.download(url: url)
                }
            }
        }

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Prepare detail view controller by setting it's video property using current table view selection
        if let controller = segue.destination as? VideoDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.videoContentInfo = contentFeed.video(atIndex: indexPath.row)
            }
        }
    }
}


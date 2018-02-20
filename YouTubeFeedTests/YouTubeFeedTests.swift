//
//  YouTubeFeedTests.swift
//  YouTubeFeedTests
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import XCTest
@testable import YouTubeFeed
//@testable import CollectionViewSlantedLayout

class YouTubeFeedTests: XCTestCase {
    
    var exampleFeed: Data?
    var codableFeed: Feed?
    
    override func setUp() {
        super.setUp()
        
        // Setup an example test feed using an embedded json file which simulates a feed download
        // This is to isolate associated tests from network conditions
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource:"test-feed", withExtension: "json")
        
        XCTAssert(url != nil)
        
        exampleFeed = try? Data(contentsOf: url!)
        
        XCTAssert(exampleFeed != nil)
        
        codableFeed = try? JSONDecoder().decode(Feed.self, from: exampleFeed!)
    }

    func testJSONModel() {

        // Test constants
        let defaultThumbnailUrl = "https:default-test-url.com"
        let highThumbnailUrl = "https:high-test-url.com"
        
        // Test feed model setup
        let mediaId = MediaId(kind: "test-kind", videoId: "test-video-id")
        
        let defaultThumbnail = Thumbnail(height: 25, width: 24, url: defaultThumbnailUrl)
        let highThumbnail = Thumbnail(height: 25, width: 24, url: highThumbnailUrl)
        let mediumThumbnail = Thumbnail(height: 25, width: 24, url: "https:medium-test-url.com")
        
        let thumbnails = Thumbnails(defaultSize: defaultThumbnail, medium: mediumThumbnail, high: highThumbnail)
        let snippet = Snippet(title: "test-title", description: "test-description", thumbnails: thumbnails)
        
        let video1 = Video(id: mediaId, snippet: snippet)
        let videos: [Video] = [video1]
        
        let feed = Feed(items: videos)
        
        // Test encoding
        guard let json = try? JSONEncoder().encode(feed) else {
            XCTFail()
            return
        }

        // Test decoding
        guard let decodedFeed = try? JSONDecoder().decode(Feed.self, from: json) else {
            XCTFail()
            return;
        }
        
        // Verify that the model hierarchy is as expected
        let defaultUrl = decodedFeed.items?.first?.smallThumbnail()?.url
        let highUrl = decodedFeed.items?.first?.largeThumbnail()?.url
        
        XCTAssert(defaultUrl == defaultThumbnailUrl)
        XCTAssert(highUrl == highThumbnailUrl)
    }
    
    func testJSONParsing() {
        guard let decodedFeed = try? JSONDecoder().decode(Feed.self, from: exampleFeed!) else {
            XCTFail()
            return;
        }
        
        XCTAssert(decodedFeed.items?.count != 0)
    }
    
    func testVideoAccess() {

        guard let decodedFeed = try? JSONDecoder().decode(Feed.self, from: exampleFeed!) else {
            XCTFail()
            return;
        }
        
        XCTAssert(decodedFeed.items != nil)
        
        // Inject our test feed to avoid a network request here; We just want to
        // proper handling of the accessor methods here
        let feed = ContentFeed()
        feed.contentFeed = decodedFeed
        
        let videoCount = feed.videoCount()
        
        for i in 0..<videoCount {
            let video = feed.video(atIndex: i)
            
            XCTAssert(video != nil)
            
            XCTAssert(!(video?.videoEmbedCode()?.isEmpty)!)
            XCTAssert(video?.videoUrl() != nil)
        }
    }
    
    func testAPIKey() {
        let feed = ContentFeed()
        
        let apiKey = feed.getAPIKey()
        
        // API key should be specified prior to using REST API
        // Obtain developer key through Google Developer Console
        XCTAssert(!apiKey.isEmpty)
    }
    
    func testVideoProperties() {
        
        let snippet = Snippet(title: "test-title", description: "test-description", thumbnails: nil)
        var video = Video(id: nil, snippet: snippet)
        
        XCTAssert(video.videoDescription() == "test-description")
        XCTAssert(video.title() == "test-title")
        
        video.snippet = snippet
    }
    
    func testChannelKey() {
        let feed = ContentFeed()
        
        let channel = feed.getChannelKey()
        
        // Channel key should be specified prior to using REST API
        XCTAssert(!channel.isEmpty)
    }
    
    func testChannelRequest() {
        let feed = ContentFeed()
        
        let request = feed.formatChannelRequest(channel: "TEST")
        
        // Channel key should be specified prior to using REST API
        XCTAssert(!request.isEmpty)
    }
    
    func testImageViewExtension() {
        let imageView = UIImageView()
        
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource:"test-image", withExtension: "jpg")!

        imageView.download(url: url, completion: { (image) in
            XCTAssert(image != nil)
        })
    }
    
    func testParallax() {
        let cell = FeedCollectionViewCell()
        
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.path(forResource: "test-image", ofType: "jpg")!
        let image = UIImage(contentsOfFile: file)
        
        cell.imageView = UIImageView()
        cell.imageView.image = image
        
        cell.updateParallax(offset: CGPoint(x: 30, y: 40))
        
        XCTAssert(cell.imageView.frame.origin.x != 0.0)
        XCTAssert(cell.imageView.frame.origin.y != 0.0)
    }
    
    func testFeedCollectionCell() {
        
        let cell = FeedCollectionViewCell()
        
        let testBundle = Bundle(for: type(of: self))
        let file = testBundle.path(forResource: "test-image", ofType: "jpg")!
        let image = UIImage(contentsOfFile: file)
        
        cell.imageView = UIImageView()
        cell.imageView.image = image
        
        XCTAssert(cell.imageHeight == image?.size.height)
        XCTAssert(cell.imageWidth == image?.size.width)
        
        cell.offsetImage(offset: CGPoint(x: 10.0, y: 20.0))
        
        XCTAssert(cell.imageView.frame.origin.x == 10.0)
        XCTAssert(cell.imageView.frame.origin.y == 20.0)
    }
    
    func testFeedCollectionViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "FeedCollectionViewController") as! FeedCollectionViewController
        
        // Inject test feed
        controller.contentFeed.contentFeed = codableFeed!

        let sections = controller.numberOfSections(in: controller.collectionView!)
        
        XCTAssert(sections == 1)
        
        let cell = controller.collectionView(controller.collectionView!, cellForItemAt: IndexPath(row: 0, section: 0)) as! FeedCollectionViewCell

        XCTAssert(!(cell.mediaTitle?.text?.isEmpty)!)
    }
    
    func testFeedDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        
        // Inject test feed
        controller.videoContentInfo = codableFeed?.items?.first
        
        // Call viewDidLoad
        let _ = controller.view
        
        XCTAssert(!(controller.videoTitleLabel.text?.isEmpty)!)
        
        controller.videoDescriptionLabel.sizeToFit()
    }
    
    func measureFeedParsing() {
        self.measure {
            _ = try? JSONDecoder().decode(Feed.self, from: exampleFeed!)
        }
    }
    
}

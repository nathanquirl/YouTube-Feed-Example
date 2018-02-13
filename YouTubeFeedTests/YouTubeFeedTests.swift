//
//  YouTubeFeedTests.swift
//  YouTubeFeedTests
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import XCTest
@testable import YouTubeFeed

class YouTubeFeedTests: XCTestCase {
    
    var exampleFeed: Data?
    
    override func setUp() {
        super.setUp()
        
        // Setup an example test feed using an embedded json file which simulates a feed download
        // This is to isolate associated tests from network conditions
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource:"test-feed", withExtension: "json")
        
        XCTAssert(url != nil)
        
        exampleFeed = try? Data(contentsOf: url!)
        
        XCTAssert(exampleFeed != nil)
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
        }
    }
    
    func testAPIKey() {
        let feed = ContentFeed()
        
        let apiKey = feed.getAPIKey()
        
        // API key should be specified prior to using REST API
        // Obtain developer key through Google Developer Console
        XCTAssert(!apiKey.isEmpty)
    }
    
    func testChannelKey() {
        let feed = ContentFeed()
        
        let channel = feed.getChannelKey()
        
        // Channel key should be specified prior to using REST API
        XCTAssert(!channel.isEmpty)
    }
    
    func testChannelNetworkLoad() {
        // Test valid network request
         let feed = ContentFeed()
        
        // Requires valid network connection during testing
        feed.loadVideoFeed { (error) in
            XCTAssert(error == nil, "Test failed due to network error")
        }
    }
    
    func measureFeedParsing() {
        self.measure {
            _ = try? JSONDecoder().decode(Feed.self, from: exampleFeed!)
        }
    }
    
}

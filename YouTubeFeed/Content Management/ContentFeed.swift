//
//  ContentFeed.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/11/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

class ContentFeed: NSObject {
    
    // MARK: - Error Declarations
    
    enum ContentFeedError: Error {
        case invalidFormat
        case noDataAvailable
        case invalidUrl
    }
    
    // MARK: - Constants
    
    /// Default key for locating the API key from the main app bundle
    /// This value should be set in the plist for the build target and is required for
    /// using the YouTube REST API
    public let feedBundleKey = "YouTube API Key"
    
    /// Example channel link for displaying a video feed;
    /// This can be changed to display a different channel feed
    public let defaultChannelKey = "UCz35fFb-aMFu5f-V6D-065w"
    
    // MARK: - Properties
    
    /// Once a feed has been successfully loaded, it is cached into this property
    var contentFeed: Feed = Feed()
    
    /// Generic method to provide the YouTube API key for REST calls. This can be overridden
    /// to provide alternate methods for retrieving the key. ie. from a server
    /// The default implementation pulls the key from the main bundle plist
    func getAPIKey() -> String {

        // Ideally, this would be retrieved from a server but is pulled from the bundle for now
        if let bundleDict = Bundle.main.infoDictionary {
            if let key = bundleDict[feedBundleKey] as? String {
                return key;
            }
        }
        
        // If the key is not found, you will need to register one through the Google developer console;
        // Add the key to the main bundle plist for the feedBundleKey property
        print("API Key not found; Returning empty value: (Did you remember to set the key?)")
        
        return ""
    }
    
    // MARK: - Content methods
    
    func getChannelKey() -> String {
        return defaultChannelKey
    }
    
    /// Format a REST API request for retrieving a list of recent videos using
    /// the specified channel
    /// - Parameter channel: Unique id used as a resource locater for a channel feed.
    func formatChannelRequest(channel: String) -> String {
        
        // An API key is required for this REST call
        let key = getAPIKey()

        // Format a REST call for retrieving a list of content from a channel
        return "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=" +
            channel + "&order=date&type=video&maxResults=30&key=" + key
    }
    
    func videoCount() -> Int {
        return contentFeed.items?.count ?? 0
    }
    
    func video(atIndex: Int) -> Video? {
        return contentFeed.items?[atIndex]
    }
    
    /// Performs rest API call to retrieve recent videos using the current
    /// channel key
    /// - Parameter completion: Block called after asynchronous loading
    ///               Passes non nil error value if load was unsuccessful
    func loadVideoFeed(_ completion: @escaping (Error?) -> Void) {

        // Get formatted REST API call as a string
        let formattedURL = formatChannelRequest(channel: getChannelKey())
        
        guard let url = URL(string: formattedURL) else {
            completion(ContentFeedError.invalidUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error -> Void in
            
            if (error != nil) {
                print("Unable to retrieve data: \(String(describing: error))")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(ContentFeedError.noDataAvailable)
                return;
            }
            
            // Decode the feed to a structure supporting the Codable JSON mapping protocol
            guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
                completion(ContentFeedError.invalidFormat)
                return;
            }
            
            // Success!
            self.contentFeed = feed
            completion(nil)
        })
        
        // Start the request
        task.resume()
    }
}


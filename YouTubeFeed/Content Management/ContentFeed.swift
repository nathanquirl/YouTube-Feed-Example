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
    
    let feedBundleKey = "YouTube API Key"
    let defaultChannelKey = "UCjnYk44Aj9E634TPucpIXnQ"
    
    // MARK: - Properties
    
    var contentFeed: Feed = Feed()
    
    func getAPIKey() -> String {

        // Ideally, this would be retrieved from a server but is pulled from the bundle for now
        if let bundleDict = Bundle.main.infoDictionary {
            if let key = bundleDict[feedBundleKey] as? String {
                return key;
            }
        }
        
        print("API Key not found; Returning empty value: (Did you remember to set the key?)")
        
        return ""
    }
    
    // MARK: - Content methods
    
    func getChannelKey() -> String {
        return defaultChannelKey
    }
    
    func formatChannelRequest(channel: String) -> String {
        
        let key = getAPIKey()
        
        return "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=" +
            channel + "&order=date&type=video&key=" + key
    }
    
    func videoCount() -> Int {
        return contentFeed.items?.count ?? 0
    }
    
    func video(atIndex: Int) -> Video? {
        return contentFeed.items?[atIndex]
    }
    
    func loadVideoFeed(completion: @escaping (Error?) -> Void) {

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
            
            guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
                completion(ContentFeedError.invalidFormat)
                return;
            }
            
            // Success!
            self.contentFeed = feed
            completion(nil)
        })
        
        task.resume()
    }
}


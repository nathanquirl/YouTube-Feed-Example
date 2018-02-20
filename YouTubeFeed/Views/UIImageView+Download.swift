//
//  UIImageView+Download.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Convenience method for simplifying asyncronous image loading
    public func download(url: URL, completion: @escaping (UIImage?) -> Void = {_ in }) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("Unable to download image at url: \(url)")
                completion(nil)
                return
            }
            
            if let data = data {
                // Must be called on the main thread to avoid locking the UI
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    completion(self.image)
                }
            }
            
        }).resume()
    }
}

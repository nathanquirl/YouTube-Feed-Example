//
//  UIImageView+Download.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    public func download(url: URL) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("Unable to download image at url: \(url)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            
        }).resume()
    }
}

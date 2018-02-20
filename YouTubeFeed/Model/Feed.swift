//
//  Feed.swift
//  YouTubeFeed
//
//  Created by Nathan Quirl on 2/12/18.
//  Copyright © 2018 Cinespan, Inc. All rights reserved.
//

import UIKit

struct Feed: Codable {
    /// Contains detail information and resource links for content and associated thumbnails
    var items: [Video]?
}

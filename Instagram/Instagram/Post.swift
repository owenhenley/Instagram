//
//  Post.swift
//  Instagram
//
//  Created by Owen Henley on 14/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import Foundation

struct Post {
    let imageURL: String

    init(dictionary: [String: Any]) {
        self.imageURL = dictionary[dict.imageUrl] as? String ?? "No Image URL"
    }
}

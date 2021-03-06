//
//  User.swift
//  Instagram
//
//  Created by Owen Henley on 2/24/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String

    init(dictionary: [String : Any]) {
        self.username = dictionary[dict.username] as? String ?? ""
        self.profileImageUrl = dictionary[dict.profileImageUrl] as? String ?? ""
    }
}

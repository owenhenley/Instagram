//
//  Constants.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase

// Firebase
let auth = Auth.auth()
let firDb = Database.database()
let dbRef = Database.database().reference()
let currentUser = Auth.auth().currentUser
let uid = Auth.auth().currentUser?.uid
let firStorage = Storage.storage()
let storageRef = Storage.storage().reference()

// Firebase Dictionary Strings
struct dict {
    static let users = "users"
    static let profileImages = "profile_images"
    static let username = "username"
    static let profileImageUrl = "profileImageUrl"
    static let posts = "posts"
    static let imageUrl = "imageUrl"
    static let caption = "caption"
    static let imageWidth = "imageWidth"
    static let imageHeight = "imageHeight"
    static let creationDate = "creationDate"
}

let creationDate = "creationDate"
let loremIpsum = """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam hendrerit nisi in tortor molestie, ac
                condimentum eros finibus. Pellentesque porta posuere est, at pretium lorem congue a. Etiam ut ipsum eu
                nisl ultricies lobortis eget nec mi. In ullamcorper aliquet cursus. Suspendisse potenti. Suspendisse
                eget tincidunt nulla. Nunc vitae magna et sem fermentum convallis id eu mauris. Fusce rhoncus augue
                nibh, et dapibus odio tempor ac. Donec tincidunt porta diam, sit amet sodales nibh ornare quis. Donec
                ultrices ut erat eu convallis. In vel tortor pretium, convallis diam vitae, ultricies lectus. Sed viverra
                nisl nulla, at ullamcorper mi suscipit et. Ut mattis turpis vel risus pellentesque iaculis. Vivamus diam
                orci, cursus ac nisi id, eleifend feugiat quam. Cras justo lacus, efficitur quis massa eu, vulputate mattis
                ligula. Morbi ut sodales mauris, at pharetra tellus.
                """

// Dependencies
let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

// Fetching
var imageCache = [String : UIImage]()

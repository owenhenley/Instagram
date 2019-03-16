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

// Dependencies
let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

// Fetching
var imageCache = [String : UIImage]()

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
let db = Database.database()
let dbRef = Database.database().reference()
let currentUser = Auth.auth().currentUser
let uid = Auth.auth().currentUser?.uid

// Firebase Dictionary Strings
struct dict {
   static let users = "users"
   static let profileImages = "profile_images"
   static let username = "username"
   static let profileImageUrl = "profileImageUrl"
}

let creationDate = "creationDate"

// Dependencies
let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

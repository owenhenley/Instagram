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
let AUTH = Auth.auth()
let DB = Database.database()
let DB_REF = Database.database().reference()
let CURRENT_USER = Auth.auth().currentUser
let UID = Auth.auth().currentUser?.uid

//Data
let USERS = "users"
let PROFILE_IMAGES = "profile_images"
let USERNAME = "username"
let PROFILE_IMAGE_URL = "profileImageUrl"

// Dependencies
// let mainTabBarControlxler = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController

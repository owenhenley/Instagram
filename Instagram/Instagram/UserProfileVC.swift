//
//  UserProfileVC.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUsername()
    }

    /// Fetches username and sets navigation title as the username
    private func fetchUsername() {
        guard let uid = CURRENT_USER else { return }
        DB_REF.child(USERS).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "No Value")

            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let username = dictionary[USERNAME] as? String
            self.navigationItem.title = username
        }) { (error) in
            print(" Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription) ")
        }
    }
}

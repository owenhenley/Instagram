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

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUsername()
        collectionView.register(UserProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "headerId")
    }

    /// Fetches username and sets navigation title as the username
    private func fetchUsername() {
        guard let uid = CURRENT_USER else { return }
        DB_REF.child(USERS).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "No Value")

            guard let dictionary = snapshot.value as? [String : Any] else { return }

            self.user = User(dictionary: dictionary)

            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }) { (error) in
            print(" Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription) ")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
}

extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

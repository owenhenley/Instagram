//
//  UserProfileVC.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class UserProfileVC: UICollectionViewController {

    // MARK: - Properties
    private var user: User?
    private var posts = [Post]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = uid // This is needed to fetch the user details, I still don't understnd why...
        fetchAndDisplayUser()
        setupCollectionViewCells()
        setupLogOutButton()
        fetchOrderedPosts()
    }

    // MARK: - Methods
    /// Fetches username and sets navigation title as the username.
    private func fetchAndDisplayUser() {
        SVProgressHUD.show()
        guard let uid = uid else { return }
        dbRef.child(dict.users).child(uid).queryOrdered(byChild: dict.creationDate).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "No Value")

            guard let dictionary = snapshot.value as? [String : Any] else {
                return
            }

            self.user = User(dictionary: dictionary)

            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }) { (error) in
            print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
        }
    }

    /// Fetch the current users posts in creation date order
    private func fetchOrderedPosts() {
        guard let uid = uid else {
            return
        }

        dbRef.child(dict.posts).child(uid).observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {
                return
            }

            let post = Post(dictionary: dictionary)
            self.posts.append(post)

            self.collectionView.reloadData()
        }) { (error) in
            print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
            return
        }
    }

    /// Fetch the current users posts in no particular order
    private func fetchPosts() {
        guard let uid = uid else {
            return
        }

        dbRef.child(dict.posts).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {
                return
            }

            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else {
                    return
                }

                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })

            self.collectionView.reloadData()

        }) { (error) in
            print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
        }
    }

    /// Sets up the Log Out Button.
    private func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icon.Settings, style: .plain, target: self, action: #selector(handleLogOut))
    }

    /// Handles what happnens when the user taps to sign out.
    @objc private func handleLogOut() {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("performing log out")
            do {
                try auth.signOut()
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController:loginVC)
                self.present(navController, animated: true)
            } catch {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(logOutAction)

        alert.preferredAction = logOutAction
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView
extension UserProfileVC {
    /// Registers the CollectionViewCells ready to use.
    private func setupCollectionViewCells() {
        collectionView.register(UserProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "headerId")
        collectionView.register(UserProfilePhotoCell.self,
                                forCellWithReuseIdentifier: "cellId")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 2) / 3
        return CGSize(width: size, height: size)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? UserProfilePhotoCell else {
            return UICollectionViewCell()
        }

        cell.post = posts[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

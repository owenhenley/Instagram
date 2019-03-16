//
//  HomeFeedVC.swift
//  Instagram
//
//  Created by Owen Henley on 16/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeFeedVC: UICollectionViewController {

    private let cellId = "cellId"

    // MARK: - Properties
    var posts = [Post]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
        fetchPosts()
    }

    // MARK: - Methods
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
}

extension HomeFeedVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeFeedCell else {
            return UICollectionViewCell()
        }

        cell.post = posts[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(400)
        return CGSize(width: width, height: height)
    }
}

private extension HomeFeedVC {
    func setupViews() {
        setupNavigationItems()
        collectionView.backgroundColor = .white
    }

    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: Icon.LogoBlack)
    }
}

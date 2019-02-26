//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainTabBarController: UITabBarController {

    private let collectionViewLayout = UICollectionViewFlowLayout()
    private lazy var userProfileVC = UserProfileVC(collectionViewLayout: collectionViewLayout)
    private lazy var navController = UINavigationController(rootViewController: userProfileVC)
    private lazy var loginVC = LoginVC()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthState()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.tintColor = .black

        navController.tabBarItem.image = Icon.ProfileUnselected
        navController.tabBarItem.selectedImage = Icon.ProfileSelected

        viewControllers = [
            navController
        ]
    }

    private func checkUserAuthState() {
        if CURRENT_USER == nil {
            let navController = UINavigationController(rootViewController: loginVC)
            DispatchQueue.main.async {
                self.present(navController, animated: true)
                SVProgressHUD.dismiss()
            }
            return
        }
    }
}

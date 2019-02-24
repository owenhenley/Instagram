//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.tintColor = .black

        let collectionViewLayout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileVC(collectionViewLayout: collectionViewLayout)

        let navController = UINavigationController(rootViewController: userProfileVC)
        navController.tabBarItem.image = Icon.ProfileUnselected
        navController.tabBarItem.selectedImage = Icon.ProfileSelected

        viewControllers = [
            navController
        ]
    }

}

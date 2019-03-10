//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Owen Henley on 2/23/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthState()
        setupViewControllers()
    }

    /// Checks if the user is currently signed in
    private func checkUserAuthState() {
        if currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true)
            }
            return
        }
    }

    /// Sets up the TabBar with associated view controllers
    /// and lays out the correct icons
    func setupViewControllers() {
        // Home
        let homeVC = addNavController(UIViewController(),
                                      unselectedIcon: TabBarIcon.HomeUnselected,
                                      selectedIcon: TabBarIcon.HomeSelected)

        // Search
        let searchVC = addNavController(UIViewController(),
                                        unselectedIcon: TabBarIcon.SearchUnselected,
                                        selectedIcon: TabBarIcon.SearchSelected)
        // Add Photo
        let addPhotoVC = addNavController(UIViewController(),
                                        unselectedIcon: TabBarIcon.PlusUnselected,
                                        selectedIcon: nil)
        // Likes
        let likesVC = addNavController(UIViewController(),
                                        unselectedIcon: TabBarIcon.HeartUnselected,
                                        selectedIcon: TabBarIcon.HeartSelected)

        // User Profile
        let userProfileVC = addNavController(UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()),
                                             unselectedIcon: TabBarIcon.ProfileUnselected,
                                             selectedIcon: TabBarIcon.ProfileSelected)

        // TabBar ViewControllers
        tabBar.tintColor = .black
        viewControllers = [homeVC,
                           searchVC,
                           addPhotoVC,
                           likesVC,
                           userProfileVC]
        customiseTabBar()
    }

    private func addNavController(_ rootViewController: UIViewController, unselectedIcon: UIImage, selectedIcon: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedIcon
        navController.tabBarItem.selectedImage = selectedIcon
        return navController
    }

    private func customiseTabBar() {
        guard let items = tabBar.items else { return }

        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}

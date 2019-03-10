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
        self.delegate = self
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
        let homeVC = addNavController(unselectedIcon: TabBarIcon.HomeUnselected,
                                      selectedIcon: TabBarIcon.HomeSelected)

        // Search
        let searchVC = addNavController(unselectedIcon: TabBarIcon.SearchUnselected,
                                        selectedIcon: TabBarIcon.SearchSelected)
        // Add Photo
        let addPhotoVC = addNavController(unselectedIcon: TabBarIcon.PlusUnselected,
                                          selectedIcon: nil)
        // Likes
        let likesVC = addNavController(unselectedIcon: TabBarIcon.HeartUnselected,
                                        selectedIcon: TabBarIcon.HeartSelected)

        // User Profile
        let userProfileVC = addNavController(unselectedIcon: TabBarIcon.ProfileUnselected,
                                             selectedIcon: TabBarIcon.ProfileSelected,
                                             rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))

        // TabBar ViewControllers
        tabBar.tintColor = .black
        viewControllers = [homeVC,
                           searchVC,
                           addPhotoVC,
                           likesVC,
                           userProfileVC]
        customiseTabBarInsets()
    }

    /// Adds a rootViewController to a navigationController with it's unselected and selected tab bar icons.
    ///
    /// - Parameters:
    ///   - unselectedIcon: The unselected tabBar icon
    ///   - selectedIcon?: The selected tabBar icon
    ///   - rootViewController: The view controller to set as the root
    /// - Returns: a new `UINavigationController`, to be passed into the tabBar's `viewControllers` array
    private func addNavController(unselectedIcon: UIImage, selectedIcon: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedIcon
        navController.tabBarItem.selectedImage = selectedIcon
        return navController
    }

    /// Centers the TabBar's veritcal alignment
    private func customiseTabBarInsets() {
        guard let items = tabBar.items else { return }

        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        let addPhotoIndex = 2
        if index == addPhotoIndex {
            let flowLayout = UICollectionViewFlowLayout()
            let photoSelectorVC = PhotoSelectorVC(collectionViewLayout: flowLayout)
            let navController = UINavigationController(rootViewController: photoSelectorVC)
            present(navController, animated: true)
            return false
        }
        return true
    }
}

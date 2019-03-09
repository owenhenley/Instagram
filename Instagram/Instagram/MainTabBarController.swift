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

    /// Sets up the TabBar with associated view controllers
    /// and lays out the correct icons
    func setupViewControllers() {
        tabBar.tintColor = .black
        let collectionViewLayout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileVC(collectionViewLayout: collectionViewLayout)
        let navController = UINavigationController(rootViewController: userProfileVC)

        navController.tabBarItem.image = Icon.ProfileUnselected
        navController.tabBarItem.selectedImage = Icon.ProfileSelected
        
        viewControllers = [
            navController,
            UIViewController()
        ]
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
}

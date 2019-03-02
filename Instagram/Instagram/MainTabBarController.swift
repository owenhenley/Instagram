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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthState()
        setupViewControllers()
    }

    func setupViewControllers() {
        tabBar.tintColor = .black
        let userProfileVC = UserProfileVC(collectionViewLayout: collectionViewLayout)
        let navController = UINavigationController(rootViewController: userProfileVC)

        navController.tabBarItem.image = Icon.ProfileUnselected
        navController.tabBarItem.selectedImage = Icon.ProfileSelected
        
        viewControllers = [
            navController,
            UIViewController()
        ]
    }

    private func checkUserAuthState() {
        if CURRENT_USER == nil {
            let loginVC = LoginVC()
            let navController = UINavigationController(rootViewController: loginVC)
            DispatchQueue.main.async {
                self.present(navController, animated: true)
                SVProgressHUD.dismiss()
            }
            return
        }
    }
}

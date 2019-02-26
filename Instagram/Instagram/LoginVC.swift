//
//  LoginVC.swift
//  Instagram
//
//  Created by Owen Henley on 2/26/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController {

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutViews()
    }

    @objc private func handleShowSignUp() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    private func layoutViews() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
}

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

class LoginVC: UIViewController {

    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Controls
    let logoImageView = UIImageView(image: Icon.LogoWhite)
    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()

    private let emailTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        return textField
    }()

    private let loginButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Login", for: .normal)
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        signUpButton.layer.cornerRadius = 4
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: " Sign Up",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 149,
                                                                                                                   green: 204,
                                                                                                                   blue: 244)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        layoutViews()
    }

    // MARK: - #selector Methods
    /// Handles what happens when the user signs in
    @objc private func handleLogin() {
        guard let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty
            else {
                return
        }

        AUTH.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
            }

            print("logged in!")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true)
        }
    }


    /// Handles what happens if the user wants to sign up
    @objc private func handleShowSignUp() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    /// Change Login button interaction based on user input
    @objc private func handleTextDidChange() {
        let formIsValid = emailTF.text != "" &&
            passwordTF.text != ""

        if formIsValid {
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            loginButton.isEnabled = false
        }
    }
}

// MARK: - Layout Views
private extension LoginVC {
    func layoutViews() {
        layoutLogo()
        layoutTextFields()
        layoutSignupButton()
    }

    func layoutLogo() {
        view.addSubview(logoContainerView)
        logoContainerView.snp.makeConstraints { (make) in
            let height = view.frame.height / 4
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height)
            view.addSubview(logoImageView)
        }

        logoImageView.snp.makeConstraints { (make) in
            logoImageView.contentMode = .scaleAspectFill
            make.center.equalTo(logoContainerView)
            make.width.equalTo(220)
            make.height.equalTo(70)
        }
    }

    func layoutTextFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTF,
                                                       passwordTF,
                                                       loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(logoContainerView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(140)
        }
    }

    func layoutSignupButton() {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
}


//
//  ViewController.swift
//  Instagram
//
//  Created by Owen Henley on 2/20/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        return button
    }()

    private let emailTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect

        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)

        return textField
    }()

    private let usernameTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect

        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)

        return textField
    }()

    private let passwordTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect

        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)

        return textField
    }()

    private let signUpButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        signUpButton.layer.cornerRadius = 4
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)

        // Layout
        plusPhotoButton.centerHorizontallyInSuperview()
        plusPhotoButton.anchor(top: view.topAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: nil,
                               padding: .init(top: 100,
                                              left: 0,
                                              bottom: 0,
                                              right: 0),
                               size: CGSize(width: 140,
                                            height: 140))

        setupTextFields()
    }

    private func setupTextFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTF,
                                                       usernameTF,
                                                       passwordTF,
                                                       signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 12

        view.addSubview(stackView)

        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 24,
                                        left: 50,
                                        bottom: 200,
                                        right: 50))
    }

    @objc private func handleSignUp() {
        print("Signing Up...")
        guard let email = emailTF.text, email != "",
            let username = usernameTF.text, username != "",
            let password = passwordTF.text, password != "" else {
                print("❌ Input incorrect ❌")
                return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("❌ Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription) ❌")
                return
            }
            print("Successfull created new user: \(auth?.user.uid ?? "")")
            self.resignFirstResponder()
        }
    }

    @objc private func handleTextDidChange() {
        let formIsValid = emailTF.text != "" &&
                          usernameTF.text != "" &&
                          passwordTF.text != ""

        if formIsValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
}

//
//  ViewController.swift
//  Instagram
//
//  Created by Owen Henley on 2/20/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SnapKit

class SignUpVC: UIViewController {

    // MARK: - Controls
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icon.AddPhoto, for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()

    private let emailTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        return textField
    }()

    private let usernameTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
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

    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: " Sign In",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 149,
                                                                                                                   green: 204,
                                                                                                                   blue: 244)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        layoutViews()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    @objc private func handleShowSignIn() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleSignUp() {
        SVProgressHUD.show()
        guard let email = emailTF.text, email != "",
            let username = usernameTF.text, username != "",
            let password = passwordTF.text, password != "" else {
                print(" Input Incorrect ")
                return
        }

        AUTH.createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                return SVProgressHUD.dismiss()
            }

            guard let image = self.plusPhotoButton.imageView?.image else { return SVProgressHUD.dismiss() }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return SVProgressHUD.dismiss() }

            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(PROFILE_IMAGES).child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                    return SVProgressHUD.dismiss()
                }

                storageRef.downloadURL(completion: { (downloadURL, error) in
                    if let error = error {
                        print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                        return SVProgressHUD.dismiss()
                    }

                    guard let profileImageUrl = downloadURL?.absoluteString else { return SVProgressHUD.dismiss() }

                    guard let uid = user?.user.uid else {
                        return SVProgressHUD.dismiss()
                    }

                    let dictionaryValues = [USERNAME: username, PROFILE_IMAGE_URL: profileImageUrl]
                    let values = [uid: dictionaryValues]
                    Database.database().reference().child(USERS).updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let error = error {
                            print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                            return SVProgressHUD.dismiss()
                        }
                        SVProgressHUD.dismiss()
                    })
                })
            })
            self.view.endEditing(true) // resign keyboard
            mainTabController?.setupViewControllers()
            self.dismiss(animated: true)
        })
    }

}

extension SignUpVC: UIGestureRecognizerDelegate {

}

extension SignUpVC: UITextFieldDelegate {
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

extension SignUpVC: UIImagePickerControllerDelegate {
    @objc private func handleAddPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
        plusPhotoButton.layer.borderWidth = 2

        dismiss(animated: true)
    }
}

extension SignUpVC: UINavigationControllerDelegate {
    // No Code
}

private extension SignUpVC {
    func layoutViews() {
        layoutAddPhotoButton()
        layoutTextFields()

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    func layoutAddPhotoButton() {
        plusPhotoButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).inset(100)
            make.size.equalTo(140)
            make.centerX.equalToSuperview()
        }
    }

    func layoutTextFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTF,
                                                       usernameTF,
                                                       passwordTF,
                                                       signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 12

        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(200)
        }
    }
}

//
//  SharePhotoVC.swift
//  Instagram
//
//  Created by Owen Henley on 12/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SVProgressHUD

class SharePhotoVC: UIViewController {

    // MARK: - Properties
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }

    // MARK: - Views
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let textView = UITextView()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        setupNavigation()
        enableTapScreenToDismiss()
    }

    /// Style the navigation bar
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }

    /// Control the share button action
    @objc private func handleShare() {
        SVProgressHUD.show()
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let image = selectedImage,
            let caption = textView.text,
            !caption.isEmpty else {
                return
        }

        guard let uploadData = image.jpegData(compressionQuality: 5) else {
            return
        }

        let filename = NSUUID().uuidString
        let storage = storageRef.child(dict.posts).child(filename)
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                SVProgressHUD.dismiss()
                return
            }

            storage.downloadURL(completion: { (downloadURL, error) in
                if let error = error {
                    print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    SVProgressHUD.dismiss()
                    return
                }

                guard let imageURL = downloadURL?.absoluteString else { return }

                print("Successfully uploaded post image:", imageURL)

                self.saveToDatabaseWithImageUrl(imageURL)
                self.dismiss(animated: true)
            })
        }

        print("sharing")
        dismissKeyboard()
    }

    /// Save the imageURL to the firebase database
    ///
    /// - Parameter imageUrl: The url of the shared image
    private func saveToDatabaseWithImageUrl(_ imageUrl: String) {
        guard let uid = uid else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            SVProgressHUD.dismiss()
            return
        }

        guard let postImage = selectedImage,
            let caption = textView.text
            else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                SVProgressHUD.dismiss()
                return
        }

        let userPostRef = dbRef.child(dict.posts).child(uid)
        let autoId = userPostRef.childByAutoId()

        let values = [
            dict.imageUrl : imageUrl,
            dict.caption : caption,
            dict.imageWidth : postImage.size.width,
            dict.imageHeight : postImage.size.height,
            dict.creationDate : Date().timeIntervalSince1970
            ] as [String : Any]

        autoId.updateChildValues(values) { (error, dbRef) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                SVProgressHUD.dismiss()
                return
            }
            print("successfullt saved post to DB")
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            SVProgressHUD.dismiss()
        }

    }
}

// MARK: - Layout Views
private extension SharePhotoVC {
    func layoutViews() {
        view.backgroundColor = .offWhite
        layoutContainerView()
        layoutImageViewAndTextView()
    }

    func layoutContainerView() {
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
        make.left.right.equalToSuperview()
        make.height.equalTo(100)
        }
    }

    func layoutImageViewAndTextView() {
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(6)
            make.width.equalTo(imageView.snp.height)
        }

        textView.font = UIFont.systemFont(ofSize: 14)
        containerView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(6)
            make.left.equalTo(imageView.snp.right).offset(12)
        }
    }
}

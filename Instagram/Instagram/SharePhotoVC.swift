//
//  SharePhotoVC.swift
//  Instagram
//
//  Created by Owen Henley on 12/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SnapKit

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
        print("sharing")
        dismissKeyboard()
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

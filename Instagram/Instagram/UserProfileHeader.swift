//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Owen Henley on 2/24/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SVProgressHUD

class UserProfileHeader: UICollectionViewCell {

    // MARK: - Properties
    var user: User? {
        didSet {
            fetchAndSetProfileImage()
            usernameLabel.text = user?.username
        }
    }

    // MARK: - Controls
    lazy var statsStackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    lazy var toolbarStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarksButton])
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 80 / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: Buttons
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icon.Grid, for: .normal)
        return button
    }()

    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icon.List, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let bookmarksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icon.Ribbon, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()

    // MARK: Labels
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "77\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "77\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "77\n",
                                                        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func fetchAndSetProfileImage() {
        if profileImageView.image == nil {
            SVProgressHUD.show()
            guard let profileImageUrl = user?.profileImageUrl else { return }
            guard let url = URL(string: profileImageUrl) else { return }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                    return
                }

                guard let data = data else { return }

                let image = UIImage(data: data)

                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    SVProgressHUD.dismiss()
                }
            }.resume()
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - Private layout methods
extension UserProfileHeader {
    func layoutViews() {
        layoutProfileImageView()
        layoutToolbar()
        layoutProfileStats()
        layoutEditProfileButton()
        layoutUsernameLabel()
    }

    func layoutProfileImageView() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(12)
            make.size.equalTo(80)
        }
    }


    func layoutUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
    }
    
    func layoutToolbar() {
        toolbarStackView.distribution = .fillEqually
        addSubview(toolbarStackView)
        toolbarStackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(43)
        }

        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        addSubview(topDividerView)
        topDividerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(toolbarStackView.snp.top)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
        }

        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        addSubview(bottomDividerView)
        bottomDividerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(toolbarStackView.snp.bottom)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
        }
    }

    func layoutProfileStats() {
        statsStackView.distribution = .fillEqually
        addSubview(statsStackView)
        statsStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(16)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    func layoutEditProfileButton() {
        addSubview(editProfileButton)
        editProfileButton.snp.makeConstraints { (make) in
            make.top.equalTo(statsStackView.snp.bottom)
            make.left.equalTo(statsStackView.snp.left)
            make.right.equalTo(statsStackView.snp.right)
        }
    }
}



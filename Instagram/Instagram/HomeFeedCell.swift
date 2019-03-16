//
//  HomeFeedCell.swift
//  Instagram
//
//  Created by Owen Henley on 16/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SnapKit

class HomeFeedCell: UICollectionViewCell {

    // MARK: - Properties
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageURL else {
                return
            }
            photoImageView.loadImage(from: imageUrl)
        }
    }

    // MARK: - Controls
    let photoImageView = CustomImageView()
    let userProfileImageView = CustomImageView()
    let usernameLabel = UILabel()
    let optionsButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let commentButton = UIButton(type: .system)
    let sendMessageButton = UIButton(type: .system)
    let bookmarkButton = UIButton(type: .system)
    let captionLabel = UILabel()
    let postDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Views
private extension HomeFeedCell {
    func layoutViews() {
        backgroundColor = .white
        addSubviews()
        layoutUserProfileImageView()
        layoutUsernameLabel()
        layoutPhotoImageView()
        layoutOptionsButton()
        setupButtonToolbar()
        layoutToolbar()
        layoutCaptionLabel()
        layoutPostDateLabel()
    }

    func addSubviews() {
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(optionsButton)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(sendMessageButton)
        addSubview(bookmarkButton)
        addSubview(captionLabel)
        addSubview(postDateLabel)
    }

    func layoutUserProfileImageView() {
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        userProfileImageView.backgroundColor = .black
        userProfileImageView.layer.cornerRadius = 20

        userProfileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
    }

    func layoutUsernameLabel() {
        usernameLabel.text = "username"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)

        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(userProfileImageView.snp.right).offset(12)
            make.right.equalTo(optionsButton.snp.left).inset(8)
            make.centerY.equalTo(userProfileImageView.snp.centerY)
        }
    }

    func layoutPhotoImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true

        photoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.frame.width)
        }
    }

    func layoutOptionsButton() {
        optionsButton.setTitle("•••", for: .normal)
        optionsButton.setTitleColor(.black, for: .normal)

        optionsButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalTo(userProfileImageView.snp.centerY)
        }
    }

    func setupButtonToolbar() {
        likeButton.setImage(Icon.Like.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.setImage(Icon.Comment.withRenderingMode(.alwaysOriginal), for: .normal)
        sendMessageButton.setImage(Icon.Send.withRenderingMode(.alwaysOriginal), for: .normal)
        bookmarkButton.setImage(Icon.Ribbon.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    func layoutToolbar() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom)
            make.left.equalToSuperview().inset(8)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }

        bookmarkButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(stackView.snp.centerY)
        }
    }

    func layoutCaptionLabel() {
        let attributedText = NSMutableAttributedString(string: "Username  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: loremIpsum, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        captionLabel.attributedText = attributedText
        captionLabel.numberOfLines = 0

        captionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(likeButton.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(postDateLabel.snp.top)
        }
    }

    func layoutPostDateLabel() {
        postDateLabel.text = "Yesterday"
        postDateLabel.textColor = .lightGray
        postDateLabel.font = UIFont.systemFont(ofSize: 13)

        postDateLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(8)
            make.height.equalTo(25)
        }
    }
}

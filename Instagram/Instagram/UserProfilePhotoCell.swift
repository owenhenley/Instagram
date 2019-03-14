//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Owen Henley on 14/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class UserProfilePhotoCell: UICollectionViewCell {

    // MARK: - Properties
    var post: Post? {
        didSet {
            guard let imageData = post?.imageURL else {
                return
            }
            photoImageView.loadImage(from: imageData)
        }
    }

    // MARK: - Controls
    let photoImageView = CustomImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Layout and setup the image view
    private func layoutImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true

        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

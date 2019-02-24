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

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 80 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(12)
            make.size.equalTo(80)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupProfileImage() {
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
    }
}

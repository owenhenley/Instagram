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

    var post: Post? {
        didSet {
            setImage()
        }
    }

    let photoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setImage() {
        SVProgressHUD.show()
        guard let imageData = post?.imageURL else {
            return
        }

        guard let url = URL(string: imageData) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                return
            }

            print(response ?? "No Response")

            guard let imageData = data else {
                return
            }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async {
                self.photoImageView.image = image
                SVProgressHUD.dismiss()
            }
        }.resume()
    }

    private func setupImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true

        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

//
//  PhotoSelectorHeader.swift
//  Instagram
//
//  Created by Owen Henley on 10/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {

    // MARK: - Properties
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutPhotoImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout view elements
private extension PhotoSelectorHeader {
    func layoutPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

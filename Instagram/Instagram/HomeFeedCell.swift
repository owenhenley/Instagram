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

    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageURL else {
                return
            }
            imageView.loadImage(from: imageUrl)
        }
    }

    let imageView = CustomImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeFeedCell {
    func layoutImageView() {
        imageView.backgroundColor = .cyan
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}

//
//  PhotoSelectorVC.swift
//  Instagram
//
//  Created by Owen Henley on 10/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController {

    // MARK: - Properties
    private let cellId = "cellId"
    private let headerId = "headerId"
    private var images = [UIImage]()
    private var selectedImage: UIImage?
    private var headerImage: PhotoSelectorHeader?
    private var assets = [PHAsset]()
    private let assetFetchOptions: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: creationDate, ascending: false)
        fetchOptions.fetchLimit = 100
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }()
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewRegister()
        setupNavigationButtons()
        fetchPhotos()
    }

    // MARK: - Methods
    /// Sets collection view background to white and registers the header and small image cells.
    private func setupCollectionViewRegister() {
        collectionView?.backgroundColor = .white
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }

    /// Setup the navigation bar's cancel and next buttons.
    private func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleNext))
    }

    /// Handle cancel bar button.
    @objc private func handleCancel() {
        dismiss(animated: true)
    }

    /// Handle next bar button.
    @objc private func handleNext() {
        let sharePhotoVC = SharePhotoVC()
        sharePhotoVC.selectedImage = headerImage?.photoImageView.image
        navigationController?.pushViewController(sharePhotoVC, animated: true)
    }

    /// Fetch photos from the users camera roll. (make sure `Privacy - Photo Library Usage Description` is setup.)
    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions)
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 150, height: 150)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset,
                                          targetSize: targetSize,
                                          contentMode: .aspectFill, options: options, resultHandler: { (image, _) in
                                            if let image = image {
                                                self.images.append(image)
                                                self.assets.append(asset)

                                                if self.selectedImage == nil {
                                                    self.selectedImage = image
                                                }
                                            }

                                            if count == allPhotos.count - 1 {
                                                DispatchQueue.main.async {
                                                    self.collectionView.reloadData()
                                                }
                                            }
                })
            }
        }
    }
}

// MARK: - Setup Collection View
extension PhotoSelectorVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                            for: indexPath) as? PhotoSelectorCell else {
                                                                return UICollectionViewCell()
        }
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        collectionView.reloadData()

        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: headerId, for: indexPath) as? PhotoSelectorHeader else {
                                                                            return UICollectionViewCell()
        }

        // Low res pre-load
        headerImage = header
        header.photoImageView.image = selectedImage

        // Hi-Res version
        if let selectedImage = selectedImage {
            if let selectedIndex = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[selectedIndex]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset,
                                          targetSize: targetSize,
                                          contentMode: .aspectFill,
                                          options: nil) { (image, info) in
                                            header.photoImageView.image = image
                                            // TODO: - Cache image
                                            // TODO: - Can't seem to detet RAW images
                }
            }
        }
        return header
    }
}

// MARK: - Setup collection view sizing
extension PhotoSelectorVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 3) / 4
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

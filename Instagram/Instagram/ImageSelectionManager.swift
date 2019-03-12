// //
// //  ImageSelectionManager.swift
// //  Instagram
// //
// //  Created by Owen Henley on 10/03/2019.
// //  Copyright © 2019 Owen Henley. All rights reserved.
// //
// 
// import UIKit
// import Photos
// 
// class ImageSelectionManager {
// 
//     static let shared = ImageSelectionManager()
//     
//     func fetchPhotos(images: [UIImage], selectedImage: UIImage?,
//                             // completion: @escaping (_ images: [UIImage], _ selectedImage: UIImage?) -> Void?,
//                             reload: @escaping () -> Void?) {
//         let fetchOptions = PHFetchOptions()
//         let sortDescriptor = NSSortDescriptor(key: creationDate, ascending: false)
//         fetchOptions.fetchLimit = 100
//         fetchOptions.sortDescriptors = [sortDescriptor]
// 
//         let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//         allPhotos.enumerateObjects { (asset, count, stop) in
//             let imageManager = PHImageManager.default()
//             let targetSize = CGSize(width: 350, height: 350)
//             let options = PHImageRequestOptions()
//             options.isSynchronous = true
//             imageManager.requestImage(for: asset,
//                                       targetSize: targetSize,
//                                       contentMode: .aspectFill, options: options, resultHandler: { (image, _) in
//                                         var images = images
//                                         var selectedImage = selectedImage
// 
//                                         if let image = image {
//                                             images.append(image)
// 
//                                             if selectedImage == nil {
//                                                 selectedImage = image
//                                             }
//                                         }
// 
//                                         if count == allPhotos.count - 1 {
//                                             DispatchQueue.main.async {
//                                                 reload()
//                                             }
//                                         }
//             })
//         }
//         // completion(images, selectedImage)
//         return
//     }
// }
// 

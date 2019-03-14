//
//  CusomImageView.swift
//  Instagram
//
//  Created by Owen Henley on 14/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit
import SVProgressHUD

class CustomImageView: UIImageView {

    var lastUrlUsedToLoadImage: String?

    func loadImage(from urlString: String) {

        lastUrlUsedToLoadImage = urlString

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error in File: \(#file), Function: \(#function), Line: \(#line), Message: \(error). \(error.localizedDescription)")
                SVProgressHUD.dismiss()
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }

            print(response ?? "No Response")

            guard let imageData = data else {
                return
            }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
        SVProgressHUD.dismiss()
    }
}

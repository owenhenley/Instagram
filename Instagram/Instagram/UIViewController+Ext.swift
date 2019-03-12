//
//  UIViewController+Ext.swift
//  Instagram
//
//  Created by Owen Henley on 12/03/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

/// Extension file for cutsom UIViewController methods.
extension UIViewController {

    /// Add's a tap gesture recogniser to the view. When the user taps anyware
    /// outsude of the keyboard or editing view, the keyboard is dismissed.
    func enableTapScreenToDismiss() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }

    /// Resign keyboard by ending editing.
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

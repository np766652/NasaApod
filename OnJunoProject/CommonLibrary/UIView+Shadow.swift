//
//  UIView+Shadow.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation
import UIKit


/**
 Adds Shadow to uiview
 Todo: need to check efficiency
 */
extension UIView {
    
   @objc public func addShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}

extension UIImageView {
    public override func addShadow() {
        super.addShadow()
        self.layer.shadowOpacity = 0.3
    }
}


//
//  ImageConstant.swift
//  OnJunoProject
//
//  Created by Nikunj Patel on 24/05/22.
//

import Foundation
import UIKit

/**
    Prepares a uiimage from asset 
    - returns: UIImage.
*/
enum ImageConstant: String {
    case placeholder
    case splashScreen
    case backgroundImage
    
    public var image: UIImage? {
        return UIImage(named: self.rawValue)?.withRenderingMode(.alwaysOriginal)
    }
}

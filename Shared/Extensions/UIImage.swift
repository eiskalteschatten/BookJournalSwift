//
//  UIImage.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 29.03.22.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}

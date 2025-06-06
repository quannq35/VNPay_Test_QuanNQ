//
//  Image+Ext.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width

extension UIImage {
    
    func resizedToWidth(ratio: Float) -> UIImage {
        let targetWidth = UIScreen.main.bounds.width
        let targetHeight = targetWidth / CGFloat(ratio)
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}



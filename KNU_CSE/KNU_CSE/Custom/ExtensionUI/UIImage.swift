//
//  UIImage.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
         var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
         // Trim off the extremely small float value to prevent core graphics from rounding it up
         newSize.width = floor(newSize.width)
         newSize.height = floor(newSize.height)

         UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
         let context = UIGraphicsGetCurrentContext()!

         // Move origin to middle
         context.translateBy(x: newSize.width/2, y: newSize.height/2)
         // Rotate around middle
         context.rotate(by: CGFloat(radians))
         // Draw the image at its center
         self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return newImage
     }
}


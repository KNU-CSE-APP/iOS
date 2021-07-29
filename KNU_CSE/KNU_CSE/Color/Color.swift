//
//  Color.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/16.
//

import Foundation
import UIKit

struct Color{
    static let mainColor : UIColor = UIColor.red
    static let subColor : UIColor = UIColor(red: 51/255, green: 13/255, blue: 0/255, alpha: 1)
    static let backColor : UIColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    static let green : UIColor = UIColor(red: 149/255, green: 241/255, blue: 159/255, alpha: 1)
    static let gray : UIColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
}

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
}
 





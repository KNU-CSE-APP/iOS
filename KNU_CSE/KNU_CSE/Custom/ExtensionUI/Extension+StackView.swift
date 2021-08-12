//
//  ExtensionStackView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/11.
//

import UIKit
extension UIStackView {
    func removeAllArrangedView() {
        for item in arrangedSubviews {
            removeArrangedSubview(item)
            item.removeFromSuperview()
        }
    }
}

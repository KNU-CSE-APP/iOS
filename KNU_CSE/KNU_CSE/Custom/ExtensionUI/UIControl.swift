//
//  UIControl.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import UIKit

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction {(action: UIAction) in closure() }, for: controlEvents)
    }
}

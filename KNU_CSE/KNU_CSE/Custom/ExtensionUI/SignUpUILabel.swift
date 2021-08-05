//
//  SignUpUiLabel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import Foundation
import UIKit

class SignUpUILabel: UILabel {
    init(text: String){
        super.init(frame: CGRect())
        self.text = text
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    init(text:String, alignment:NSTextAlignment, color:UIColor){
        super.init(frame: CGRect())
        self.text = text
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.textAlignment = alignment
        self.textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

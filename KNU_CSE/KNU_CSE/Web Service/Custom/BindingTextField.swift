//
//  BindingTextField.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Foundation
import UIKit

class BindingTextField: UITextField {
    var textChanged: (String) -> Void = { _ in }
    
    func bind(callBack: @escaping (String) -> Void) {
        textChanged = callBack
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        //UITextField에 이미 있는 프로퍼티
        guard let text = text else { return }
        textChanged(text)
    }

    
    func draw(){
        setUpBorder()
        setLeftPaddingPoints(CGFloat(10))
        setUpImage(imageName: "exclamationmark.triangle.fill", on: .right, color: UIColor.systemRed)
    }
    
    func setUpBorder() {
        let borderWidth:CGFloat = 1.5
        let cornerRadius:CGFloat = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.cornerRadius = cornerRadius
   }
    
}

enum TextFieldImageSide {
    case left
    case right
}

extension BindingTextField {
    func setUpImage(imageName: String, on side: TextFieldImageSide, color : UIColor) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        if let imageWithSystemName = UIImage(systemName: imageName) {
            imageView.image = imageWithSystemName
        } else {
            imageView.image = UIImage(named: imageName)
        }
        
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        imageContainerView.addSubview(imageView)
        
        switch side {
        case .left:
            leftView = imageContainerView
            leftViewMode = .always
        case .right:
            imageView.tintColor = color
            rightView = imageContainerView
            rightViewMode = .always
        }
    }
    
    
    func setLeftPaddingPoints(_ amount:CGFloat){ 
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    enum pwResult{
        case Success
        case Fail
    }
    
    func textFieldBorderSetup(result : pwResult){
        switch result {
        case .Success:
            setUpBorderColor(color: UIColor.systemBlue)
            removeImage(on: .right)
            //setUpImage(imageName: "exclamationmark.triangle.fill", on: .right, color: UIColor.systemBlue)
        case .Fail:
            setUpBorderColor(color: UIColor.systemRed)
            setUpImage(imageName: "exclamationmark.triangle.fill", on: .right, color: UIColor.systemRed)
        }
        
    }
    
    func removeImage(on side: TextFieldImageSide){
        rightView = nil
        switch side {
        case .left:
            leftView = nil
        case .right:
            rightView = nil
        }
    }
}

extension UITextField{
    func setUpBorderColor(color : UIColor){
        self.layer.borderColor = color.cgColor
    }
}

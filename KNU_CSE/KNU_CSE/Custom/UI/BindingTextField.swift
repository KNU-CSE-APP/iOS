//
//  BindingTextField.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Foundation
import UIKit
import SnapKit

class BindingTextField: UITextField {
    var textChanged: (String) -> Void = { _ in }
    let textfont : UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    func bind(callBack: @escaping (String) -> Void) {
        textChanged = callBack
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let text = text else { return }
        textChanged(text)
    }

    init(){
        super.init(frame: CGRect())
        self.font = textfont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(){
        setUpBorder()
        setLeftPaddingPoints(CGFloat(10))
    }
    
    func prefixDraw(text : String, on side: TextFieldImageSide){
        setUpText(text: text, on: side, color: UIColor.black)
    }
    
    func setUpBorder() {
        let borderWidth:CGFloat = 1
        let cornerRadius:CGFloat = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = cornerRadius
   }
    
    func setupUpperBorder() {
        let borderWidth:CGFloat = 1
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.systemRed.cgColor
   }
}

enum TextFieldImageSide {
    case left
    case right
}

extension BindingTextField {
    func setUpImage(imageName: String, on side: TextFieldImageSide, color : UIColor, width : ConstraintRelatableTarget, height : ConstraintRelatableTarget) {
        let btn = UIButton()
        
        btn.addAction {
            self.isSecureTextEntry.toggle()
        }
        
        let image = UIImage(systemName: imageName)
        btn.tintColor = color
        
        btn.setImage(image , for: .normal)
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(btn)
        
        switch side {
        case .left:
            leftView = imageContainerView
            leftViewMode = .always
        case .right:
            rightView = imageContainerView
            rightViewMode = .always
        }

        imageContainerView.snp.makeConstraints{ make in
            make.width.equalTo(width).multipliedBy(1)
            make.height.equalTo(height).multipliedBy(1)
        }
        
        btn.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.right.equalTo(-10)
        }
    }
    
    func setUpText(text : String, on side: TextFieldImageSide, color : UIColor) {
        var leftpadding = 0
        switch side {
        case .left:
            leftpadding = 20
        case .right:
            leftpadding = -15
        }
        
        
        let textlabel = UILabel(frame: CGRect(x: leftpadding, y: 0, width: 70, height: 40))
        textlabel.textColor = color
        textlabel.text = text
        
        let textContainerView = UIView(frame: CGRect(x: leftpadding, y: 0, width: 70, height: 40))
        textContainerView.addSubview(textlabel)
        textlabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        switch side {
        case .left:
            leftView = textContainerView
            leftViewMode = .always
        case .right:
            rightView = textContainerView
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
            setUpBorderColor(color: UIColor.darkGray)
            //removeImage(on: .right)
        case .Fail:
            setUpBorderColor(color: UIColor.systemRed)
            //setUpImage(imageName: "exclamationmark.triangle.fill", on: .right, color: UIColor.darkGray, width: 40, height: 40)
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
    
    func editContentType(){
        if self.textContentType == .password{
            self.textContentType = nil
        }else {
            self.textContentType = .password
        }
    }
    
}

extension UITextField{
    func setUpBorderColor(color : UIColor){
        self.layer.borderColor = color.cgColor
    }
}

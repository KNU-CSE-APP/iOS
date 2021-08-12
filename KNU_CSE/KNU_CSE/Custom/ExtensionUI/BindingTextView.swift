//
//  BindingTextView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/09.
//

import UIKit

class BindingTextView: UITextView {
    var textChanged: (String) -> Void = { _ in }

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

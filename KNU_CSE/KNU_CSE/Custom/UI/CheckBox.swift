//
//  CheckBox.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import M13Checkbox
import UIKit
import SnapKit

class CheckBox : UIView{
    
    var width : CGFloat
    var height : CGFloat
    var text : String
    
    var checkBox : M13Checkbox
    var label : UILabel
    
    var action : () -> Void = { }
    
    init(width:CGFloat, height:CGFloat, text:String){
        self.width = width
        self.height = height
        self.text = text
        
        checkBox = M13Checkbox()
        label = UILabel()
        super.init(frame: CGRect())
        
        setUpView()
        addView()
        setUpCheckBox()
        setUpLabel()
    }
    
    func setUpView(){
        frame = CGRect(x: 0, y: 0, width: width, height: height)
        tintColor = .red
    }
    
    func addView(){
        self.addSubview(checkBox)
        self.addSubview(label)
    }
    
    func setUpCheckBox(){
        checkBox.snp.makeConstraints{ make in
            make.width.equalTo(height * 0.5)
            make.height.equalTo(height * 0.5)
            make.leading.equalToSuperview().offset(0)
            make.top.equalTo(height * 0.25)
            make.bottom.equalTo(height * 0.25)
        }
    }
    
    func setUpLabel(){
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.snp.makeConstraints{ make in
            make.width.equalTo(width).multipliedBy(0.5)
            make.height.equalTo(height)
            make.leading.equalTo(checkBox.snp.trailing).offset(5)
        }
    }
    
    func setChecked(checkState:Bool){
        if checkState{
            self.checkBox.checkState = .checked
        }else{
            self.checkBox.checkState = .unchecked
        }
        
    }
    
    func bind(callBack: @escaping () -> Void){
        action = callBack
        checkBox.addTarget(self, action: #selector(stateDidChange(_:)), for: .valueChanged)
    }
    
    func setColor(tintColor:UIColor, textColor:UIColor){
        self.tintColor = tintColor
        label.textColor = textColor
    }
    
    @objc func stateDidChange(_ sender: M13Checkbox)  {
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

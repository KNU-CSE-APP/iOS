//
//  ClassSeatCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import UIKit
import SnapKit

class ClassSeatCell:UICollectionViewCell{
    static let identifier = "ClassSeatCell"
    var action:()->() = {}
    var _classSeat:ClassSeat!
    
    var classSeat: ClassSeat{
        get{
            return _classSeat
        }set(newValue){
            _classSeat = newValue
            self.isUsable = newValue.status
            self.seatBtn.setTitle(String(self.classSeat.seatNumber), for: .normal)
        }
    }
    
    var seatBtn:UIButton!{
        didSet{
            seatBtn.layer.cornerRadius = 10
        }
    }
    
    var _isUsable : Bool!
    var isUsable : Bool{
        get{
            return _isUsable
        }set(newValue){
            _isUsable = newValue
            if _isUsable{
                setUsable()
            }else{
                setUnUsable()
            }
        }
    }
    override init(frame: CGRect) {
       super.init(frame: frame)
       draw()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(){
        initUI()
        addView()
        setUpConstraints()
    }
    
    func initUI(){
        seatBtn = UIButton()
    }
    
    func addView(){
        self.contentView.addSubview(seatBtn)
    }
    
    func setUpConstraints(){
        seatBtn.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setUsable(){
        seatBtn.backgroundColor = Color.green
        seatBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        seatBtn.addAction {
            self.action()
        }
    }
    
    func setUnUsable(){
        seatBtn.backgroundColor = Color.gray
    }
    
    func setBtnAction(action:@escaping()->()){
        self.action = action
    }
}

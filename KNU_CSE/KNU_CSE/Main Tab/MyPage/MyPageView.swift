//
//  MyPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import UIKit
import SnapKit

class MyPageView : UIViewController{
    
    var testbtn :UIButton!{
        didSet{
            testbtn.backgroundColor = Color.subColor
            testbtn.setTitle("로그아웃", for: .normal)
            testbtn.setTitleColor(.black, for: .highlighted)
            testbtn.addAction {
                //UserDefaults.standard.removeObject(forKey: "checkState")
                guard StorageManager.shared.readUser() != nil else {
                    print("유저 정보 없음")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                if StorageManager.shared.deleteUser(){
                    print("삭제성공")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("삭제싪패")
                }
            }
        }
    }
    
    var testbtn2 :UIButton!{
        didSet{
            testbtn2.backgroundColor = Color.subColor
            testbtn2.setTitle("test", for: .normal)
            testbtn2.setTitleColor(.black, for: .highlighted)
            testbtn2.addAction {
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "마이페이지"
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        testbtn = UIButton()
    }
    
    func addView(){
        self.view.addSubview(testbtn)
    }
    
    func setupConstraints(){
        testbtn.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(100)
            make.centerY.equalToSuperview()
        }
    }
}

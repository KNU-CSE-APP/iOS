//
//  TabView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit
import SnapKit

class TabView : UIViewController{
    
    var testbtn :UIButton!{
        didSet{
            testbtn.backgroundColor = Color.subColor
            testbtn.setTitle("로그아웃", for: .normal)
            testbtn.setTitleColor(.black, for: .highlighted)
            testbtn.addAction {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    var testbtn2 :UIButton!{
        didSet{
            testbtn2.backgroundColor = Color.subColor
            testbtn2.setTitle("test", for: .normal)
            testbtn2.setTitleColor(.black, for: .highlighted)
            testbtn2.addAction {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView")
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //push했기때문에 backbutton 없애기
        self.navigationItem.setHidesBackButton(true, animated: true);
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

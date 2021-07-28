//
//  MyPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class UserInformView:UIViewController, ViewProtocol{
    
    var profileBtn:UIButton!{
        didSet{
            let image = UIImage(systemName: "person.crop.circle")?.resized(toWidth: 150)
            self.profileBtn.setImage(image, for: .normal)
        }
    }
    
    var nameLabel:UILabel!{
        didSet{
            nameLabel.text = "노준석"
            nameLabel.textAlignment = .center
            nameLabel.layer.borderWidth = 0.5
            nameLabel.layer.borderColor = UIColor.lightGray.cgColor
            nameLabel.layer.cornerRadius = 3
            nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    var stuidLabel:UILabel!{
        didSet{
            stuidLabel.text = "2016117285"
            stuidLabel.textAlignment = .center
            stuidLabel.layer.borderWidth = 0.5
            stuidLabel.layer.borderColor = UIColor.lightGray.cgColor
            stuidLabel.layer.cornerRadius = 3
            stuidLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    var nickNameLabel:UITextField!{
        didSet{
            nickNameLabel.text = "IYNONE"
            nickNameLabel.textAlignment = .center
            nickNameLabel.layer.borderWidth = 0.5
            nickNameLabel.layer.borderColor = UIColor.lightGray.cgColor
            nickNameLabel.layer.cornerRadius = 3
            nickNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI() {
        self.profileBtn = UIButton()
        self.nameLabel = UILabel()
        self.stuidLabel = UILabel()
        self.nickNameLabel = UITextField()
    }
    
    func addView() {
        _ = [self.profileBtn, self.nameLabel, self.stuidLabel, self.nickNameLabel].map{
            self.view.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        let left_margin = 30
        let right_margin = -30
        let label_height = 45
        
        self.profileBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        self.nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.profileBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.height.equalTo(label_height)
        }
        
        self.stuidLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.height.equalTo(label_height)
        }
        
        self.nickNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.stuidLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.height.equalTo(label_height)
        }
    }
}

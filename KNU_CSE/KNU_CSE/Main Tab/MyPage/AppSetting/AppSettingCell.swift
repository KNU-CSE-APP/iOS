//
//  AppSettingCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//
import UIKit
import SnapKit

class AppSettingCell : UITableViewCell {
    static let identifier = "AppSettingCell"
    var titleLabel:PaddingLabel!{
        didSet{
            titleLabel.textAlignment = .left
        }
    }
    
    var switchBtn:UISwitch!{
        didSet{
            
        }
    }
    var listener : (UISwitch)->Void = { _ in }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        self.titleLabel = PaddingLabel(withInsets: 0, 0, 20, 0)
        self.switchBtn = UISwitch(frame:CGRect.zero)
    }
    
    func addView(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.switchBtn)
    }
    
    func setListener(listener: @escaping(UISwitch)->Void ){
        self.listener = listener
        switchBtn.addTarget(self, action:#selector(onClickSwitch), for: .valueChanged)
    }
    
    @objc func onClickSwitch(){
        self.listener(self.switchBtn)
    }
    
    func setUpConstraints(){
        self.titleLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(0)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        
        self.switchBtn.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
    }
}

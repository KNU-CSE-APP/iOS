//
//  ReservationCheckCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import UIKit

class ReservationCheckCell : UITableViewCell {
    static let identifier = "ReservationCheckCell"
    var titleView = UIView()
    var titleLabel = UILabel()
    var contentLabel = UILabel()
    
    var action :()->() = {}
    
    func setTitle(text: String) {
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        titleLabel.textAlignment = .right
    }
    
    func setContent(text: String) {
        contentLabel.text = text
        contentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        contentLabel.textAlignment = .left
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
        
    }
    
    func addView(){
        self.contentView.addSubview(titleView)
        self.contentView.addSubview(contentLabel)
        
        self.titleView.addSubview(titleLabel)
    }
    
    func setUpConstraints(){
        titleView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints{ make in
            make.left.equalTo(titleView.snp.right).offset(0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(0)
        }
    }
}

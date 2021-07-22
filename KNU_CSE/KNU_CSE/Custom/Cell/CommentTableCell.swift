//
//  CommentTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import UIKit

class CommentTableCell : UITableViewCell {
    static let identifier = "CommentTableCell"
    var titleView = UIView()
    
    var titleLabel:UILabel!{
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
            titleLabel.textAlignment = .right
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            contentLabel.textAlignment = .left
        }
    }
    
    var action :()->() = {}
    
    var comment:Comment!{
        didSet{
            titleLabel.text = comment.author
            contentLabel.text = comment.content
            
            self.setUpConstraints()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
        self.addView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        self.titleLabel = UILabel()
        self.contentLabel = UILabel()
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

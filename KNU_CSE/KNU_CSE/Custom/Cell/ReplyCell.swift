//
//  ReplyTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import UIKit

class ReplyCell : UIView {
    let titleHeight:CGFloat = 30
    
    var arrowImageView:UIImageView!{
        didSet{
            let image = UIImage(systemName: "arrow.turn.down.right")
            arrowImageView.image = image
            arrowImageView.tintColor = Color.mainColor
        }
    }
    
    var authorImageView:UIImageView!{
        didSet{
            let image = UIImage(systemName: "person.crop.square.fill")
            authorImageView.image = image
            authorImageView.tintColor = .lightGray
        }
    }
    
    var authorLabel:UILabel!{
        didSet{
            authorLabel.text = reply.author
            authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            authorLabel.textAlignment = .left
            authorLabel.sizeToFit()
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.text = reply.content
            contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
            contentLabel.textAlignment = .left
            contentLabel.numberOfLines = 0
            contentLabel.sizeToFit()
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            dateLabel.text = reply.date
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            dateLabel.textAlignment = .left
        }
    }
    
    var reply:Reply
    
    init(reply:Reply) {
        self.reply = reply
        super.init(frame: CGRect())
        self.draw()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func draw(){
    }
    
    func initUI(){
        self.arrowImageView = UIImageView()
        self.authorImageView = UIImageView()
        self.authorLabel = UILabel()
        self.contentLabel = UILabel()
        self.dateLabel = UILabel()
    }
    
    func addView(){
        self.addSubview(arrowImageView)
        self.addSubview(authorImageView)
        self.addSubview(authorLabel)
        self.addSubview(contentLabel)
        self.addSubview(dateLabel)
    }
    
    func setUpConstraints(){
        let top_margin = 10
        let left_margin = 50
        let right_margin = -20
        let bottom_margin = -5
        let arrow_width = titleHeight * 0.5
        
        arrowImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(top_margin)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(arrow_width)
            make.height.equalTo(arrow_width)
        }
        
        authorImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(top_margin)
            make.left.equalTo(self.arrowImageView.snp.right).offset(5)
            make.height.equalTo(authorLabel.snp.height)
            make.width.equalTo(authorLabel.snp.height)
        }
        
        authorLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(top_margin)
            make.left.equalTo(authorImageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(right_margin)
        }
        
        contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.authorLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.bottom.equalToSuperview().offset(bottom_margin)
        }
    }
}

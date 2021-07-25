//
//  CommentTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import UIKit

class CommentCell : UIView {
    let titleHeight:CGFloat = 30
    var borderLine:UIView!{
        didSet{
            borderLine.layer.borderWidth = 0.3
            borderLine.layer.borderColor = UIColor.lightGray.cgColor
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
            authorLabel.text = comment.author
            authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            authorLabel.textAlignment = .left
            authorLabel.sizeToFit()
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.text = comment.content
            contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
            contentLabel.textAlignment = .left
            contentLabel.numberOfLines = 0
            contentLabel.sizeToFit()
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            dateLabel.text = comment.date
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            dateLabel.textAlignment = .left
            dateLabel.sizeToFit()
        }
    }
    
    var replyBtn:UIButton!{
        didSet{
            replyBtn.setTitle("답글달기", for: .normal)
            replyBtn.setTitleColor(.black, for: .normal)
            replyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            replyBtn.sizeToFit()
            replyBtn.addAction {
                print("ttttt")
            }
        }
    }
    
    var comment:Comment
    
    init(comment:Comment) {
        self.comment = comment
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
        self.borderLine = UIView()
        self.authorImageView = UIImageView()
        self.authorLabel = UILabel()
        self.contentLabel = UILabel()
        self.dateLabel = UILabel()
        self.replyBtn = UIButton()
    }
    
    func addView(){
        self.addSubview(borderLine)
        self.addSubview(authorImageView)
        self.addSubview(authorLabel)
        self.addSubview(contentLabel)
        self.addSubview(dateLabel)
        self.addSubview(replyBtn)
    }
    
    func setUpConstraints(){
        let top_margin = 10
        let left_margin = 20
        let right_margin = -20
        let bottom_margin = -5
        
        borderLine.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.3)
        }
        
        authorImageView.snp.makeConstraints{ make in
            make.top.equalTo(borderLine.snp.bottom).offset(top_margin)
            make.left.equalToSuperview().offset(left_margin)
            make.height.equalTo(authorLabel.snp.height)
            make.width.equalTo(authorLabel.snp.height)
        }
        
        authorLabel.snp.makeConstraints{ make in
            make.top.equalTo(borderLine.snp.bottom).offset(top_margin)
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
            make.bottom.equalToSuperview().offset(bottom_margin)
        }
        
        replyBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.left.equalTo(self.dateLabel.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(bottom_margin)
        }
    }
}

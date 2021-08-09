//
//  BoardCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import UIKit
import SnapKit

class FreeBoardCell : UITableViewCell {
    static let identifier = "FreeBoardCell"
    
    var height:CGFloat!{
        didSet{
            setUpConstraints()
        }
    }
    
    var authorLabel:UILabel!{
        didSet{
            authorLabel.textAlignment = .left
            authorLabel.textColor = UIColor.black
            authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            dateLabel.textAlignment = .right
            dateLabel.textColor = UIColor.black
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        }
    }
    
    var titleLabel:UILabel!{
        didSet{
            titleLabel.textAlignment = .left
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.textAlignment = .left
            contentLabel.textColor = UIColor.black
            contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
            contentLabel.numberOfLines = 2
        }
    }
    
    var commentImage:UIImageView!{
        didSet{
            let image = UIImage(systemName: "text.bubble.fill")
            commentImage.image = image
            commentImage.tintColor = .lightGray
        }
    }
    
    var commentLabel:UILabel!{
        didSet{
            commentLabel.textAlignment = .left
            commentLabel.textColor = UIColor.black
            commentLabel.font = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
        }
    }
    
    var categoryLabel:UILabel!{
        didSet{
            self.categoryLabel.textAlignment = .center
            self.categoryLabel.textColor = UIColor.lightGray
            self.categoryLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        }
    }
    
    var board : Board!{
        didSet{
            self.setAuthorText(title: board.author)
            self.setDateText(title: board.time)
            self.setTitleText(title: board.title)
            self.setContentText(title: board.content)
            self.setCommentText(title: String(board.commentCnt))
            self.setCategoryText(title: board.category)
        }
    }
    
    override func prepareForReuse() {
        
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
        authorLabel = UILabel()
        dateLabel = UILabel()
        titleLabel = UILabel()
        contentLabel = UILabel()
        categoryLabel = UILabel()
        commentImage = UIImageView()
        commentLabel = UILabel()
    }
    
    func addView(){
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(commentImage)
        self.contentView.addSubview(commentLabel)
    }
    
    func setUpConstraints(){

        self.authorLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(height*0.2)
        }
        
        self.dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(authorLabel.snp.top)
            make.left.equalTo(self.authorLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(height*0.2)
        }
        
        self.titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(authorLabel.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(height*0.2)
        }

        self.contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(height*0.25)
        }
        
        self.commentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(height*0.15)
            make.width.equalTo(height*0.15)
        }
        
        self.commentImage.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.right.equalTo(commentLabel.snp.left).offset(-5)
            make.height.equalTo(height*0.15)
            make.width.equalTo(height*0.15)
        }
        
        self.categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(height*0.15)
            //make.width.equalTo(height*0.15)
        }
        
    }
}

extension FreeBoardCell{
    func setAuthorText(title: String) {
        authorLabel.text = title
    }
    
    func setDateText(title: String) {
        dateLabel.text = title
    }
    
    func setTitleText(title: String) {
        titleLabel.text = title
    }
    
    func setContentText(title: String) {
        contentLabel.text = title
    }
    
    func setCommentText(title: String) {
        commentLabel.text = title
    }
    
    func setCategoryText(title : String){
        categoryLabel.text = "#\(title)"
    }
}




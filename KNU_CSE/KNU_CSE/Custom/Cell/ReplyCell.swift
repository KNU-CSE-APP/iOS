//
//  ReplyTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import UIKit

class ReplyCell : UIView {
    let titleHeight:CGFloat = 30
    var imageSize:CGFloat!
    
    var arrowImageView:UIImageView!{
        didSet{
            let image = UIImage(systemName: "arrow.turn.down.right")
            arrowImageView.image = image
            arrowImageView.tintColor = Color.mainColor
        }
    }
    
    var image:UIImage!
    
    var authorImageView:UIImageView!{
        didSet{
            self.imageSize = authorLabel.font.lineHeight + 4
            
            authorImageView.image = self.image
            authorImageView.clipsToBounds = true
            authorImageView.contentMode = .scaleAspectFill
            authorImageView.layer.borderWidth = 1
            authorImageView.layer.borderColor = UIColor.clear.cgColor
            authorImageView.layer.cornerRadius = imageSize / 4
            authorImageView.frame.size = CGSize(width: imageSize, height: imageSize)
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
        self.setImage()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(){
        do {
            let url = URL(string: self.reply.image)
            let data =  try Data(contentsOf: url!)
            self.image = UIImage(data: data)
        } catch  {
            self.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
        }
    }
    
    func initUI(){
        self.arrowImageView = UIImageView()
        self.authorLabel = UILabel()
        self.authorImageView = UIImageView()
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
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
        }
        
        authorLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(self.authorImageView)
            make.left.equalTo(authorImageView.snp.right).offset(7)
            make.right.equalToSuperview().offset(right_margin)
        }
        
        contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.authorImageView.snp.bottom).offset(5)
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

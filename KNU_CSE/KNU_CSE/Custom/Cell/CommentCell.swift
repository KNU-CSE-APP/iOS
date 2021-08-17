//
//  CommentTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import UIKit

class CommentCell : UIView {
    let titleHeight:CGFloat = 30
    var imageSize:CGFloat!
    
    var borderLine:UIView!{
        didSet{
            borderLine.layer.borderWidth = 0.3
            borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var image:UIImage!
    
    var authorImageView:UIImageView!{
        didSet{
            self.imageSize = authorLabel.font.lineHeight + 8
            
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
            authorLabel.text = comment.author
            authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            authorLabel.textAlignment = .left
            authorLabel.sizeToFit()
        }
    }

    var settingBtn:UIButton!{
        didSet{
            self.settingBtn.setImage(UIImage.init(systemName: "ellipsis")?.rotate(radians: .pi/2)?.withTintColor(UIColor.lightGray), for: .normal)
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.text = comment.content
            contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
            contentLabel.textAlignment = .left
            contentLabel.numberOfLines = 0
            contentLabel.sizeToFit()
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            dateLabel.text = comment.time
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
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
        }
    }
    
    var comment:Comment
    
    init(comment:Comment) {
        self.comment = comment
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
            if let loadedImage = self.comment.image, let url = URL(string: loadedImage){
                let data =  try Data(contentsOf: url)
                self.image = UIImage(data: data)
            }else{
                self.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
            }
            
        } catch  {
            self.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
        }
    }
    
    func initUI(){
        self.borderLine = UIView()
        self.authorLabel = UILabel()
        self.authorImageView = UIImageView()
        self.settingBtn = UIButton()
        self.contentLabel = UILabel()
        self.dateLabel = UILabel()
        self.replyBtn = UIButton()
    }
    
    func addView(){
        self.addSubview(self.borderLine)
        self.addSubview(self.authorImageView)
        self.addSubview(self.authorLabel)
        self.addSubview(self.settingBtn)
        self.addSubview(self.contentLabel)
        self.addSubview(self.dateLabel)
        self.addSubview(self.replyBtn)
    }
    
    func setUpConstraints(){
        let top_margin = 10
        let left_margin = 20
        let right_margin = -20
        let bottom_margin = -5
        
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.3)
        }
        
        self.authorImageView.snp.makeConstraints{ make in
            make.top.equalTo(borderLine.snp.bottom).offset(top_margin)
            make.left.equalToSuperview().offset(left_margin)
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
        }
        
        self.authorLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(self.authorImageView)
            make.left.equalTo(authorImageView.snp.right).offset(5)
        }
        
        self.settingBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(self.authorLabel)
            make.width.height.equalTo(self.authorLabel.snp.height).dividedBy(0.8)
            make.right.equalToSuperview().offset(right_margin)
        }
        
        self.contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.authorImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
        }
        
        self.dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(left_margin)
            make.bottom.equalToSuperview().offset(bottom_margin)
        }
        
        self.replyBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(3)
            make.left.equalTo(self.dateLabel.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(bottom_margin)
        }
    }
}

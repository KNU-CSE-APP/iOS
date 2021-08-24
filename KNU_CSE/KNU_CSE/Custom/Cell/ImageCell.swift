//
//  ImageCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/25.
//

import UIKit

class ImageCell : UICollectionViewCell {
    static let identifier = "ImageCell"
    
    lazy var imageView: UIButton = {
        var imageView = UIButton()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        return imageView
    }()
    
    lazy var deleteBtn: UIButton = {
        var deleteBtn = UIButton()
        deleteBtn.clipsToBounds = true
        deleteBtn.setImage(UIImage.init(systemName: "xmark.circle.fill")?.withTintColor(.black), for: .normal)
        deleteBtn.imageView?.tintColor = .black
        
        return deleteBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(){
        initUI()
        addView()
        setUpConstraints()
    }
    
    func initUI(){
        
    }
    
    func addView(){
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.deleteBtn)
    }
    
    func setUpConstraints(){
        self.imageView.snp.makeConstraints{ make in
            make.width.height.equalTo(80)
        }
        
        let btnSize = 20
        self.deleteBtn.snp.makeConstraints{ make in
            make.left.equalTo(self.imageView.snp.right)
            make.top.equalTo(self.imageView.snp.top)
            make.width.height.equalTo(btnSize)
        }
    }
}

extension ImageCell{
    func setImage(image: UIImage) {
        self.imageView.setImage(image, for: .normal)
    }
}

//
//  ImageCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/25.
//

import UIKit
import Alamofire

class ImageCell : UICollectionViewCell {
    static let identifier = "ImageCell"
    
    var image: UIImage!{
        didSet{
            self.imageView.setImage(image, for: .normal)
        }
    }
    
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
    
    var imageURL: String = ""{
        didSet{
            self.getImage(imageURL: imageURL, index:0){ [self] data, index in
                if let image = UIImage(data: data)?.resized(toWidth: 100) {
                    self.setImage(image: image)
                }
            }
        }
    }
    var calledType: CalledType!{
        didSet{
            self.setUpConstraints()
        }
    }
    
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
    }
    
    func initUI(){
        
    }
    
    func addView(){
        self.contentView.addSubview(self.imageView)
    }
    
    func setUpConstraints(){
        switch calledType {
        case .boardWrite:
            self.constraintsOfBoardWrite()
        case .boardDetail:
            self.constraintsOfBoardDetail()
        case .none:
            break
        }
        
    }
    
    func constraintsOfBoardWrite(){
        self.contentView.addSubview(self.deleteBtn)
        
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
    
    func constraintsOfBoardDetail(){
        self.imageView.snp.makeConstraints{ make in
            make.width.height.equalTo(100)
        }
    }
    
    enum CalledType{
        case boardWrite
        case boardDetail
    }
}

extension ImageCell{
    func setImage(image: UIImage) {
        self.image = image
    }
    
    public func getImage(imageURL:String, index:Int, successHandler: @escaping (Data, Int)->()){
        AF.request(imageURL, method: .get).responseData{ response in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    successHandler(data, index)
                }
            case .failure(_):
                break
            }
        }
    }
}



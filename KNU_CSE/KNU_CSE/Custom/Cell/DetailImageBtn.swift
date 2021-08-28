
//
//  ImageCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/25.
//

import UIKit
import Alamofire

class ImageView : UIView {
    
    var image: UIImage!{
        didSet{
            self.btn.setImage(image, for: .normal)
        }
    }
    
    lazy var btn: UIButton = {
        var imageView = UIButton()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.imageView?.contentMode = .scaleToFill
        
        return imageView
    }()
    
    init(){
        super.init(frame: CGRect.zero)
        self.draw()
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
        setUpConstraints()
    }
    
    func initUI(){
        
    }
    
    func addView(){
        self.addSubview(self.btn)
    }
    
    func setUpConstraints(){
        self.snp.makeConstraints{ make in
            make.width.height.equalTo(100)
        }
        
        self.btn.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension ImageView{
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






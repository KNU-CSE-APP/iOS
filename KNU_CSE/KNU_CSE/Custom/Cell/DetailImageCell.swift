//
//  DetailImageCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/26.
//

import UIKit

class DetailImageViewController : UIViewController {
    var image: UIImage!
    
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        
    }
    
    func addView(){
        self.view.addSubview(self.imageView)
    }
    
    func setUpConstraints(){
        self.imageView.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width)
        }
    }
}

extension DetailImageViewController{
    func setImage(image: UIImage) {
        self.image = image
        self.imageView.image = image
    }
}

//
//  DetailImageCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/26.
//

import UIKit

class DetailImageViewController : UIViewController {
    var image: UIImage!
    
    lazy var imageView: ISImageView! = {
        var imageView = ISImageView()
        imageView.isInteractable = true
        return imageView
    }()
    var isZooming: Bool = false
    var originalImageCenter:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    deinit {
        print("deinit DetailImageVC")
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
        if image.size.height < image.size.width{
            self.imageView.contentMode = .scaleAspectFit
        }else{
            self.imageView.contentMode = .scaleAspectFill
        }
        self.imageView.image = image
    }
}

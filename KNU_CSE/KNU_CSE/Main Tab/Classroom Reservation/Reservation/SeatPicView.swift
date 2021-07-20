//
//  SeatPicView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import UIKit
import SnapKit

class SeatPicView : UIViewController, ViewProtocol{

    var imageView:UIImageView!{
        didSet{
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            let gesture : UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(dismissView))
            self.view.addGestureRecognizer(gesture)
            imageView.backgroundColor = .green
            imageView.image = UIImage(named: "testImage.jpeg")
            
        }
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setUpConstraints()
    }

    func initUI() {
        imageView = UIImageView()
    }
    
    func addView() {
        self.view.addSubview(imageView)
    }
    
    func setUpConstraints() {
        let top_margin = self.view.frame.height * 0.3
        let left_margin = 10
        let right_margin = -left_margin
        
        imageView.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.top.equalToSuperview().offset(top_margin)
            make.bottom.equalToSuperview().offset(-top_margin)
        }
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
}

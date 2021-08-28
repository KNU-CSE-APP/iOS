//
//  CustomPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/26.
//

import UIKit

class PageViewController: UIPageViewController, ViewProtocol{
    
    let size: CGFloat = 25
    
    lazy var backBtn:UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage.init(systemName: "xmark")?.resized(toWidth: self.size), for: .normal)
        btn.imageView?.tintColor = .black
        btn.addAction {
            self.dismiss(animated: true)
        }
        return btn
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
        self.view.addSubview(self.backBtn)
    }
    
    func setUpConstraints(){
        self.backBtn.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(self.size)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
        }
    }
}

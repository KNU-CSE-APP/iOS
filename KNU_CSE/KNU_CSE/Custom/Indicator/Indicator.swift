//
//  Indicator.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

struct IndicatorView{
    let indicator = NVActivityIndicatorView(frame: CGRect(),
                                            type: .ballSpinFadeLoader,
                                            color: .black,
                                            padding: 0)
    let loadingView = UIView()
    let viewController : UIViewController
    
    init(viewController : UIViewController){
        self.viewController = viewController
    }
    
    func startIndicator(){
        DispatchQueue.main.async {
            self.viewController.view.addSubview(self.loadingView)
            self.viewController.view.addSubview(self.indicator)
            self.loadingView.backgroundColor = UIColor.init(cgColor: CGColor(red: 220, green: 220, blue: 220, alpha: 0.5))
            self.loadingView.snp.makeConstraints{ make in
                make.top.left.right.bottom.equalTo(self.viewController.view).offset(0)
            }
            self.indicator.snp.makeConstraints{ make in
                make.width.equalToSuperview().multipliedBy(0.15)
                make.height.equalToSuperview().multipliedBy(0.15)
                make.center.equalTo(self.viewController.view)
            }
            self.indicator.startAnimating()
        }
    }
    
    func stopIndicator(){
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
            self.loadingView.removeFromSuperview()
        }
    }
    
}

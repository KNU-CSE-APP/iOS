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
    var isZooming: Bool = false
    var originalImageCenter:CGPoint?
    
    func initUI(){
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
//        self.view.addGestureRecognizer(pinch)
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
    
//    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
//        // 이미지를 스케일에 맞게 변환
////        print(pinch.scale, self.imageView.transform)
////        if self.imageView.transform.a < 0.55 && self.imageView.transform.d < 0.55 {
//////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//////                self.imageView.transform.a = 1
//////                self.imageView.transform.d = 1
//////            }
////            //self.imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
////        }
////        else{
////            self.imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
////            // 다음 변환을 위해 핀치의 스케일 속성을 1로 설정
////        }
////        pinch.scale = 1
//
//        if pinch.state == .began || pinch.state == .changed {
//            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
//            let newScale = currentScale*pinch.scale
//            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//            self.imageView.transform = transform
//            pinch.scale = 1
//        }
//    }
    
    @objc func doPinch(_ sender:UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
            print("began \(newScale), \(currentScale) , \(sender.scale)")
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: sender.scale, y: sender.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform.identity
                self.imageView.center = center
            }, completion: { _ in
                self.isZooming = false
            })
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

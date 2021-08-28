//
//  DetailImageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/26.
//

import UIKit

class DetailImageView:UIViewController, ViewProtocol{
    
    var images: [UIImage]!
    var index: Int!

    lazy var pageViewController:PageViewController = {
        var pageVC = PageViewController(transitionStyle: .scroll,navigationOrientation: .horizontal)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.backBtn.addAction {
            self.dismiss(animated: true)
        }
        print(images, self.index)
        let firstVC = instantiateViewController(image: images[index], index: self.index)
        pageVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        pageVC.didMove(toParent: self)
        self.addChild(pageVC)
        
        return pageVC
    }()
        
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.images.count
        pc.currentPage = self.index
        pc.currentPageIndicatorTintColor = .black   // 현재 페이지 인디케이터 색
        pc.pageIndicatorTintColor = .lightGray        // 나머지 페이지 인디케이터 색
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initUI() {
      
    }
    
    func addView() {
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.pageControl)
    }
    
    func setUpConstraints() {
        self.pageControl.snp.makeConstraints{ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
}

extension DetailImageView: UIPageViewControllerDataSource {
    
    //  이전 컨텐츠 뷰컨을 리턴해주시면 됨
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = index > 0 ? index - 1 : images.count - 1
        let nextVC = instantiateViewController(image: images[nextIndex], index: nextIndex)
        return nextVC
    }
    
    //  다음 컨텐츠 뷰컨을 리턴해주시면 됩니다. 위에 메서드랑 똑같은데 다음 컨텐츠를 담으면 됨
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        
        let nextIndex = (index + 1) % images.count
        let nextVC = instantiateViewController(image: images[nextIndex], index: nextIndex)
        return nextVC
    }
}

extension DetailImageView: UIPageViewControllerDelegate {
    
    //  스와이프 제스쳐가 끝나면 호출되는 메서드입니다. 여기서 페이지 컨트롤의 인디케이터를 움직임
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //  페이지 이동이 안됐으면 그냥 종료
        guard completed else { return }
        
        //  페이지 이동이 됐기 때문에 페이지 컨트롤의 인디케이터를 갱신
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}

extension DetailImageView{
    private func instantiateViewController(image:UIImage, index: Int) -> UIViewController {
        let vc = DetailImageViewController()
        vc.view.tag = index
        vc.setImage(image: image)
        return vc
  }
}

extension DetailImageView:ImageDelegate{
    func sendImages(images: [UIImage], index: Int) {
        self.images = images
        self.index = index
        
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
}

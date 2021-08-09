//
//  WrittenBoardListView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class WrittenBaordListView:UIViewController, ViewProtocol{
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "내가 쓴 글")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBoardView()
    }
    
    func initUI() {
        
    }
    
    func addView() {
        
    }
    
    func setUpConstraints() {
        
    }
}

extension WrittenBaordListView{
    
    func addBoardView(){
        guard let BoardVC = storyboard?.instantiateViewController(withIdentifier: "BoardView") as? BoardView else{
            return
        }
        self.addChild(BoardVC)
        self.view.addSubview(BoardVC.view)
        BoardVC.didMove(toParent: self)
        BoardVC.view.backgroundColor = .yellow
        BoardVC.view.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

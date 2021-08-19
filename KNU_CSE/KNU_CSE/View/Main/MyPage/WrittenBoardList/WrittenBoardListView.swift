//
//  WrittenBoardListView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class WrittenBaordListView:UIViewController, ViewProtocol{
    
    var BoardVC : BoardView!{
        didSet{
            self.BoardVC.parentType = .Write
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "내가 쓴 글")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.addBoardView()
        self.setUpConstraints()
    }
    
    func initUI() {
        self.BoardVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardView") as? BoardView
        self.BoardVC.parentType = .Write
        self.BoardVC.boardViewModel.getBoardsByMyBoards()
    }
    
    func addView() {
        
    }
    
    func setUpConstraints() {
        
    }
}

extension WrittenBaordListView{
    
    func addBoardView(){
        self.addChild(self.BoardVC)
        self.view.addSubview(self.BoardVC.view)
        self.BoardVC.didMove(toParent: self)
        self.BoardVC.view.backgroundColor = .yellow
        self.BoardVC.view.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

 

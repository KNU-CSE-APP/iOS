//
//  BoarcSearchView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit

class BoardSearchView:UIViewController, ViewProtocol{
    
    var searchController:UISearchController!{
        didSet{
            self.searchController.isActive = true
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.hidesNavigationBarDuringPresentation = false
            
            let searchBar = searchController.searchBar
            searchBar.delegate = self
            searchBar.placeholder = "검색어를 입력하세요"
            searchBar.tintColor = .white
            searchBar.setValue("취소", forKey: "cancelButtonText")
            
            let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.titleView = searchBar
            
           
        }
    }
    
    var BoardVC : FreeBoardView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "게시물 검색"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
        self.setTextfiledBecomeFirstResponder()
    }
    
    func initUI() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.BoardVC = storyboard?.instantiateViewController(withIdentifier: "FreeBoardView") as? FreeBoardView
    }
    
    func addView() {
        
    }
    
    func setUpConstraints() {
        
    }
}

extension BoardSearchView{

    func addBoardView(){
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
    
    //if press cancel button then pop
    @objc func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(removeBoardView), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //if keyboard show up then remove BoardVC
    @objc func removeBoardView(){
        BoardVC.willMove(toParent: nil)
        BoardVC.view.removeFromSuperview()
        BoardVC.removeFromParent()
    }
    
    func setTextfiledBecomeFirstResponder(){
        //0.6 밑으로는 안됨
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6){
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

extension BoardSearchView:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.addBoardView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.popViewController()
    }
}



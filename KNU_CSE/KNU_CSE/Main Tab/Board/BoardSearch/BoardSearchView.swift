//
//  BoarcSearchView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit

class BoardSearchView:UIViewController, ViewProtocol{
    
    let categoryTitle:[String] = ["잡담하기", "정보", "팀원 구하기", "수업", "팀원 구하기", "팀원 구하기", "팀원 구하기", "팀원 구하기", "팀원 구하기"]
    
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
    
    var categoryTable:UICollectionView!{
        didSet{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = .zero
            flowLayout.minimumInteritemSpacing = 16
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
            
            self.categoryTable.setCollectionViewLayout(flowLayout, animated: false)
            self.categoryTable.delegate = self
            self.categoryTable.dataSource = self
            self.categoryTable.backgroundColor = .white
            self.categoryTable.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
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
        self.categoryTable = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        self.BoardVC = storyboard?.instantiateViewController(withIdentifier: "FreeBoardView") as? FreeBoardView
    }
    
    func addView() {
        self.view.addSubview(self.categoryTable)
    }
    
    func setUpConstraints() {
        let left_margin = 20
        let right_margin = -20
        let category_height = 55
        
        self.categoryTable.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.height.equalTo(category_height)
        }
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
        
        self.categoryTable.isHidden = true
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
        self.BoardVC.willMove(toParent: nil)
        self.BoardVC.view.removeFromSuperview()
        self.BoardVC.removeFromParent()
        
        self.categoryTable.isHidden = false
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


extension BoardSearchView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else{
            return UICollectionViewCell()
        }
        cell.setTitle(title: self.categoryTitle[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CategoryCell.fittingSize(name: categoryTitle[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryTable {
            print(categoryTitle[indexPath.row])
        }
    }
}

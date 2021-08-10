//
//  BoardView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/21.
//

import UIKit

class BoardTabView:UIViewController, ViewProtocol{
    
    let titleList:[String] = ["자유게시판", "질의응답", "학생회 공지"]
    
    let title_left_Margin:CGFloat = 10
    
    var cellWidth:CGFloat!
    var collectionViewHeihgt:CGFloat!{
        didSet{
            let layout = tabCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: cellWidth, height: collectionViewHeihgt!)
        }
    }
    
    var tabCollectionView : UICollectionView!{
        didSet{
            tabCollectionView.backgroundColor = .white
            tabCollectionView.dataSource = self
            tabCollectionView.delegate = self
            tabCollectionView.register(BoardTitleCell.self, forCellWithReuseIdentifier: BoardTitleCell.identifier)
        }
    }
    
    var highlightView:UIView!{
        didSet{
            highlightView.backgroundColor = Color.mainColor
        }
    }
    
    var searchBtn:UIBarButtonItem!{
        didSet{
            searchBtn.style = .plain
            searchBtn.tintColor = .white
            searchBtn.target = self
            let image = UIImage(systemName: "magnifyingglass")
            searchBtn.image = image
            searchBtn.action = #selector(pushBoardSearchView)
        }
    }

    var selectedTabIndex:Int = 0
    var writeBoardhBtn:UIBarButtonItem!{
        didSet{
            writeBoardhBtn.style = .plain
            writeBoardhBtn.tintColor = .white
            writeBoardhBtn.target = self
            let image = UIImage(systemName: "pencil")
            writeBoardhBtn.image = image
            writeBoardhBtn.action = #selector(pushBoardWriteView)
        }
    }

    var cellRowHeight : CGFloat!
    var boardDelegate:BoardDataDelegate?
    
    var pageView:UIView!
    var BoardVC:BoardView!{
        didSet{
            self.BoardVC.parentType = .BoardTap
            self.BoardVC.actionBinding()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadNavigationItems(selectedTabIndex:self.selectedTabIndex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.initUI()
        self.addView()
        self.addBoardVC()
        self.setUpConstraints()
        self.selectCell()
    }
    
    func initUI() {
        self.tabCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        self.highlightView = UIView()
        self.searchBtn = UIBarButtonItem()
        self.writeBoardhBtn = UIBarButtonItem()
        self.cellRowHeight = self.view.frame.height
        self.pageView = UIView()
        self.BoardVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardView") as? BoardView
    }
    
    func addView() {
        self.view.addSubview(self.tabCollectionView)
        self.view.addSubview(self.highlightView)
        self.view.addSubview(self.pageView)
    }
    
    func setUpConstraints() {
        cellWidth = self.view.frame.width * 0.2
        collectionViewHeihgt = self.view.frame.height * 0.05
        
        self.tabCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.left.equalToSuperview().offset(title_left_Margin)
            make.right.equalToSuperview()
            make.height.equalTo(collectionViewHeihgt)
        }
        
        self.pageView.snp.makeConstraints{ make in
            make.top.equalTo(self.highlightView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension BoardTabView{
    func addBoardVC(){
        self.addChild(BoardVC)
        self.pageView.addSubview(BoardVC.view)
        self.BoardVC.view.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        self.BoardVC.didMove(toParent: self)
    }
    
    func selectCell(){
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.collectionView(tabCollectionView, didSelectItemAt: firstIndexPath)
        tabCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .right)
    }
}

extension BoardTabView:UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardTitleCell.identifier, for: indexPath) as? BoardTitleCell else{
            return UICollectionViewCell()
        }
        cell.setTitle(title: titleList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            self.reloadNavigationItems(selectedTabIndex: indexPath.row)
            self.upDateHighlightView(indexPath: indexPath)
            if indexPath.row == 0{
                self.BoardVC.boardViewModel.category = "FREE"
                self.BoardVC.boardViewModel.getBoards()
            }else if indexPath.row == 1{
                self.BoardVC.boardViewModel.category = "QNA"
                self.BoardVC.boardViewModel.getBoards()
            }else{
                
            }
        }
    }
}

extension BoardTabView{
    
    @objc func pushBoardWriteView(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardWriteView") as? BoardWriteView
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    @objc func pushBoardSearchView(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardSearchView") as? BoardSearchView
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func pushDetaiView(board:Board){
        let pushVC = (self.storyboard?.instantiateViewController(withIdentifier: "BoardDetailView")) as? BoardDetailView
        if !(self.navigationController!.viewControllers.contains(pushVC!)){
            self.boardDelegate = pushVC
            self.boardDelegate?.sendBoard(board: board)
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    func upDateHighlightView(indexPath:IndexPath){
        let leading = cellWidth * CGFloat(indexPath.row) + (CGFloat(indexPath.row) * 24) + title_left_Margin
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.highlightView.snp.updateConstraints{ make in
                make.top.equalTo(self.tabCollectionView.snp.bottom).offset(0)
                make.leading.equalTo(leading)
                make.width.equalTo(self.cellWidth)
                make.height.equalTo(self.collectionViewHeihgt*0.1)
            }
        }, completion: nil)
    }
    
    func reloadNavigationItems(selectedTabIndex:Int){
        self.selectedTabIndex = selectedTabIndex
        switch selectedTabIndex {
        case 0:
            let parent = self.parent as? TabView
            parent?.setNavigationItemWithSearchWrite()
            break
        case 1:
            let parent = self.parent as? TabView
            parent?.setNavigationItemWithSearchWrite()
            break
        case 2:
            let parent = self.parent as? TabView
            parent?.setNavigationItemWithSearch()
            break
        default:
            break
        }
    }
}


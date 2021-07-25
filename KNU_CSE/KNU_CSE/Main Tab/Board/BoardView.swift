//
//  BoardView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/21.
//

import UIKit

class BoardView:UIViewController, ViewProtocol{
    
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
    
    var searchBtn:UIButton!{
        didSet{
            let image = UIImage(systemName: "magnifyingglass")?.resized(toWidth: 25)
            searchBtn.setImage(image?.withTintColor(Color.mainColor), for: .normal)
            searchBtn.addAction {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardSearchView") as? BoardSearchView
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }
        }
    }
    
    var writeBoardhBtn:UIButton!{
        didSet{
            let image = UIImage(systemName: "pencil")?.resized(toWidth: 25)
            writeBoardhBtn.setImage(image?.withTintColor(Color.mainColor), for: .normal)
            writeBoardhBtn.addAction {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardWriteView") as? BoardWriteView
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }
        }
    }
    
    var pageView:UIView!{
        didSet{
            
        }
    }
    
    var freeBoardVC : FreeBoardView!
    var noticeBoardVC : FreeBoardView!
    
    override func viewDidLoad() {
        initUI()
        addView()
        setUpConstraints()
        selectCell()
    }
    
    func initUI() {
        self.tabCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        self.highlightView = UIView()
        self.searchBtn = UIButton()
        self.writeBoardhBtn = UIButton()
        self.pageView = UIView()
        self.freeBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "FreeBoardView") as? FreeBoardView
        self.noticeBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "FreeBoardView") as? FreeBoardView
    }
    
    func addView() {
        self.view.addSubview(tabCollectionView)
        self.view.addSubview(highlightView)
        self.view.addSubview(searchBtn)
        self.view.addSubview(writeBoardhBtn)
        self.view.addSubview(pageView)
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
        
        self.searchBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.tabCollectionView.snp.top)
            make.right.equalTo(self.tabCollectionView.snp.right).offset(-10)
            make.bottom.equalTo(self.tabCollectionView.snp.bottom)
            make.width.equalTo(self.tabCollectionView.snp.height)
        }
        
        self.writeBoardhBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.tabCollectionView.snp.top)
            make.right.equalTo(self.searchBtn.snp.left).offset(-10)
            make.bottom.equalTo(self.tabCollectionView.snp.bottom)
            make.width.equalTo(self.tabCollectionView.snp.height)
        }
        
        self.pageView.snp.makeConstraints{ make in
            make.top.equalTo(self.highlightView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    func selectCell(){
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionView(tabCollectionView, didSelectItemAt: firstIndexPath)
        tabCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .right)
    }
}

extension BoardView:UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let titleList:[String] = ["자유게시판", "학생회 공지"]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardTitleCell.identifier, for: indexPath) as? BoardTitleCell else{
            return UICollectionViewCell()
        }
        cell.setTitle(title: titleList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
           
            upDateHighlightView(indexPath: indexPath)
            if indexPath.row == 0{
                self.addFreeBoardVC()
                self.removeNoticeBoardVC()
                
            }else{
                self.removeFreeBoardVC()
                self.addNoticeBoardVC()
            }
        }
    }
}

extension BoardView{
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
    
    func addFreeBoardVC(){
        self.addChild(freeBoardVC)
        pageView.addSubview(freeBoardVC.view)
        freeBoardVC.view.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        freeBoardVC.didMove(toParent: self)
    }
    
    func removeFreeBoardVC(){
        freeBoardVC.willMove(toParent: nil)
        freeBoardVC.view.removeFromSuperview()
        freeBoardVC.removeFromParent()
    }
    
    func addNoticeBoardVC(){
        self.addChild(noticeBoardVC)
        pageView.addSubview(noticeBoardVC.view)
        noticeBoardVC.view.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        noticeBoardVC.didMove(toParent: self)
    }
    
    func removeNoticeBoardVC(){
        noticeBoardVC.willMove(toParent: nil)
        noticeBoardVC.view.removeFromSuperview()
        noticeBoardVC.removeFromParent()
    }
}

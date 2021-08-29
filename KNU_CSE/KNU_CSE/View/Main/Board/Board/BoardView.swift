//
//  BoardView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

enum ParentType{
    case BoardTap
    case Search
    case Write
    case Edit
}

class BoardView : BaseUIViewController, ViewProtocol{
    var parentType:ParentType!{
        didSet{
            self.actionBinding()
        }
    }
    var dataLoaded:Bool = false
    
    var boardViewModel : BoardViewModel = BoardViewModel()
    var cellRowHeight : CGFloat!
    var boardDelegate:BoardDataDelegate?
    
    var boardTableView :UITableView!{
        didSet{
            self.boardTableView.register(FreeBoardCell.self, forCellReuseIdentifier: FreeBoardCell.identifier)
            self.boardTableView.dataSource = self
            self.boardTableView.delegate = self
            self.boardTableView.rowHeight = cellRowHeight * 0.12
            self.boardTableView.tableFooterView = UIView(frame: .zero)
            self.boardTableView.separatorInset.left = 0
            self.boardTableView.showsVerticalScrollIndicator = true
            
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(self.refresh(refresh:)), for: .valueChanged)
            self.boardTableView.refreshControl = refresh
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Boardview \(CFGetRetainCount(self))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Boardview \(CFGetRetainCount(self))")
    }
    
    func initUI(){
        self.cellRowHeight = self.view.frame.height
        self.boardTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(self.boardTableView)
    }
    
    func setUpConstraints(){
        self.boardTableView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension BoardView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.boardViewModel.boards.count == 0 && self.dataLoaded{
            switch self.parentType {
            case .BoardTap:
                    self.setTablViewBackgroundView(text: "")
            case .Search:
                self.setTablViewBackgroundView(text: "검색 결과가 없습니다")
            case .Write:
                self.setTablViewBackgroundView(text: "작성한 게시글이 없습니다")
            default:
                break
            }
            return 0
        }else{
            self.deleteTablViewBackgroundView()
            return boardViewModel.boards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FreeBoardCell.identifier, for: indexPath) as? FreeBoardCell else{
            return UITableViewCell()
        }
        
        cell.board =  self.boardViewModel.boards[indexPath.row]
        cell.height = self.cellRowHeight * 0.115
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setTablViewBackgroundView(text:String){
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        emptyLabel.text = text
        emptyLabel.textColor = .lightGray
        emptyLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        emptyLabel.textAlignment = NSTextAlignment.center
        self.boardTableView.backgroundView = emptyLabel
        self.boardTableView.separatorStyle = .none
    }
    
    func deleteTablViewBackgroundView(){
        self.boardTableView.backgroundView = UIView()
    }
}

extension BoardView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// remove selection style
        self.pushDetaiView(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.parentType == .BoardTap{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.height
            let requested = self.boardViewModel.requested
            let isLastPage = self.boardViewModel.isLastPage
            
            if offsetY * 1.3 > (contentHeight - height) && !requested && !isLastPage{
                self.boardViewModel.getBoardsByPaging()
                self.boardViewModel.requested = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                    self?.boardViewModel.requested = false
                }
            }
        }
    }
}

extension BoardView{
    func pushDetaiView(_ index: Int){
        if let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardDetailView") as? BoardDetailView{
            if !(self.navigationController!.viewControllers.contains(pushVC)){
                pushVC.boardDetailViewModel.board.secondBind{ [weak self] board in
                    self?.boardViewModel.boards[index] = board
                    self?.boardTableView.reloadData()
                }
                
                self.boardDelegate = pushVC
                self.boardDelegate?.sendBoardData(board:self.boardViewModel.boards[index])
                
                //Detailview에서 게시판이 삭제됐을 경우
                self.boardDelegate?.deleteBoard { [weak self] in
                    self?.boardViewModel.boards.remove(at: index)
                    self?.boardTableView.reloadData()
                }
                
                self.navigationController?.pushViewController(pushVC, animated: true)
            }
        }
    }
    
    @objc func refresh(refresh: UIRefreshControl){
        switch parentType {
            case .BoardTap:
                self.boardViewModel.getBoardsByFirstPage()
            case .Search:
                break
            case .Write:
                break
            default:
                break
        }
        refresh.endRefreshing()
    }
}

extension BoardView{
    func actionBinding(){
        switch parentType {
            case .BoardTap:
                self.BindingGetBoardWithPaging()
            case .Search:
                self.BindingGetBoard()
            case .Write:
                self.BindingGetBoard()
            default:
                break
        }
        self.BindingCategory()
    }
    
    //카테고리가 바뀌면 page를 0으로 설정
    func BindingCategory(){
        self.boardViewModel.category.bind{ [weak self] _ in
            self?.boardViewModel.page = 0
        }
    }
    
    func BindingGetBoard(){
        self.boardViewModel.getBoardAction.binding(successHandler: { [weak self] result in
            if result.success, let boards = result.response{
                self?.boardViewModel.boards = boards
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }
        , asyncHandler: { [weak self] in
            self?.indicator.startIndicator()
        }
        , endHandler: { [weak self] in
            self?.dataLoaded = true
            self?.indicator.stopIndicator()
            self?.boardTableView.reloadData()
        })
    }
    
    func BindingGetBoardWithPaging(){
        self.boardViewModel.BoardsByPagingAction.binding(successHandler: { [weak self] result in
            if result.success, let response = result.response{
                if let boards = response.content{
                    if response.first{
                        self?.boardViewModel.boards = boards
                    }else{
                        for board in boards{
                            self?.boardViewModel.boards.append(board)
                        }
                    }
                    if !response.last{
                        self?.boardViewModel.page += 1
                    }
                }
                self?.boardViewModel.isLastPage = response.last
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
    
        }, endHandler: { [weak self] in
            self?.dataLoaded = true
            self?.boardTableView.reloadData()
        })
    }
}

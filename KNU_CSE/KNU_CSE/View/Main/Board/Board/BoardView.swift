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
                case .none:
                    break
            }
            return 0
        }else{
            self.deleteTablViewBackgroundView()
            return boardViewModel.boards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FreeBoardCell.identifier, for: indexPath) as! FreeBoardCell
        let board = self.boardViewModel.boards[indexPath.row]
        cell.selectionStyle = .none
        cell.board = board
        cell.height = self.cellRowHeight * 0.115
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
        self.pushDetaiView(board: self.boardViewModel.boards[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.parentType == .BoardTap{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.height
            let requested = self.boardViewModel.requested
            let isLastPage = self.boardViewModel.isLastPage
            
            //print(offsetY, contentHeight, height, contentHeight-height)
            if offsetY * 1.3 > (contentHeight - height) && !requested && !isLastPage{
                self.boardViewModel.getBoardsByPaging()
                self.boardViewModel.requested = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.boardViewModel.requested = false
                }
            }
        }
    }
}

extension BoardView{
    func pushDetaiView(board:Board){
        let pushVC = (self.storyboard?.instantiateViewController(withIdentifier: "BoardDetailView")) as? BoardDetailView
        if !(self.navigationController!.viewControllers.contains(pushVC!)){
            self.boardDelegate = pushVC
            self.boardDelegate?.sendBoard(board: board)
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
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
            case .none:
                break
        }
        self.BindingCategory()
    }
    
    //카테고리가 바뀌면 page를 0으로 설정
    func BindingCategory(){
        self.boardViewModel.category.bind{ _ in
            self.boardViewModel.page = 0
        }
    }
    
    func BindingGetBoard(){
        self.boardViewModel.getBoardAction.binding(successHandler: { result in
            if result.success, let boards = result.response{
                self.boardViewModel.boards = boards
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }
        , asyncHandler: {
            self.indicator.startIndicator()
        }
        , endHandler: {
            self.dataLoaded = true
            self.indicator.stopIndicator()
            self.boardTableView.reloadData()
        })
    }
    
    func BindingGetBoardWithPaging(){
        self.boardViewModel.BoardsByPagingAction.binding(successHandler: { result in
            if result.success, let response = result.response{
                if let boards = response.content{
                    if response.first{
                        self.boardViewModel.boards = boards
                    }else{
                        for board in boards{
                            self.boardViewModel.boards.append(board)
                        }
                    }
                    if !response.last{
                        self.boardViewModel.page += 1
                    }
                }
                self.boardViewModel.isLastPage = response.last
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
    
        }, endHandler: {
            self.dataLoaded = true
            self.boardTableView.reloadData()
        })
    }
}

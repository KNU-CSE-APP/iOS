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

class BoardView : UIViewController{
    
    var parentType:ParentType!
    
    var boardViewModel : BoardViewModel = BoardViewModel()
    var cellRowHeight : CGFloat!
    var boardDelegate:BoardDataDelegate?
    
    var boardTableView :UITableView!{
        didSet{
            boardTableView.register(FreeBoardCell.self, forCellReuseIdentifier: FreeBoardCell.identifier)
            boardTableView.dataSource = self
            boardTableView.delegate = self
            boardTableView.rowHeight = cellRowHeight * 0.12
            boardTableView.tableFooterView = UIView(frame: .zero)
            boardTableView.separatorInset.left = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionBinding()
        
        self.initUI()
        self.addView()
        self.setupConstraints()
    }
    
    func initUI(){
        self.cellRowHeight = self.view.frame.height
        self.boardTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(boardTableView)
    }
    
    func setupConstraints(){
        boardTableView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension BoardView : UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boardViewModel.boards.count == 0{
            switch parentType {
            case .BoardTap:
                    self.setTablViewBackgroundView(text: "게시글이 없습니다")
                case .Search:
                    self.setTablViewBackgroundView(text: "검색 결과가 없습니다")
                case .Write:
                    self.setTablViewBackgroundView(text: "작성한 게시글이 없습니다")
                case .none:
                    break
            }
            return 0
        }else{
            return boardViewModel.boards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FreeBoardCell.identifier, for: indexPath) as! FreeBoardCell
        let board = boardViewModel.boards[indexPath.row]
        cell.selectionStyle = .none
        cell.board = board
        cell.height = cellRowHeight * 0.115
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

}

extension BoardView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// remove selection style
        self.pushDetaiView(board: boardViewModel.boards[indexPath.row])
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
                self.BindingGetBoard()
            case .Search:
                break
            case .Write:
                break
            case .none:
                break
        }
    }
    
    func BindingGetBoard(){
        self.boardViewModel.boardListener.binding(successHandler: { result in
            if result.success{
                if let boards = result.response{
                    self.boardViewModel.boards = boards
                }
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }
        , asyncHandler: {
        }
        , endHandler: {
            self.boardTableView.reloadData()
        })
    }
}

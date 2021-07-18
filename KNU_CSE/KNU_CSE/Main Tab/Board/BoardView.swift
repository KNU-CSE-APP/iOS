//
//  BoardView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class BoardView : UIViewController{
    
    let bordViewModel : BoardViewModel = BoardViewModel()
    
    var cellRowHeight : CGFloat!
    
    var boardTableView :UITableView!{
        didSet{
            boardTableView.translatesAutoresizingMaskIntoConstraints = false
            boardTableView.register(BoardCell.self, forCellReuseIdentifier: BoardCell.identifier)
            boardTableView.dataSource = self
            boardTableView.rowHeight = cellRowHeight * 0.1
            boardTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "자유게시판"
    }
    
    override func viewDidLoad() {
        self.initUI()
        self.addView()
        self.setupConstraints()
    }
    
    func initUI(){
        cellRowHeight = self.view.frame.height
        boardTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(boardTableView)
    }
    
    func setupConstraints(){
        boardTableView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

extension BoardView : UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bordViewModel.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoardCell.identifier, for: indexPath) as! BoardCell
        cell.selectionStyle = .none
        cell.board = bordViewModel.boards[indexPath.row]
        return cell
    }
    
}

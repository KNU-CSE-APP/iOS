//
//  BoardView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class FreeBoardView : UIViewController{
    
    let freeBordViewModel : FreeBoardViewModel = FreeBoardViewModel()
    
    var cellRowHeight : CGFloat!
    
    var freeboardTableView :UITableView!{
        didSet{
            freeboardTableView.register(FreeBoardCell.self, forCellReuseIdentifier: FreeBoardCell.identifier)
            freeboardTableView.dataSource = self
            freeboardTableView.rowHeight = cellRowHeight * 0.115
            freeboardTableView.tableFooterView = UIView(frame: .zero)
            freeboardTableView.separatorInset.left = 0
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
        freeboardTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(freeboardTableView)
    }
    
    func setupConstraints(){
        freeboardTableView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension FreeBoardView : UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freeBordViewModel.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FreeBoardCell.identifier, for: indexPath) as! FreeBoardCell
        cell.selectionStyle = .none
        cell.viewModel = freeBordViewModel.boards[indexPath.row]
        cell.height = cellRowHeight * 0.115
        cell.cellBtn.addAction {
            print("\(indexPath.row)")
        }
        return cell
    }
}

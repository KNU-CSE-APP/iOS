//
//  SeatReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ClassRoomView : UIViewController{

    let classRoomViewModel : ClassRoomViewModel = ClassRoomViewModel()
    
    var cellRowHeight : CGFloat!
    
    var classTableView :UITableView!{
        didSet{
            classTableView.translatesAutoresizingMaskIntoConstraints = false
            classTableView.register(ClassRoomCell.self, forCellReuseIdentifier: ClassRoomCell.identifier)
            classTableView.dataSource = self
            classTableView.rowHeight = cellRowHeight * 0.1
            classTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "강의실 예약"
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        cellRowHeight = self.view.frame.height
        classTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(classTableView)
    }
    
    func setupConstraints(){
        classTableView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension ClassRoomView : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classRoomViewModel.lecture.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassRoomCell.identifier, for: indexPath) as! ClassRoomCell
        cell.selectionStyle = .none
        cell.classRoom = classRoomViewModel.lecture[indexPath.row]
        //cell.setTitle(title: title)
        
        return cell
    }
}

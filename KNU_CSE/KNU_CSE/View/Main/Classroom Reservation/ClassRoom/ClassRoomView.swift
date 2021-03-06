//
//  SeatReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ClassRoomView : UIViewController{

    var classRoomViewModel : ClassRoomViewModel = ClassRoomViewModel()
    var delegate: ClassDataDelegate?
    
    var cellRowHeight : CGFloat!
    
    var classTableView :UITableView!{
        didSet{
            classTableView.translatesAutoresizingMaskIntoConstraints = false
            classTableView.register(ClassRoomCell.self, forCellReuseIdentifier: ClassRoomCell.identifier)
            classTableView.dataSource = self
            classTableView.delegate = self
            classTableView.rowHeight = cellRowHeight * 0.1
            classTableView.tableFooterView = UIView(frame: .zero)
            classTableView.separatorInset.left = 0
        }
    }
    
    override func viewDidLoad() {
        self.initUI()
        self.addView()
        self.setupConstraints()
        self.Binding()
        self.classRoomViewModel.getClassRooms()
    }
    
    deinit {
        print("ClassRoomView deinit")
    }
    
    func initUI(){
        cellRowHeight = self.view.frame.height
        classTableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
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
        return classRoomViewModel.classrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassRoomCell.identifier, for: indexPath) as! ClassRoomCell
        cell.selectionStyle = .none
        cell.classRoom = classRoomViewModel.classrooms[indexPath.row]
        return cell
    }
}

extension ClassRoomView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushView(indexPath)
    }
    
    func pushView(_ indexPath:IndexPath){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ReservationView") as? ReservationView
        self.navigationController?.pushViewController(pushVC!, animated: true)
        self.delegate = pushVC
        self.delegate?.sendData(data: self.classRoomViewModel.classrooms[indexPath.row])
    }
}

extension ClassRoomView{
    func Binding(){
        self.classRoomViewModel.classRoomsAction.binding(successHandler: {
            [weak self] result in
            if result.success, let classRooms = result.response{
                self?.classRoomViewModel.classrooms = classRooms
                self?.classTableView.reloadData()
            }
        }, failHandler: { Error in
            
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
}

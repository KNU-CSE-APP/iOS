//
//  MyPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import UIKit
import SnapKit

class MyPageView : UIViewController{
    
    let sectionHeader = ["계정 관리", "강의실", "게시판", "앱 관리"]
    let accountSection = ["마이페이지", "비밀번호 변경"]
    let classRoomSection = ["예약내역"]
    let boardRoomSection = ["내가쓴글"]
    let appSettingSection = ["환경설정", "로그아웃"]
    
    var tableView:UITableView!{
        didSet{
            tableView.isScrollEnabled = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(MyPageViewCell.self, forCellReuseIdentifier: MyPageViewCell.identifier)
            tableView.rowHeight = 50
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.separatorInset.left = 0
            
        }
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        self.tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
    }
    
    func addView(){
        self.view.addSubview(tableView)
    }
    
    func setupConstraints(){
        self.tableView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MyPageView:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return sectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.accountSection.count
        }else if section == 1{
            return self.classRoomSection.count
        }else if section == 2 {
            return self.boardRoomSection.count
        }else if section == 3{
            return self.appSettingSection.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageViewCell.identifier, for: indexPath) as? MyPageViewCell else{
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        
        switch indexPath.section{
        case 0:
            cell.setTitle(title: accountSection[indexPath.row])
        case 1:
            cell.setTitle(title: classRoomSection[indexPath.row])
        case 2:
            cell.setTitle(title: boardRoomSection[indexPath.row])
        case 3:
            cell.setTitle(title: appSettingSection[indexPath.row])
        default:
            break
        }
        
        return cell
    }
}

extension MyPageView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            if indexPath.row == 0 {
                pushView(identifier: "UserInformView", typeOfVC: UserInformView.self)
            }else if indexPath.row == 1{
                pushView(identifier: "EditPwView", typeOfVC: EditPwView.self)
            }
        case 1:
            if indexPath.row == 0 {
                pushView(identifier: "ReservationHistView", typeOfVC: ReservationHistView.self)
            }
        case 2:
            if indexPath.row == 0 {
                pushView(identifier: "WrittenBaordListView", typeOfVC: WrittenBaordListView.self)
            }
        case 3:
            if indexPath.row == 0 {
                pushView(identifier: "AppSettingView", typeOfVC: AppSettingView.self)
            }else if indexPath.row == 1{
                self.logOut()
            }
        default:
            break
        }
   
    }
}

extension UIViewController{
    
    func pushView<T:UIViewController>(identifier:String, typeOfVC:T.Type){
        guard let VC = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else{
            return
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func logOut(){
        guard StorageManager.shared.readUser() != nil else {
            print("유저 정보 없음")
            self.navigationController?.popViewController(animated: true)
            return
        }
        if StorageManager.shared.deleteUser(){
            print("삭제성공")
            self.navigationController?.popViewController(animated: true)
        }else{
            print("삭제싪패")
        }
    }
}

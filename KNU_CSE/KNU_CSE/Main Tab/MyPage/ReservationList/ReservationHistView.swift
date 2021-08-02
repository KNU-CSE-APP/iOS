//
//  ReservationListView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation
import UIKit

class ReservationHistView: UIViewController, ViewProtocol{
    
    let reservationTime:Int = 6
    
    let titleList:[titleText] = [titleText.inform, titleText.status, titleText.extensionCnt ,titleText.startTime, titleText.endTime]
    var contents:[String]!
    var reservationHistViewModel:ReservationHistViewModel!{
        didSet{
            self.reservationCheck()
        }
    }
    
    var cautionLabel:UILabel!{
        didSet{
            cautionLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            cautionLabel.textColor = Color.mainColor
            cautionLabel.textAlignment = .center
            cautionLabel.layer.borderWidth = 0.5
            cautionLabel.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var reserTableView:UITableView!{
        didSet{
            reserTableView.isScrollEnabled = false
            reserTableView.register(ReservationCheckCell.self, forCellReuseIdentifier: ReservationCheckCell.identifier)
            reserTableView.dataSource = self
            reserTableView.tableFooterView = UIView(frame: .zero)
            reserTableView.separatorInset.left = 0
            reserTableView.layer.borderWidth = 0.5
            reserTableView.layer.borderColor = UIColor.lightGray.cgColor
            reserTableView.rowHeight = view.frame.height * 0.3 / CGFloat(titleList.count)
        }
    }
    
    var cancelBtn:UIButton!{
        didSet{
            cancelBtn.setTitle("좌석 반납", for: .normal)
            cancelBtn.setTitleColor(.black, for: .normal)
            cancelBtn.setTitleColor(UIColor.lightGray.withAlphaComponent(0.3), for: .highlighted)
            cancelBtn.layer.borderWidth = 0.5
            cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
            cancelBtn.backgroundColor = .white
            cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            cancelBtn.addAction {
                
            }
        }
    }
    
    var reservExtendBtn:UIButton!{
        didSet{
            reservExtendBtn.setTitle("예약 연장", for: .normal)
            reservExtendBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            reservExtendBtn.setTitleColor(.white, for: .normal)
            reservExtendBtn.backgroundColor = Color.mainColor
            reservExtendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            reservExtendBtn.addAction {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "예약내역")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        
        self.reservationHistViewModel = ReservationHistViewModel()
    }
    
    func initUI() {
        self.cautionLabel = UILabel()
    }
    
    func initTableView(){
        self.reserTableView = UITableView()
        self.cancelBtn = UIButton()
        self.reservExtendBtn = UIButton()
    }
    
    func addView() {
        self.view.addSubview(cautionLabel)
    }
    
    func addTableView(){
        self.view.addSubview(reserTableView)
        self.view.addSubview(cancelBtn)
        self.view.addSubview(reservExtendBtn)
    }
    
    func setUpConstraints() {
        let left_Margin = 25
        let right_Margin = -left_Margin
        let top_Margin = 25
        let labelHeight = self.view.frame.height * 0.3 / CGFloat(self.titleList.count) / 1.4
 
        self.cautionLabel.snp.makeConstraints{ make in
            make.left.equalTo(left_Margin)
            make.right.equalTo(right_Margin)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(top_Margin)
            make.height.equalTo(labelHeight)
        }
    }
    
    func setUpTableViewConstraints(){
        let left_Margin = 25
        let right_Margin = -left_Margin
        let btnWidth = self.view.frame.width * 0.25
        let btnHeight = btnWidth * 0.4
        let btn_left_Margin = -CGFloat(btnWidth*0.5) - 10
        
        self.reserTableView.snp.makeConstraints{ make in
            make.left.equalTo(left_Margin)
            make.right.equalTo(right_Margin)
            make.top.equalTo(self.cautionLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        self.cancelBtn.snp.makeConstraints{ make in
            make.centerX.equalTo(self.reserTableView).offset(btn_left_Margin)
            make.top.equalTo(self.reserTableView.snp.bottom).offset(10)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
        
        self.reservExtendBtn.snp.makeConstraints{ make in
            make.left.equalTo(cancelBtn.snp.right).offset(10)
            make.top.equalTo(self.reserTableView.snp.bottom).offset(10)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
  
}

extension ReservationHistView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
        return self.titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReservationCheckCell.identifier, for: indexPath) as? ReservationCheckCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setTitle(text: "\(titleList[indexPath.row].rawValue)")
        cell.setContent(text: reservationHistViewModel.getContentText()[indexPath.row])
        return cell
    }
}

extension ReservationHistView{
    func reservationCheck(){
        if reservationHistViewModel.check(){
            self.cautionLabel.text = "현재 예약된 좌석 정보입니다."
            self.initTableView()
            self.addTableView()
            self.setUpTableViewConstraints()
        }else{
            self.cautionLabel.text = "예약된 좌석 정보가 없습니다."
        }
    }
}

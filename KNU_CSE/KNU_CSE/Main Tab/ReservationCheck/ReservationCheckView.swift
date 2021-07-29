//
//  ReservationCheckView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import Foundation
import UIKit

class ReservationCheckView: UIViewController, ViewProtocol{
    
    let reservationTime:Int = 6
    
    let titleList:[titleText] = [titleText.inform, titleText.status, titleText.startTime, titleText.endTime]
    var contentList:[contentText]!
    var reservationCheckViewModel:ReservationCheckViewModel!
    
    var cautionLabel:UILabel!{
        didSet{
            cautionLabel.text = "예약 좌석 관리는 '설정 > 예약 내역'에서 가능합니다."
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
    
    var reservationBtn:UIButton!{
        didSet{
            reservationBtn.setTitle("확인", for: .normal)
            reservationBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            reservationBtn.setTitleColor(.white, for: .normal)
            reservationBtn.backgroundColor = Color.mainColor
            reservationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            reservationBtn.addAction { [weak self] in
                self?.popView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "좌석예약정보")
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setUpConstraints()
    }
    
    func initUI() {
        reserTableView = UITableView()
        cautionLabel = UILabel()
        reservationBtn = UIButton()
    }
    
    func addView() {
        self.view.addSubview(reserTableView)
        self.view.addSubview(cautionLabel)
        self.view.addSubview(reservationBtn)
    }
    
    func setUpConstraints() {
        let left_Margin = 25
        let right_Margin = -left_Margin
        let top_Margin = 25
        let labelHeight = self.view.frame.height * 0.3 / CGFloat(self.titleList.count) / 1.5
        let btnWidth = self.view.frame.width * 0.25
        let btnHeight = btnWidth * 0.4
        
        self.cautionLabel.snp.makeConstraints{ make in
            make.left.equalTo(left_Margin)
            make.right.equalTo(right_Margin)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(top_Margin)
            make.height.equalTo(labelHeight)
        }
        
        self.reserTableView.snp.makeConstraints{ make in
            make.left.equalTo(left_Margin)
            make.right.equalTo(right_Margin)
            make.top.equalTo(self.cautionLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        self.reservationBtn.snp.makeConstraints{ make in
            make.centerX.equalTo(self.reserTableView)
            make.top.equalTo(self.reserTableView.snp.bottom).offset(10)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
    
    func popView(){
        guard let viewControllers = self.navigationController?.viewControllers as? [UIViewController] else {
            return
        }
        self.navigationController?.popToViewController(viewControllers[viewControllers.count-3], animated: true)
    }
}

extension ReservationCheckView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReservationCheckCell.identifier, for: indexPath) as? ReservationCheckCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setTitle(text: "\(titleList[indexPath.row].rawValue)")
        cell.setContent(text: setCellTitleText(contentText: contentList[indexPath.row]))
        
        return cell
    }
}

extension ReservationCheckView:ReservationCheckDelegate{
    func sendData(classRoom: ClassRoom, classSeat: ClassSeat) {
        self.reservationCheckViewModel = ReservationCheckViewModel(email: "sdfsdfs", building: classRoom.building, classSeat: classSeat, classRoom: classRoom)
        
        contentList = [contentText.inform(classRoom.building,String(classRoom.roomNum),String(classSeat.seatNumber)), contentText.status("예약 완료"), contentText.startTime(""), contentText.endTime("")]
    }
    
    func setCellTitleText(contentText:contentText)->String{
        let startDate:Date = Date()
        let endDate = Calendar.current.date(byAdding: .hour, value: reservationTime, to: startDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let startTime = dateFormatter.string(from: startDate)
        let endTime = dateFormatter.string(from: endDate)

        switch contentText{
            case .inform(let building,let roomNum,let seatNumber):
                return "\(building)-\(roomNum)호 \(seatNumber)번 좌석"
            case .status(let status):
                return status
            case .startTime(_):
                return startTime
            case .endTime(_):
                return endTime
        }
    }
}


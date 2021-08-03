//
//  ReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ReservationView : UIViewController{
    
    let cellNumbersofLine:Int = 4
    var reservationViewModel :ReservationViewModel = ReservationViewModel()
    var delegate: ReservationCheckDelegate?
    
    var usableView : UIView!{
        didSet{
            usableView.backgroundColor = Color.green
        }
    }
    
    var usableLabel : UILabel!{
        didSet{
            usableLabel.text = "사용가능"
            usableLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    var unusableView : UIView!{
        didSet{
            unusableView.backgroundColor = Color.gray
        }
    }
    
    var unusableLabel : UILabel!{
        didSet{
            unusableLabel.text = "사용불가"
            unusableLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    var seatPicBtn : UIButton!{
        didSet{
            seatPicBtn.setTitle("배치도 보기", for: .normal)
            seatPicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            seatPicBtn.backgroundColor = Color.subColor
            seatPicBtn.layer.cornerRadius = 7
            seatPicBtn.addAction {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SeatPicView") as? SeatPicView
                pushVC?.modalPresentationStyle = .popover
                self.navigationController?.present(pushVC!, animated: true, completion: nil)
            }
        }
    }
    
    var seatCollectionView : UICollectionView!{
        didSet{
            seatCollectionView.backgroundColor = .white
            seatCollectionView.dataSource = self
            seatCollectionView.delegate = self
            seatCollectionView.register(ClassSeatCell.self, forCellWithReuseIdentifier: ClassSeatCell.identifier)
            seatCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
            
            let layout = seatCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = self.view.frame.width / CGFloat(cellNumbersofLine) * 0.7
            let cellHeigt = cellWidth * 0.6
            
            layout.itemSize = CGSize(width: cellWidth, height: cellHeigt)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        usableView = UIView()
        usableLabel = UILabel()
        unusableView = UIView()
        unusableLabel = UILabel()
        seatPicBtn = UIButton()
        seatCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func addView(){
        self.view.addSubview(usableView)
        self.view.addSubview(usableLabel)
        self.view.addSubview(unusableView)
        self.view.addSubview(unusableLabel)
        self.view.addSubview(seatPicBtn)
        self.view.addSubview(seatCollectionView)
    }
    
    func setupConstraints(){
        let leftmargin = self.view.frame.width * 0.275
        let titleViewWidth = self.view.frame.width * 0.05
        let titleLabelWidth = self.view.frame.width * 0.2
        let titleTopMargin = 15
        let btnWidth = self.view.frame.width * 0.25
        let btnHeight = btnWidth * 0.3
        
        usableView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(titleTopMargin)
            make.width.equalTo(titleViewWidth)
            make.height.equalTo(titleViewWidth)
            make.leading.equalTo(leftmargin)
        }
        
        usableLabel.snp.makeConstraints{ make in
            make.top.equalTo(usableView.snp.top)
            make.width.equalTo(titleLabelWidth)
            make.height.equalTo(titleViewWidth)
            make.leading.equalTo(usableView.snp.trailing).offset(5)
        }
        
        unusableView.snp.makeConstraints{ make in
            make.top.equalTo(usableView.snp.top)
            make.width.equalTo(titleViewWidth)
            make.height.equalTo(titleViewWidth)
            make.leading.equalTo(usableLabel.snp.trailing).offset(10)
        }
        
        unusableLabel.snp.makeConstraints{ make in
            make.top.equalTo(usableView.snp.top)
            make.width.equalTo(titleLabelWidth)
            make.height.equalTo(titleViewWidth)
            make.leading.equalTo(unusableView.snp.trailing).offset(5)
        }
        
        seatPicBtn.snp.makeConstraints{ make in
            make.top.equalTo(unusableLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
        
        seatCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(seatPicBtn.snp.bottom).offset(titleTopMargin)
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
}

extension ReservationView:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reservationViewModel.classSeat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassSeatCell.identifier, for: indexPath) as? ClassSeatCell else{
            return UICollectionViewCell()
        }
        cell.classSeat = reservationViewModel.classSeat[indexPath.row]
        cell.setBtnAction {[weak self] in
            guard let classRoom = self?.reservationViewModel.classRoom, let classSeats = self?.reservationViewModel.classSeat else{
                return
            }
            
            let alert = Alert(title: "좌석 확인", message: "다음 좌석을 예약하시겠습니까?\n\(classRoom.building)-\(classRoom.roomNum)호 \(indexPath.row+1)번\n\n *반드시 착석 후 좌석을 예약해주세요.", viewController: self!)
            alert.popUpNormalAlert{ (action) in
                self?.pushToReservationCheckView(classRoom: classRoom, classSeat: classSeats, index: indexPath.row)
            }
        }
        return cell
    }
    
    func pushToReservationCheckView(classRoom:ClassRoom, classSeat:[ClassSeat], index:Int){
        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ReservationCheckView") as? ReservationCheckView else{
            return
        }
        self.navigationController?.pushViewController(pushVC, animated: true)
        self.delegate = pushVC
        self.delegate?.sendData(classRoom: classRoom, classSeat: classSeat[index])
    }
}

extension ReservationView:ClassDataDelegate{
    func sendData(data: ClassRoom) {
        reservationViewModel.setClassRoom(classRoom: data)
        setNavigationTitle(title: "\(data.building)-\(data.roomId)호")
    }
    
}

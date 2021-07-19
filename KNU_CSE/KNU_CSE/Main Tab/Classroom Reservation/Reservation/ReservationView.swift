//
//  ReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ReservationView : UIViewController, ClassDataDelegate{
    
    let cellNumbersofLine:Int = 4
    var reservationViewModel :ReservationViewModel = ReservationViewModel()
    
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
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
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
        seatCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func addView(){
        self.view.addSubview(usableView)
        self.view.addSubview(usableLabel)
        self.view.addSubview(unusableView)
        self.view.addSubview(unusableLabel)
        self.view.addSubview(seatCollectionView)
    }
    
    func setupConstraints(){
        let leftmargin = self.view.frame.width * 0.275
        let titleViewWidth = self.view.frame.width * 0.05
        let titleLabelWidth = self.view.frame.width * 0.2
        let titleTopMargin = 15
        
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
        
        seatCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(unusableLabel.snp.bottom).offset(titleTopMargin)
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview()
        }
    }
    
    func sendData(data: ClassRoom) {
        reservationViewModel.setClassRoomNum(classRoomNum: data.roomNum)
        setNavigationTitle(title: "\(data.building)-\(data.roomId)호")
    }
    
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
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
        cell.setBtnAction {
            print("zz")
        }
        return cell
    }
}

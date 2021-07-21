//
//  SeatReservationCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import UIKit
import SnapKit

class ClassRoomCell : UITableViewCell {
    static let identifier = "ClassRoomCell"
    var titleLabel = UILabel()
    var cellBtn = UIButton()
    
    var action :()->() = {}
    
    var classRoom : ClassRoom!{
        didSet{
            let title = "\(classRoom.building)-\(classRoom.roomNum)호(\(classRoom.currentSeat)/\(classRoom.totalSeat))"
            self.setTitle(title: title)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }
    
    func setAction(action:@escaping()->()){
        self.action = action
        self.cellBtn.addTarget(self, action: #selector(pushView), for: .touchUpInside)
    }

    @objc func pushView(){
        self.action()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        
    }
    
    func addView(){
        self.contentView.addSubview(cellBtn)
        self.cellBtn.addSubview(titleLabel)
    }
    
    func setUpConstraints(){
        cellBtn.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

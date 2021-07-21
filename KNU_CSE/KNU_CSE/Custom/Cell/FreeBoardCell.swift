//
//  BoardCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import UIKit
import SnapKit

class FreeBoardCell : UITableViewCell {
    static let identifier = "FreeBoardCell"
    var titleLabel = UILabel()
    var action :()->() = {}
    var cellBtn = UIButton()
    
    var board : FreeBoard!{
        didSet{
            let title = "\(board.building)-\(board.roomNum)호(\(board.currentSeat)/\(board.totalSeat))"
            self.setTitle(title: title)
        }
    }
    
    override func prepareForReuse() {
        
    }
    
    @objc func pushView(){
        self.action()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        //self.contentView.addSubview(titleLabel)
    }
    
    func setUpConstraints(){
        
        cellBtn.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension FreeBoardCell{
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }
    
}

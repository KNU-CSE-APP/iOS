//
//  BoardCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import UIKit
import SnapKit

class BoardCell : UITableViewCell {
    static let identifier = "BoardCell"
    var titleLabel = UILabel()
    var action :()->() = {}
    
    var board : Board!{
        didSet{
            let title = "\(board.building)-\(board.roomNum)호(\(board.currentSeat)/\(board.totalSeat))"
            self.setTitle(title: title)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
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
        //contentView.isUserInteractionEnabled = true
    }
    
    func addView(){
        self.contentView.addSubview(titleLabel)
    }
    
    func setUpConstraints(){
        titleLabel.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

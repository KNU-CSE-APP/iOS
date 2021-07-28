//
//  MyPageViewCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/28.
//

import UIKit
import SnapKit

class MyPageViewCell : UITableViewCell {
    static let identifier = "MyPageViewCell"
    var titleLabel:PaddingLabel!{
        didSet{
            titleLabel.textAlignment = .left
        }
    }
    
    var listener : ()->Void = { }
    
    func setTitle(title: String) {
        titleLabel.text = title
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
        self.titleLabel = PaddingLabel(withInsets: 0, 0, 20, 0)
    }
    
    func addView(){
        self.contentView.addSubview(titleLabel)
    }
    
    func setListener(listener: @escaping()->Void ){
        print(type(of: listener))
        self.listener = listener
    }
    
    func setUpConstraints(){
        titleLabel.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

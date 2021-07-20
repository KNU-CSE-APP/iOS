//
//  BoardTitleCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/21.
//

import UIKit

class BoardTitleCell : UICollectionViewCell {
    var titleLabel = UILabel()
    static let identifier = "BoardTitleCell"
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                titleLabel.textColor = .black
            } else {
                titleLabel.textColor = .lightGray
            }
        }
    }
    
    override func prepareForReuse() {
        //isSelected = false
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
        self.isSelected = false
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(){
        initUI()
        addView()
        setUpConstraints()
    }
    
    func initUI(){
        
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

extension BoardTitleCell{
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }
}

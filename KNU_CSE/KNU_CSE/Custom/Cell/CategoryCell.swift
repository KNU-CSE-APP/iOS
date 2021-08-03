//
//  CategoryCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/03.
//

import UIKit

class CategoryCell : UICollectionViewCell {
    var titleLabel = UILabel()
    static let identifier = "CategoryCell"
    
    static func fittingSize(name: String) -> CGSize {
        let cell = CategoryCell()
        cell.setTitle(title: name)
        
        let cellheight = cell.titleLabel.font.lineHeight + 10
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellheight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.titleLabel.textColor = .white
                self.contentView.backgroundColor = Color.mainColor.withAlphaComponent(0.65)
            } else {
                self.titleLabel.textColor = .lightGray
                self.contentView.backgroundColor = .white
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
        self.contentView.layer.borderWidth = 0.3
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func addView(){
        self.contentView.addSubview(titleLabel)
    }
    
    func setUpConstraints(){
        titleLabel.snp.makeConstraints{ make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
}

extension CategoryCell{
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
}

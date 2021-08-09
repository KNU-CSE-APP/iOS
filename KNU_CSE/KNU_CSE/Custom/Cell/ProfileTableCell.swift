//
//  ProfileTableCell.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//


import UIKit
import SnapKit

class ProfileTableCell : UITableViewCell {
    static let identifier = "ProfileTableCell"
    @objc var listener : (String, String)->Void = { _, _ in }
    var origin_text:String!
    
    private var titleLabel:PaddingLabel!{
        didSet{
            titleLabel.textAlignment = .left
        }
    }
    
    var contentLabel:UITextField!{
        didSet{
            contentLabel.textAlignment = .left
            contentLabel.isEnabled = false
            contentLabel.delegate = self
            contentLabel.returnKeyType = .done
        }
    }
    
    private var editBtn:UIButton!{
        didSet{
            editBtn.setTitle("수정", for: .normal)
            editBtn.setTitleColor(.black, for: .normal)
            editBtn.setTitleColor(.black.withAlphaComponent(0.7), for: .highlighted)
            editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            editBtn.backgroundColor = .white
            editBtn.layer.borderWidth = 0.5
            editBtn.layer.borderColor = UIColor.lightGray.cgColor
            editBtn.layer.cornerRadius = 10
            editBtn.isHidden = true
            
            editBtn.addAction {
                self.contentLabel.isEnabled = true
                self.contentLabel.becomeFirstResponder()
            }
        }
    }
    
    var delegate:UITextFieldDelegate?
    
    func setTitle(title:String, content:String) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.origin_text = content
    }
    
    func setEditable(){
        self.editBtn.isHidden = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
        self.addView()
        self.setUpNormalCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        self.titleLabel = PaddingLabel(withInsets: 0, 0, 20, 0)
        self.contentLabel = UITextField()
        self.editBtn = UIButton()
    }
    
    func addView(){
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(editBtn)
    }
    
    func setUpNormalCellConstraints(){
        self.titleLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        self.contentLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview()
        }
    }
    
    func setUpEditCellConstraints(){
        let btn_width = 60
        self.titleLabel.snp.removeConstraints()
        self.contentLabel.snp.removeConstraints()
        
        self.titleLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        self.contentLabel.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(self.editBtn.snp.left).offset(-5)
        }
        
        self.editBtn.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(btn_width)
            make.right.equalToSuperview().offset(-15)
    
        }
    }
}

extension ProfileTableCell: UITextFieldDelegate{

    //touch any space then keyboard shut down
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.contentView.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension ProfileTableCell{
    func setListener(listener: @escaping(String, String)->Void ){
        self.listener = listener
        self.contentLabel.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    @objc func textChange(){
        self.listener(origin_text, contentLabel.text!)
    }
}

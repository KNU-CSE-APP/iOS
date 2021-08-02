//
//  EditPwView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//


import UIKit

class EditPwView:UIViewController,ViewProtocol{
    
    var indicator : IndicatorView!
    
    var findPwViewModel : FindPwViewModel = FindPwViewModel(listener: nil)
    
    let containerView = UIView()
    
    var pwTextField: BindingTextField! {
        didSet {
            pwTextField.isSecureTextEntry = true
            pwTextField.delegate = self
            pwTextField.textContentType = .password
            pwTextField.draw()
            pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            pwTextField.bind { [weak self] pw in
                self?.findPwViewModel.account.password = pw
                self?.checkChangeValue()
            }
        }
    }
    
    var pw2TextField: BindingTextField! {
        didSet {
            pw2TextField.isSecureTextEntry = true
            pw2TextField.delegate = self
            pw2TextField.textContentType = .password
            pw2TextField.draw()
            pw2TextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            pw2TextField.bind { [weak self] pw2 in
                self?.findPwViewModel.account.password2 = pw2
                self?.checkChangeValue()
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            registerBtn.backgroundColor = UIColor.lightGray
            registerBtn.setTitle("비밀번호 변경", for: .normal)
            registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            registerBtn.layer.cornerRadius = 5
        }
    }
    
    var pwTitle : SignUpUILabel!{
        didSet{

        }
    }
    var pw2Title : SignUpUILabel!{
        didSet{

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title:"비밀번호 변경")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        self.pwTitle = SignUpUILabel(text: "비밀번호")
        self.pw2Title = SignUpUILabel(text: "비밀번호 재확인")
        
        self.pwTextField = BindingTextField()
        self.pw2TextField = BindingTextField()
        
        self.registerBtn = UIButton()
        self.indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(containerView)
        _ =  [self.pwTextField,self.pw2TextField,self.pwTitle,self.pw2Title,self.registerBtn].map{
            self.containerView.addSubview($0)
        }
    }
    
    func setUpConstraints(){
        let title_height:CGFloat = self.view.frame.width * 0.05
        let height:CGFloat = self.view.frame.height * 0.05
        let top_padding:CGFloat = 15
        let title_To_textField_margin:CGFloat = 3
        let left_margin:CGFloat = 30
        let right_margin:CGFloat = -30
        
        self.containerView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }

        // MARK: - 비밀번호
        self.pwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(containerView.snp.top).offset(top_padding+10)
            make.height.equalTo(title_height)
        }

        self.pwTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pwTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 비밀번호 확인
        self.pw2Title.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pwTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.pw2TextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pw2Title.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 회원가입 버튼
        self.registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pw2TextField.snp.bottom).offset(top_padding*2)
            make.height.equalTo(height)
        }
    }
}


extension EditPwView: UITextFieldDelegate{

    //touch any space then keyboard shut down
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    //if keyboard show up and press return button then keyboard shutdown
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkChangeValue(){
        if self.findPwViewModel.SignUpCheck(){
            self.addBtnAction()
        }else{
            self.removeBtnAction()
        }
    }
    
    func addBtnAction(){
        registerBtn.backgroundColor = Color.mainColor
        registerBtn.addAction{
          
        }
    }
    
    func removeBtnAction(){
        registerBtn.backgroundColor = UIColor.lightGray
        registerBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}

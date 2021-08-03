//
//  PwFind.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class FindPwView:UIViewController,ViewProtocol{
        
    var indicator : IndicatorView!
    
    var findPwViewModel : FindPwViewModel = FindPwViewModel(listener: nil)
    
    let containerView = UIView()
    var emailTextField: BindingTextField! {
        didSet {
            emailTextField.draw()
            emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
            emailTextField.delegate = self
            emailTextField.bind { [weak self] email in
                self?.findPwViewModel.account.email = email
            }
        }
    }
    
    var sendCodeBtn : UIButton! {
        didSet{
            sendCodeBtn.backgroundColor = Color.mainColor
            sendCodeBtn.setTitle("인증번호 전송", for: .normal)
            sendCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
            sendCodeBtn.tintColor = .white
            sendCodeBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            sendCodeBtn.addAction{
                let alert = Alert(title: "인증번호 전송", message: "인증번호가 해당 이메일로 전송되었습니다.", viewController: self)
                alert.popUpDefaultAlert(action: nil)
            }
        }
    }
    
    var emailCodeTextField: BindingTextField! {
        didSet {
            emailCodeTextField.draw()
            emailCodeTextField.delegate = self
            emailCodeTextField.keyboardType = .numberPad
            emailCodeTextField.placeholder = "인증번호를 입력하세요."
            emailCodeTextField.bind { [weak self] code in
                self?.findPwViewModel.emailCode = code
            }
        }
    }
    
    var confirmCodeBtn : UIButton! {
        didSet{
            confirmCodeBtn.backgroundColor = Color.mainColor
            confirmCodeBtn.setTitle("인증확인", for: .normal)
            confirmCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
            confirmCodeBtn.tintColor = .white
            confirmCodeBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            confirmCodeBtn.addAction{ [weak self] in
                let alert = Alert(title: "인증 성공", message: "이메일 인증을 완료했습니다.", viewController: self!)
                alert.popUpDefaultAlert(action: nil)
                self?.showPwField()
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            pwTextField.isHidden = true
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
            pw2TextField.isHidden = true
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
            registerBtn.isHidden = true
            registerBtn.backgroundColor = UIColor.lightGray
            registerBtn.setTitle("비밀번호 변경", for: .normal)
            registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            registerBtn.layer.cornerRadius = 5
        }
    }
    
    var emailTitle : SignUpUILabel!
    var pwTitle : SignUpUILabel!{
        didSet{
            pwTitle.isHidden = true
        }
    }
    var pw2Title : SignUpUILabel!{
        didSet{
            pw2Title.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title:"비밀번호 찾기")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        self.emailTitle = SignUpUILabel(text: "이메일")
        self.pwTitle = SignUpUILabel(text: "비밀번호")
        self.pw2Title = SignUpUILabel(text: "비밀번호 재확인")
        
        self.emailTextField = BindingTextField()
        self.emailCodeTextField = BindingTextField()
        self.pwTextField = BindingTextField()
        self.pw2TextField = BindingTextField()
        
        self.sendCodeBtn = UIButton()
        self.confirmCodeBtn = UIButton()
        self.registerBtn = UIButton()
        
        indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(containerView)
        _ =  [emailTextField,emailCodeTextField,sendCodeBtn,emailCodeTextField,confirmCodeBtn,pwTextField,pw2TextField,emailTitle,pwTitle,pw2Title,registerBtn].map{
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
        
        // MARK: - Email
        self.emailTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalToSuperview().offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        self.emailTextField.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.7)
            make.leading.equalTo(left_margin)
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        self.sendCodeBtn.snp.makeConstraints{ make in
            make.leading.equalTo(emailTextField.snp.trailing).offset(10)
            make.trailing.equalTo(right_margin)
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - Email code
        self.emailCodeTextField.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.7)
            make.leading.equalTo(left_margin)
            make.top.equalTo(emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }

        self.confirmCodeBtn.snp.makeConstraints{ make in
            make.leading.equalTo(emailCodeTextField.snp.trailing).offset(10)
            make.trailing.equalTo(right_margin)
            make.top.equalTo(emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }

        // MARK: - 비밀번호
        self.pwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailCodeTextField.snp.bottom).offset(top_padding+10)
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


extension FindPwView: UITextFieldDelegate{

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

extension FindPwView{
    func showPwField(){
        self.emailTextField.isEnabled = false
        self.emailCodeTextField.isEnabled = false
        self.sendCodeBtn.isEnabled = false
        self.confirmCodeBtn.isEnabled = false
        
        self.pwTitle.isHidden = false
        self.pwTextField.isHidden = false
        self.pw2Title.isHidden = false
        self.pw2TextField.isHidden = false
        self.registerBtn.isHidden = false
    }
}

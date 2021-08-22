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
            self.emailTextField.draw()
            self.emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
            self.emailTextField.delegate = self
            self.emailTextField.bind { [weak self] email in
                self?.findPwViewModel.account.email = email
            }
        }
    }
    
    var sendCodeBtn : UIButton! {
        didSet{
            self.sendCodeBtn.backgroundColor = Color.mainColor
            self.sendCodeBtn.setTitle("인증번호 전송", for: .normal)
            self.sendCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
            self.sendCodeBtn.tintColor = .white
            self.sendCodeBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.sendCodeBtn.addAction{ [weak self] in
                self?.findPwViewModel.requestCode()
            }
        }
    }
    
    var emailCodeTextField: BindingTextField! {
        didSet {
            self.emailCodeTextField.draw()
            self.emailCodeTextField.delegate = self
            self.emailCodeTextField.keyboardType = .numberPad
            self.emailCodeTextField.placeholder = "인증번호를 입력하세요."
            self.emailCodeTextField.bind { [weak self] code in
                self?.findPwViewModel.account.code = code
            }
        }
    }
    
    var confirmCodeBtn : UIButton! {
        didSet{
            self.confirmCodeBtn.backgroundColor = Color.mainColor
            self.confirmCodeBtn.setTitle("인증확인", for: .normal)
            self.confirmCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
            self.confirmCodeBtn.tintColor = .white
            self.confirmCodeBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.confirmCodeBtn.addAction{ [weak self] in
                self?.findPwViewModel.requestCodeConfirm()
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            self.pwTextField.isHidden = true
            self.pwTextField.isSecureTextEntry = true
            self.pwTextField.delegate = self
            self.pwTextField.textContentType = .password
            self.pwTextField.draw()
            self.pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            self.pwTextField.bind { [weak self] pw in
                self?.findPwViewModel.account.password = pw
                self?.checkChangeValue()
            }
        }
    }
    
    var pw2TextField: BindingTextField! {
        didSet {
            self.pw2TextField.isHidden = true
            self.pw2TextField.isSecureTextEntry = true
            self.pw2TextField.delegate = self
            self.pw2TextField.textContentType = .password
            self.pw2TextField.draw()
            self.pw2TextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            self.pw2TextField.bind { [weak self] pw2 in
                self?.findPwViewModel.account.password2 = pw2
                self?.checkChangeValue()
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            self.registerBtn.isHidden = true
            self.registerBtn.backgroundColor = UIColor.lightGray
            self.registerBtn.setTitle("비밀번호 변경", for: .normal)
            self.registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.registerBtn.layer.cornerRadius = 5
        }
    }
    
    var emailTitle : SignUpUILabel!
    
    var pwTitle : SignUpUILabel!{
        didSet{
            self.pwTitle.isHidden = true
        }
    }
    
    var pwCautionTitle : SignUpUILabel!{
        didSet{
            self.pwCautionTitle.isHidden = true
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
        
        self.Binding()
    }
    
    func initUI(){
        self.emailTitle = SignUpUILabel(text: "이메일")
        self.pwTitle = SignUpUILabel(text: "비밀번호")
        self.pwCautionTitle = SignUpUILabel(text: "영어,숫자를 조합한 8~20자",alignment: .right, color: UIColor.lightGray)
        self.pw2Title = SignUpUILabel(text: "비밀번호 재확인")
        
        self.emailTextField = BindingTextField()
        self.emailCodeTextField = BindingTextField()
        self.pwTextField = BindingTextField()
        self.pw2TextField = BindingTextField()
        
        self.sendCodeBtn = UIButton()
        self.confirmCodeBtn = UIButton()
        self.registerBtn = UIButton()
        
        self.indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(containerView)
        _ =  [self.emailTextField,self.emailCodeTextField,self.sendCodeBtn,self.emailCodeTextField,self.confirmCodeBtn,self.pwTextField,self.pw2TextField,self.emailTitle,self.pwTitle,self.pwCautionTitle,self.pw2Title,self.registerBtn].map{
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
            make.width.equalTo(self.pwTextField.snp.width).multipliedBy(0.7)
            make.leading.equalTo(left_margin)
            make.top.equalTo(self.emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        self.sendCodeBtn.snp.makeConstraints{ make in
            make.leading.equalTo(self.emailTextField.snp.trailing).offset(10)
            make.trailing.equalTo(right_margin)
            make.top.equalTo(self.emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - Email code
        self.emailCodeTextField.snp.makeConstraints{ make in
            make.width.equalTo(self.pwTextField.snp.width).multipliedBy(0.7)
            make.leading.equalTo(left_margin)
            make.top.equalTo(self.emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }

        self.confirmCodeBtn.snp.makeConstraints{ make in
            make.leading.equalTo(self.emailCodeTextField.snp.trailing).offset(10)
            make.trailing.equalTo(right_margin)
            make.top.equalTo(self.emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }

        // MARK: - 비밀번호
        self.pwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.width.equalTo(100)
            make.top.equalTo(self.emailCodeTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        self.pwCautionTitle.snp.makeConstraints{ make in
            make.left.equalTo(self.pwTitle.snp.right)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.emailCodeTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.pwTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pwTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 비밀번호 확인
        self.pw2Title.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pwTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.pw2TextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pw2Title.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 회원가입 버튼
        self.registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pw2TextField.snp.bottom).offset(top_padding*2)
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
        self.registerBtn.backgroundColor = Color.mainColor
        self.registerBtn.addAction { [weak self] in
            self?.findPwViewModel.modifyPw()
        }
    }
    
    func removeBtnAction(){
        self.registerBtn.backgroundColor = UIColor.lightGray
        self.registerBtn.removeTarget(nil, action: nil, for: .allEvents)
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
        self.pwCautionTitle.isHidden = false
        self.pw2Title.isHidden = false
        self.pw2TextField.isHidden = false
        self.registerBtn.isHidden = false
    }
}

extension FindPwView{
    func Binding(){
        self.BindingForCode()
        self.BindingForCodeConfirm()
        self.BindingForModifyPw()
    }
    
    func BindingForCode(){
        self.findPwViewModel.emailCodeAction.binding(successHandler: {
            [weak self] result in
            if result.success{
                
            }else{
                if let error = result.error?.message{
                    Alert(title: "실패", message: error, viewController: self!).popUpDefaultAlert(action: nil)
                }
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self!).popUpDefaultAlert(action: nil)
        }, asyncHandler: { [weak self] in
            let alert = Alert(title: "인증번호 전송", message: "인증번호가 해당 이메일로 전송되었습니다.\n전송된 메일이 스팸함에 있을 수 있습니다.", viewController: self!)
            alert.popUpDefaultAlert(action: nil)
        }, endHandler: {
            
        })
    }
    
    func BindingForCodeConfirm(){
        self.findPwViewModel.emailCodeConfirmAction.binding(successHandler: {
            [weak self] result in
            if result.success, let code = result.response{
                self?.findPwViewModel.account.code = code
                self?.showPwField()
                Alert(title: "인증 성공", message: "이메일 인증에 성공했습니다.", viewController: self!).popUpDefaultAlert(action: nil)
            }else{
                if let error = result.error?.message{
                    Alert(title: "실패", message: error, viewController: self!).popUpDefaultAlert(action: nil)
                }
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self!).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
    
    func BindingForModifyPw(){
        self.findPwViewModel.modifyPwAction.binding(successHandler: {
            [weak self] result in
            if result.success{
                Alert(title: "비밀번호 변경 성공", message: "비밀번호 변경이 완료됐습니다. 변경한 비밀번호로 로그인해주세요.", viewController: self!).popUpDefaultAlert{ [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            }else{
                if let error = result.error?.message{
                    Alert(title: "실패", message: error, viewController: self!).popUpDefaultAlert(action: nil)
                }
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self!).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
}

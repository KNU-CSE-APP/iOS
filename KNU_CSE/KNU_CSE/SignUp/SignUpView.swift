//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import UIKit
import SnapKit
import M13Checkbox

class SignUpView: UIViewController,ViewProtocol{
    
    var indicator : IndicatorView!
    
    var signUpViewModel : SignUpViewModel = SignUpViewModel()
    
    let containerView = UIView()
    
    var emailTextField: BindingTextField! {
        didSet {
            self.emailTextField.draw()
            self.emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
            self.emailTextField.delegate = self
            self.emailTextField.bind { [weak self] email in
                self?.signUpViewModel.account.email = email + "@knu.ac.kr"
                self?.checkChangeValue()
            }
        }
    }
    
    var requestCodeBtn : UIButton! {
        didSet{
            self.requestCodeBtn.backgroundColor = Color.mainColor
            self.requestCodeBtn.setTitle("인증번호 전송", for: .normal)
            self.requestCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
            self.requestCodeBtn.tintColor = .white
            self.requestCodeBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.BindingRequestCodeBtn()
            self.requestCodeBtn.addAction{ [weak self] in
                self?.signUpViewModel.CodeRequest()
            }
        }
    }
    
    var emailCodeTextField: BindingTextField! {
        didSet {
            self.emailCodeTextField.draw()
            self.emailCodeTextField.delegate = self
            self.emailCodeTextField.keyboardType = .numberPad
            self.emailCodeTextField.placeholder = "인증번호를 입력하세요."
            self.emailCodeTextField.bind { [weak self] permissionCode in
                self?.signUpViewModel.account.permissionCode = permissionCode
                self?.checkChangeValue()
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
            self.BindingConfirmCodeBtn()
            self.confirmCodeBtn.addAction{ [weak self] in
                self?.signUpViewModel.CodeConfirm()
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            self.pwTextField.isSecureTextEntry = true
            self.pwTextField.delegate = self
            self.pwTextField.textContentType = .password
            self.pwTextField.draw()
            self.pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            self.pwTextField.bind { [weak self] pw in
                self?.signUpViewModel.account.password = pw
                self?.checkChangeValue()
            }
        }
    }
    
    var pw2TextField: BindingTextField! {
        didSet {
            self.pw2TextField.isSecureTextEntry = true
            self.pw2TextField.delegate = self
            self.pw2TextField.textContentType = .password
            self.pw2TextField.draw()
            self.pw2TextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
        }
    }
    
    var userNameTextField: BindingTextField! {
        didSet {
            self.userNameTextField.draw()
            self.userNameTextField.delegate = self
            self.userNameTextField.bind { [weak self] userName in
                self?.signUpViewModel.account.username = userName
                self?.checkChangeValue()
            }
            self.addKeyBoardAnimaion(textField: userNameTextField)
        }
    }
    
    var nickNameTextField: BindingTextField! {
        didSet {
            self.nickNameTextField.draw()
            self.nickNameTextField.delegate = self
            self.nickNameTextField.bind { [weak self] nickName in
                self?.signUpViewModel.account.nickname = nickName
                self?.checkChangeValue()
            }
            self.addKeyBoardAnimaion(textField: nickNameTextField)
        }
    }
    
    var stuidTextField: BindingTextField! {
        didSet {
            self.stuidTextField.keyboardType = .numberPad
            self.stuidTextField.delegate = self
            self.stuidTextField.draw()
            self.stuidTextField.bind { [weak self] studentId in
                self?.signUpViewModel.account.studentId = studentId
                self?.checkChangeValue()
            }
            self.addKeyBoardAnimaion(textField: stuidTextField)
        }
    }
    
    var majorCom : CheckBox!{
        didSet{
            let checkbox : M13Checkbox = majorCom.checkBox
            self.majorCom.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.majorGlob.checkBox.checkState == .checked{
                            self.majorGlob.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.major = "ADVANCED"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.major = ""
                        break
                    case .mixed:
                        break
                }
                self.checkChangeValue()
            }
        }
    }
    
    var majorGlob : CheckBox!{
        didSet{
            let checkbox : M13Checkbox = majorGlob.checkBox
            self.majorGlob.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.majorCom.checkBox.checkState == .checked{
                            self.majorCom.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.major = "GLOBAL"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.major = ""
                        break
                    case .mixed:
                        break
                }
                self.checkChangeValue()
            }
        }
    }
    
    var genderMale : CheckBox!{
        didSet{
            let checkbox : M13Checkbox = genderMale.checkBox
            self.genderMale.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.genderFemale.checkBox.checkState == .checked{
                            self.genderFemale.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.gender = "MALE"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.gender = ""
                        break
                    case .mixed:
                        break
                }
                self.checkChangeValue()
            }
        }
    }
    
    var genderFemale : CheckBox!{
        didSet{
            let checkbox : M13Checkbox = genderFemale.checkBox
            self.genderFemale.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.genderMale.checkBox.checkState == .checked{
                            self.genderMale.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.gender = "FEMALE"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.gender = ""
                        break
                    case .mixed:
                        break
                }
                self.checkChangeValue()
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            self.registerBtn.backgroundColor = UIColor.lightGray
            self.registerBtn.setTitle("회원가입", for: .normal)
            self.registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.registerBtn.layer.cornerRadius = 5
            self.BindingSignUp()
            self.registerBtn.addAction{ [weak self] in
                guard let check = self?.signUpViewModel.SignUpCheck() else{
                    return
                }
                if check{
                    if self?.signUpViewModel.account.password != self?.pw2TextField.text{
                        let alert = Alert(title: "회원가입 실패", message: "비밀번호가 일치하지 않습니다.", viewController: self!)
                        alert.popUpDefaultAlert(action: nil)
                    }
                    else{
                        self?.signUpViewModel.SignUp()
                    }
                }else{
                    let alert = Alert(title: "회원가입 실패", message: "모든 정보를 입력하지 않았습니다.", viewController: self!)
                    alert.popUpDefaultAlert(action: nil)
                }
            }
        }
    }
    
    let emailTitle : SignUpUILabel = SignUpUILabel(text: "이메일")
    let pwCautionTitle : SignUpUILabel = SignUpUILabel(text: "영어,숫자를 조합한 8~20자",alignment: .right, color: UIColor.lightGray)
    let pwTitle : SignUpUILabel = SignUpUILabel(text: "비밀번호")
    let pw2Title : SignUpUILabel = SignUpUILabel(text: "비밀번호 재확인")
    let userNameTitle : SignUpUILabel = SignUpUILabel(text: "이름")
    let nickNameTitle : SignUpUILabel = SignUpUILabel(text: "닉네임")
    let stuidTitle : SignUpUILabel = SignUpUILabel(text: "학번")
    let majorTitle : SignUpUILabel = SignUpUILabel(text: "전공")
    let genderTitle : SignUpUILabel = SignUpUILabel(text: "성별")
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title:"회원가입")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        self.emailTextField = BindingTextField()
        self.emailCodeTextField = BindingTextField()
        self.pwTextField = BindingTextField()
        self.pw2TextField = BindingTextField()
        self.userNameTextField = BindingTextField()
        self.nickNameTextField = BindingTextField()
        self.stuidTextField = BindingTextField()
        
        self.majorCom = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "심컴")
        self.majorGlob = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "글솦")
        self.genderMale = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "남")
        self.genderFemale = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "여")
        
        self.requestCodeBtn = UIButton()
        self.confirmCodeBtn = UIButton()
        self.registerBtn = UIButton()
        
        self.indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(containerView)
        
        _ =  [self.emailTextField,self.emailCodeTextField,self.requestCodeBtn,self.emailCodeTextField,self.confirmCodeBtn,self.pwTextField,self.pw2TextField,self.userNameTextField,self.nickNameTextField,self.stuidTextField,self.emailTitle,self.pwTitle,self.pwCautionTitle,self.pw2Title,self.userNameTitle,self.nickNameTitle,self.stuidTitle,self.majorTitle,self.majorCom,self.majorGlob,self.genderTitle,self.genderMale,self.genderFemale,self.registerBtn].map{
            self.containerView.addSubview($0)
        }
    }
    
    func setUpConstraints(){
        let title_height = self.view.frame.width * 0.05
        let height = self.view.frame.height * 0.05
        let top_padding = 15
        let title_To_textField_margin = 1
        let left_margin = 30
        let right_margin = -30
        
        self.containerView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
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
            make.width.equalTo(self.pwTextField).multipliedBy(0.7)
            make.leading.equalTo(left_margin)
            
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        self.requestCodeBtn.snp.makeConstraints{ make in
            make.leading.equalTo(self.emailTextField.snp.trailing).offset(10)
            make.trailing.equalTo(right_margin)
            make.top.equalTo(self.emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - Email code
        self.emailCodeTextField.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.7)
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

        // MARK: - 이름
        self.userNameTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pw2TextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.userNameTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.userNameTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }


        // MARK: - 닉네임
        self.nickNameTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.userNameTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.nickNameTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.nickNameTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 학번
        self.stuidTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.nickNameTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.stuidTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.stuidTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - Checkbox 제목
        self.majorTitle.snp.makeConstraints{ make in
            make.leading.equalTo(left_margin)
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.5)
            make.top.equalTo(self.stuidTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        self.genderTitle.snp.makeConstraints{ make in
            make.leading.equalTo(self.majorTitle.snp.trailing)
            make.width.equalTo(self.stuidTextField.snp.width).multipliedBy(0.5)
            make.top.equalTo(self.stuidTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }

        // MARK: - 전공
        self.majorCom.snp.makeConstraints{ make in
            make.width.equalTo(self.stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(self.stuidTextField.snp.height)
            make.top.equalTo(self.majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(left_margin)
        }

        self.majorGlob.snp.makeConstraints{ make in
            make.width.equalTo(self.stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(self.stuidTextField.snp.height)
            make.top.equalTo(self.majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(self.majorCom.snp.trailing).offset(0)
        }

        self.genderMale.snp.makeConstraints{ make in
            make.width.equalTo(self.stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(self.stuidTextField.snp.height)
            make.top.equalTo(self.majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(self.majorGlob.snp.trailing).offset(0)
        }

        self.genderFemale.snp.makeConstraints{ make in
            make.width.equalTo(self.stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(self.stuidTextField.snp.height)
            make.top.equalTo(self.majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(self.genderMale.snp.trailing).offset(0)

        }
        // MARK: - 회원가입 버튼
        self.registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.majorCom.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
    }
}

//About keyboard action
extension SignUpView{
    func addKeyBoardAnimaion(textField:BindingTextField){
        textField.addTarget(self, action:#selector(setKeyBoardAction), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(removeKeyBoardAction), for: .editingDidEnd)
    }
    
    @objc func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func removeKeyBoardAction(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.containerView.snp.updateConstraints{ make in
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.containerView.snp.updateConstraints{ make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            }
        }
    }
}

//About textField delegate
extension SignUpView: UITextFieldDelegate{
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
        if self.signUpViewModel.SignUpCheck(){
            self.registerBtn.backgroundColor = Color.mainColor
            self.registerBtn.isEnabled = true
        }else{
            self.registerBtn.backgroundColor = UIColor.lightGray
            self.registerBtn.isEnabled = false
        }
    }
}

//About Action Binding
extension SignUpView{
    func BindingRequestCodeBtn(){
        self.signUpViewModel.codeRequestListner.binding(successHandler: { response in
            if response.success{
                print("인증번호 전송 성공")
            }
        }, failHandler: { Error in
            print("인증번호 전송 실패 \(Error)")
        }, asyncHandler: {
            let alert = Alert(title: "인증번호 전송", message: "인증번호가 해당 이메일로 전송되었습니다.\n전송된 메일이 스팸함에 있을 수 있습니다.", viewController: self)
            alert.popUpDefaultAlert(action: nil)
        }, endHandler: {
            
        })
    }
    
    func BindingConfirmCodeBtn(){
        self.signUpViewModel.codeConfirmListner.binding(successHandler: { response in
            if response.success{
                let alert = Alert(title: "인증 성공", message: "이메일 인증을 완료했습니다.", viewController: self)
                alert.popUpDefaultAlert(action: nil)
            }
        }, failHandler: { Error in
            print(Error)
        }, asyncHandler: {
            self.indicator.startIndicator()
        }, endHandler: {
            self.indicator.stopIndicator()
        })
    }
    
    func BindingSignUp(){
        self.signUpViewModel.signUpListner.binding(successHandler: { response in
            if response.success {
                let alert = Alert(title: "회원가입성공", message: "확인 버튼을 누르면 로그인 페이지로 이동합니다.", viewController: self)
                alert.popUpDefaultAlert(action: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else{
                let alert = Alert(title: "회원가입실패", message: "\((response.error?.message)!)", viewController: self)
                alert.popUpDefaultAlert(action: nil)
            }
        }, failHandler: { Error in
            print("Fail(\(Error)")
        }, asyncHandler: { [weak self] in
            self?.indicator.startIndicator()
        }, endHandler: { [weak self] in
            self?.indicator.stopIndicator()
        })
    }
}

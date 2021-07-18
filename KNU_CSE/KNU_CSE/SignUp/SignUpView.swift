//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import UIKit
import SnapKit
import M13Checkbox

enum SignUpEnum{
    
}

class SignUpView: UIViewController{
    
    var indicator : IndicatorView!
    
    var signUpViewModel : SignUpViewModel = SignUpViewModel(listener: nil)
    
    var emailTextField: BindingTextField! {
        didSet {
            emailTextField.draw()
            emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
            emailTextField.delegate = self
            emailTextField.bind { [weak self] email in
                self?.signUpViewModel.account.email = email
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
                self.signUpViewModel.getEvent(successHandler: { response in
                    if response.result == 1 {
                        
                    }
                }, failHandler: { Error in
                    print(Error)
                }, asyncHandler: {
                    let alert = Alert(title: "인증번호 전송", message: "인증번호가 해당 이메일로 전송되었습니다.", viewController: self)
                    alert.popUpDefaultAlert(action: nil)
                })
            }
        }
    }
    
    var emailCodeTextField: BindingTextField! {
        didSet {
            emailCodeTextField.draw()
            emailCodeTextField.keyboardType = .numberPad
            emailCodeTextField.placeholder = "인증번호를 입력하세요."
            emailCodeTextField.bind { [weak self] email in
                self?.signUpViewModel.account.email = email
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
            confirmCodeBtn.addAction{
                self.signUpViewModel.getEvent(successHandler: { response in
                    if response.result == 1 {
                        let alert = Alert(title: "인증 성공", message: "이메일 인증을 완료했습니다.", viewController: self)
                        alert.popUpDefaultAlert(action: nil)
                    }
                    self.indicator.stopIndicator()
                }, failHandler: { Error in
                    print(Error)
                }, asyncHandler: {
                    self.indicator.startIndicator()
                })
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            pwTextField.isSecureTextEntry = true
            pwTextField.delegate = self
            pwTextField.textContentType = .password
            pwTextField.draw()
            pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            pwTextField.bind { [weak self] pw in
                self?.signUpViewModel.account.password = pw
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
                self?.signUpViewModel.account.password2 = pw2
            }
        }
    }
    
    var userNameTextField: BindingTextField! {
        didSet {
            userNameTextField.draw()
            userNameTextField.delegate = self
            userNameTextField.bind { [weak self] userName in
                self?.signUpViewModel.account.username = userName
            }
        }
    }
    
    var nickNameTextField: BindingTextField! {
        didSet {
            nickNameTextField.draw()
            nickNameTextField.delegate = self
            nickNameTextField.bind { [weak self] nickName in
                self?.signUpViewModel.account.nickname = nickName
            }
        }
    }
    
    var stuidTextField: BindingTextField! {
        didSet {
            stuidTextField.keyboardType = .numberPad
            stuidTextField.draw()
            stuidTextField.bind { [weak self] student_id in
                self?.signUpViewModel.account.student_id = student_id
            }
        }
    }
    
   
    
    var majorCom : CheckBox!{
        didSet{
            self.view.addSubview(majorCom)
            let checkbox : M13Checkbox = majorCom.checkBox
            majorCom.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.majorGlob.checkBox.checkState == .checked{
                            self.majorGlob.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.major = "심컴"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.major = ""
                        break
                    case .mixed:
                        break
                }
            }
        }
    }
    
    var majorGlob : CheckBox!{
        didSet{
            self.view.addSubview(majorGlob)
            let checkbox : M13Checkbox = majorGlob.checkBox
            majorGlob.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.majorCom.checkBox.checkState == .checked{
                            self.majorCom.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.major = "글솦"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.major = ""
                        break
                    case .mixed:
                        break
                }
            }
        }
    }
    
    var genderMale : CheckBox!{
        didSet{
            self.view.addSubview(genderMale)
            let checkbox : M13Checkbox = genderMale.checkBox
            genderMale.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.genderFemale.checkBox.checkState == .checked{
                            self.genderFemale.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.gender = "남"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.gender = ""
                        break
                    case .mixed:
                        break
                }
            }
        }
    }
    
    var genderFemale : CheckBox!{
        didSet{
            self.view.addSubview(genderFemale)
            let checkbox : M13Checkbox = genderFemale.checkBox
            genderFemale.bind {
                switch checkbox.checkState {
                    case .checked:
                        if self.genderMale.checkBox.checkState == .checked{
                            self.genderMale.checkBox.checkState = .unchecked
                        }
                        self.signUpViewModel.account.gender = "여"
                        break
                    case .unchecked:
                        self.signUpViewModel.account.gender = ""
                        break
                    case .mixed:
                        break
                }
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            registerBtn.backgroundColor = Color.mainColor
            registerBtn.setTitle("회원가입", for: .normal)
            registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            registerBtn.addAction{
                if self.signUpViewModel.SignUpCheck(){
                    self.signUpViewModel.getEvent(successHandler: { response in
                        if response.result == 1 {
                            let alert = Alert(title: "회원가입성공", message: "확인 버튼을 누르면 로그인 페이지로 이동합니다.", viewController: self)
                            alert.popUpDefaultAlert(action: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                        self.indicator.stopIndicator()
                    }, failHandler: { Error in
                        print(Error)
                    }, asyncHandler: {
                        self.indicator.startIndicator()
                    })
                }else{
                    let alert = Alert(title: "회원가입 실패", message: "모든 정보를 입력하지 않았습니다.", viewController: self)
                    alert.popUpDefaultAlert(action: nil)
                }
            }
        }
    }
    
    let emailTitle : SignUpUILabel = SignUpUILabel(text: "이메일")
    let pwTitle : SignUpUILabel = SignUpUILabel(text: "비밀번호")
    let pw2Title : SignUpUILabel = SignUpUILabel(text: "비밀번호 재확인")
    let userNameTitle : SignUpUILabel = SignUpUILabel(text: "이름")
    let nickNameTitle : SignUpUILabel = SignUpUILabel(text: "닉네임")
    let stuidTitle : SignUpUILabel = SignUpUILabel(text: "학번")
    let majorTitle : SignUpUILabel = SignUpUILabel(text: "전공")
    let genderTitle : SignUpUILabel = SignUpUILabel(text: "성별")
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "회원가입"
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        emailTextField = BindingTextField()
        emailCodeTextField = BindingTextField()
        pwTextField = BindingTextField()
        pw2TextField = BindingTextField()
        userNameTextField = BindingTextField()
        nickNameTextField = BindingTextField()
        stuidTextField = BindingTextField()
        
        majorCom = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "심컴")
        majorGlob = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "글솦")
        genderMale = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "남")
        genderFemale = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "여")
        
        sendCodeBtn = UIButton()
        confirmCodeBtn = UIButton()
        registerBtn = UIButton()
        
        indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(emailTextField)
        self.view.addSubview(emailCodeTextField)
        self.view.addSubview(sendCodeBtn)
        
        self.view.addSubview(emailCodeTextField)
        self.view.addSubview(confirmCodeBtn)
        
        self.view.addSubview(pwTextField)
        self.view.addSubview(pw2TextField)
        
        self.view.addSubview(userNameTextField)
        self.view.addSubview(nickNameTextField)
        self.view.addSubview(stuidTextField)
        
        self.view.addSubview(emailTitle)
        self.view.addSubview(pwTitle)
        self.view.addSubview(pw2Title)
        self.view.addSubview(userNameTitle)
        self.view.addSubview(nickNameTitle)
        self.view.addSubview(stuidTitle)
        self.view.addSubview(majorTitle)
        self.view.addSubview(genderTitle)
        
        self.view.addSubview(registerBtn)
    }
    
    func setupConstraints(){
        let title_height = self.view.frame.width * 0.05
        let height = self.view.frame.height * 0.05
        let top_padding = 15
        let title_To_textField_margin = 1
        let left_margin = 30
        let right_margin = -30
        
        // MARK: - Email
        emailTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.6)
            make.left.equalTo(left_margin)
            make.right.equalTo(sendCodeBtn.snp.left).offset(-10)
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        sendCodeBtn.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.2)
            make.left.equalTo(emailTextField.snp.right).offset(10)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - Email code
        emailCodeTextField.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.6)
            make.left.equalTo(left_margin)
            make.right.equalTo(confirmCodeBtn.snp.left).offset(-10)
            make.top.equalTo(emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
        
        confirmCodeBtn.snp.makeConstraints{ make in
            make.width.equalTo(pwTitle).multipliedBy(0.2)
            make.left.equalTo(emailCodeTextField.snp.right).offset(10)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
        
        // MARK: - 비밀번호
        pwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailCodeTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        pwTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pwTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 비밀번호 확인
        pw2Title.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pwTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        pw2TextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pw2Title.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 이름
        userNameTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pw2TextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        userNameTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(userNameTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        
        // MARK: - 닉네임
        nickNameTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(userNameTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        nickNameTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(nickNameTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 학번
        stuidTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(nickNameTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        stuidTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(stuidTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - Checkbox 제목
        majorTitle.snp.makeConstraints{ make in
            make.leading.equalTo(left_margin)
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.5)
            make.top.equalTo(stuidTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        genderTitle.snp.makeConstraints{ make in
            make.leading.equalTo(majorTitle.snp.trailing)
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.5)
            make.top.equalTo(stuidTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        // MARK: - 전공
        majorCom.snp.makeConstraints{ make in
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(stuidTextField.snp.height)
            make.top.equalTo(majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(left_margin)
            
        }
        
        majorGlob.snp.makeConstraints{ make in
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(stuidTextField.snp.height)
            make.top.equalTo(majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(majorCom.snp.trailing).offset(0)
            
        }
        
        genderMale.snp.makeConstraints{ make in
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(stuidTextField.snp.height)
            make.top.equalTo(majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(majorGlob.snp.trailing).offset(0)
            
        }
        
        genderFemale.snp.makeConstraints{ make in
            make.width.equalTo(stuidTextField.snp.width).multipliedBy(0.25)
            make.height.equalTo(stuidTextField.snp.height)
            make.top.equalTo(majorTitle.snp.bottom).offset(title_To_textField_margin)
            make.leading.equalTo(genderMale.snp.trailing).offset(0)
            
        }
        // MARK: - 회원가입 버튼
        registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(majorCom.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
    }
}

extension SignUpView: UITextFieldDelegate{
    
    //touch any space then keyboard shut down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    //if keyboard show up and press return button then keyboard shutdown
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction {(action: UIAction) in closure() }, for: controlEvents)
    }
}

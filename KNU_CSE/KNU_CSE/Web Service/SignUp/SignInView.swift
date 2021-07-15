//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var signInViewModel : SignInViewModel = SignInViewModel(listener: nil)
    
    var emailTextField: BindingTextField! {
        didSet {
            emailTextField.draw()
            emailTextField.bind { [weak self] email in
                self?.signInViewModel.account.email = email
                if email.count < 1 {
                    self?.emailTextField.textFieldBorderSetup(result: .Fail)
                }else{
                    self?.emailTextField.textFieldBorderSetup(result: .Success)
                }
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            pwTextField.isSecureTextEntry = true
            pwTextField.textContentType = .password
            pwTextField.draw()
            pwTextField.bind { [weak self] pw in
                self?.signInViewModel.account.password = pw
                if pw.count < 1 || pw != self?.signInViewModel.account.password2 {
                    self?.pwTextField.textFieldBorderSetup(result: .Fail)
                    self?.pw2TextField.textFieldBorderSetup(result: .Fail)
                }else{
                    self?.pwTextField.textFieldBorderSetup(result: .Success)
                    self?.pw2TextField.textFieldBorderSetup(result: .Success)
                }
            }
        }
    }
    
    var pw2TextField: BindingTextField! {
        didSet {
            pw2TextField.isSecureTextEntry = true
            pw2TextField.textContentType = .password
            pw2TextField.draw()
            pw2TextField.bind { [weak self] pw2 in
                self?.signInViewModel.account.password2 = pw2
                if pw2.count < 1 || pw2 != self?.signInViewModel.account.password {
                    self?.pwTextField.textFieldBorderSetup(result: .Fail)
                    self?.pw2TextField.textFieldBorderSetup(result: .Fail)
                }else{
                    self?.pwTextField.textFieldBorderSetup(result: .Success)
                    self?.pw2TextField.textFieldBorderSetup(result: .Success)
                }
            }
        }
    }
    
    var nameTextField: BindingTextField! {
        didSet {
            nameTextField.draw()
            nameTextField.bind { [weak self] name in
                self?.signInViewModel.account.name = name
                if name.count < 1 {
                    self?.nameTextField.textFieldBorderSetup(result: .Fail)
                }else{
                    self?.nameTextField.textFieldBorderSetup(result: .Success)
                }
            }
        }
    }
    
    var stuidTextField: BindingTextField! {
        didSet {
            stuidTextField.keyboardType = .numberPad
            stuidTextField.draw()
            stuidTextField.bind { [weak self] student_id in
                self?.signInViewModel.account.student_id = student_id
                if student_id.count < 1 {
                    self?.stuidTextField.textFieldBorderSetup(result: .Fail)
                }else{
                    self?.stuidTextField.textFieldBorderSetup(result: .Success)
                }
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            registerBtn.backgroundColor = .systemRed
            registerBtn.setTitle("회원가입", for: .normal)
            registerBtn.addAction{
                self.signInViewModel.getEvent(successHandler: { response in
                    if response.result == 1 {
                        let alert = UIAlertController(title: "회원가입성공", message: "확인 버튼을 누르면 로그인 페이지로 이동합니다.", preferredStyle: .alert)
                        let actionDefault = UIAlertAction(title: "확인", style: .default){ (action) in

                        }
                        alert.addAction(actionDefault)
                        self.present(alert, animated: true, completion: nil)
                    }
                }, failHandler: { Error in
                    print(Error)
                })
            }
        }
    }
    
    let emailTitle : UILabel = UILabel()
    let pwTitle : UILabel = UILabel()
    let pw2Title : UILabel = UILabel()
    let nameTitle : UILabel = UILabel()
    let stuidTitle : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        initUI()
        addView()
        setupConstraints()
        
//        signInViewModel.bind { [weak self] account in
//
//        }
    }
    
    func addView(){
        self.view.addSubview(emailTextField)
        self.view.addSubview(pwTextField)
        self.view.addSubview(pw2TextField)
        self.view.addSubview(nameTextField)
        self.view.addSubview(stuidTextField)
        
        self.view.addSubview(emailTitle)
        self.view.addSubview(pwTitle)
        self.view.addSubview(pw2Title)
        self.view.addSubview(nameTitle)
        self.view.addSubview(stuidTitle)
        
        self.view.addSubview(registerBtn)
    }
    
    func initUI(){
        emailTextField = BindingTextField()
        pwTextField = BindingTextField()
        pw2TextField = BindingTextField()
        nameTextField = BindingTextField()
        stuidTextField = BindingTextField()
        registerBtn = UIButton()
    }
    func setupTitle(){
        emailTitle.text = "Email"
        pwTitle.text = "비밀번호"
        pw2Title.text = "비밀번호 확인"
        nameTitle.text = "이름"
        stuidTitle.text = "학번"
    }
    
    func setupConstraints(){
        let title_height = 30
        let height = 40
        let top_padding = 20
        let title_To_textField_margin = 3
        let left_margin = 30
        let right_margin = -30
        
        // MARK: - Email
        emailTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(150)
            make.height.equalTo(title_height)
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 비밀번호
        pwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(emailTextField.snp.bottom).offset(top_padding)
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
        nameTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pw2TextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        nameTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(nameTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 학번
        stuidTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(nameTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(title_height)
        }
        
        stuidTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(stuidTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }
        
        // MARK: - 회원가입 버튼
        registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(stuidTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction {(action: UIAction) in closure() }, for: controlEvents)
    }
}

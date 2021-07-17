//
//  ViewController.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import UIKit
import SnapKit
import M13Checkbox

class ViewController: UIViewController {
    
    var signInViewModel : SignInViewModel = SignInViewModel(listener: nil)
    
    var accountUI : UIView! {
        didSet{
            accountUI.layer.borderWidth = 1
            accountUI.layer.borderColor = Color.mainColor.cgColor
        }
    }
    
    var emailTextField: BindingTextField! {
        didSet {
            emailTextField.prefixDraw(text: "이메일", on: .left)
            emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
            emailTextField.backgroundColor = .white
            emailTextField.bind { [weak self] email in
                self?.signInViewModel.account.email = email
            }
        }
    }
    
    var pwTextField: BindingTextField! {
        didSet {
            pwTextField.isSecureTextEntry = true
            pwTextField.backgroundColor = .white
            pwTextField.setupUpperBorder()
            pwTextField.prefixDraw(text: "비밀번호", on: .left)
            pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray,width: 30,height: 25)
            pwTextField.bind { [weak self] pw in
                self?.signInViewModel.account.password = pw
            }
        }
    }
    
    var signInBtn : UIButton! {
        didSet{
            signInBtn.backgroundColor = Color.subColor
            signInBtn.setTitle("로그인", for: .normal)
            signInBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            signInBtn.addAction{
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
    
    var signUpBtn : UIButton! {
        didSet{
            signUpBtn.backgroundColor = Color.subColor
            signUpBtn.setTitle("회원가입", for: .normal)
            signUpBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            signUpBtn.addAction{
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView")
                self.navigationController?.pushViewController(pushVC!, animated: true)
                self.navigationController?.navigationBar.isHidden = false
            }
        }
    }
    
    var autoSignInBox : CheckBox!{
        didSet{
            let checkbox : M13Checkbox = autoSignInBox.checkBox
            autoSignInBox.setColor(tintColor: .white, textColor: .white)
            autoSignInBox.bind {
                switch checkbox.checkState {
                    case .checked:
                      
                        break
                    case .unchecked:

                        break
                    case .mixed:
                        break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.mainColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func addView(){
        accountUI.addSubview(emailTextField)
        accountUI.addSubview(pwTextField)
        
        self.view.addSubview(accountUI)
        self.view.addSubview(pwTextField)
        self.view.addSubview(signInBtn)
        self.view.addSubview(signUpBtn)
        self.view.addSubview(autoSignInBox)
    }
    
    func initUI(){
        self.view.backgroundColor = Color.mainColor
        
        accountUI = UIView()
        emailTextField = BindingTextField()
        pwTextField = BindingTextField()
        signInBtn = UIButton()
        signUpBtn = UIButton()
        autoSignInBox = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "자동로그인")
    }
    
    func setupConstraints(){
        let title_height = 200
        let height = 40
        let top_padding = 20
        let left_margin = 30
        let right_margin = -30
        
        accountUI.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.view).offset(title_height)
            make.height.equalTo(height * 2)
        }
        // MARK: - Email

        emailTextField.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(1)
            make.left.equalToSuperview().offset(0)
            make.right.equalTo(0)
            make.top.equalToSuperview()
            make.height.equalTo(height).multipliedBy(2)
        }
        
        // MARK: - 비밀번호
        pwTextField.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.top.equalTo(emailTextField.snp.bottom).offset(0)
            make.height.equalTo(height).multipliedBy(2)
        }
        
        // MARK: - 로그인 버튼
        signInBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(pwTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
        
        // MARK: - 회원가입 버튼
        signUpBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(signInBtn.snp.bottom).offset(Double(top_padding) * 0.5)
            make.height.equalTo(height)
        }
        
        // MARK: - 자동로그인 버튼
        autoSignInBox.snp.makeConstraints{ make in
            make.width.equalTo(signUpBtn.snp.width).multipliedBy(0.25)
            make.height.equalTo(signUpBtn.snp.height)
            make.top.equalTo(signUpBtn.snp.bottom).offset(top_padding)
            make.trailing.equalTo(right_margin)
        }
    }
    
}

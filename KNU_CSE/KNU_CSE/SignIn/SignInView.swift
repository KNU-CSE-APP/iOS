//
//  ViewController.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import UIKit
import SnapKit
import M13Checkbox

class ViewController: UIViewController, ViewProtocol{
    
    var signInViewModel : SignInViewModel = SignInViewModel()
    
    lazy var accountUI:UIView = {
        let accountUI = UIView()
        accountUI.layer.borderWidth = 1
        accountUI.layer.borderColor = Color.mainColor.cgColor
        return accountUI
    }()
    
    lazy var emailTextField:BindingTextField = {
        let emailTextField = BindingTextField()
        emailTextField.delegate = self
        emailTextField.prefixDraw(text: "이메일", on: .left)
        emailTextField.setUpText(text: "@knu.ac.kr", on: .right, color: .black)
        emailTextField.backgroundColor = .white
        emailTextField.bind { [weak self] email in
            self?.signInViewModel.account.email = email + "@knu.ac.kr"
        }
        return emailTextField
    }()
    
    lazy var pwTextField:BindingTextField = {
        var pwTextField = BindingTextField()
        pwTextField.delegate = self
        pwTextField.isSecureTextEntry = true
        pwTextField.backgroundColor = .white
        pwTextField.setupUpperBorder()
        pwTextField.prefixDraw(text: "비밀번호", on: .left)
        pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray,width: 30,height: 25)
        pwTextField.bind { [weak self] pw in
            self?.signInViewModel.account.password = pw
        }
        return pwTextField
    }()
    
    lazy var signInBtn:UIButton = {
        let signInBtn = UIButton()
        signInBtn.backgroundColor = Color.subColor
        signInBtn.setTitle("로그인", for: .normal)
        signInBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        signInBtn.addAction{ [weak self] in
            guard let check = self?.signInViewModel.SignInCheck() else{
                return
            }
            if check{
                self?.signInViewModel.SignInRequest()
            }else {
                let alert = Alert(title: "로그인 실패", message: "아이디와 비밀번호를 입력하세요.", viewController: self!)
                alert.popUpDefaultAlert(action: nil)
            }
        }
        return signInBtn
    }()
    
    lazy var findPwBtn:UIButton = {
        let findPwBtn = UIButton()
        findPwBtn.backgroundColor = .clear
        findPwBtn.setTitle("비밀번호 찾기", for: .normal)
        findPwBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        findPwBtn.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        findPwBtn.addAction{ [weak self] in
            self?.pushView(identifier: "FindPwView", typeOfVC: FindPwView.self)
        }
        return findPwBtn
    }()
    
    lazy var signUpBtn:UIButton = {
        let signUpBtn = UIButton()
        signUpBtn.backgroundColor = .clear
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        signUpBtn.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        signUpBtn.addAction{ [weak self] in
            self?.pushView(identifier: "SignUpView", typeOfVC: SignUpView.self)
        }
        return signUpBtn
    }()
    
    lazy var autoSignInBox:CheckBox = {
        autoSignInBox = CheckBox(width: self.view.frame.height * 0.1, height: self.view.frame.height * 0.05, text : "자동로그인")
        let checkbox : M13Checkbox = autoSignInBox.checkBox
        autoSignInBox.setColor(tintColor: .white, textColor: .white)
        autoSignInBox.setChecked(checkState: UserDefaults.standard.bool(forKey: "checkState"))
        autoSignInBox.bind {
            switch checkbox.checkState {
                case .checked:
                    UserDefaults.standard.setValue(true, forKey: "checkState")
                    break
                case .unchecked:
                    UserDefaults.standard.setValue(false, forKey: "checkState")
                    break
                case .mixed:
                    break
            }
        }
        return autoSignInBox
    }()
    
    lazy var indicator:IndicatorView = {
        let indicator = IndicatorView(viewController: self)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setSignInAction()
        self.checkKeyChain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func initUI(){
        self.view.backgroundColor = Color.mainColor
    }
    
    func addView(){
        self.accountUI.addSubview(self.emailTextField)
        self.accountUI.addSubview(self.pwTextField)
        _ = [self.accountUI, self.pwTextField, self.signInBtn, self.findPwBtn, self.signUpBtn, self.autoSignInBox].map{
            self.view.addSubview($0)
        }
    }
    
    func setUpConstraints(){
        let title_height:CGFloat = 200
        let height:CGFloat = 40
        let top_padding:CGFloat = 20
        let left_margin:CGFloat = 30
        let right_margin:CGFloat = -30
        let btn_height:CGFloat = height * 0.8
            
        self.accountUI.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.view).offset(title_height)
            make.height.equalTo(height * 2)
        }
        // MARK: - Email

        self.emailTextField.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(1)
            make.left.equalToSuperview().offset(0)
            make.right.equalTo(0)
            make.top.equalToSuperview()
            make.height.equalTo(height).multipliedBy(2)
        }
        
        // MARK: - 비밀번호
        self.pwTextField.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(left_margin)
            make.right.equalToSuperview().offset(right_margin)
            make.top.equalTo(self.emailTextField.snp.bottom).offset(0)
            make.height.equalTo(height).multipliedBy(2)
        }
        
        // MARK: - 로그인 버튼
        self.signInBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pwTextField.snp.bottom).offset(top_padding)
            make.height.equalTo(height)
        }
        
        // MARK: - 자동로그인 버튼
        self.autoSignInBox.snp.makeConstraints{ make in
            make.width.equalTo(self.signUpBtn.snp.width).multipliedBy(0.25)
            make.height.equalTo(height)
            make.top.equalTo(self.signInBtn.snp.bottom).offset(top_padding*0.5)
            make.trailing.equalTo(right_margin)
        }
        
        // MARK: - 비밀번호찾기 버튼
        self.findPwBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.autoSignInBox.snp.bottom).offset(top_padding)
            make.height.equalTo(btn_height)
        }
        
        // MARK: - 회원가입 버튼
        self.signUpBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.findPwBtn.snp.bottom).offset(top_padding*0.5)
            make.height.equalTo(btn_height)
        }
    }
}

extension ViewController{
    func setNavigationView(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.mainColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func pushTabView(){
        let pushVC = (self.storyboard?.instantiateViewController(withIdentifier: "TabView"))!
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func saveKeyChain(){
        if self.autoSignInBox.checkBox.checkState == .checked{
            self.signInViewModel.storeUserAccount()
        }else{
            self.signInViewModel.storeUserEmail()
        }
    }
    
    func checkKeyChain(){
        if self.signInViewModel.checkUserAccount(){
            self.signInViewModel.SignInRequest()
        }
    }
}

extension ViewController: UITextFieldDelegate{

    //touch any space then keyboard shut down
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    //if keyboard show up and press return button then keyboard shutdown
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController{
    func setSignInAction(){
        self.signInViewModel.signInListener.binding(successHandler: { response in
            if response.success {
                self.pushTabView()
                self.saveKeyChain()
            } else{
                Alert(title: "로그인 실패", message: "\((response.error?.message)!)", viewController: self).popUpDefaultAlert(action: nil)
            }
        }, failHandler: { Error in
            let alert = Alert(title: "로그인 실패", message: "네트워크 상태를 확인하세요", viewController: self)
            alert.popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            self.indicator.startIndicator()
        }, endHandler: {
            self.indicator.stopIndicator()
        })
    }
}

//
//  EditPwView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//


import UIKit

class EditPwView:UIViewController,ViewProtocol{
    
    var indicator : IndicatorView!
    
    var editPwViewModel : EditPwViewModel = EditPwViewModel()
    
    let containerView = UIView()
    var pwTextField: BindingTextField! {
        didSet {
            self.pwTextField.isSecureTextEntry = true
            self.pwTextField.delegate = self
            self.pwTextField.textContentType = .password
            self.pwTextField.draw()
            self.pwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            self.pwTextField.bind { [weak self] changePassword in
                self?.editPwViewModel.model.changePassword = changePassword
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
            self.pw2TextField.bind { [weak self] changePassword2 in
                self?.editPwViewModel.model.changePassword2 = changePassword2
                self?.checkChangeValue()
            }
        }
    }
    
    var currentPwTextField: BindingTextField! {
        didSet {
            self.currentPwTextField.isSecureTextEntry = true
            self.currentPwTextField.delegate = self
            self.currentPwTextField.textContentType = .password
            self.currentPwTextField.draw()
            self.currentPwTextField.setUpImage(imageName: "eye.fill", on: .right, color: UIColor.darkGray, width:40, height: 40)
            self.currentPwTextField.bind { [weak self] currentPassword in
                self?.editPwViewModel.model.currentPassword = currentPassword
                self?.checkChangeValue()
            }
        }
    }
    
    var registerBtn : UIButton! {
        didSet{
            self.registerBtn.backgroundColor = UIColor.lightGray
            self.registerBtn.setTitle("비밀번호 변경", for: .normal)
            self.registerBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
            self.registerBtn.layer.cornerRadius = 5
        }
    }
    
    let pwTitle : SignUpUILabel = SignUpUILabel(text: "새 비밀번호")
    let pwCautionTitle : SignUpUILabel = SignUpUILabel(text: "영어,숫자를 조합한 8~20자",alignment: .right, color: UIColor.lightGray)
    let pw2Title : SignUpUILabel = SignUpUILabel(text: "새 비밀번호 확인")
    let currrentPwTitle : SignUpUILabel = SignUpUILabel(text: "현재 비밀번호")
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title:"비밀번호 변경")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BindingEditPw()
        
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        self.pwTextField = BindingTextField()
        self.pw2TextField = BindingTextField()
        self.currentPwTextField = BindingTextField()
        self.registerBtn = UIButton()
        self.indicator = IndicatorView(viewController: self)
    }
    
    func addView(){
        self.view.addSubview(containerView)
        _ =  [self.pwTextField,self.pw2TextField,self.pwTitle,self.pwCautionTitle,self.pw2Title,self.currentPwTextField,self.currrentPwTitle,self.registerBtn].map{
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
            make.width.equalTo(100)
            make.top.equalTo(self.containerView.snp.top).offset(top_padding+10)
            make.height.equalTo(title_height)
        }
        
        self.pwCautionTitle.snp.makeConstraints{ make in
            make.left.equalTo(self.pwTitle.snp.right)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.containerView.snp.top).offset(top_padding+10)
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
        
        // MARK: - 현재 비밀번호
        self.currrentPwTitle.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.pw2TextField.snp.bottom).offset(top_padding*2)
            make.height.equalTo(title_height)
        }

        self.currentPwTextField.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.currrentPwTitle.snp.bottom).offset(title_To_textField_margin)
            make.height.equalTo(height)
        }

        // MARK: - 회원가입 버튼
        self.registerBtn.snp.makeConstraints{ make in
            make.left.equalTo(left_margin)
            make.right.equalTo(right_margin)
            make.top.equalTo(self.currentPwTextField.snp.bottom).offset(top_padding)
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
        if self.editPwViewModel.PwCheck(){
            self.addBtnAction()
        }else{
            self.removeBtnAction()
        }
    }
    
    func addBtnAction(){
        registerBtn.backgroundColor = Color.mainColor
        registerBtn.addAction{
            self.editPwViewModel.EditPw()
        }
    }
    
    func removeBtnAction(){
        registerBtn.backgroundColor = UIColor.lightGray
        registerBtn.removeTarget(nil, action: nil, for: .allEvents)
    }
}

extension EditPwView{
    func BindingEditPw(){
        self.editPwViewModel.editPwListener.binding(successHandler: { response in
            if response.success{
                Alert(title: "비밀번호 변경 성공", message: "비밀번호 변경에 성공했습니다.\n새로운 비밀번호로 로그인해주세요.", viewController: self).popUpDefaultAlert(action:{ action in
                    self.popTwiceView()
                    self.logOut()
                })
            }else{
                Alert(title: "비밀번호 변경 실패", message: response.error!.message, viewController: self).popUpDefaultAlert(action:nil)
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
}

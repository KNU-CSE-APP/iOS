//
//  BoardWriteView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit
import BTNavigationDropdownMenu

class BoardWriteView:UIViewController, ViewProtocol{
    
    var scrollView:UIScrollView!{
        didSet{
            scrollView.alwaysBounceVertical = true
        }
    }
    
    var textFieldHeight:CGFloat!
    var titleField:UITextField!{
        didSet{
            self.titleField.placeholder = "제목을 입력하세요."
            self.titleField.delegate = self
            self.titleField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            self.titleField.addTarget(self, action: #selector(setRightItemColor), for: .editingChanged)
            if let font = self.titleField.font {
                self.textFieldHeight = font.lineHeight + 20
            }
        }
    }
    
    var borderLine:UIView!{
        didSet{
            self.borderLine.layer.borderWidth = 0.3
            self.borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var categoryLabel:UILabel!{
        didSet{
            self.categoryLabel.text = "추천 카테고리"
        }
    }
    
    var contentField:UITextView!{
        didSet{
            self.contentField.delegate = self
            self.contentField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            self.contentField.isScrollEnabled = false
        }
    }
    
    let placeHolderText = "내용을 입력하세요."
    var contentPlaceHolder:UILabel!{
        didSet{
            self.contentPlaceHolder.text = self.placeHolderText
            self.contentPlaceHolder.font = self.contentField.font
            self.contentPlaceHolder.textColor = UIColor.lightGray.withAlphaComponent(0.75)
            self.contentPlaceHolder.isHidden = !self.contentField.text.isEmpty
        }
    }
    
    var contentCheck:Bool = false
    var rightItemButton:UIBarButtonItem!{
        didSet{
            self.rightItemButton.title = "작성"
            self.rightItemButton.style = .plain
            self.rightItemButton.tintColor = .white.withAlphaComponent(0.7)
            self.rightItemButton.target = self
            self.rightItemButton.action = #selector(addTapped)
            self.navigationItem.rightBarButtonItem = self.rightItemButton
        }
    }
    
    let menu:[String] = ["잡담하기", "정보구하기", "팀원 구하기"]
    var navigatiopDropDown:BTNavigationDropdownMenu!{
        didSet{
            self.navigatiopDropDown.menuTitleColor = .white
            
            //cell detail setting
            self.navigatiopDropDown.cellHeight = 40
            self.navigatiopDropDown.cellBackgroundColor = Color.mainColor
            self.navigatiopDropDown.cellSelectionColor = Color.mainColor.withAlphaComponent(0.5)
            self.navigatiopDropDown.cellTextLabelFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.navigatiopDropDown.cellTextLabelColor = UIColor.white
            self.navigatiopDropDown.cellTextLabelAlignment = .center
            self.navigatiopDropDown.cellSeparatorColor = .white
            
            self.navigatiopDropDown.animationDuration = 0.5
            
            //if dropdown show then setup backgroundcolor
            self.navigatiopDropDown.maskBackgroundOpacity = 0.1
            self.navigatiopDropDown.maskBackgroundColor = .black
            
            self.navigationItem.titleView = self.navigatiopDropDown
            self.navigatiopDropDown.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                    print("Did select item at index: \(indexPath)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "게시물 작성")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
    }
    
    
    func initUI() {
        self.scrollView = UIScrollView()
        self.titleField = UITextField()
        self.borderLine = UIView()
        
        self.categoryLabel = UILabel()
      
        
        self.contentField = UITextView()
        self.contentPlaceHolder = UILabel()
        self.rightItemButton = UIBarButtonItem()
        self.navigatiopDropDown = BTNavigationDropdownMenu(title: "카테고리를 설정해주세요.", items: self.menu)
    }
    
    func addView() {
        self.view.addSubview(scrollView)
        _ = [self.titleField, self.borderLine, self.contentField, self.contentPlaceHolder, self.categoryLabel].map{
            self.scrollView.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        let left_margin = 20
        let right_margin = -20
        let padding = 5
        let category_height = 55
        
        self.scrollView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.titleField.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin+padding)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.height.equalTo(textFieldHeight)
        }
        
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalTo(self.titleField.snp.bottom).offset(5)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.height.equalTo(0.3)
        }
        
        self.contentField.snp.makeConstraints{ make in
            make.top.equalTo(self.borderLine.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.bottom.equalToSuperview()
        }
        
        self.contentPlaceHolder.snp.makeConstraints{ make in
            make.top.equalTo(self.contentField.snp.top)
            make.left.equalToSuperview().offset(left_margin+padding)
            make.right.equalToSuperview().offset(right_margin)
            make.height.equalTo(contentField.snp.height)
        }
    }
    
    
}

extension BoardWriteView{
    func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.scrollView.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height+self.view.safeAreaInsets.bottom-20)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.scrollView.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    @objc func addTapped(){
        if contentCheck{
            print("ok")
        }
    }
}

extension BoardWriteView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.contentPlaceHolder.isHidden = !textView.text.isEmpty
        self.setRightItemColor()
    }
    
    @objc func popView(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension BoardWriteView:UITextFieldDelegate{
    //if return key press then keyboard shut down
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func setRightItemColor(){
        if titleField.text != "" && contentField.text != ""{
            self.contentCheck = true
            rightItemButton.tintColor = .white
        }else{
            self.contentCheck = false
            rightItemButton.tintColor = .white.withAlphaComponent(0.7)
        }
    }
}


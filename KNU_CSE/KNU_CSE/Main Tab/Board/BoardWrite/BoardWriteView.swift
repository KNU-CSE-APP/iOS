//
//  BoardWriteView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit
import BTNavigationDropdownMenu

class BoardWriteView:UIViewController, ViewProtocol{
    
    let categoryTitle:[String] = ["잡담하기", "정보", "팀원 구하기", "수업", "팀원 구하기", "팀원 구하기", "팀원 구하기", "팀원 구하기", "팀원 구하기"]
    
    var scrollView:UIScrollView!{
        didSet{
            scrollView.alwaysBounceVertical = true
        }
    }
    
    var textFieldHeight:CGFloat!
    var titleField:UITextField!{
        didSet{
            titleField.placeholder = "제목을 입력하세요."
            titleField.delegate = self
            titleField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleField.addTarget(self, action: #selector(setRightItemColor), for: .editingChanged)
            if let font = titleField.font {
                self.textFieldHeight = font.lineHeight + 20
            }
        }
    }
    
    var borderLine:UIView!{
        didSet{
            borderLine.layer.borderWidth = 0.3
            borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var categoryLabel:UILabel!{
        didSet{
            categoryLabel.text = "추천 카테고리"
        }
    }
    
    var categoryScroll:UIScrollView!{
        didSet{
            categoryScroll.alwaysBounceHorizontal = true
        }
    }
    
    var categoryStack:UIStackView!{
        didSet{
            categoryStack.axis = .horizontal
            categoryStack.distribution = .equalSpacing
            categoryStack.spacing = 10
            self.addStackView()
        }
    }
    
    var contentField:UITextView!{
        didSet{
            contentField.delegate = self
            contentField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            contentField.isScrollEnabled = false
        }
    }
    
    let placeHolderText = "내용을 입력하세요."
    var contentPlaceHolder:UILabel!{
        didSet{
            contentPlaceHolder.text = placeHolderText
            contentPlaceHolder.font = contentField.font
            contentPlaceHolder.textColor = UIColor.lightGray.withAlphaComponent(0.75)
            contentPlaceHolder.isHidden = !contentField.text.isEmpty
        }
    }
    
    var contentCheck:Bool = false
    var rightItemButton:UIBarButtonItem!{
        didSet{
            rightItemButton.title = "작성"
            rightItemButton.style = .plain
            rightItemButton.tintColor = .white.withAlphaComponent(0.7)
            rightItemButton.target = self
            rightItemButton.action = #selector(addTapped)
            self.navigationItem.rightBarButtonItem = rightItemButton
        }
    }
    
    let menu:[String] = ["잡담하기", "정보구하기", "팀원 구하기"]
    var navigatiopDropDown:BTNavigationDropdownMenu!{
        didSet{
            navigatiopDropDown.menuTitleColor = .white
            
            //cell detail setting
            navigatiopDropDown.cellHeight = 40
            navigatiopDropDown.cellBackgroundColor = Color.mainColor
            navigatiopDropDown.cellSelectionColor = Color.mainColor.withAlphaComponent(0.5)
            navigatiopDropDown.cellTextLabelFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
            navigatiopDropDown.cellTextLabelColor = UIColor.white
            navigatiopDropDown.cellTextLabelAlignment = .center
            navigatiopDropDown.cellSeparatorColor = .white
            
            navigatiopDropDown.animationDuration = 0.5
            
            //if dropdown show then setup backgroundcolor
            navigatiopDropDown.maskBackgroundOpacity = 0.1
            navigatiopDropDown.maskBackgroundColor = .black
            
            self.navigationItem.titleView = navigatiopDropDown
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
        self.categoryScroll = UIScrollView()
        self.categoryStack = UIStackView()
        
        self.contentField = UITextView()
        self.contentPlaceHolder = UILabel()
        self.rightItemButton = UIBarButtonItem()
        self.navigatiopDropDown = BTNavigationDropdownMenu(title: "카테고리를 설정해주세요.", items: self.menu)
    }
    
    func addView() {
        self.view.addSubview(scrollView)
        _ = [titleField, borderLine, contentField, contentPlaceHolder, categoryLabel, categoryScroll].map{
            self.scrollView.addSubview($0)
        }
        self.categoryScroll.addSubview(categoryStack)
    }
    
    func setUpConstraints() {
        let left_margin = 20
        let right_margin = -20
        let padding = 5
        let category_height = 50
        
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
        
        self.categoryScroll.snp.makeConstraints{ make in
            make.top.equalTo(self.borderLine.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.height.equalTo(category_height)
        }
        
        self.categoryStack.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.contentField.snp.makeConstraints{ make in
            make.top.equalTo(self.categoryScroll.snp.bottom).offset(10)
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


extension BoardWriteView{
    func addStackView(){
        for i in 0..<categoryTitle.count{
            self.categoryStack.addArrangedSubview(addingCustomButton(buttonTitle: categoryTitle[i], buttonFontSize: 15, buttonCount: 1))
        }
    }
    
    func addingCustomButton(buttonTitle : String, buttonFontSize: CGFloat, buttonCount : Int) -> UIButton
    {
        let ownButton = UIButton()
        ownButton.setTitle(buttonTitle, for: UIControl.State.normal)
        ownButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        ownButton.backgroundColor = .white
        ownButton.setTitleColor(UIColor.black, for: .normal)
        ownButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        ownButton.addTarget(self, action: #selector(ownButtonAction), for: .touchUpInside)
        ownButton.layer.borderWidth = 0.5
        ownButton.layer.borderColor = UIColor.lightGray.cgColor
        ownButton.layer.cornerRadius = 10
        
        let buttonTitleSize = (buttonTitle as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: buttonFontSize + 1)])

        let height = buttonTitleSize.height * 1.5
        let width = buttonTitleSize.width + 20
        ownButton.snp.makeConstraints{ make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        return ownButton
    }

    @objc func ownButtonAction(sender: UIButton)
    {
        print("\n\n Title  \(sender.titleLabel?.text)")
    }
}
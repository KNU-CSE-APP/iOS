//
//  BoardWriteView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit
import BTNavigationDropdownMenu

class BoardWriteView:UIViewController, ViewProtocol{
    
    var boardWriteViewModel:BoardWriteViewModel = BoardWriteViewModel()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    var textFieldHeight:CGFloat!
    lazy var titleField:BindingTextField = {
        var titleField = BindingTextField()
        titleField.placeholder = "제목을 입력하세요."
        titleField.delegate = self
        titleField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleField.addTarget(self, action: #selector(setRightItemColor), for: .editingChanged)
        if let font = titleField.font {
            self.textFieldHeight = font.lineHeight + 20
        }
        titleField.bind{ [weak self] title in
            self?.boardWriteViewModel.model.title = title
        }
        return titleField
    }()
    
    lazy var borderLine:UIView = {
        var borderLine = UIView()
        borderLine.layer.borderWidth = 0.3
        borderLine.layer.borderColor = UIColor.lightGray.cgColor
        return borderLine
    }()
    
    lazy var categoryLabel:UILabel = {
        var categoryLabel = UILabel()
        categoryLabel.text = "추천 카테고리"
        return categoryLabel
    }()
    
    lazy var contentField:UITextView = {
        var contentField = UITextView()
        contentField.delegate = self
        contentField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        contentField.isScrollEnabled = false
        return contentField
    }()
    
    let placeHolderText = "내용을 입력하세요."
    lazy var contentPlaceHolder:UILabel = {
        var contentPlaceHolder = UILabel()
        contentPlaceHolder.text = self.placeHolderText
        contentPlaceHolder.font = self.contentField.font
        contentPlaceHolder.textColor = UIColor.lightGray.withAlphaComponent(0.75)
        contentPlaceHolder.isHidden = !self.contentField.text.isEmpty
        return contentPlaceHolder
    }()
    
    var contentCheck:Bool = false
    lazy var rightItemButton:UIBarButtonItem = {
        let rightItemButton = UIBarButtonItem()
        rightItemButton.title = "작성"
        rightItemButton.style = .plain
        rightItemButton.tintColor = .white.withAlphaComponent(0.7)
        rightItemButton.target = self
        rightItemButton.action = #selector(addTapped)
        self.BindingBoardWrite()
        return rightItemButton
    }()
    
    let menu:[String] = ["자유게시판", "질의응답"]
    let menuDict:[String:String] = ["자유게시판":"FREE", "질의응답":"QNA"]
    
    var categoryIndex = -1
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
            self.navigatiopDropDown.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                if let selfVC = self {
                    selfVC.categoryIndex = indexPath
                    selfVC.setRightItemColor()
                    selfVC.boardWriteViewModel.model.category = selfVC.menuDict[selfVC.menu[indexPath]]!
                }
            }
            self.navigationItem.titleView = self.navigatiopDropDown
            self.navigationItem.rightBarButtonItem = rightItemButton
        }
    }
    
    lazy var indicator:IndicatorView = {
        let indicator = IndicatorView(viewController: self)
        return indicator
    }()
    
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
            make.height.equalTo(self.contentField.snp.height)
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
            print(self.boardWriteViewModel.model.category, self.boardWriteViewModel.model.content, self.boardWriteViewModel.model.title)
            self.boardWriteViewModel.BoardWriteRequest()
        }
    }
}

extension BoardWriteView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.contentPlaceHolder.isHidden = !textView.text.isEmpty
        self.setRightItemColor()
        if textView == self.contentField{
            self.boardWriteViewModel.model.content = textView.text
        }
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
        if self.titleField.text != "" && self.contentField.text != "" && self.categoryIndex != -1{
            self.contentCheck = true
            rightItemButton.tintColor = .white
        }else{
            self.contentCheck = false
            rightItemButton.tintColor = .white.withAlphaComponent(0.7)
        }
    }
}

extension BoardWriteView{
    func BindingBoardWrite(){
        self.boardWriteViewModel.Listener.binding(successHandler: { response in
            if response.success{
                self.navigationController?.popViewController(animated: true)
            }else{
                Alert(title: "작성 실패", message: "게시물 작성에 실패했습니다.", viewController: self).popUpDefaultAlert(action: nil)
            }
        }, failHandler: {_ in
            Alert(title: "작성 실패", message: "네트워크 상태를 확인하세요.", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            self.indicator.startIndicator()
        }, endHandler: {
            self.indicator.stopIndicator()
        })
    }
}


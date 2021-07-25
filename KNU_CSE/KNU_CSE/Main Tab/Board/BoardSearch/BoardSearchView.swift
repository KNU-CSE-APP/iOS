//
//  BoarcSearchView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit

class BoardSearchView:UIViewController, ViewProtocol{
    
    var scrollView:UIScrollView!{
        didSet{
            scrollView.alwaysBounceVertical = true
        }
    }
    
    var textFieldHeight:CGFloat!
    var titleField:UITextField!{
        didSet{
            if let font = titleField.font {
                self.textFieldHeight = font.lineHeight + 16
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.textFieldHeight, height: self.textFieldHeight))
            let imageView = UIImageView()
            let image = UIImage(systemName: "magnifyingglass")?.resized(toWidth: self.textFieldHeight*0.6)
            
            titleField.placeholder = "검색어를 입력하세요."
            titleField.delegate = self
            titleField.addTarget(self, action: #selector(removeKeyBoardAction), for: .editingDidEnd)
            titleField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            titleField.backgroundColor = .white.withAlphaComponent(0.4)
            titleField.layer.cornerRadius = 10
            titleField.textColor = .white
            
            imageView.frame = CGRect(x: self.textFieldHeight*0.2, y: self.textFieldHeight*0.2, width: self.textFieldHeight*0.6, height: self.textFieldHeight*0.6)
            
            imageView.image = image?.withTintColor(.white)
            view.addSubview(imageView)
            
            titleField.enablesReturnKeyAutomatically = true // textfield에 text가 있을 때 return key 활성화
            
            titleField.leftView = view
            titleField.leftViewMode = .always
            titleField.returnKeyType = .search
            self.navigationItem.titleView = titleField
        }
    }
    
    var contentCheck:Bool = false
    var rightItemButton:UIBarButtonItem!{
        didSet{
            rightItemButton.title = "취소"
            rightItemButton.style = .plain
            rightItemButton.tintColor = .white
            rightItemButton.target = self
            rightItemButton.action = #selector(removeBoardView)
            self.navigationItem.rightBarButtonItem = rightItemButton
        }
    }
    
    var BoardVC : FreeBoardView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideBackBtnTitle()
        self.setNavigationTitle(title: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI() {
        self.scrollView = UIScrollView()
        self.titleField = UITextField()
        self.rightItemButton = UIBarButtonItem()
        self.BoardVC = storyboard?.instantiateViewController(withIdentifier: "FreeBoardView") as? FreeBoardView
    }
    
    func addView() {
        
    }
    
    func setUpConstraints() {
        self.titleField.snp.makeConstraints{ make in
            make.width.equalTo(250)
            make.height.equalTo(textFieldHeight)
        }
    }
}

extension BoardSearchView{
    
    func addBoardView(){
        self.addChild(BoardVC)
        self.view.addSubview(BoardVC.view)
        BoardVC.didMove(toParent: self)
        BoardVC.view.backgroundColor = .yellow
        BoardVC.view.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func removeBoardView(){
        BoardVC.willMove(toParent: nil)
        BoardVC.view.removeFromSuperview()
        BoardVC.removeFromParent()
        titleField.resignFirstResponder()
    }
    
    @objc func removeKeyBoardAction(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideBackBtnTitle(){
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
    
}

extension BoardSearchView:UITextFieldDelegate{
    //if return key press then keyboard shut down
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .search{
            textField.resignFirstResponder()
            self.addBoardView()
        }
        return true
    }
    
    func addSearchButtonOnKeyBoard(){
        let searchBtn:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        searchBtn.barStyle = .default
    }
}
 

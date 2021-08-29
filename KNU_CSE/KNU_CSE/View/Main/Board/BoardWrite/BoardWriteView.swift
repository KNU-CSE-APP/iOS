//
//  BoardWriteView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit
import BTNavigationDropdownMenu
import PhotosUI

class BoardWriteView:UIViewController, ViewProtocol{
    
    var boardWriteViewModel:BoardWriteViewModel = BoardWriteViewModel()
    var editClosure:(()->())?
    var parentType: ParentType!
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.layer.borderWidth = 0.5
        scrollView.layer.borderColor = UIColor.lightGray.cgColor
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
            self?.boardWriteViewModel.model.value.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return titleField
    }()
    
    lazy var borderLine:UIView = {
        var borderLine = UIView()
        borderLine.layer.borderWidth = 0.3
        borderLine.layer.borderColor = UIColor.lightGray.cgColor
        return borderLine
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
        rightItemButton.tintColor = .white.withAlphaComponent(0.5)
        rightItemButton.target = self
        rightItemButton.action = #selector(addTapped)
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
                    selfVC.boardWriteViewModel.model.value.category = selfVC.menuDict[selfVC.menu[indexPath]]!
                }
            }
            
            self.navigationItem.titleView = self.navigatiopDropDown
            self.navigationItem.rightBarButtonItem = rightItemButton
        }
    }
    
    var cellTapped: Bool = false
    lazy var photoView:UICollectionView = {
        var photoView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        photoView.backgroundColor = .white
        photoView.dataSource = self
        photoView.delegate = self
        photoView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        photoView.isHidden = true
        photoView.contentInset = UIEdgeInsets.init(top: 5, left: 10, bottom: -5, right: -10)
        photoView.isMultipleTouchEnabled = false
        
        let layout = photoView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .horizontal
        
        return photoView
    }()
    
    var images: [UIImage] = []{
        didSet{
            self.photoLabel.text = "\(self.images.count)/10"
        }
    }
    var originURLs: [String] = []
    var imageURLs: [String] = []

    lazy var photoBtn:UIButton = {
        var photoBtn = UIButton()
        photoBtn.setImage(UIImage.init(systemName: "photo.on.rectangle.angled"), for: .normal)
        photoBtn.imageView?.tintColor = UIColor.lightGray
        
        photoBtn.addAction {
            self.presentPhotoView()
        }
        
        return photoBtn
    }()
    
    lazy var photoLabel:UILabel! = {
        var photoLabel = UILabel()
        photoLabel.text = "0/10"
        photoLabel.textColor = UIColor.lightGray
        return photoLabel
    }()
    
    lazy var resignBtn:UIButton! = {
        var resignBtn = UIButton()
        resignBtn.isHidden = true
        resignBtn.setImage(UIImage.init(systemName: "keyboard.chevron.compact.down"), for: .normal)
        resignBtn.imageView?.tintColor = UIColor.lightGray
        resignBtn.addAction {
            self.contentField.resignFirstResponder()
        }
        return resignBtn
    }()
    
    lazy var indicator: IndicatorView = {
        let indicator = IndicatorView(viewController: self)
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "게시물 작성")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
        
        self.Binding()
    }
    
    func initUI() {
        self.navigatiopDropDown = BTNavigationDropdownMenu(title: "카테고리를 설정해주세요.", items: self.menu)
    }
    
    deinit {
        print("deinit BoardWriteView")
    }
    
    func addView() {
        self.view.addSubview(scrollView)
        self.view.addSubview(self.photoBtn)
        self.view.addSubview(self.photoLabel)
        self.view.addSubview(self.resignBtn)
        
        _ = [self.titleField, self.borderLine, self.photoView, self.contentField, self.contentPlaceHolder].map{
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
            make.bottom.equalTo(self.photoBtn.snp.top)
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
        
        self.photoView.snp.makeConstraints{ make in
            make.top.equalTo(self.borderLine.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            if self.images.count > 0 {
                self.photoView.isHidden = false
                make.height.equalTo(100)
            }else{
                make.height.equalTo(0)
            }
        }
        
        self.contentField.snp.makeConstraints{ make in
            make.top.equalTo(self.photoView.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(left_margin)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(right_margin)
            make.bottom.equalTo(self.scrollView.snp.bottom).offset(-40)
        }
        
        self.contentPlaceHolder.snp.makeConstraints{ make in
            make.top.equalTo(self.contentField.snp.top)
            make.left.equalToSuperview().offset(left_margin+padding)
            make.right.equalToSuperview().offset(right_margin)
            make.height.equalTo(self.contentField.snp.height)
        }
        
        self.photoBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(5)
        }
        
        self.photoLabel.snp.makeConstraints{ make in
            make.height.width.bottom.equalTo(self.photoBtn)
            make.left.equalTo(self.photoBtn.snp.right).offset(5)
        }
        
        self.resignBtn.snp.makeConstraints{ make in
            make.height.width.bottom.equalTo(self.photoBtn)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
        }
    }
}

extension BoardWriteView: BoardDataforEditDelegate{
    func sendBoard(board: Board?, images: [UIImage]?, imageURLs: [String]?, closure:@escaping ()->()) {
        self.rightItemButton.title = "수정"
        
        if let board = board, let uiImages = images, let imageURLs = imageURLs{
            self.boardWriteViewModel.model.value.title = board.title
            self.boardWriteViewModel.model.value.content = board.content
            self.boardWriteViewModel.model.value.category = menuDict[board.category]!
            self.boardWriteViewModel.boardId = board.boardId
            self.images = uiImages
            self.imageURLs = imageURLs
            self.originURLs = imageURLs
        }
        self.editClosure = closure
    }
}

extension BoardWriteView{
    func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.resignBtn.isHidden = false
            self.photoBtn.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height+self.view.safeAreaInsets.bottom)
            }
            
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.resignBtn.isHidden = true
            self.photoBtn.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    @objc func addTapped(){
        if contentCheck{
            //let model = self.boardWriteViewModel.model.value
            self.boardWriteViewModel.request(parentType: self.parentType)
        }
    }
}

extension BoardWriteView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.contentPlaceHolder.isHidden = !textView.text.isEmpty
        self.setRightItemColor()
        if textView == self.contentField{
            self.boardWriteViewModel.model.value.content = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
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
            self.rightItemButton.tintColor = .white
        }else{
            self.contentCheck = false
            self.rightItemButton.tintColor = .white.withAlphaComponent(0.5)
        }
    }
}

extension BoardWriteView:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else{
            return UICollectionViewCell()
        }
        cell.imageURL = imageURLs[indexPath.row]
        cell.calledType = .boardWrite
        cell.deleteBtn.addAction { [weak self] in
            if (self?.cellTapped) == false{
                for i in (0..<(self?.images.count)!){
                    if cell.imageURL == self?.imageURLs[i]{
                        self?.images.remove(at: i)
                        self?.imageURLs.remove(at: i)
                        self?.boardWriteViewModel.model.value.deleteUrl.append(cell.imageURL)
                        self?.photoView.deleteItems(at: [ IndexPath(row: i, section: 0)])
                        break
                    }
                }
                self?.updatePhotoViewConstraints()
                self?.cellTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self?.cellTapped = false
                }
            }
        }
        
        cell.imageView.addAction { [weak self] in
            if self?.cellTapped == false{
                if let VC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailImageView") as? DetailImageView, let images = self?.images{
                    VC.modalPresentationStyle = .fullScreen
                    self?.present(VC, animated: true)
                    let delegate: ImageDelegate = VC
                    delegate.sendImages(images: images, index: (self?.imageURLs.firstIndex(of: cell.imageURL)!)!)
                }
                self?.cellTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self?.cellTapped = false
                }
            }
        }
        cell.setImage(image: images[indexPath.row])
        
        return cell
    }
}

extension BoardWriteView{
    func presentPhotoView(){
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "PhotoView") as? PhotoView else{
            return
        }
        VC.modalPresentationStyle = .overFullScreen
        VC.isMutltiSelection = true
        VC.setListener{ [weak self] image, url in
            do{
                DispatchQueue.main.async {
                    self?.images.append(image)
                    self?.imageURLs.append(url)
                    self?.boardWriteViewModel.imageData.append(image.jpegData(compressionQuality: 0.4)!)
                    self?.photoView.reloadData()
                }
            }
        }
        
        VC.setInitListener { [weak self] in
            self?.photoView.isHidden = false
            self?.photoView.snp.updateConstraints{ make in
                make.height.equalTo(100)
            }
            self?.boardWriteViewModel.model.value.deleteUrl = (self?.originURLs)!
            self?.images = []
            self?.imageURLs = []
            self?.boardWriteViewModel.imageData = []
        }
        
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    func updatePhotoViewConstraints(){
        self.photoView.snp.removeConstraints()
        self.photoView.snp.makeConstraints{ make in
            make.top.equalTo(self.borderLine.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            if self.images.count > 0 {
                self.photoView.isHidden = false
                make.height.equalTo(100)
            }else{
                make.height.equalTo(0)
            }
        }
    }
}

extension BoardWriteView{
    func Binding(){
        self.BindingBoardWrite()
        self.BindingModel()
        self.BindingBoardEdit()
    }
    
    func BindingModel(){
        if parentType == .Edit{
            self.boardWriteViewModel.model.bind{ [weak self] board in
                self?.titleField.text = board.title
                self?.contentField.text = board.content
                self?.contentPlaceHolder.isHidden = !((self?.contentField.text.isEmpty)!)
                
                if let menuDict = self?.menuDict{
                    for (key, value) in menuDict{
                        if value == board.category, let index =
                            self?.menu.firstIndex(of: key){
                            self?.categoryIndex = index
                            self?.navigatiopDropDown.setSelected(index: index)
                        }
                    }
                }
                self?.setRightItemColor()
            }
        }
    }
    
    func BindingBoardWrite(){
        self.boardWriteViewModel.writeListener.binding(successHandler: { response in
            if response.success{
                self.boardWriteViewModel.shouldbeReload.value = true
                
                //작성하고 pop하기 전에 reload한다. need to code refactoring
                if let parentView = self.getTopViewController() as? TabView, let tabView = parentView.children[2] as? BoardTabView{
                    tabView.BoardVC?.boardViewModel.getBoardsByFirstPage()
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }, failHandler: { Error in
            Alert(title: "작성 실패", message: "네트워크 상태를 확인하세요.", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            self.indicator.startIndicator()
        }, endHandler: {
            self.indicator.stopIndicator()
        })
    }
    
    func BindingBoardEdit(){
        self.boardWriteViewModel.editListener.binding(successHandler: { result in
            if result.success{
                Alert(title: "게시글 수정 성공", message: (result.response)!, viewController: self).popUpDefaultAlert(action: { action in
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                let message = result.response ?? "게시글 수정 실패"
                Alert(title: "게시글 수정 실패", message: message, viewController: self).popUpDefaultAlert(action:nil)
            }
        }, failHandler: { Error in
            Alert(title: "작성 실패", message: "네트워크 상태를 확인하세요.", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            self.indicator.startIndicator()
        }, endHandler: {
            self.indicator.stopIndicator()
        })
    }
}


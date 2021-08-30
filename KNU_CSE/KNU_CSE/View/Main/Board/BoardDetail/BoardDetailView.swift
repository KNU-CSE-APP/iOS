//
//  DetailView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/22.
//

import UIKit

class BoardDetailView:BaseUIViewController, ViewProtocol{
    
    private var boardDetailViewModel = BoardDetailViewModel()
    private var delegate:CommentDataDelegate?

    private let commentPlaceHolder = "댓글을 입력해주세요."
    private var stackViewSize: Int = 0
    
    private let titleHeight:CGFloat = 30
    private var imageSize:CGFloat!
    private var textViewHeight:CGFloat!
    private var textViewPadding:CGFloat = 5
    private var imageWidth:CGFloat!
    
    private lazy var rightBtn:UIBarButtonItem = {
        var rightBtn = UIBarButtonItem(image: UIImage.init(systemName: "ellipsis")?.rotate(radians: .pi/2)?.withTintColor(UIColor.lightGray), style: .plain, target: self, action: #selector(addActionSheet))
        return rightBtn
    }()

    private var scrollView:UIScrollView!{
        didSet{
            self.scrollView.alwaysBounceVertical = true
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            self.scrollView.addGestureRecognizer(tap)
            self.scrollView.showsVerticalScrollIndicator = true
            
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(self.refresh(refresh:)), for: .valueChanged)
            self.scrollView.refreshControl = refresh
        }
    }
    
    private var boardContentView:UIView = UIView()
    
    private var image:UIImage!{
        didSet{
            self.authorImageView.image = self.image
        }
    }
    
    private var authorImageView:UIImageView!{
        didSet{
            self.imageSize = self.authorLabel.font.lineHeight + 10
            self.authorImageView.image = self.image
            self.authorImageView.clipsToBounds = true
            self.authorImageView.contentMode = .scaleAspectFill
            self.authorImageView.layer.borderWidth = 1
            self.authorImageView.layer.borderColor = UIColor.clear.cgColor
            self.authorImageView.layer.cornerRadius = self.imageSize / 4
            self.authorImageView.frame.size = CGSize(width: imageSize, height: imageSize)
            self.authorImageView.tintColor = .lightGray
        }
    }
    
    private var authorLabel:UILabel!{
        didSet{
            self.authorLabel.textAlignment = .left
            self.authorLabel.textColor = UIColor.black
            self.authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.authorLabel.sizeToFit()
        }
    }
    
    private var dateLabel:UILabel!{
        didSet{
            self.dateLabel.textAlignment = .right
            self.dateLabel.textColor = UIColor.black
            self.dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
            self.dateLabel.sizeToFit()
        }
    }
    
    private var titleLabel:UILabel!{
        didSet{
            self.titleLabel.textAlignment = .left
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            self.titleLabel.numberOfLines = 0
            self.titleLabel.sizeToFit()
        }
    }
    
    private var contentLabel:UILabel!{
        didSet{
            self.contentLabel.textAlignment = .left
            self.contentLabel.textColor = UIColor.black
            self.contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .thin)
            self.contentLabel.numberOfLines = 0
        }
    }
    
    private var cellTapped: Bool = false
    
    private var uiImages: [UIImage] = []
    private var photoCells: [ImageView] = []
    
    private lazy var photoScrollView:UIScrollView = {
        var photoScrollView = UIScrollView()
        photoScrollView.alwaysBounceHorizontal = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        photoScrollView.addGestureRecognizer(tap)
        photoScrollView.showsHorizontalScrollIndicator = true
        photoScrollView.addSubview(self.photoView)
        return photoScrollView
    }()
    
    private lazy var photoView:UIStackView = {
        var photoView = UIStackView()
        photoView.axis = .horizontal
        photoView.alignment = .center
        photoView.distribution = .equalSpacing
        photoView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        photoView.isLayoutMarginsRelativeArrangement = true
        photoView.spacing = 8
        return photoView
    }()
    
    private var categoryLabel:UILabel!{
        didSet{
            self.categoryLabel.textAlignment = .center
            self.categoryLabel.textColor = UIColor.lightGray
            self.categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    private var photoImage:UIImageView!{
        didSet{
            photoImage.image = UIImage(systemName: "photo")
            photoImage.tintColor = .lightGray
            photoImage.isHidden = true
        }
    }
    
    private var photoLabel:UILabel!{
        didSet{
            photoLabel.textAlignment = .left
            photoLabel.textColor = UIColor.black
            photoLabel.font = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
            photoLabel.sizeToFit()
            photoLabel.isHidden = true
        }
    }
    
    private var commentImage:UIImageView!{
        didSet{
            let image = UIImage(systemName: "text.bubble.fill")
            self.commentImage.image = image
            self.commentImage.tintColor = .lightGray
        }
    }
    
    private var commentLabel:UILabel!{
        didSet{
            self.commentLabel.textAlignment = .left
            self.commentLabel.textColor = UIColor.black
            self.commentLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
            self.commentLabel.sizeToFit()
        }
    }
    
    private var stackView:CommentView!{
        didSet{
            self.stackView.axis = .vertical
            self.stackView.distribution = .fill
        }
    }
        
    private var textFieldView:UIView!{
        didSet{
            textFieldView.backgroundColor = .white
        }
    }
    
    private var borderLine:UIView!{
        didSet{
            self.borderLine.layer.borderWidth = 0.3
            self.borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    private var textField:UITextView!{
        didSet{
            self.textField.delegate = self
            self.textField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            self.textField.layer.cornerRadius = 10
            self.textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            self.textField.textColor = UIColor.black
            let top_padding:CGFloat = textViewPadding * 2
            let bottom_padding:CGFloat = textViewPadding * 2
            if let font = textField.font {
                self.textViewHeight = font.lineHeight + top_padding + bottom_padding + textViewPadding + textViewPadding
                self.imageWidth = textViewHeight-(textViewPadding*3)
            }
            self.textField.isScrollEnabled = false
            self.textField.textContainerInset = UIEdgeInsets(top: top_padding, left: 10, bottom: bottom_padding, right: imageWidth)
        }
    }

    private var placeholderLabel : UILabel!{
        didSet{
            self.placeholderLabel.text = commentPlaceHolder
            self.placeholderLabel.font = textField.font
            self.placeholderLabel.textColor = UIColor.lightGray
            self.placeholderLabel.isHidden = !textField.text.isEmpty
        }
    }
    
    private var textFieldBtn:UIButton!{
        didSet{
            let image = UIImage(systemName: "paperplane.circle.fill")?.resized(toWidth: imageWidth)
            self.textFieldBtn.setImage(image?.withTintColor(Color.mainColor), for: .normal)
            self.textFieldBtn.tintColor = Color.mainColor
            self.textFieldBtn.setTitleColor(Color.mainColor.withAlphaComponent(0.5), for: .highlighted)
            self.textFieldBtn.addAction {[weak self] in
                self?.boardDetailViewModel.writeCommentRequest()
            }
            self.textFieldBtn.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
        self.textViewBinding()
        
        self.Binding()
        self.boardDetailViewModel.getCommentRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.boardDetailViewModel.getBoardRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DetailViwe \(CFGetRetainCount(self))")
        print("stackView \(CFGetRetainCount(self.stackView))")
        print("photoView \(CFGetRetainCount(self.photoView))")
    }
    
    func initUI(){
        self.scrollView = UIScrollView()
        
        self.authorLabel = UILabel()
        self.authorImageView = UIImageView()
        self.dateLabel = UILabel()
        self.titleLabel = UILabel()
        self.contentLabel = UILabel()
        self.categoryLabel = UILabel()
        self.photoImage = UIImageView()
        self.photoLabel = UILabel()
        self.commentImage = UIImageView()
        self.commentLabel = UILabel()
        
        self.stackView = CommentView(storyboard: self.storyboard, navigationVC: self.navigationController, isHiddenReplyBtn: false)
        
        self.textFieldView = UIView()
        self.borderLine = UIView()
        self.textField = UITextView()
        self.placeholderLabel = UILabel()
        self.textFieldBtn = UIButton()
    }
    
    deinit {
        print("deinit DetailView")
    }
    
    func addView(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(boardContentView)
        _ = [authorLabel,authorImageView, dateLabel, titleLabel, contentLabel, categoryLabel, photoScrollView, photoImage, photoLabel, commentImage, commentLabel, stackView].map { self.boardContentView.addSubview($0)}
        
        self.view.addSubview(textFieldView)
        _ = [borderLine,textField,textFieldBtn].map{
            self.textFieldView.addSubview($0)
        }
        
        self.textField.addSubview(placeholderLabel)
    }
    
    func setUpConstraints(){
        let height = self.view.frame.height * 0.2
        
        self.scrollView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.textFieldView.snp.top)
        }
        
        self.boardContentView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()//필수
        }
        
        self.authorImageView.snp.makeConstraints{ make in
            make.top.equalTo(boardContentView.snp.top).offset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(imageSize)
            make.width.equalTo(imageSize)
        }
        
        self.authorLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(self.authorImageView)
            make.left.equalTo(self.authorImageView.snp.right).offset(4)
        }
        
        self.dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(authorLabel.snp.top)
            make.left.equalTo(self.authorLabel.snp.right)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(height*0.1)
        }
        
        self.titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        self.contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        self.photoScrollView.snp.makeConstraints{make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            if (self.boardDetailViewModel.board.value.images.count) > 0 {
                self.photoView.isHidden = false
                make.height.equalTo(120)
            }else{
                make.height.equalTo(0)
            }
        }
        
        self.photoView.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        self.photoImage.snp.makeConstraints{ make in
            make.top.equalTo(self.photoScrollView.snp.bottom).offset(10)
            make.right.equalTo(photoLabel.snp.left).offset(-5)
            make.height.equalTo(height*0.1)
            make.width.equalTo(height*0.1)
        }

        self.photoLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.photoScrollView.snp.bottom).offset(10)
            make.right.equalTo(commentImage.snp.left).offset(-10)
            make.height.equalTo(height*0.1)
            //make.width.equalTo(height*0.15)
        }
        
        self.commentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.photoScrollView.snp.bottom).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(height*0.1)
            //make.width.equalTo(height*0.1)
        }
        
        self.commentImage.snp.makeConstraints{ make in
            make.top.equalTo(self.commentLabel.snp.top)
            make.right.equalTo(commentLabel.snp.left).offset(-5)
            make.height.equalTo(height*0.1)
            make.width.equalTo(height*0.1)
        }
        
        self.categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.commentLabel.snp.top)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(height*0.1)
        }
        
        self.stackView.snp.makeConstraints{ make in
            make.top.equalTo(commentImage.snp.bottom).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalToSuperview().offset(-5)//아래 여백 주기
        }
        
        self.textFieldView.snp.makeConstraints{ make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(textViewHeight)
        }
        
        // textField 위에 구분선
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(1)
        }
        
        self.textField.snp.makeConstraints{ make in
            make.top.equalTo(self.borderLine.snp.bottom).offset(textViewPadding)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-textViewPadding)
        }
        
        self.placeholderLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        self.textFieldBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.right.equalTo(self.textField.snp.right)
            make.width.equalTo(textViewHeight)
            make.height.equalTo(textViewHeight)
        }
    }
    
    func initRightBtn(){
        if self.boardDetailViewModel.checkNickName(){
            self.navigationItem.rightBarButtonItem = self.rightBtn
        }
    }
    
    @objc func addActionSheet(){
        //기존에 presented된 view가 있다면 닫아준다 UISearchVC가 present되기도 함 따라서 dismiss해줘야헌다.
        if self.presentedViewController != nil {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        var actionSheet = ActionSheet(viewController: self)
        actionSheet.popUpActionSheet(edit_text: "게시글 수정", editAction: { [weak self] action in
            
            self?.pushView(identifier: "BoardWriteView", typeOfVC: BoardWriteView.self){ VC in
                VC.parentType = .Edit
                var delegate: BoardDataforEditDelegate?
                delegate = VC
                delegate?.sendBoard(board: (self?.boardDetailViewModel.board.value), images: (self?.uiImages), imageURLs: self?.boardDetailViewModel.board.value.images){ [weak self] in
                    self?.boardDetailViewModel.getBoardRequest()
                }
            }
        }, remove_text: "게시글 삭제", removeAction:{ [weak self] action in
            Alert(title: "게시글 삭제", message: "게시글을 삭제하시겠습니까?", viewController: self).popUpNormalAlert{ (action) in
                self?.boardDetailViewModel.deleteBoard()
            }
        }, cancel_text: "취소")
    }
}

extension BoardDetailView:BoardDataDelegate, ReplyDataDelegate{
    
    /// BoardView로 부터의 Delegation을 전달받음
    func sendBoardData(board: Board) {
        self.boardDetailViewModel.boardId = board.boardId
    }
    
    func deleteBoard(deleteBoard: @escaping () -> ()) {
        self.boardDetailViewModel.deleteBoardClosure = deleteBoard
    }
    
    func editBoard(editBoard: @escaping () -> ()) {
        self.boardDetailViewModel.editBoardClosure = editBoard
    }
    /// ReplyView로 부터의 Delegation을 전달받음
    /// Reply에서 답글을 작성 후 BoardDetailView로 돌아왔을 때 view를 update
    func sendReply(comment: Comment?) {
        if comment == nil{
            self.boardDetailViewModel.getCommentRequest()
            self.stackView.removeAllToStackView()
            self.stackView.InitToStackView(comments: self.boardDetailViewModel.comments.value, board: self.boardDetailViewModel.board.value)
        }else{
            self.stackView.updateReply(comments: self.boardDetailViewModel.comments.value, target: comment)
        }
    }
}


//about keyboard action, refresh
extension BoardDetailView{
    func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] (keyboardFrame) in
            self?.textFieldView.snp.updateConstraints{ make in
                if let VC = self {
                    make.bottom.equalTo(VC.view.safeAreaLayoutGuide).offset(-keyboardFrame.height+VC.view.safeAreaInsets.bottom)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] (keyboardFrame) in
            self?.textFieldView.snp.updateConstraints{ make in
                if let VC = self{
                    make.bottom.equalTo(VC.view.safeAreaLayoutGuide).offset(0)
                }
            }
        }
    }
    
    @objc func refresh(refresh: UIRefreshControl){
        self.boardDetailViewModel.getCommentRequest()
        self.boardDetailViewModel.getBoardRequest()
        refresh.endRefreshing()
    }
    
}

//textView 관련
extension BoardDetailView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.setPlaceHolder(textView)
        self.boardDetailViewModel.listener!(textView.text)
        self.hideSendBtn(text:textView.text)
    }
    
    func adjustTextViewHeight(textView:UITextView) {
        let fixedWidth = textView.frame.size.width
        
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height > CGFloat(textViewHeight) * CGFloat(2.5) {
            textField.isScrollEnabled = true
        }else {
            textField.isScrollEnabled = false
            self.textFieldView.snp.updateConstraints{ make in
                //textfieldView의 높이는 textfield의 size에 위아래 padding을 넣어준 값
                make.height.equalTo(newSize.height+textViewPadding+textViewPadding)
            }
        }
    }
    
    func textViewBinding(){
        boardDetailViewModel.bind{ [weak self] text in
            self?.boardDetailViewModel.comment.content = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func hideSendBtn(text:String){
        if text == ""{
            self.textFieldBtn.isHidden = true
        }else{
            self.textFieldBtn.isHidden = false
        }
    }
    
    func setPlaceHolder(_ textView: UITextView){
        self.adjustTextViewHeight(textView: textView)
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func completedWriteComment(){
        self.textField.text = ""
        self.boardDetailViewModel.comment.content = nil
        self.setPlaceHolder(self.textField)
        self.textField.resignFirstResponder()
        
        self.textViewDidChange(self.textField)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){ [weak self] in
            self?.scrollView.scrollToBottom()
        }
    }
}

//이미지 초기화, 포토뷰 초기화
extension BoardDetailView{
    func initProfileImage(url:String){
        if url == ""{
            self.authorImageView.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
        }else{
            self.boardDetailViewModel.getImage(imageURL: url, successHandler: { [weak self] data in
                let image = UIImage(data: data)
                self?.image = image!
            }, failHandler: { [weak self] in
                self?.authorImageView.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
            })
        }
    }

    func initPhotoView(imageURLs:[String]){
        //새롭게 불러온 URL과 기존에 있던 URL이 다르면 새롭게 이미지를 다운로드
        if !(self.boardDetailViewModel.checkSameURL(newURLs: imageURLs)){
            let count = imageURLs.count
            self.photoCells.removeAll()
            self.uiImages = [UIImage](repeating: UIImage(), count: count)
            self.boardDetailViewModel.loadedURLs = []
            for view in self.photoView.arrangedSubviews{
                view.removeFromSuperview()
            }
            for i in 0..<imageURLs.count{
                let cell = ImageView()
                cell.draw()
                cell.btn.addAction { [weak self] in
                    if let isAbletouched = self?.boardDetailViewModel.checkAllLoaded(), isAbletouched{
                        if let VC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailImageView") as? DetailImageView, let images = self?.uiImages{
                               VC.modalPresentationStyle = .fullScreen
                               self?.present(VC, animated: true)
                               let delegate: ImageDelegate = VC
                               delegate.sendImages(images: images, index: i)
                       }
                    }
               }
                self.photoView.addArrangedSubview(cell)
                self.photoCells.append(cell)
                self.boardDetailViewModel.getImage(imageURL: imageURLs[i], successHandler: { [weak self] data in
                    if let image = UIImage(data: data) {
                        self?.uiImages[i] = image
                        self?.photoCells[i].image = image
                        self?.boardDetailViewModel.loadedURLs.append(imageURLs[i])
                   }
                }, failHandler:{})
            }
        }
    }
    
    //게시글에 사진이 있을 경우 호출
    func updatePhoptoViewConstrains(){
        self.photoScrollView.snp.removeConstraints()
        self.photoScrollView.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(30)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            if (self.boardDetailViewModel.board.value.images.count) > 0 {
                self.photoView.isHidden = false
                make.height.equalTo(120)
            }else{
                make.height.equalTo(0)
            }
        }
    }
}

extension BoardDetailView{
    func Binding(){
        self.BindingBoard()
        self.BindingGetBoard()
        self.BindingComment()
        self.BindingGetComment()
        self.BindingWriteComment()
        self.BindingDeleteComment()
        self.BindingStackAction()
        self.BindingDeleteBoard()
    }
    
    func BindingBoard(){
        self.boardDetailViewModel.board.bind{ [weak self] board in
            //초기 세팅이 아닐 경우 진행
            if board.boardId != -1 {
                self?.contentLabel.text = board.content
                self?.titleLabel.text = board.title
                self?.authorLabel.text = board.author
                self?.dateLabel.text = board.time
                self?.categoryLabel.text = "#\(board.category)"
                self?.commentLabel.text = String(board.commentCnt)
                
                if board.images.count > 0 {
                    self?.photoImage.isHidden = false
                    self?.photoLabel.isHidden = false
                    self?.photoLabel.text = "\(board.images.count)"
                }
                
                self?.initProfileImage(url:board.profileImg)
                self?.initPhotoView(imageURLs: board.images)
                self?.updatePhoptoViewConstrains()
                self?.initRightBtn()
            }
        }
    }
    
    func BindingComment(){
        self.boardDetailViewModel.comments.bind{ [weak self] comment in
            if comment.count > 0 {
                self?.stackView.removeInitialView()
                
            }else{
                self?.stackView.addInitialView()
            }
        }
    }
    
    func BindingGetBoard(){
        self.boardDetailViewModel.getBoardListener.binding(successHandler: { [weak self] result in
            if result.success, let board = result.response{
                self?.boardDetailViewModel.board.value = board
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
    
    func BindingGetComment(){
        self.boardDetailViewModel.getCommentListener.binding(successHandler: { [weak self] result in
            if result.success{
                if let comments = result.response{
                    self?.boardDetailViewModel.comments.value = comments
                    self?.stackView.removeAllToStackView()
                    self?.stackView.InitToStackView(comments: self?.boardDetailViewModel.comments.value, board: self?.boardDetailViewModel.board.value)
                }else{
                    if let error = result.error?.message {
                        Alert(title: "실패", message: error, viewController: self).popUpDefaultAlert(action: { action in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }
        , asyncHandler: {
            
        }, endHandler: {

        })
    }
    
    func BindingWriteComment(){
        self.boardDetailViewModel.writeCommentListener.binding(successHandler: { [weak self] result in
            if result.success, let comment = result.response{
                self?.boardDetailViewModel.comments.value.append(comment)
                self?.stackView.addCommentToStackView(comment, self?.boardDetailViewModel.board.value)
            }else{
                if let error = result.error?.message {
                    Alert(title: "실패", message: error, viewController: self).popUpDefaultAlert(action: { action in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: { [weak self] in
            self?.indicator.viewController = self
            self?.indicator.startIndicator()
        }, endHandler: { [weak self] in
            self?.boardDetailViewModel.getBoardRequest()
            self?.indicator.stopIndicator()
            self?.completedWriteComment()
        })
    }
    
    func BindingDeleteComment(){
        self.boardDetailViewModel.deleteCommentListener.binding(successHandler: { [weak self] result in
            if result.success{
                Alert(title: "성공", message: result.response!, viewController: self).popUpDefaultAlert(action: nil)
                self?.boardDetailViewModel.getCommentRequest()
            }else if !result.success, let message = result.error?.message{
                Alert(title: "실패", message: message, viewController: self).popUpDefaultAlert(action: nil)
            }
            
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
    
    func BindingStackAction(){
        self.stackView.setActionSheetAction{ [weak self] commentId, deleteAction in
            if self?.presentedViewController != nil {
                self?.dismiss(animated: false, completion: nil)
            }
            var actionSheet = ActionSheet(viewController: self)
            actionSheet.popUpDeleteActionSheet(remove_text: "댓글 삭제", removeAction:{ action in
                deleteAction?(commentId)
            }
            , cancel_text: "취소")
        }
        
        self.stackView.setDeleteAlertAction{ [weak self] commentId in
            Alert(title: "삭제", message: "댓글을 삭제하겠습니까?", viewController: self).popUpNormalAlert(){ action in
                self?.boardDetailViewModel.deleteCommentRequest(commentId: commentId)
            }
        }
    }
    
    func BindingDeleteBoard(){
        self.boardDetailViewModel.deleteBoardListener.binding(successHandler: { [weak self] result in
            if result.success{
                Alert(title: "삭제 성공", message: (result.response)!, viewController: self).popUpDefaultAlert(action: { action in
                    self?.boardDetailViewModel.deleteBoardClosure?()
                    self?.navigationController?.popViewController(animated: true)
                })
            }else if !result.success, let message = result.error?.message{
                Alert(title: "실패", message: message, viewController: self).popUpDefaultAlert(action: nil)
            }
        }, failHandler: { [weak self] Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
    
    func BindingBoardSecond(closure: @escaping (Board)->Void){
        self.boardDetailViewModel.board.secondBind(closure)
    }
}

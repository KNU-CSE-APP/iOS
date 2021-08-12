//
//  ReplyView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import UIKit

class ReplyView:BaseUIViewController, ViewProtocol{

    //var selectedView:CommentCell? = nil
    
    var delegate:ReplyDataDelegate?
    
    var replyViewModel = ReplyViewModel()
    
    let replyPlaceHolder = "답글을 입력해주세요."
    var textViewHeight:CGFloat!
    var textViewPadding:CGFloat = 5
    var imageWidth:CGFloat!
    
    var scrollView:UIScrollView!{
        didSet{
            scrollView.alwaysBounceVertical = true
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            scrollView.addGestureRecognizer(tap)
        }
    }
    
    var boardContentView:UIView = UIView()
    
    var stackView:CommentView!{
        didSet{
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.InitToStackView(comments: [self.replyViewModel.comment.value], board: self.replyViewModel.board)
        }
    }
    
    var textFieldView:UIView!{
        didSet{
            textFieldView.backgroundColor = .white
        }
    }
    
    var borderLine:UIView!{
        didSet{
            borderLine.layer.borderWidth = 0.3
            borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var textField:UITextView!{
        didSet{
            textField.delegate = self
            textField.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
            textField.layer.cornerRadius = 10
            textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            textField.textColor = UIColor.black
            let top_padding:CGFloat = textViewPadding * 2
            let bottom_padding:CGFloat = textViewPadding * 2
            if let font = textField.font {
                self.textViewHeight = font.lineHeight + top_padding + bottom_padding + textViewPadding + textViewPadding
                self.imageWidth = textViewHeight-(textViewPadding*3)
            }
            textField.isScrollEnabled = false
            textField.textContainerInset = UIEdgeInsets(top: top_padding, left: 10, bottom: bottom_padding, right: imageWidth)
        }
    }

    var placeholderLabel : UILabel!{
        didSet{
            placeholderLabel.text = replyPlaceHolder
            placeholderLabel.font = textField.font
            placeholderLabel.textColor = UIColor.lightGray
            placeholderLabel.isHidden = !textField.text.isEmpty
        }
    }
    
    var textFieldBtn:UIButton!{
        didSet{
            let image = UIImage(systemName: "paperplane.circle.fill")?.resized(toWidth: imageWidth)
            textFieldBtn.setImage(image?.withTintColor(Color.mainColor), for: .normal)
            textFieldBtn.tintColor = Color.mainColor
            textFieldBtn.setTitleColor(Color.mainColor.withAlphaComponent(0.5), for: .highlighted)
            textFieldBtn.addAction {
                self.replyViewModel.writeReplyRequest()
            }
            textFieldBtn.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
        self.textViewBinding()
        
        self.BindingWriteReply()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTitle(title: "답글달기")
        self.hideBackTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("will disapper")
        self.sendReplyToParent(replys: self.replyViewModel.replys)
    }
    
    func initUI(){
        scrollView = UIScrollView()
        
        stackView = CommentView(storyboard: nil, navigationVC: nil, isHiddenReplyBtn: true)
        
        textFieldView = UIView()
        borderLine = UIView()
        textField = UITextView()
        placeholderLabel = UILabel()
        textFieldBtn = UIButton()
    }
    
    func addView(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(boardContentView)
        _ = [ stackView].map { self.boardContentView.addSubview($0)}
        
        self.view.addSubview(textFieldView)
        _ = [borderLine,textField,textFieldBtn].map{
            self.textFieldView.addSubview($0)
        }
        
        self.textField.addSubview(placeholderLabel)
    }
    
    func setUpConstraints(){
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
        
        self.stackView.snp.makeConstraints{ make in
            make.top.equalTo(boardContentView.snp.top).offset(0)
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
        
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(0.3)
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
            make.right.equalTo(textField.snp.right)
            make.width.equalTo(textViewHeight)
            make.height.equalTo(textViewHeight)
        }
    }
}


extension ReplyView:CommentDataDelegate{
    
    /// BoardDetailView로 부터의 Delegation을 전달받음
    func sendComment(board:Board, comment: Comment) {
        self.replyViewModel.board = board
        self.replyViewModel.comment.value = comment
    }
    
    func sendReplyToParent(replys:[Comment]){
        if let index = self.navigationController?.children.count{
            if self.navigationController?.children != nil{
                self.delegate = self.navigationController?.children[index-1] as? BoardDetailView
                self.delegate?.sendReply(replys: replys)
            }
        }
    }
}

extension ReplyView{
    func setKeyBoardAction(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.textFieldView.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.height+self.view.safeAreaInsets.bottom)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.textFieldView.snp.updateConstraints{ make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            }
        }
    }
}

extension ReplyView:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight(textView: textView)
        self.placeholderLabel.isHidden = !textView.text.isEmpty
        self.replyViewModel.listener!(textView.text)
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
        replyViewModel.bind{ text in
            self.replyViewModel.replyBody.content = text
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
        self.setPlaceHolder(self.textField)
        self.textField.resignFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){
            self.scrollView.scrollToBottom()
        }
    }
}

extension ReplyView{
    func BindingWriteReply(){
        self.replyViewModel.writeReplyListener.binding(successHandler: { result in
            if result.success{
                if let reply = result.response{
                    self.replyViewModel.comment.value.replyList.append(reply)
                    self.replyViewModel.replys.append(reply)
                    self.stackView.addReplyToStackView(reply)
                }
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }
        , asyncHandler: {
            self.indicator.viewController = self
            self.indicator.startIndicator()
        }
        , endHandler: {
            self.indicator.stopIndicator()
            self.completedWriteComment()
        })
    }
}

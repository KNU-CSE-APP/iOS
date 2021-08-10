//
//  DetailView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/22.
//

import UIKit

class BoardDetailView:UIViewController, ViewProtocol, BoardDataDelegate{
    
    var selectedView:CommentCell? = nil
    
    var boardDetailViewModel = BoardDetailViewModel()
    var delegate:CommentDataDelegate?
    
    let commentPlaceHolder = "댓글을 입력해주세요."
    let titleHeight:CGFloat = 30
    var imageSize:CGFloat!
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
    
    var image:UIImage!
    var authorImageView:UIImageView!{
        didSet{
            self.imageSize = authorLabel.font.lineHeight + 8
            self.authorImageView.image = self.image
            self.authorImageView.clipsToBounds = true
            self.authorImageView.contentMode = .scaleAspectFill
            self.authorImageView.layer.borderWidth = 1
            self.authorImageView.layer.borderColor = UIColor.clear.cgColor
            self.authorImageView.layer.cornerRadius = imageSize / 4
            self.authorImageView.frame.size = CGSize(width: imageSize, height: imageSize)
            self.authorImageView.tintColor = .lightGray
        }
    }
    
    var authorLabel:UILabel!{
        didSet{
            self.authorLabel.text = boardDetailViewModel.board.author
            self.authorLabel.textAlignment = .left
            self.authorLabel.textColor = UIColor.black
            self.authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            self.authorLabel.sizeToFit()
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            self.dateLabel.text = boardDetailViewModel.board.time
            self.dateLabel.textAlignment = .right
            self.dateLabel.textColor = UIColor.black
            self.dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
            self.dateLabel.sizeToFit()
        }
    }
    
    var titleLabel:UILabel!{
        didSet{
            self.titleLabel.text = boardDetailViewModel.board.title
            self.titleLabel.textAlignment = .left
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            self.titleLabel.numberOfLines = 0
            self.titleLabel.sizeToFit()
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            self.contentLabel.text = boardDetailViewModel.board.content
            self.contentLabel.textAlignment = .left
            self.contentLabel.textColor = UIColor.black
            self.contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .thin)
            self.contentLabel.numberOfLines = 0
            self.contentLabel.sizeToFit()
        }
    }
    
    var categoryLabel:UILabel!{
        didSet{
            self.categoryLabel.text = "#\(boardDetailViewModel.board.category)"
            self.categoryLabel.textAlignment = .center
            self.categoryLabel.textColor = UIColor.lightGray
            self.categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    var commentImage:UIImageView!{
        didSet{
            let image = UIImage(systemName: "text.bubble.fill")
            self.commentImage.image = image
            self.commentImage.tintColor = .lightGray
        }
    }
    
    var commentLabel:UILabel!{
        didSet{
            self.commentLabel.text = String(boardDetailViewModel.board.commentCnt)
            self.commentLabel.textAlignment = .left
            self.commentLabel.textColor = UIColor.black
            self.commentLabel.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
        }
    }
    
    var stackView:UIStackView!{
        didSet{
            stackView.axis = .vertical
            stackView.distribution = .fill
            addToStackView()
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
            placeholderLabel.text = commentPlaceHolder
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
                self.boardDetailViewModel.sendComment()
            }
            textFieldBtn.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initImage()
        self.initUI()
        self.addView()
        self.setUpConstraints()
        self.setKeyBoardAction()
        self.textViewBinding()
    }
    
    func initUI(){
        self.scrollView = UIScrollView()
        
        self.authorLabel = UILabel()
        self.authorImageView = UIImageView()
        self.dateLabel = UILabel()
        self.titleLabel = UILabel()
        self.contentLabel = UILabel()
        self.categoryLabel = UILabel()
        self.commentImage = UIImageView()
        self.commentLabel = UILabel()
        
        self.stackView = UIStackView()
        
        self.textFieldView = UIView()
        self.borderLine = UIView()
        self.textField = UITextView()
        self.placeholderLabel = UILabel()
        self.textFieldBtn = UIButton()
    }
    
    func addView(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(boardContentView)
        _ = [authorLabel,authorImageView, dateLabel, titleLabel, contentLabel, categoryLabel, commentImage, commentLabel, stackView].map { self.boardContentView.addSubview($0)}
        
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
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        self.contentLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        self.commentLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(height*0.1)
            make.width.equalTo(height*0.1)
        }
        
        self.commentImage.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(0)
            make.right.equalTo(commentLabel.snp.left).offset(-5)
            make.height.equalTo(height*0.1)
            make.width.equalTo(height*0.1)
        }
        
        self.categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(5)
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


extension BoardDetailView{
    
    /// BoardView로 부터의 Delegation을 전달받음
    func sendBoard(board: Board) {
        self.boardDetailViewModel.board = board
    }
    
    /// StackView에 CommentCell, ReplyCell 추가
    func addToStackView(){
        for i in 0..<self.boardDetailViewModel.comments.count{
            let comment = self.boardDetailViewModel.comments[i]
            let commentView = CommentCell(comment: comment)
            commentView.replyBtn.addAction {
                self.pushView(comment)
            }
            stackView.addArrangedSubview(commentView)
            for j in 0..<comment.replyList.count{
                let reply = comment.replyList[j]
                let replyView = ReplyCell(reply: reply)
                stackView.addArrangedSubview(replyView)
            }
        }
    }
    
    func pushView(_ comment:Comment){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyView") as? ReplyView
        self.navigationController?.pushViewController(pushVC!, animated: true)
        self.delegate = pushVC
        self.delegate?.sendComment(comment: comment)
    }
    
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

extension BoardDetailView:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight(textView: textView)
        self.placeholderLabel.isHidden = !textView.text.isEmpty
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
        boardDetailViewModel.bind{ text in
            self.boardDetailViewModel.comment.content = text
        }
    }
    
    func hideSendBtn(text:String){
        if text == ""{
            self.textFieldBtn.isHidden = true
        }else{
            self.textFieldBtn.isHidden = false
        }
    }
}

extension BoardDetailView{
    func initImage(){
        do {
            print(self.boardDetailViewModel.board.image)
            if let url = URL(string: self.boardDetailViewModel.board.image){
                let data =  try Data(contentsOf: url)
                self.image = UIImage(data: data)
            }else{
                self.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
            }
            
        } catch  {
            self.image = UIImage(systemName: "person.crop.square.fill")?.resized(toWidth: 100)?.withTintColor(.lightGray)
        }
    }
}

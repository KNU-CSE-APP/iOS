//
//  DetailView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/22.
//

import UIKit

class BoardDetailView:UIViewController, ViewProtocol, BoardDataDelegate, UITableViewDelegate{
    
    var boardDetailViewModel = BoardDetailViewModel()
    
    var scrollView:UIScrollView!{
        didSet{
            scrollView.alwaysBounceVertical = true
        }
    }
    
    var boardContentView:UIView = UIView()
    
    var authorLabel:UILabel!{
        didSet{
            authorLabel.text = boardDetailViewModel.board.author
            authorLabel.textAlignment = .left
            authorLabel.textColor = UIColor.black
            authorLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        }
    }
    
    var dateLabel:UILabel!{
        didSet{
            dateLabel.text = boardDetailViewModel.board.date
            dateLabel.textAlignment = .right
            dateLabel.textColor = UIColor.black
            dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        }
    }
    
    var titleLabel:UILabel!{
        didSet{
            titleLabel.text = boardDetailViewModel.board.title
            titleLabel.textAlignment = .left
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }
    
    var contentLabel:UILabel!{
        didSet{
            contentLabel.text = boardDetailViewModel.board.content
            contentLabel.textAlignment = .left
            contentLabel.textColor = UIColor.black
            contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            contentLabel.numberOfLines = 0
            contentLabel.sizeToFit()
        }
    }
    
    var commentImage:UIImageView!{
        didSet{
            let image = UIImage(systemName: "text.bubble.fill")
            commentImage.image = image
            commentImage.tintColor = .lightGray
        }
    }
    
    var commentLabel:UILabel!{
        didSet{
            commentLabel.text = String(boardDetailViewModel.board.numberOfcomment)
            commentLabel.textAlignment = .left
            commentLabel.textColor = UIColor.black
            commentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    var borderLine:UIView!{
        didSet{
            borderLine.layer.borderWidth = 1
            borderLine.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    var commentTableView:UITableView!{
        didSet{
            commentTableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.identifier)
            commentTableView.rowHeight = self.view.frame.height * 0.1
            commentTableView.dataSource = self
            commentTableView.separatorInset.left = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.hideBackBtnTitle()
    }
    
    override func viewDidLoad() {
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI(){
        scrollView = UIScrollView()
        
        authorLabel = UILabel()
        dateLabel = UILabel()
        titleLabel = UILabel()
        contentLabel = UILabel()
        commentImage = UIImageView()
        commentLabel = UILabel()
        borderLine = UIView()
        
        commentTableView = UITableView()
    }
    
    func addView(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(boardContentView)
        _ = [authorLabel, dateLabel, titleLabel, contentLabel, commentImage, commentLabel, borderLine, commentTableView].map { self.boardContentView.addSubview($0)}
    }
    
    func setUpConstraints(){
        let height = self.view.frame.height * 0.2
        let tableHeight = self.view.frame.height * 0.1 * CGFloat(self.boardDetailViewModel.comments.count)
        
        self.scrollView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.boardContentView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()//필수
        }
        
        self.authorLabel.snp.makeConstraints{ make in
            make.top.equalTo(boardContentView.snp.top).offset(15)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(height*0.1)
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
        
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalTo(commentLabel.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(0.5)
            //make.bottom.equalToSuperview()//필수
        }
        
        self.commentTableView.snp.makeConstraints{make in
            make.top.equalTo(borderLine.snp.bottom).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(tableHeight)
            make.bottom.equalToSuperview().offset(-20)//아래 여백 주기
        }
        
    }
}

extension BoardDetailView{
    func sendBoard(board: Board) {
        self.boardDetailViewModel.board = board
    }
    
    func hideBackBtnTitle(){
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
}

extension BoardDetailView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boardDetailViewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableCell.identifier, for: indexPath) as! CommentTableCell
        cell.comment = self.boardDetailViewModel.comments[indexPath.row]
        let testView = UIView()
        testView.backgroundColor = .yellow
        testView
        return cell
    }
    
    
}

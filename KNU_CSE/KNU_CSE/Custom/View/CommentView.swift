//
//  CommentView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/12.
//

import UIKit
import Foundation
import SnapKit

class CommentView: UIStackView {
    
    var delegate:CommentDataDelegate?
    var storyboard:UIStoryboard?
    var navigationVC:UINavigationController?
    var currentVC:UIViewController?
    var isHiddenReplyBtn:Bool
    var resetAction:(()->Void)?
    var deleteAction:((Int)->Void)?
    var stackViews:[UIView] = []
    
    var borderLine:UIView = {
        var borderLine = UIView()
        borderLine.layer.borderWidth = 0.5
        borderLine.layer.borderColor = UIColor.lightGray.cgColor
        
        return borderLine
    }()
    
    lazy var label : UILabel = {
        var label = UILabel()
        label.text = "작성된 댓글이 없습니다"
        label.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        label.tintColor = .lightGray
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    init(storyboard:UIStoryboard?, navigationVC:UINavigationController?, currentVC:UIViewController?, isHiddenReplyBtn:Bool){
        self.storyboard = storyboard
        self.navigationVC = navigationVC
        self.currentVC = currentVC
        self.isHiddenReplyBtn = isHiddenReplyBtn
        super.init(frame: CGRect.zero)
        
        self.addSubview(self.borderLine)
        self.borderLine.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(0.5)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit CommentView")
    }
    
    func addInitialView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)){ [weak self] in
            self?.addSubview((self?.label)!)
            self?.addArrangedSubview((self?.label)!)
            self?.label.snp.makeConstraints{ make in
                make.height.equalTo(300)
            }
        }
    }
    
    func removeInitialView(){
        DispatchQueue.main.asyncAfter(deadline: .now() +
                                        .milliseconds(0)){ [weak self] in
            self?.label.snp.removeConstraints()
            self?.label.removeFromSuperview()
            self?.removeArrangedSubview((self?.label)!)
        }
    }
    
    /// StackView에 CommentCell, ReplyCell 추가
    func InitToStackView(comments:[Comment]?, board:Board?){
        if let comments = comments, let board = board{
            for i in 0..<comments.count{
                let comment = comments[i]
                self.addCommentToStackView(comment,board)
            }
        }
    }
    
    func addCommentToStackView(_ comment:Comment?, _ board:Board?){
        DispatchQueue.main.async { [weak self] in
            if let comment = comment, let board = board{
                let commentView = CommentCell(comment: comment)
                self?.stackViews.append(commentView)
                
                commentView.replyBtn.isHidden = (self?.isHiddenReplyBtn)!
                commentView.replyBtn.addAction {
                    self?.pushView(board, comment)
                }
                
                commentView.settingBtn.addAction {
                    self?.addActionSheet(commentId: comment.commentId)
                }
                
                self?.addArrangedSubview(commentView)
                if let replyList = comment.replyList{
                    for j in 0..<replyList.count{
                        let reply = comment.replyList[j]
                        let replyView = ReplyCell(reply: reply)
                        self?.stackViews.append(replyView)
                        replyView.settingBtn.addAction {
                            self?.addActionSheet(commentId: reply.commentId)
                        }
                        self?.addArrangedSubview(replyView)
                    }
                }
            }
        }
    }
    
    func addReplyToStackView(_ reply:Comment){
        DispatchQueue.main.async { [weak self] in
            let replyView = ReplyCell(reply: reply)
            self?.addArrangedSubview(replyView)
        }
    }
    
    func insertReplyToStackView(reply:Comment, index:Int){
        DispatchQueue.main.async { [weak self] in
            let replyView = ReplyCell(reply: reply)
            self?.stackViews.insert(replyView, at: index)
            self?.insertArrangedSubview(replyView, at: index)
        }
    }
    
    func updateReply(comments:[Comment]?, target:Comment?){
        var targetIndex = 1
        
        if let comments = comments, let target = target{
            for comment in comments{
                if comment.commentId == target.commentId{
                    (0..<comment.replyList.count).forEach{ _ in
                        self.removeArrangedSubview(stackViews[targetIndex])
                        self.stackViews[targetIndex].removeFromSuperview()
                        self.stackViews.remove(at: targetIndex)
                    }
                    
                    for reply in target.replyList{
                        self.insertReplyToStackView(reply: reply, index: targetIndex)
                        targetIndex += 1
                    }
                }
                targetIndex += 1
                targetIndex += comment.replyList.count
            }
        }
    }
    
    func removeAllToStackView(){
        for view in self.arrangedSubviews{
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        self.stackViews.removeAll()
    }
}

extension CommentView{
    func addActionSheet(commentId:Int){
        var actionSheet = ActionSheet(viewController: currentVC)
        actionSheet.popUpDeleteActionSheet(remove_text: "댓글 삭제", removeAction:{ [weak self] action in
            self?.deleteAction?(commentId)
        }
        , cancel_text: "취소")
    }
    
    func pushView(_ board:Board, _ comment:Comment){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyView") as? ReplyView
        self.navigationVC?.pushViewController(pushVC!, animated: true)
        self.delegate = pushVC
        self.delegate?.sendComment(board:board, comment: comment)
    }
    
    func setResetAction(action:@escaping ()->Void){
        self.resetAction = action
    }
    
    func setDeleteAction(action:@escaping (Int)->Void){
        self.deleteAction = action
    }
}

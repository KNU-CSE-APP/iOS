//
//  CommentView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/12.
//

import UIKit
import Foundation

class CommentView: UIStackView {
    
    var delegate:CommentDataDelegate?
    var storyboard:UIStoryboard?
    var navigationVC:UINavigationController?
    var currentVC:UIViewController
    var isHiddenReplyBtn:Bool
    var resetAction:(()->Void)?
    var deleteAction:((Int)->Void)?
    var stackViews:[UIView]?
    
    init(storyboard:UIStoryboard?, navigationVC:UINavigationController?, currentVC:UIViewController, isHiddenReplyBtn:Bool){
        self.storyboard = storyboard
        self.navigationVC = navigationVC
        self.currentVC = currentVC
        self.isHiddenReplyBtn = isHiddenReplyBtn
        super.init(frame: CGRect.zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// StackView에 CommentCell, ReplyCell 추가
    func InitToStackView(comments:[Comment], board:Board){
        for i in 0..<comments.count{
            let comment = comments[i]
            self.addCommentToStackView(comment,board)
        }
    }
    
    func addCommentToStackView(_ comment:Comment, _ board:Board){
        DispatchQueue.main.async {
            let commentView = CommentCell(comment: comment)
            commentView.replyBtn.isHidden = self.isHiddenReplyBtn
            commentView.replyBtn.addAction {
                self.pushView(board, comment)
            }
            
            commentView.settingBtn.addAction {
                //self.deleteAction?(comment.commentId)
                self.addActionSheet(commentId: comment.commentId)
            }
            
            self.addArrangedSubview(commentView)
            if let replyList = comment.replyList{
                for j in 0..<replyList.count{
                    let reply = comment.replyList[j]
                    let replyView = ReplyCell(reply: reply)
                    replyView.settingBtn.addAction {
                        //self.deleteAction?(reply.commentId)
                        self.addActionSheet(commentId: comment.commentId)
                    }
                    self.addArrangedSubview(replyView)
                }
            }
        }
    }
    
    func addReplyToStackView(_ reply:Comment){
        DispatchQueue.main.async {
            let replyView = ReplyCell(reply: reply)
            self.addArrangedSubview(replyView)
        }
    }
    
    func insertReplyToStackView(reply:Comment, index:Int){
        DispatchQueue.main.async {
            let replyView = ReplyCell(reply: reply)
            self.insertArrangedSubview(replyView, at: index)
        }
    }
    
    //reply가 업데이트 될때 사용하는 함수
    func updateToStackView(Comments:[Comment], replys:[Comment], board:Board){
        var targetIndex = 0
        
        guard replys.count > 0 else{
            return
        }
        
        for comment in Comments{
            targetIndex += 1
            if comment.commentId == replys[0].parentId{
                if let replyList = comment.replyList{
                    targetIndex += replyList.count
                    targetIndex -= replys.count
                }
                
                for reply in replys{
                    insertReplyToStackView(reply: reply, index: targetIndex)
                    targetIndex += 1
                }
                break
            }else{
                if let replyList = comment.replyList{
                    targetIndex += replyList.count
                }
            }
        }
    }
    
    func updateReplyToStackView(newReplys:[Comment], oldReplys:[Comment]){
        for newReply in newReplys{
            var flag = true
            for oldReply in oldReplys{
                if newReply.commentId == oldReply.commentId{
                    flag = false
                }
            }
            if flag{
                self.addReplyToStackView(newReply)
            }
        }
    }
    
    func removeAllToStackView(){
        for view in self.arrangedSubviews{
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
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

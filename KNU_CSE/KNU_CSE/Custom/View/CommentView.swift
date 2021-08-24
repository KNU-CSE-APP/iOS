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
    var stackViews:[UIView] = []
    
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
            self.stackViews.append(commentView)
            
            commentView.replyBtn.isHidden = self.isHiddenReplyBtn
            commentView.replyBtn.addAction {
                self.pushView(board, comment)
            }
            
            commentView.settingBtn.addAction {
                self.addActionSheet(commentId: comment.commentId)
            }
            
            self.addArrangedSubview(commentView)
            if let replyList = comment.replyList{
                for j in 0..<replyList.count{
                    let reply = comment.replyList[j]
                    let replyView = ReplyCell(reply: reply)
                    self.stackViews.append(replyView)
                    replyView.settingBtn.addAction {
                        self.addActionSheet(commentId: reply.commentId)
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
            self.stackViews.insert(replyView, at: index)
            self.insertArrangedSubview(replyView, at: index)
        }
    }
    
    func updateReply(comments:[Comment], target:Comment){
        var targetIndex = 1
        
        for comment in comments{
            if comment.commentId == target.commentId{
                (0..<comment.replyList.count).forEach{ _ in
                    self.removeArrangedSubview(stackViews[targetIndex])
                    stackViews[targetIndex].removeFromSuperview()
                    stackViews.remove(at: targetIndex)
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

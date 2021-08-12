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
    var isHiddenReplyBtn:Bool
    
    init(storyboard:UIStoryboard?, navigationVC:UINavigationController?, isHiddenReplyBtn:Bool){
        self.storyboard = storyboard
        self.navigationVC = navigationVC
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
            self.addArrangedSubview(commentView)
            if let replyList = comment.replyList{
                for j in 0..<replyList.count{
                    let reply = comment.replyList[j]
                    let replyView = ReplyCell(reply: reply)
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
            }
        }
    }
}

extension CommentView{
    func pushView(_ board:Board, _ comment:Comment){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyView") as? ReplyView
        self.navigationVC?.pushViewController(pushVC!, animated: true)
        self.delegate = pushVC
        self.delegate?.sendComment(board:board, comment: comment)
    }
}

//
//  BoardDataDelegate.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation

protocol BoardDataDelegate{
    func sendBoard(board:Board)
}

protocol CommentDataDelegate {
    func sendComment(board:Board, comment:Comment)
}

protocol ReplyDataDelegate{
    func sendReply(replys:[Comment], removedCommentId:Int?)
}

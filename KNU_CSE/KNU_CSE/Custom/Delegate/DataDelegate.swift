//
//  BoardDataDelegate.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation
import UIKit

protocol BoardDataDelegate: AnyObject{
    func sendBoardData(board:Board)
    func deleteBoard(deleteBoard: @escaping ()->Void)
    func editBoard(editBoard: @escaping ()->Void)
}

protocol CommentDataDelegate: AnyObject{
    func sendComment(board:Board, comment:Comment)
}

protocol ReplyDataDelegate: AnyObject{
    func sendReply(comment:Comment?)
}

protocol ImageDelegate: AnyObject{
    func sendImages(images:[UIImage], index:Int)
}

protocol BoardDataforEditDelegate: AnyObject{
    func sendBoard(board: Board?, images: [UIImage]?, imageURLs: [String]?, closure:@escaping ()->())
}

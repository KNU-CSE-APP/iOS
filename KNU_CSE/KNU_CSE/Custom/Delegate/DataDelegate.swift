//
//  BoardDataDelegate.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation
import UIKit

protocol BoardDataDelegate{
    func sendBoard(board:Board)
}

protocol CommentDataDelegate {
    func sendComment(board:Board, comment:Comment)
}

protocol ReplyDataDelegate{
    func sendReply(comment:Comment?)
}

protocol ImageDelegate{
    func sendImages(images:[UIImage], index:Int)
}

//
//  ReplyViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import Foundation


struct ReplyViewModel{
    var board:Board!
    var comment:Comment?
    var reply:ReplyTextModel = ReplyTextModel()
    var listener:((String)->Void)?
    
    init(){
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
    
    func sendReply(){
        self.reply.commentId = comment?.commentId
        self.reply.email = "ljs3271@naver.com"
        print(reply.commentId, reply.content, reply.email)
    }
}

class ReplyTextModel:BaseObject{
    var commentId:Int!
    var email:String!
    var content:String!
}

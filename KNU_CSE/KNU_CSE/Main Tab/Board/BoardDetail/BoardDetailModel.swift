//
//  BoardDetailModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation

class Comment:BaseObject{
    var commentId:Int!
    var content:String!
    var date:String!
    var author:String!
    var replyList:[Reply]!
    
    init(commentId:Int, content:String, date:String, author:String) {
        self.commentId = commentId
        self.content = content
        self.date = date
        self.author = author
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func setReplyList(replyList:[Reply]){
        self.replyList = replyList
    }
}

struct Reply:Codable{
    var replyId:Int!
    var content:String!
    var date:String!
    var author:String!
    
    init(replyId:Int, content:String, date:String, author:String) {
        self.replyId = replyId
        self.content = content
        self.date = date
        self.author = author
    }
}

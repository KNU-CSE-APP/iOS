//
//  ReplyViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import Foundation


struct ReplyViewModel{
    var writeReplyListener:BaseAction<Comment, errorHandler> = BaseAction()
    
    var board:Board!
    var comment:Observable<Comment> = Observable(Comment(image: "", commentId: 0, content: "", time: "", author: ""))
    
    var replys:[Comment] = []
    var replyBody:ReplyTextModel = ReplyTextModel()
    var listener:((String)->Void)?
    
    init(){
        
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
    
    mutating func addReply(reply:Comment){
        self.comment.value.replyList.append(reply)
    }
}

extension ReplyViewModel{
    public func writeReplyRequest() {
        self.replyBody.boardId = board.boardId
        self.replyBody.commentId = comment.value.commentId
        
        let request = Request(requestBodyObject: self.replyBody, requestMethod: .post, enviroment: .writeReply)
        request.sendRequest(request: request, responseType: Comment.self, errorType: errorHandler.self, action:self.writeReplyListener)
    }
}

class ReplyTextModel:BaseObject{
    var boardId:Int!
    var commentId:Int!
    var content:String!
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(boardId, forKey: .boardId)
        try container.encode(commentId, forKey: .commentId)
        try container.encode(content, forKey: .content)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case boardId,commentId, content
     }
}

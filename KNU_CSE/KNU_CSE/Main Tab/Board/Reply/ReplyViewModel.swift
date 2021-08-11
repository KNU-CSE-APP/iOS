//
//  ReplyViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import Foundation


struct ReplyViewModel{
    var writeReplyListener:BaseAction<ReplyTextModel, errorHandler> = BaseAction()
    
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
       
    }
}

extension ReplyViewModel{
    public func writeReplyRequest() {
        self.reply.boardId = board.boardId
        self.reply.commentId = comment?.commentId
        
        let request = Request(requestBodyObject: self.reply, requestMethod: .post, enviroment: .writeReply)
        request.sendRequest(request: request, responseType: ReplyTextModel.self, errorType: errorHandler.self, action:self.writeReplyListener)
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

class ReplyResponse:BaseObject{
    var author: String
    var boardId: Int
    var commentId: Int
    var content: String
    var parentId:Int
    var replyList:[Reply]!
    var time: String
    
    var image:String!
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = (try? container.decode(String.self, forKey: .author)) ?? ""
        self.boardId = (try? container.decode(Int.self, forKey: .boardId)) ?? 0
        self.commentId = (try? container.decode(Int.self, forKey: .commentId)) ?? 0
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.parentId = (try? container.decode(Int.self, forKey: .parentId)) ?? 0
        self.replyList = (try? container.decode([Reply].self, forKey: .replyList))
        self.time = (try? container.decode(String.self, forKey: .time)) ?? ""
        self.image = (try? container.decode(String.self, forKey: .image)) ?? ""
        super.init()
    }
    
    enum CodingKeys: CodingKey {
        case boardId, commentId, parentId, author, content, time, image, replyList
     }
}

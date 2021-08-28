//
//  ReplyViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/25.
//

import Foundation


struct ReplyViewModel{
    var writeReplyListener:BaseAction<Comment, errorHandler> = BaseAction()
    var getCommentListener:BaseAction<Comment, errorHandler> = BaseAction()
    var deleteCommentListener:BaseAction<String, errorHandler> = BaseAction()
    
    var board:Board!
    var comment:Observable<Comment?> = Observable(Comment(image: "", commentId: 0, content: "", time: "", author: ""))
    
    var newReplys:Observable<[Comment]> = Observable([]) // Parent View로 넘어갔을때 추가된 reply를 넘겨줌
    var replyBody:ReplyTextModel = ReplyTextModel()
    
    var removedCommentId:Int?// commentor reply가 삭제됐을 경우 사용
    var listener:((String)->Void)?
    
    init(){
        self.bindingReplys()
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
    
    mutating func addReply(reply:Comment){
        self.comment.value?.replyList.append(reply)
    }
}

extension ReplyViewModel{
    public func bindingReplys(){
        self.newReplys.bind{ replys in
            for reply in replys{
                //print("replys \(replys) count: \(replys.count)")
                self.comment.value?.replyList.append(reply)
            }
        }
    }
    
    public func writeReplyRequest() {
        self.replyBody.boardId = board.boardId
        self.replyBody.commentId = comment.value?.commentId
        
        let request = Request(requestBodyObject: self.replyBody, requestMethod: .post, enviroment: .writeReply)
        request.sendRequest(request: request, responseType: Comment.self, errorType: errorHandler.self, action:self.writeReplyListener)
    }
    
    public func getCommentRequest(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getComment(comment.value!.commentId))
        request.sendRequest(request: request, responseType: Comment.self, errorType: errorHandler.self, action:self.getCommentListener)
    }
    
    public func deleteCommentRequest(commentId:Int){
        let request = Request(requestBodyObject: nil, requestMethod: .delete, enviroment: .deleteComment(commentId))
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.deleteCommentListener)
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

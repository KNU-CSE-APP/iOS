//
//  BoardViewDetailViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation

struct BoardDetailViewModel{
    var getBoardListener:BaseAction<Board, errorHandler> = BaseAction()
    var getCommentListener:BaseAction<[Comment], errorHandler> = BaseAction()
    var writeCommentListener:BaseAction<Comment, errorHandler> = BaseAction()
    
    var board:Observable<Board> = Observable(Board(image: "", boardId: 0, category: "", title: "", content: "", author: "", time: "", commentCnt: 0))
    
    var oldcomments:[Comment]!
    var comments:[Comment] = []
    var comment:CommentTextModel = CommentTextModel()
    var listener:((String)->Void)?
    
    init(){
       
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
}

extension BoardDetailViewModel{
    public func getBoardRequest() {
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoard(board.value.boardId))
        request.sendRequest(request: request, responseType: Board.self, errorType: errorHandler.self, action:self.getBoardListener)
    }
    
    public func getCommentRequest() {
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .findContentsByBoardId(board.value.boardId))
        request.sendRequest(request: request, responseType: [Comment].self, errorType: errorHandler.self, action:self.getCommentListener)
    }
    
    public func writeCommentRequest(){
        self.comment.boardId = self.board.value.boardId
        let request = Request(requestBodyObject: self.comment, requestMethod: .post, enviroment: .writeComment)
        request.sendRequest(request: request, responseType: Comment.self, errorType: errorHandler.self, action:self.writeCommentListener)
    }
}

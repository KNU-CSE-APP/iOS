//
//  BoardViewDetailViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/23.
//

import Foundation
import Alamofire

struct BoardDetailViewModel{
    var getBoardListener:BaseAction<Board, errorHandler> = BaseAction()
    var getCommentListener:BaseAction<[Comment], errorHandler> = BaseAction()
    var writeCommentListener:BaseAction<Comment, errorHandler> = BaseAction()
    var deleteCommentListener:BaseAction<String, errorHandler> = BaseAction()
    var deleteBoardListener:BaseAction<String, errorHandler> = BaseAction()
    
    var board:Observable<Board> = Observable(Board(boardId: -1, category: "", title: "", content: "", author: "", time: "", profileImg: "", commentCnt: 0, images: []))
    var boardId: Int!
    var comments:Observable<[Comment]> = Observable([])
    var comment:CommentTextModel = CommentTextModel()
    var deleteBoardClosure:(()->Void)?
    var editBoardClosure:(()->Void)?
    
    var userNickName = UserDefaults.standard.string(forKey: "nickName")
    
    var listener:((String)->Void)?
    
    init(){
       
    }
    
    mutating func bind(listener:((String)->Void)?) {
        self.listener = listener
    }
    
    func checkNickName()->Bool {
        if self.board.value.author == userNickName{
            return true
        }else{
            return false
        }
    }
}

extension BoardDetailViewModel{
    public func getBoardRequest() {
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoard(self.boardId))
        request.sendRequest(request: request, responseType: Board.self, errorType: errorHandler.self, action:self.getBoardListener)
    }
    
    public func getCommentRequest() {
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .findContentsByBoardId(self.boardId))
        request.sendRequest(request: request, responseType: [Comment].self, errorType: errorHandler.self, action:self.getCommentListener)
    }
    
    public func writeCommentRequest(){
        self.comment.boardId = self.board.value.boardId
        let request = Request(requestBodyObject: self.comment, requestMethod: .post, enviroment: .writeComment)
        request.sendRequest(request: request, responseType: Comment.self, errorType: errorHandler.self, action:self.writeCommentListener)
    }
    
    public func deleteCommentRequest(commentId:Int){
        let request = Request(requestBodyObject: nil, requestMethod: .delete, enviroment: .deleteComment(commentId))
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.deleteCommentListener)
    }
    
    public func getImage(imageURL:String, successHandler: @escaping (Data)->(), failHandler: @escaping()->()){
        AF.request(imageURL, method: .get).responseData{ response in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    successHandler(data)
                }
            case .failure(_):
                failHandler()
            }
        }
    }
    
    public func deleteBoard(){
        self.comment.boardId = self.boardId
        let request = Request(requestBodyObject: nil, requestMethod: .delete, enviroment: .deleteBoard(self.boardId))
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.deleteBoardListener)
    }
}

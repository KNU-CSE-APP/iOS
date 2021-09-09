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
    
    //이미 불러온 URL check
    var loadedURLs = [String]()
    //URL을 전부 다운로드 완료하면 사진 상세보기 화면 터치가능
    var isAbleTouched:Bool = false
    
    
    //UserDefault로 부터 닉네임을 불러옴 for 작성자라면 게시글 수정, 삭제가능
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
    
    func checkSameURL(newURLs:[String])->Bool{
        let count = loadedURLs.count
        if count != newURLs.count{
            return false
        }else{
            var sameCount = 0
            for i in 0..<count{
                for j in 0..<count{
                    if loadedURLs[i] == newURLs[j]{
                        sameCount += 1
                    }
                }
            }
            if sameCount == count{
                return true
            }else{
                return false
            }
        }
    }
    
    func checkAllLoaded()->Bool{
        if self.loadedURLs.count == self.board.value.images.count{
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

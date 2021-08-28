//
//  BoardViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct BoardViewModel{
    var BoardsByPagingAction: BaseAction<BoardsWithPaging, errorHandler> = BaseAction()
    var getBoardAction:BaseAction<[Board], errorHandler> = BaseAction()
    
    var boards : [Board] = []
    var category:Observable<String> = Observable("FREE")
    var page:Int = 0
    var size:Int = 20
    var isLastPage:Bool = false
    var requested:Bool = false
    
    init(){
        
    }
}

extension BoardViewModel{
    func getBoardsByCategory(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoardWithCategory(self.category.value))
        request.sendRequest(request: request, responseType: [Board].self, errorType: errorHandler.self, action:self.getBoardAction)
    }
    
    mutating func getBoardsByFirstPage(){
        self.page = 0
        self.getBoardsByPaging()
    }
    
    mutating func getBoardsByPaging(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoardPaging(self.category.value, self.page, self.size))
        request.sendRequest(request: request, responseType: BoardsWithPaging.self, errorType: errorHandler.self, action:self.BoardsByPagingAction)
    }
    
    public func getBoardBySearch(searchType:SearchType, parameter:String) {
        var request:Request! = Request(requestBodyObject: nil, requestMethod: .get, enviroment: nil)
        
        switch searchType {
        case .title:
            request.enviroment = .getBoardWithTitle(parameter)
        case .content:
            request.enviroment = .getBoardWithContent(parameter)
        case .author:
            request.enviroment = .getBoardWithAuthor(parameter)
        case .category:
            request.enviroment = .getBoardWithCategory(parameter)
        }
        
        request.sendRequest(request: request, responseType: [Board].self, errorType: errorHandler.self, action:self.getBoardAction)
    }
    
    func getBoardsByMyBoards(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getMyBoard)
        request.sendRequest(request: request, responseType: [Board].self, errorType: errorHandler.self, action:self.getBoardAction)
    }
}

enum SearchType{
    case title
    case content
    case author
    case category
}


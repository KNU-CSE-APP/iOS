//
//  BoardViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct BoardViewModel{
    var BoardsByCategoryAction: BaseAction<[Board], errorHandler> = BaseAction()
    var BoardsByPagingAction: BaseAction<BoardsWithPaging, errorHandler> = BaseAction()
    
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
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoardCategory(self.category.value))
        request.sendRequest(request: request, responseType: [Board].self, errorType: errorHandler.self, action:self.BoardsByCategoryAction)
    }
    
    mutating func getBoardsByPaging(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getBoardPaging(self.category.value, self.page, self.size))
        request.sendRequest(request: request, responseType: BoardsWithPaging.self, errorType: errorHandler.self, action:self.BoardsByPagingAction)
    }
}

//
//  BoardWriteViewModel+Model.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/09.
//

import Foundation

struct boardWriteHandler:Codable{
    var boardId:Int
    var category:String
    var title:String
    var content:String
    var author:String
    var time:String
    var commentCnt:Int
}

struct BoardWriteViewModel{
    var Listener: BaseAction<boardWriteHandler, errorHandler> = BaseAction()
    var model:BoardWriteModel = BoardWriteModel(category: "", content: "", title: "")
    var shouldbeReload:Observable<Bool> = Observable(false)
    var images: [String] = []
    
    init() {
        
    }
    
    public func BoardWriteRequest() {
        let request = Request(requestBodyObject: self.model, requestMethod: .post, enviroment: .BoardWrite)
        request.sendRequest(request: request, responseType: boardWriteHandler.self, errorType: errorHandler.self, action:self.Listener)
    }
}

class BoardWriteModel:BaseObject{
    var category:String
    var content:String
    var title:String
    
    init(category:String, content:String, title:String){
        self.category = category
        self.content = content
        self.title = title
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(content, forKey: .content)
        try container.encode(title, forKey: .title)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
       case category, content, title
     }
}

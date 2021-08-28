//
//  BoardWriteViewModel+Model.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/09.
//

import Foundation
import Alamofire

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
    var writeListener: BaseAction<boardWriteHandler, errorHandler> = BaseAction()
    var editListener: BaseAction<String, errorHandler> = BaseAction()
    var model:
        Observable<BoardWriteModel> = Observable(BoardWriteModel(category: "", content: "", title: ""))
    var shouldbeReload:Observable<Bool> = Observable(false)
    
    var boardId:Int!
    var imageData: [Data] = []{
        didSet{
            self.model.value.file = self.imageData
        }
    }
    
    init() {
        
    }
    
    public func request(parentType:ParentType){
        switch parentType {
        case .Write:
            self.BoardWriteRequest()
        case .Edit:
            self.BoardEditRequest()
        default:
            break
        }
    }
    
    public func BoardWriteRequest() {
        let request = Request(requestMultipart: model.value.getMultipart(), requestMethod: .post, enviroment:.BoardWrite)
        request.sendMutiPartRequest(request: request, responseType: boardWriteHandler.self, errorType: errorHandler.self, action: self.writeListener)
    }
    
    public func BoardEditRequest() {
        let request = Request(requestMultipart: model.value.getMultipart(), requestMethod: .put, enviroment:.editBoard(self.boardId))
        request.sendMutiPartRequest(request: request, responseType: String.self, errorType: errorHandler.self, action: self.editListener)
    }
}

class BoardWriteModel:BaseObject{
    var category: String
    var content: String
    var title: String
    var deleteUrl: [String] = []
    var file: [Data]?
    
    init(category:String, content:String, title:String){
        self.category = category
        self.content = content
        self.title = title
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func getMultipart()->MultipartFormData{
        let multipartFormData = MultipartFormData()
        
        multipartFormData.append(Data(category.utf8), withName: "category")
        multipartFormData.append(Data(title.utf8), withName: "title")
        multipartFormData.append(Data(content.utf8), withName: "content")
        
        if deleteUrl.count > 0 {
            for url in self.deleteUrl{
                if let data = url.data(using: .utf8) {
                    multipartFormData.append(data, withName: "deleteUrl"+"[]" )
                }
            }
        }
        
        if let file = self.file{
            var cnt = 1
            for data in file{
                multipartFormData.append(data, withName: "file", fileName: "board\(cnt).jpg", mimeType: "image/jpeg")
            }
            cnt += 1
        }
        
        return multipartFormData
    }
}

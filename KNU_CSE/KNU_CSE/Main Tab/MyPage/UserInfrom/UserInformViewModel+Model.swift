//
//  UserInformViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/31.
//

import Foundation
import Alamofire

struct UserInformViewModel{
    var model:Profile!
    var getInformlistener: BaseAction<Profile, errorHandler> = BaseAction()
    var setInformlistener: BaseAction<String, errorHandler> = BaseAction()
    
    init(){
        
    }
    
    func getUserInform(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getInform)
        request.sendRequest(request: request, responseType: Profile.self, errorType: errorHandler.self, action:self.getInformlistener)
    }
    
    func setUserInform(){
        let request = Request(requestMultipart: model.getMultipart(), requestMethod: .put, enviroment:.setInform)
        request.sendMutiPartRequest(request: request, responseType: String.self, errorType: errorHandler.self, action: self.setInformlistener)
    }
}

class Profile:BaseObject{
    var email:String!
    var imagePath:String!
    var editedNickname:String!
    var nickname:String!
    var userId:Int!
    var username:String!
    var studentId:String!
    var imageData:Data!
    
    init(email:String, imagePath:String, nickname:String, userId:Int){
        self.email = email
        self.imagePath = imagePath
        self.nickname = nickname
        self.userId = userId
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imagePath = (try? container.decode(String.self, forKey: .imagePath)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.username = (try? container.decode(String.self, forKey: .username)) ?? ""
        self.nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.editedNickname = nickname
        self.studentId = (try? container.decode(String.self, forKey: .studentId)) ?? ""
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(imageData, forKey: .image)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case email, imagePath, nickname, userId, username, studentId
        case name,image
     }
    
    func getMultipart()->MultipartFormData{
        let multipartFormData = MultipartFormData()
        
        if editedNickname != nickname{
            multipartFormData.append(Data(editedNickname.utf8), withName: "nickName")
        }
        
        if let image = imageData{
            multipartFormData.append(image, withName: "image", fileName: "\(String(describing: nickname))_profile", mimeType: "image/jpeg")
        }else{
            multipartFormData.append(Data("".utf8), withName: "image")
        }
        return multipartFormData
    }
}
    

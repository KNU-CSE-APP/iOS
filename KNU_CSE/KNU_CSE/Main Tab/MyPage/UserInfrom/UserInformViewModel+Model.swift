//
//  UserInformViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/31.
//

import Foundation

struct UserInformViewModel{
    var model:Profile!
    var getInformlistener: BaseAction<Profile, errorHandler> = BaseAction()
    
    init(){
        
    }
    
    func getUserInform(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getInform)
        request.sendRequest(request: request, responseType: Profile.self, errorType: errorHandler.self, action:self.getInformlistener)
    }
    
    func setUserInform(){
        let request = Request(requestBodyObject: self.model, requestMethod: .put, enviroment: .getInform)
        request.sendRequest(request: request, responseType: Profile.self, errorType: errorHandler.self, action:self.getInformlistener)
    }
}

class Profile:BaseObject{
    var email:String!
    var imagePath:String!
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
        imagePath = (try? container.decode(String.self, forKey: .imagePath)) ?? ""
        email = (try? container.decode(String.self, forKey: .email)) ?? ""
        username = (try? container.decode(String.self, forKey: .username)) ?? ""
        nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        studentId = (try? container.decode(String.self, forKey: .studentId)) ?? ""
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nickname, forKey: .name)
        try container.encode(imageData, forKey: .file)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case email, imagePath, nickname, userId, username, studentId
        case name,file
     }
}

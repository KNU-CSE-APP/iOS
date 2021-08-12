//
//  BoardSearchViewModel+Model.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/09.
//

import Foundation

//struct BoardSearchViewModel{
//    var model:BoardSearchModel = BoardSearchModel(email: "", imagePath: "", nickname: "", userId: -1)
//    var getInformlistener: BaseAction<BoardSearchModel, errorHandler> = BaseAction()
//
//    func get
//}
//
//class BoardSearchModel:BaseObject{
//    var email:String
//    var imagePath:String
//    var nickname:String
//    var userId:Int
//
//    init(email:String, imagePath:String, nickname:String, userId:Int){
//        self.email = email
//        self.imagePath = imagePath
//        self.nickname = nickname
//        self.userId = userId
//        super.init()
//    }
//
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
//
//    override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(email, forKey: .email)
//        try container.encode(imagePath, forKey: .imagePath)
//        try container.encode(nickname, forKey: .nickname)
//        try container.encode(userId, forKey: .userId)
//        try super.encode(to: encoder)
//    }
//
//    enum CodingKeys: CodingKey {
//       case email, imagePath, nickname, userId
//     }
//}

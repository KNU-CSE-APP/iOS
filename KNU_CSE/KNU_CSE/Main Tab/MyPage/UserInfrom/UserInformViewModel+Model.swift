//
//  UserInformViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/31.
//

import Foundation

struct UserInformViewModel{
    let profile:Profile = Profile(image: "https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg", Username: "노준석", Nickname: "IYNONE", Student_ID: "2016117285")
    var imageData:Data!
    
    init(){
        
    }
    
}




class Profile:BaseObject{
    let image:String
    let Username:String
    let Nickname:String
    let Student_ID:String
    
    init(image:String, Username:String, Nickname:String, Student_ID:String) {
        self.image = image
        self.Username = Username
        self.Nickname = Nickname
        self.Student_ID = Student_ID
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

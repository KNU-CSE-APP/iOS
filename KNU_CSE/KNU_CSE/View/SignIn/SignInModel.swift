//
//  File.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/16.
//

import Foundation

class SignInModel : BaseObject{
    var email:String
    var password:String
    
    init(email:String, password:String) {
        self.email = email
        self.password = password
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if email != "" &&  password != ""{
            return true
        }else{
            return false
        }
    }
    
    enum CodingKeys: CodingKey {
       case email, password
     }
}


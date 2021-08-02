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
}


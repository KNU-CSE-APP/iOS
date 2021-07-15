//
//  Model.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

class Account : BaseObject{
    var email : String
    var password : String
    var password2 : String
    var username : String
    var nickname : String
    var student_id : String
    var gender : String
    var major : String
    
    init(email : String, password : String, password2 : String, username : String, nickname : String, student_id : String, gender : String, major : String){
        self.email = email
        self.password = password
        self.password2 = password2
        self.username = username
        self.nickname = nickname
        self.student_id = student_id
        self.gender = gender
        self.major = major
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

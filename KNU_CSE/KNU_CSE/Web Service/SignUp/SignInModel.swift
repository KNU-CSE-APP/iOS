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
    var name : String
    var student_id : String
    
    init(email : String, password : String, password2 : String, name : String, student_id : String){
        self.email = email
        self.password = password
        self.password2 = password2
        self.name = name
        self.student_id = student_id
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

//
//  Model.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

class Account : BaseObject{
    var email : String
    var password : String
    var permissionCode : String
    var username : String
    var nickname : String
    var studentId : String
    var gender : String
    var major : String
    
    init(email : String, password : String, permissionCode : String, username : String, nickname : String, studentId : String, gender : String, major : String){
        self.email = email
        self.password = password
        self.permissionCode = permissionCode
        self.username = username
        self.nickname = nickname
        self.studentId = studentId
        self.gender = gender
        self.major = major
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(permissionCode, forKey: .permissionCode)
        try container.encode(username, forKey: .username)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(studentId, forKey: .studentId)
        try container.encode(gender, forKey: .gender)
        try container.encode(major, forKey: .major)
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if email != "" &&  password != "" && permissionCode != ""
            && username != "" && nickname != ""
            && studentId != "" && gender != "" && major != ""{
            return true
        }else{
            return false
        }
    }
    
    enum CodingKeys: CodingKey {
       case email, password, permissionCode, username, nickname, studentId, gender, major
     }
    
    func getEmailRequest()->Verification{
        return Verification(email: self.email, code: self.permissionCode)
    }
}

class Verification:BaseObject{
    var email:String
    var code:String
    
    init(email:String, code:String){
        self.email = email
        self.code = code
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(code, forKey: .code)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
       case email, code
     }
}


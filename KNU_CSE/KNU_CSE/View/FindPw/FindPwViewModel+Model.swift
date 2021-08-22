//
//  FindPwViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/30.
//

import UIKit

class FindPwViewModel {
    typealias Listener = (FindPwModel) -> Void
    var listener: Listener?
    var account: FindPwModel = FindPwModel(email: "", code: "", password: "", password2: "")
    var emailCodeAction:BaseAction<String,errorHandler> = BaseAction()
    var emailCodeConfirmAction:BaseAction<String,errorHandler> = BaseAction()
    var modifyPwAction:BaseAction<String,errorHandler> = BaseAction()
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func SignUpCheck()-> Bool{
        return account.Check()
    }
    
    func requestCode(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .codeForPw("\(account.email)@knu.ac.kr"))
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.emailCodeAction)
    }
    
    func requestCodeConfirm(){
        let body = PwConfirmBody(email: "\(account.email)@knu.ac.kr", code: self.account.code)
        let request = Request(requestBodyObject: body, requestMethod: .post, enviroment: .codeConfirmForPw)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.emailCodeConfirmAction)
    }
    
    func modifyPw(){
        let body = ModifyPwBody(email: "\(account.email)@knu.ac.kr", password: self.account.password, permissionCode: self.account.code)
        let request = Request(requestBodyObject: body, requestMethod: .post, enviroment: .changePasswordForFindPw)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.modifyPwAction)
    }
}

class FindPwModel: BaseObject{
    var email : String
    var code: String
    var password : String
    var password2 : String
    
    init(email : String, code: String, password : String, password2 : String){
        self.email = email
        self.code = code
        self.password = password
        self.password2 = password2
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if self.password != "" && self.code != "" && self.password2 != "" && self.password == self.password2{
            return true
        }else{
            return false
        }
    }
}

class PwConfirmBody:BaseObject{
    var email : String!
    var code: String!
    
    init(email:String, code:String) {
        self.email = email
        self.code = code
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
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


class ModifyPwBody:BaseObject{
    var email : String!
    var password: String!
    var permissionCode: String!
    
    init(email:String, password:String, permissionCode:String) {
        self.email = email
        self.password = password
        self.permissionCode = permissionCode
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(permissionCode, forKey: .permissionCode)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case email, password, permissionCode
     }
    
}


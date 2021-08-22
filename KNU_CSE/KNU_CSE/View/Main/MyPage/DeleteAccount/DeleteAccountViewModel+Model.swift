//
//  DeleteAccountViewModel + Model.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/23.
//

import Foundation

class DeleteAccountViewModel {
    var deleteAccountAction: BaseAction<String, errorHandler> = BaseAction()
    var model: DeleteAccountModel = DeleteAccountModel(password: "", password2: "")
    
    init(){
        
    }
    
    func PwCheck()-> Bool{
        return model.Check()
    }
    
    public func deleteAccount(){
        let request = Request(requestBodyObject: self.model, requestMethod: .delete, enviroment: .deleteAccount)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.deleteAccountAction)
    }
}

class DeleteAccountModel: BaseObject{
    var password:String
    var password2:String
    
    init(password : String, password2 : String){
        self.password = password
        self.password2 = password2
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if self.password != "" && self.password2 != "" &&  self.password == self.password2{
            return true
        }else{
            return false
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(password, forKey: .password)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
       case password
     }
}

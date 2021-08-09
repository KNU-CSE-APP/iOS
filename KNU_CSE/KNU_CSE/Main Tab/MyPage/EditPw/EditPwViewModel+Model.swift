//
//  EditPwViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/06.
//

import Foundation

class EditPwViewModel {
    var editPwListener: BaseAction<String, errorHandler> = BaseAction()
    var model: EditPwModel = EditPwModel(changePassword: "", changePassword2: "", currentPassword:"")
    
    init(){
        
    }
    
    func PwCheck()-> Bool{
        return model.Check()
    }
    
    public func EditPw(){
        let request = Request(requestBodyObject: self.model, requestMethod: .put, enviroment: .changePassword)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.editPwListener)
    }
}

class EditPwModel: BaseObject{
    var changePassword:String
    var changePassword2:String
    var currentPassword:String
    
    init(changePassword : String, changePassword2 : String, currentPassword : String){
        self.changePassword = changePassword
        self.changePassword2 = changePassword2
        self.currentPassword = currentPassword
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if self.changePassword != "" && self.changePassword2 != "" && self.currentPassword != "" && self.changePassword == self.changePassword2{
            return true
        }else{
            return false
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(changePassword, forKey: .changePassword)
        try container.encode(currentPassword, forKey: .currentPassword)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
       case changePassword, currentPassword
     }
}

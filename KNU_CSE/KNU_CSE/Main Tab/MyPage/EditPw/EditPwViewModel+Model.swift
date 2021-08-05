//
//  EditPwViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/06.
//

import Foundation

class EditPwViewModel {
    typealias Listener = (EditPwModel) -> Void
    var listener: Listener?
    var account: EditPwModel = EditPwModel(email: "", changePassword: "", changePassword2: "", currentPassword:"")
    var emailCode:String!
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func SignUpCheck()-> Bool{
        return account.Check()
    }
}

class EditPwModel: BaseObject{
    var email:String
    var changePassword:String
    var changePassword2:String
    var currentPassword:String
    
    init(email : String, changePassword : String, changePassword2 : String, currentPassword : String){
        self.email = email
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
}

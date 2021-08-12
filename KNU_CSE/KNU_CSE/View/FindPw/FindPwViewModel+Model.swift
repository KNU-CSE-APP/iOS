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
    var account: FindPwModel = FindPwModel(email: "", password: "", password2: "")
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

class FindPwModel: BaseObject{
    var email : String
    var password : String
    var password2 : String
    
    init(email : String, password : String, password2 : String){
        self.email = email
        self.password = password
        self.password2 = password2
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func Check() -> Bool{
        if self.password != "" && self.password2 != "" && self.password == self.password2{
            return true
        }else{
            return false
        }
    }
}

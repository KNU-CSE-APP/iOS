//
//  SignInViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import Alamofire
import Foundation
import UIKit

class SignInViewModel{
    var signInListener: BaseAction<signInHandler, errorHandler> = BaseAction()
    var account: SignInModel = SignInModel(email: "", password: "")
    
    init(){
        
    }
    
    public func SignInRequest() {
        let request = Request(requestBodyObject: self.account, requestMethod: .post, enviroment: .SignIn)
        request.sendRequest(request: request, responseType: signInHandler.self, errorType: errorHandler.self, action:self.signInListener)
    }

    func SignInCheck()-> Bool{
        return account.Check()
    }
}

extension SignInViewModel{
    func storeUserAccount(){
        guard StorageManager.shared.readUser() != nil else {
            StorageManager.shared.createUser(User(email: account.email, password: account.password))
            return
        }
        
        if StorageManager.shared.deleteUser(){
            StorageManager.shared.createUser(User(email: account.email, password: account.password))
        }
    }
    
    func storeUserEmail(){
        guard StorageManager.shared.readUser() != nil else {
            StorageManager.shared.createUser(User(email: account.email, password: ""))
            return
        }
        
        if StorageManager.shared.deleteUser(){
            StorageManager.shared.createUser(User(email: account.email, password: ""))
        }
    }
    
    func removeUserAccount(){
        if StorageManager.shared.deleteUser(){
            print("Success remove UserAccount")
        }else{
            print("Fail remove UserAccount")
        }
    }
    
    func checkUserAccount()->Bool{
        guard let user = StorageManager.shared.readUser() else {
            return false
        }
        if user.password == ""{ return false }
        else {
            self.account.email = user.email
            self.account.password = user.password
            return true
        }
    }
}

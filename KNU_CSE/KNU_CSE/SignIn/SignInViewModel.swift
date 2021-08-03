//
//  SignInViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/15.
//

import Alamofire
import Foundation
import UIKit

class SignInViewModel {
    typealias Listener = (SignInModel) -> Void
    var listener: Listener?
    var account: SignInModel = SignInModel(email: "", password: "")
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    public func SignInRequest(successHandler: @escaping (ResponseBody<signInHandler,errorHandler>) -> (), failHandler: @escaping (Error) -> (),asyncHandler:@escaping()->()) {
        let request = Request(requestBodyObject: self.account, requestMethod: .post, enviroment: .SignIn)
        request.sendRequest(request: request, type: ResponseBody<signInHandler,errorHandler>.self, successHandler: successHandler, failHandler: failHandler, asyncHandler: asyncHandler)
    }
    
    func SignInCheck()-> Bool{
        return account.Check()
    }
    
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
        else { return true }
    }
}


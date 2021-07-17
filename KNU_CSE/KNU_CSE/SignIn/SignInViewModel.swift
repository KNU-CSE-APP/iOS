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
    typealias Listener = (Account) -> Void
    var listener: Listener?
    var account: SignInModel = SignInModel(email: "", password: "")
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    public func getEvent(successHandler: @escaping (Response) -> (), failHandler: @escaping (Error) -> (),asyncHandler:@escaping()->()) {
        let signUpRequest = Request(requestBodyObject: self.account, requestMethod: .Post, enviroment: .SignIn)
        signUpRequest.sendRequest(request: signUpRequest, type: Response.self, successHandler: successHandler, failHandler: failHandler, asyncHandler: asyncHandler)
    }
    
    func SignInCheck()-> Bool{
        return account.Check()
    }
}


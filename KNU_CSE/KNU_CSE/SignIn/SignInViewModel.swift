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
    var account: Account = Account(email: "", password: "", password2: "", username: "", nickname: "", student_id: "", gender: "", major: "")

    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }

    
//    public func getEvent(successHandler: @escaping (Response) -> (), failHandler: @escaping (Error) -> ()) {
//        let signInRequest = SignInRequest(requestBodyObject: self.account, requestMethod: .Post, enviroment: .SignIn)
//        sendRequest(request: signInRequest, type: Response.self, successHandler: successHandler, failHandler: failHandler)
//    }
//
}


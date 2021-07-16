//
//  ViewModel.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Alamofire
import Foundation
import UIKit

class SignUpViewModel {
    typealias Listener = (Account) -> Void
    var listener: Listener?
    var account: Account = Account(email: "", password: "", password2: "", username: "", nickname: "", student_id: "", gender: "", major: "")
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    public func getEvent(successHandler: @escaping (Response) -> (), failHandler: @escaping (Error) -> ()) {
        let signUpRequest = Request(requestBodyObject: self.account, requestMethod: .Post, enviroment: .SignUp)
        signUpRequest.sendRequest(request: signUpRequest, type: Response.self, successHandler: successHandler, failHandler: failHandler)
    }
    
}

struct Response : Codable{
    var result : Int
}

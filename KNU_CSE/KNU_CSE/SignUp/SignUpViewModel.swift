//
//  ViewModel.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Alamofire
import Foundation
import UIKit

struct SignUpViewModel {
    typealias Listener = (Account) -> Void
    var listener: Listener?
    var account: Account = Account(email: "", password: "", permissionCode: "", username: "", nickname: "", studentId: "", gender: "", major: "")
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    mutating func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func getEvent(successHandler: @escaping (ResponseBody<String,errorHandler>) -> (), failHandler: @escaping (Error) -> (),asyncHandler:@escaping()->()) {
        let signUpRequest = Request(requestBodyObject: self.account, requestMethod: .post, enviroment: .SignUp)
        signUpRequest.sendRequest(request: signUpRequest, type: ResponseBody<String,errorHandler>.self, successHandler: successHandler, failHandler: failHandler, asyncHandler: asyncHandler)
    }
    
    func SignUpCheck()-> Bool{
        return account.Check()
    }
}

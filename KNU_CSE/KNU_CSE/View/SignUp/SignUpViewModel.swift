//
//  ViewModel.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Alamofire
import Foundation
import UIKit

struct SignUpViewModel{
    var account: Account = Account(email: "", password: "", permissionCode: "", username: "", nickname: "", studentId: "", gender: "", major: "")
    var codeRequestListner:BaseAction<String,errorHandler> = BaseAction()
    var codeConfirmListner:BaseAction<String,errorHandler> = BaseAction()
    var signUpListner:BaseAction<String,errorHandler> = BaseAction()
    
    init(){
        
    }
    
    func SignUpCheck()-> Bool{
        return account.Check()
    }
}

extension SignUpViewModel{
    func CodeRequest() {
        let request = Request(requestBodyObject:nil, requestMethod: .get, enviroment: .codeRequest(self.account.email))
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.codeRequestListner)
    }
    
    func CodeConfirm() {
        let request = Request(requestBodyObject:account.getEmailRequest(), requestMethod: .post, enviroment: .codeConfirm)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.codeConfirmListner)
    }
    
    func SignUp() {
        let request = Request(requestBodyObject: self.account, requestMethod: .post, enviroment: .SignUp)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.signUpListner)
    }
}

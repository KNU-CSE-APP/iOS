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
    var codeRequestListner:BaseAction<String> = BaseAction()
    var codeConfirmListner:BaseAction<String> = BaseAction()
    var signUpListner:BaseAction<String> = BaseAction()
    
    init(){
        
    }
    
    func SignUpCheck()-> Bool{
        return account.Check()
    }
}

extension SignUpViewModel{
    func CodeRequest() {
        let codeRequest = Request(requestBodyObject:nil, requestMethod: .get, enviroment: .CodeRequest(self.account.email))
        codeRequest.sendRequest(request: codeRequest, type: ResponseBody<String,errorHandler>.self, successHandler: codeRequestListner.successHandler, failHandler: codeRequestListner.failHandler, asyncHandler: codeRequestListner.asyncHandler, endHandler: codeRequestListner.endHandler)
    }
    
    func CodeConfirm() {
        let codeConfirm = Request(requestBodyObject:account.getEmailRequest(), requestMethod: .post, enviroment: .CodeConfirm)
        codeConfirm.sendRequest(request: codeConfirm, type: ResponseBody<String,errorHandler>.self, successHandler: codeConfirmListner.successHandler, failHandler: codeConfirmListner.failHandler, asyncHandler: codeConfirmListner.asyncHandler, endHandler: codeConfirmListner.endHandler)
    }
    
    func SignUp() {
        let signUpRequest = Request(requestBodyObject: self.account, requestMethod: .post, enviroment: .SignUp)
        signUpRequest.sendRequest(request: signUpRequest, type: ResponseBody<String,errorHandler>.self, successHandler: signUpListner.successHandler, failHandler: signUpListner.failHandler, asyncHandler: signUpListner.asyncHandler,endHandler: signUpListner.endHandler)
    }
}

//
//  2.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/09.
//

struct SignInRequest: BaseApiRequest {
    var requestBodyObject: BaseObject?
    var requestMethod: RequestHttpMethod? = RequestHttpMethod.Post
    var enviroment: Environment = .SignIn
    
    mutating func setBodyObject(bodyObject: Account) {
        self.requestBodyObject = bodyObject
    }
}



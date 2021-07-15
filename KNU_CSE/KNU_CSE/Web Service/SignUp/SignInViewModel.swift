//
//  ViewModel.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/05.
//

import Alamofire
import Foundation
import UIKit

class SignInViewModel {
    typealias Listener = (Account) -> Void
    var listener: Listener?
    var account: Account = Account(email: "", password: "", password2: "", name: "", student_id: "")
    
    init(listener : Listener?){
        self.listener = listener
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }

    private func sendRequest<T:Codable>( request:BaseApiRequest, type :T.Type,successHandler:@escaping(T)->(),failHandler:@escaping(Error)->()){
        AF.request(request.request()).responseDecodable { (response:AFDataResponse<T>) in
             switch response.result{
                       case .success(let responseEventList):
                        successHandler(responseEventList)
                           print("success")
                       case .failure(let error):
                           failHandler(error)
                           print("fail")
            }
        }
    }
    
    public func getEvent(successHandler: @escaping (Response) -> (), failHandler: @escaping (Error) -> ()) {
        let signInRequest = SignInRequest(requestBodyObject: self.account, requestMethod: .Post, enviroment: .SignIn)
        sendRequest(request: signInRequest, type: Response.self, successHandler: successHandler, failHandler: failHandler)
    }
    
}

struct Response : Codable{
    var result : Int
}

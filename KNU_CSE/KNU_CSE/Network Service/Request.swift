//
//  2.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/09.
//
import Alamofire

struct Request: BaseApiRequest {
    
    var requestBodyObject: BaseObject?
    var requestMethod: RequestHttpMethod? = RequestHttpMethod.post
    var enviroment: Environment?
    
    mutating func setBodyObject(bodyObject: BaseObject?) {
        self.requestBodyObject = bodyObject
    }
    
    func sendRequest<T:Codable,V:Codable>( request:BaseApiRequest, responseType :T.Type,errorType:V.Type, action:BaseAction<T,V>){
        action.asyncHandler()
        AF.request(request.request()).responseDecodable { (response:AFDataResponse<ResponseBody<T,V>>) in
             switch response.result{
             case .success(let responseEventList):
                action.successHandler(responseEventList)
                   print("success")
               case .failure(let error):
                action.failHandler(error)
                   print("fail")
            }
            action.endHandler()
        }
    }
}

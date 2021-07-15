//
//  2.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/09.
//
import Alamofire

struct SignUpRequest: BaseApiRequest {
    var requestBodyObject: BaseObject?
    var requestMethod: RequestHttpMethod? = RequestHttpMethod.Post
    var enviroment: Environment?
    
    mutating func setBodyObject(bodyObject: Account) {
        self.requestBodyObject = bodyObject
    }
    
    func sendRequest<T:Codable>( request:BaseApiRequest, type :T.Type,successHandler:@escaping(T)->(),failHandler:@escaping(Error)->()){
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
}

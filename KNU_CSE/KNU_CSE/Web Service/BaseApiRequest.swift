//
//  URL.swift
//  MVVM_Practice
//
//  Created by junseok on 2021/07/09.
//

//
//  ApiRequest.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import Alamofire

protocol BaseApiRequest {
    var requestMethod: RequestHttpMethod?{ get }
    var requestBodyObject: BaseObject?{ get }
    func request() -> URLRequest
    var enviroment: Environment { get }
}

extension BaseApiRequest{
    
    public func request() -> URLRequest {
        let url: URL! = URL(string: baseUrl)
        var request = URLRequest(url: url)
        switch requestMethod {
        case .Get:
            request.httpMethod = "GET"
            break
        case .Post:
            request.httpMethod = "POST"
            if(requestBodyObject != nil){
                let jsonEncoder = JSONEncoder()
                do {
                    request.httpBody = try jsonEncoder.encode(requestBodyObject)
                } catch  {
                    print(error)
                }
            }
            break
        default:
            request.httpMethod = "GET"
            break
        }
        return request
    }
    
    var baseUrl: String {
        switch enviroment {
        case .SignIn:
            return "http://218.233.221.188:5002/SignIn"
        default:
            return "http://api.myjson.com/"
        }
    }
}

enum RequestHttpMethod{
    case Get
    case Post
}

enum Environment{
    case SignIn
}





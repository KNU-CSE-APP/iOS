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
    var requestMultipart:MultipartFormData!{ get }
    func request() -> URLRequest
    var enviroment: Environment? { get }
}

extension BaseApiRequest{
    func getAddress(domain:String)->String{
//        let ip = "218.233.221.188"
//        let port = "5002"
//
        let ip = "3.34.14.12"
        let port = ""
        
        if port == ""{
            return  "http://\(ip)/\(domain)"
        }else{
            return "http://\(ip):\(port)/\(domain)"
        }
    }
    
    public func request() -> URLRequest {
        let url: URL! = URL(string: baseUrl)
        print(baseUrl)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch requestMethod {
        case .get:
            request.method = .get
            break
        case .post:
            request.method = .post
            if(requestBodyObject != nil){
                let jsonEncoder = JSONEncoder()
                do {
                    if let data = try? jsonEncoder.encode(requestBodyObject.self){
                        let jsonString = String(decoding: data, as: UTF8.self)
                        request.httpBody = data
                        print(jsonString)
                    }
                }
            }
            break
        case .put:
            request.method = .put
            if(requestBodyObject != nil){
                let jsonEncoder = JSONEncoder()
                do {
                    if let data = try? jsonEncoder.encode(requestBodyObject.self){
                        let jsonString = String(decoding: data, as: UTF8.self)
                        request.httpBody = data
                        print(jsonString)
                    }
                }
            }
        default:
            request.httpMethod = "GET"
            break
        }
        return request
    }
    
    var baseUrl: String {
        switch enviroment {
        case .SignIn:
            return getAddress(domain: "user/signIn")
        case .SignUp:
            return getAddress(domain: "user/signUp")
        case .getInform:
            return getAddress(domain: "user/getUserEmailNickname")
        case .setInform:
            return getAddress(domain: "user/image/nickname")
        case .changePassword:
            return getAddress(domain: "user/changePassword")
        case .CodeRequest(let email):
            return "\(getAddress(domain: "user/verify"))/\(email)"
        case .CodeConfirm:
            return getAddress(domain: "user/verify")
        case .BoardWrite:
            return getAddress(domain: "board/write")
        case .getBoardCategory(let category):
            return getAddress(domain: "board/findCategory?category=\(category)")
        case .getBoard(let boardId):
            return getAddress(domain: "board/\(boardId)")
        case .writeComment:
            return getAddress(domain: "comment/write")
        case .writeReply:
            return getAddress(domain: "comment/reply/write")
        case .findContentsByBoardId(let boardId):
            return getAddress(domain: "comment/findContentsByBoardId?boardId=\(boardId)")
        case .none:
            return ""
        }
    }
}

enum RequestHttpMethod{
    case get
    case post
    case put
}

enum Environment{
    case SignIn
    case SignUp
    case getInform
    case setInform
    case changePassword
    case CodeRequest(String)
    case CodeConfirm
    case BoardWrite
    case getBoardCategory(String)
    case getBoard(Int)
    case writeComment
    case writeReply
    case findContentsByBoardId(Int)
}





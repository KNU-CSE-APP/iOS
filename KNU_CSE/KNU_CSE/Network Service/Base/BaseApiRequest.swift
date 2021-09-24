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
        let port = "8089"
        
        if port == ""{
            return  "http://\(ip)/\(domain)"
        }else{
            return "http://\(ip):\(port)/\(domain)"
        }
    }
    
    public func request() -> URLRequest {
        let encoding = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url: URL! = URL(string: encoding!)
        print(baseUrl)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch requestMethod {
        case .get:
            request.method = .get
        case .post:
            request.method = .post
        case .put:
            request.method = .put
        case .delete:
            request.method = .delete
        default:
            request.httpMethod = "GET"
            break
        }
        
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
        
        return request
    }
    
    var baseUrl: String {
        switch enviroment {
        case .SignIn:
            return getAddress(domain: "user/signIn")
        case .SignUp:
            return getAddress(domain: "user/signUp")
        case .deleteAccount:
            return getAddress(domain: "user/deleteMember")
        case .codeForPw(let email):
            return getAddress(domain: "user/findPassword/\(email)")
        case .codeConfirmForPw:
            return getAddress(domain: "user/verifyPassword")
        case .changePasswordForFindPw:
            return getAddress(domain: "user/changeValidatedPassword")
        case .getInform:
            return getAddress(domain: "user/getUserEmailNickname")
        case .setInform:
            return getAddress(domain: "user/image/nickname")
        case .resetImage:
            return getAddress(domain: "user/profileimage")
        case .changePassword:
            return getAddress(domain: "user/changePassword")
        case .codeRequest(let email):
            return (getAddress(domain: "user/verify/\(email)"))
        case .codeConfirm:
            return getAddress(domain: "user/verify")
        case .BoardWrite:
            return getAddress(domain: "board/write")
        case .getBoardPaging(let category, let page, let size):
            return getAddress(domain: "board/list?category=\(category)&page=\(page)&size=\(size)")
        case .getBoard(let boardId):
            return getAddress(domain: "board/\(boardId)")
        case .getBoardWithTitle(let title):
            return getAddress(domain: "board/findTitle?title=\(title)")
        case .getBoardWithContent(let content):
            return getAddress(domain: "board/findContent?content=\(content)")
        case .getBoardWithAuthor(let author):
            return getAddress(domain: "board/findAuthor?author=\(author)")
        case .getBoardWithCategory(let category):
            return getAddress(domain: "board/findCategory?category=\(category)")
        case .getMyBoard:
            return getAddress(domain: "board/findMyBoards")
        case .deleteBoard(let boardId):
            return getAddress(domain: "board/\(boardId)")
        case .editBoard(let boardId):
            return getAddress(domain: "board/\(boardId)")
        case .writeComment:
            return getAddress(domain: "comment/write")
        case .getComment(let commentId):
            return getAddress(domain: "comment/\(commentId)")
        case .deleteComment(let commentId):
            return getAddress(domain: "comment/\(commentId)")
        case .writeReply:
            return getAddress(domain: "comment/reply/write")
        case .findContentsByBoardId(let boardId):
            return getAddress(domain: "comment/findContentsByBoardId?boardId=\(boardId)")
        case .searchSeat(let building, let roomNumber):
            return getAddress(domain: "classRoom/searchSeats/\(building)/\(roomNumber)")
        case .getAllClassRoom:
            return getAddress(domain: "classRoom/searchAllClassRoom")
        case .reservation:
            return getAddress(domain: "reservation/reservation")
        case .reservationFind:
            return getAddress(domain: "reservation/findReservation")
        case .reservationDelete:
            return getAddress(domain: "reservation/delete")
        case .reservationExtension:
            return getAddress(domain: "reservation/extension")
        case .myReservation:
            return getAddress(domain: "reservation/findReservation")
        case .none:
            return ""
        }
    }
}

enum RequestHttpMethod{
    case get
    case post
    case put
    case delete
}

enum Environment{
    case SignIn
    case SignUp
    case deleteAccount
    case codeForPw(String)
    case codeConfirmForPw
    case changePasswordForFindPw
    case getInform
    case setInform
    case resetImage
    case changePassword
    case codeRequest(String)
    case codeConfirm
    case BoardWrite
    case getBoardPaging(String,Int,Int)
    case getBoard(Int)
    case getBoardWithTitle(String)
    case getBoardWithContent(String)
    case getBoardWithAuthor(String)
    case getBoardWithCategory(String)
    case getMyBoard
    case deleteBoard(Int)
    case editBoard(Int)
    case writeComment
    case getComment(Int)
    case deleteComment(Int)
    case writeReply
    case findContentsByBoardId(Int)
    case searchSeat(String, Int)
    case getAllClassRoom
    case reservation
    case reservationFind
    case reservationDelete
    case reservationExtension
    case myReservation
}





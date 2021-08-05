//
//  ResponseBody.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/04.
//

import Foundation

struct ResponseBody<T:Codable,V:Codable>:Codable{
    var success:Bool
    var response:T?
    var error:V?
}

struct signInHandler:Codable{
    var nickname:String
    var userId:Int
}

struct errorHandler:Codable{
    var message:String
    var status:Int
}


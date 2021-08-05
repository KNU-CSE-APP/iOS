//
//  BaseAction.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/06.
//

import Foundation

struct BaseAction<T:Codable>{
    var successHandler:((ResponseBody<T,errorHandler>) -> ())!
    var failHandler:((Error) -> ())!
    var asyncHandler:(()->())!
    var endHandler:(()->())!
    
    init(){
        self.successHandler = nil
        self.failHandler = nil
        self.asyncHandler = nil
        self.endHandler = nil
    }
    
    public mutating func binding(successHandler: @escaping (ResponseBody<T,errorHandler>) -> (), failHandler: @escaping (Error) -> (),asyncHandler:@escaping()->(),endHandler:@escaping()->()) {
        self.successHandler = successHandler
        self.failHandler = failHandler
        self.asyncHandler = asyncHandler
        self.endHandler =  endHandler
    }
}

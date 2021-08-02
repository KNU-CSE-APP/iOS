//
//  ReservationModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import Foundation

class ReservationCheckModel:BaseObject{
    var email:String
    var roomNum:Int
    var seatNumber:Int
    
    init(email:String, roomNum:Int, seatNumber:Int){
        self.email = email
        self.roomNum = roomNum
        self.seatNumber = seatNumber
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    static func returnCheckModel(email:String, roomNum:Int, seatNumber:Int)->ReservationCheckModel{
        return ReservationCheckModel(email: email, roomNum: roomNum, seatNumber: seatNumber)
    }
}

enum titleText:String{
    case inform = "좌석정보"
    case status = "이용상태"
    case startTime = "입실시간"
    case endTime = "퇴실시간"
}

enum contentText{
    case inform(String, String, String)
    case status(String)
    case startTime(String)
    case endTime(String)
}

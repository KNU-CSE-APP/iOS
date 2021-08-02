//
//  ReservationHistModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation

class ReservationHistModel:BaseObject{
    
    var building:String
    var roomNumber:Int
    var seatNumber:Int
    var extension_cnt:Int
    var startDate:String
    var endDate:String
    
    init(building:String, roomNumber:Int, seatNumber:Int, extension_cnt:Int, startDate:String, endDate:String) {
        self.building = building
        self.roomNumber = roomNumber
        self.seatNumber = seatNumber
        self.extension_cnt = extension_cnt
        self.startDate = startDate
        self.endDate = endDate
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}


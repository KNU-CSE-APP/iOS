//
//  ReservationHistModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation

class ReservationModel:BaseObject{
    
    var building:String
    var roomNumber:Int
    var seatNumber:Int
    var startDate:String
    var endDate:String
    
    init(building:String, roomNumber:Int, seatNumber:Int, startDate:String, endDate:String) {
        self.building = building
        self.roomNumber = roomNumber
        self.seatNumber = seatNumber
        self.startDate = startDate
        self.endDate = endDate
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

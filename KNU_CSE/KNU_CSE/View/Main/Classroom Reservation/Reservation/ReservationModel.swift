//
//  ReservationModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

class ClassSeat:BaseObject{
    var seatId:Int
    var seatNumber:Int
    var status:Bool
    
    init(seatId:Int, seatNumber:Int, status:Bool){
        self.seatId = seatId
        self.seatNumber = seatNumber
        self.status = status
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

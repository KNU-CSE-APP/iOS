//
//  ReservationCheckViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import Foundation

struct ReservationCheckViewModel{
    var building:String!
    var classSeat:ClassSeat!
    var classRoom:ClassRoom!
    
    var reservationCheckModel:ReservationCheckModel!
    
    init(email:String, building:String, classSeat:ClassSeat, classRoom:ClassRoom){
        self.classSeat = classSeat
        self.classRoom = classRoom
        reservationCheckModel = ReservationCheckModel.returnCheckModel(email: email, roomNum: classRoom.roomNum, seatNumber: classSeat.seatNumber)
    }
}

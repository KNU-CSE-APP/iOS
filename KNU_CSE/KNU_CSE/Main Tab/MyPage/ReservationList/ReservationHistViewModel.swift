//
//  ReservationHistViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation

struct ReservationHistViewModel{
    var reservationModel:ReservationModel!
    
    var reservationCheckModel:ReservationCheckModel!
    
    init(){
        self.setReservation()
    }

    mutating func setReservation(){
        self.reservationModel = ReservationModel(building: "IT4", roomNumber: 104, seatNumber: 5,startDate: "2021-07-27 22:11:55", endDate: "2021-07-28 05:11:55")
    }
    
    func getContentText()->[String]{
        
        let seatInfo = "\(reservationModel.building) \(reservationModel.roomNumber)호 \(reservationModel.seatNumber)번"
        let status = "예약중"
        let startDate = reservationModel.startDate
        let endDate = reservationModel.endDate
        
        return [seatInfo, status, startDate, endDate]
    }
}

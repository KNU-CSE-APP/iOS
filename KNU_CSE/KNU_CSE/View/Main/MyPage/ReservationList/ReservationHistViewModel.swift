//
//  ReservationHistViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation

struct ReservationHistViewModel{
    
    var reservationHistModel:ReservationHistModel!
    var deleteAction: BaseAction<String, errorHandler> = BaseAction()
    var extensionAction: BaseAction<Int, errorHandler> = BaseAction()
    
    init(){
        self.setReservation()
    }

    mutating func setReservation(){
        self.reservationHistModel = ReservationHistModel(building: "IT4", roomNumber: 104, seatNumber: 5,extension_cnt: 1, startDate: "2021-07-27 22:11:55", endDate: "2021-07-28 05:11:55")
    }
    
    func getContentText()->[String]{
        
        let seatInfo = "\(reservationHistModel.building) \(reservationHistModel.roomNumber)호 \(reservationHistModel.seatNumber)번"
        let status = "사용중"
        let extension_cnt = String(reservationHistModel.extension_cnt)
        let startDate = reservationHistModel.startDate
        let endDate = reservationHistModel.endDate
        
        return [seatInfo, status, extension_cnt, startDate, endDate]
    }
    
    func check()-> Bool{
        guard reservationHistModel != nil else{
            return false
        }
        return true
    }
}

extension ReservationHistViewModel{
    func reservationDelete(){
        let request = Request(requestBodyObject: nil, requestMethod: .post, enviroment: .reservationDelete)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.deleteAction)
    }
    
    func reservationExtend(){
        let request = Request(requestBodyObject: nil, requestMethod: .post, enviroment: .reservationExtension)
        request.sendRequest(request: request, responseType: Int.self, errorType: errorHandler.self, action:self.extensionAction)
    }
}

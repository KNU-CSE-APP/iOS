//
//  ReservationViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct ReservationViewModel{
    var classSeats : [ClassSeat] = []
    var seatIndex : Int!
        
    var classRoom : ClassRoom!
    
    var classSeatAction:BaseAction<[ClassSeat], errorHandler> = BaseAction()
    var reservationAction:BaseAction<String, errorHandler> = BaseAction()
    
    init(){

    }
    
    mutating func setClassRoom(classRoom:ClassRoom){
        self.classRoom = classRoom
    }
    
    func getClassSeats(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .searchSeat(classRoom.building, classRoom.roomNum))
        request.sendRequest(request: request, responseType: [ClassSeat].self, errorType: errorHandler.self, action:self.classSeatAction)
    }
    
    func reservation(){
        let body = ReservationBody(building: self.classRoom.building, roomNumber: self.classRoom.roomNum, seatNumber: self.classSeats[self.seatIndex].seatNumber)
        
        let request = Request(requestBodyObject: body, requestMethod: .post, enviroment: .reservation)
        request.sendRequest(request: request, responseType: String.self, errorType: errorHandler.self, action:self.reservationAction)
    }
    
    mutating func showSeatPicture(){
        
    }
    
}


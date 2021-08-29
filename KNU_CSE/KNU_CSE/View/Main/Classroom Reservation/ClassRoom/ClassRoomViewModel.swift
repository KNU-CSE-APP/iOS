//
//  SeatReservationViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation

struct ClassRoomViewModel{
    var classrooms : [ClassRoom] = []
    var classRoomsAction:BaseAction<[ClassRoom], errorHandler> = BaseAction(
    )
    
    init(){
        
    }
    
    func getClassRooms(){
        let request = Request(requestBodyObject: nil, requestMethod: .get, enviroment: .getAllClassRoom)
        request.sendRequest(request: request, responseType: [ClassRoom].self, errorType: errorHandler.self, action:self.classRoomsAction)
    }
}


//
//  SeatReservationViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation

struct ClassRoomViewModel{
    var classrooms : [ClassRoom] = []
   
    init(){
        self.setUpLecture()
    }
    
    mutating func setUpLecture(){
        classrooms.append(ClassRoom(roomId: 101, roomNum: 101, building: "IT4", totalSeat: 30, currentSeat: 10))
        classrooms.append(ClassRoom(roomId: 102, roomNum: 102, building: "IT4", totalSeat: 30, currentSeat: 11))
        classrooms.append(ClassRoom(roomId: 103, roomNum: 103, building: "IT4", totalSeat: 30, currentSeat: 12))
        classrooms.append(ClassRoom(roomId: 104, roomNum: 104, building: "IT4", totalSeat: 30, currentSeat: 13))
    }
}


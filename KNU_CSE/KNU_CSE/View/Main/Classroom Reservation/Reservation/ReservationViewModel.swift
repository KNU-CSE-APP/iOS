//
//  ReservationViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct ReservationViewModel{
    var classSeat : [ClassSeat] = []
    var classRoom : ClassRoom!
    typealias classRoomType = Int
    var classRoomNum : classRoomType!
    
    init(){
        self.setClassSeat()
    }
    
    mutating func setClassRoom(classRoom:ClassRoom){
        self.classRoom = classRoom
    }
    
    mutating func setClassSeat(){
        self.classSeat.append(ClassSeat(seatId: 1 , seatNumber: 1, status: true))
        self.classSeat.append(ClassSeat(seatId: 2 , seatNumber: 2, status: true))
        self.classSeat.append(ClassSeat(seatId: 3 , seatNumber: 3, status: false))
        self.classSeat.append(ClassSeat(seatId: 4 , seatNumber: 4, status: true))
        self.classSeat.append(ClassSeat(seatId: 5 , seatNumber: 5, status: false))
        self.classSeat.append(ClassSeat(seatId: 6 , seatNumber: 6, status: false))
        self.classSeat.append(ClassSeat(seatId: 7 , seatNumber: 7, status: true))
        self.classSeat.append(ClassSeat(seatId: 8 , seatNumber: 8, status: true))
        self.classSeat.append(ClassSeat(seatId: 9 , seatNumber: 9, status: false))
        self.classSeat.append(ClassSeat(seatId: 10 , seatNumber: 10, status: true))
        self.classSeat.append(ClassSeat(seatId: 11, seatNumber: 11, status: false))
        self.classSeat.append(ClassSeat(seatId: 12 , seatNumber: 12, status: true))
    }
    
    mutating func showSeatPicture(){
        
    }
    
}

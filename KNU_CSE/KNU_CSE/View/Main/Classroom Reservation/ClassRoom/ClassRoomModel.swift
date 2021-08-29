//
//  SeatReservationModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation

class ClassRoom:BaseObject{
    var roomId : Int!
    
    var building : String
    var roomNum : Int
    var totalSeat : Int
    var currentSeat : Int
    
    init(roomId:Int, roomNum:Int, building:String, totalSeat:Int, currentSeat:Int) {
        self.roomId = roomId
        self.roomNum = roomNum
        self.building = building
        self.totalSeat = totalSeat
        self.currentSeat = currentSeat
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.building = (try! container.decode(String.self, forKey: .building))
        self.roomNum = (try! container.decode(Int.self, forKey: .roomNumber))
        self.totalSeat = (try! container.decode(Int.self, forKey: .totalSeatNumber))
        self.currentSeat = (try! container.decode(Int.self, forKey: .reservedSeatNumber))
        
        super.init()
    }
    
    enum CodingKeys: CodingKey {
        case building, roomNumber, totalSeatNumber, reservedSeatNumber
     }
}

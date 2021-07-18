//
//  BoardModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

class Board:BaseObject{
    var roomId : Int
    var roomNum : Int
    var building : String
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
        fatalError("init(from:) has not been implemented")
    }
}

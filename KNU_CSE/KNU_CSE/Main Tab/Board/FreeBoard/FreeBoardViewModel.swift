//
//  BoardViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct FreeBoardViewModel{
    var boards : [FreeBoard] = []
    
    init(){
        self.setUpBoards()
    }
    
    mutating func setUpBoards(){
        boards.append(FreeBoard(roomId: 101, roomNum: 101, building: "IT4", totalSeat: 30, currentSeat: 10))
        boards.append(FreeBoard(roomId: 102, roomNum: 102, building: "IT4", totalSeat: 30, currentSeat: 11))
        boards.append(FreeBoard(roomId: 103, roomNum: 103, building: "IT4", totalSeat: 30, currentSeat: 12))
        boards.append(FreeBoard(roomId: 104, roomNum: 104, building: "IT4", totalSeat: 30, currentSeat: 13))
    }
}

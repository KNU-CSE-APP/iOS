//
//  ReservationHistModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import Foundation

class ReservationHistModel:BaseObject{
    
    var building:String
    var roomNumber:Int
    var seatNumber:Int
    var startDate:String
    var endDate:String
    var extension_cnt:Int
    
    init(building:String, roomNumber:Int, seatNumber:Int, extension_cnt:Int, startDate:String, endDate:String) {
        self.building = building
        self.roomNumber = roomNumber
        self.seatNumber = seatNumber
        self.extension_cnt = extension_cnt
        self.startDate = startDate
        self.endDate = endDate
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.building = (try! container.decode(String.self, forKey: .building))
        self.roomNumber = (try! container.decode(Int.self, forKey: .roomNumber))
        self.seatNumber = (try! container.decode(Int.self, forKey: .seatNumber))
        self.startDate = (try! container.decode(String.self, forKey: .startDate)).replacingOccurrences(of: "T", with: " ")
        self.endDate = (try! container.decode(String.self, forKey: .dueDate)).replacingOccurrences(of: "T", with: " ")
        self.extension_cnt = (try! container.decode(Int.self, forKey: .extensionNum))
        super.init()
    }
    
    enum CodingKeys: CodingKey {
        case building, roomNumber, seatNumber, startDate, dueDate, extensionNum
     }
}


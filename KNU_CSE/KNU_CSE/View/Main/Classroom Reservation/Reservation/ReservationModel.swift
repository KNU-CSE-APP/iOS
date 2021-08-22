//
//  ReservationModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

class ClassSeat:BaseObject{
    var seatNumber:Int
    var status:Bool
    
    init(seatNumber:Int, status:Bool){
        self.seatNumber = seatNumber
        self.status = status
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.seatNumber = (try! container.decode(Int.self, forKey: .number))
        let status = (try! container.decode(String.self, forKey: .status))
        
        if status == ReservationState.RESERVED.rawValue{
            self.status = false
        }else{
            self.status = true
        }
        super.init()
    }
    
    enum CodingKeys: CodingKey {
        case number, status
     }
    
    enum ReservationState:String{
        case RESERVED = "RESERVED"
        case UNRESERVED = "UNRESERVED"
    }

}

class ReservationBody:BaseObject{
    var building: String
    var roomNumber: Int
    var seatNumber: Int
    
    
    init(building:String, roomNumber:Int, seatNumber:Int){
        self.building = building
        self.roomNumber = roomNumber
        self.seatNumber = seatNumber
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(building, forKey: .building)
        try container.encode(roomNumber, forKey: .roomNumber)
        try container.encode(seatNumber, forKey: .seatNumber)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: CodingKey {
        case building, roomNumber, seatNumber
     }
}

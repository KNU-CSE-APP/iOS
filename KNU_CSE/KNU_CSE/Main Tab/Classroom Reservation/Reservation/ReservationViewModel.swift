//
//  ReservationViewModel.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/19.
//

import Foundation

struct ReservationViewModel{
    var classRoom : ClassRoom?
    
    mutating func setClassRoom(classRoom:ClassRoom){
        self.classRoom = classRoom
    }
}

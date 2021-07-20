//
//  ReservationCheckDelegate.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/20.
//

import Foundation

protocol ReservationCheckDelegate {
    func sendData(classRoom:ClassRoom, classSeat:ClassSeat)
}

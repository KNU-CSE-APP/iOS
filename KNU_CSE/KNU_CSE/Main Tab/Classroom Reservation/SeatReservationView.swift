//
//  SeatReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ClassRoomView : UIViewController{

    let seatReservationViewModel : SeatReservationViewModel = SeatReservationViewModel()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "강의실 예약"
    }
    
    override func viewDidLoad() {
        
    }
    
}

extension ClassRoomView : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seatReservationViewModel.lecture.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SeatReservationCell.Identifier, for: indexPath) as! SeatReservationCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

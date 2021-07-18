//
//  ReservationView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit

class ReservationView : UIViewController, ClassDataDelegate{
    
    var reservationViewModel : ReservationViewModel = ReservationViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    override func viewDidLoad() {
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        
    }
    
    func addView(){
        
    }
    
    func setupConstraints(){
        
    }
    
    func sendData(data: ClassRoom) {
        reservationViewModel.setClassRoom(classRoom: data)
        setNavigationTitle(title: "\(data.building)-\(data.roomId)호")
    }
    
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
}

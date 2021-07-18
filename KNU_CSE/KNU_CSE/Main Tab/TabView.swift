//
//  TabView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit

class TabView : UITabBarController{
    
    override func viewWillAppear(_ animated: Bool) {
        //push했기때문에 backbutton 없애기
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    override func viewDidLoad() {
        
    }
}

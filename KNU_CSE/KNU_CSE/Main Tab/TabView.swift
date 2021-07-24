//
//  TabView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit

class TabView : UITabBarController{
    
    @IBOutlet weak var customTabBar: UITabBar!{
        didSet{
            customTabBar.tintColor = Color.mainColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //push했기때문에 backbutton 없애기
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    override func viewDidLoad() {
        
    }
}

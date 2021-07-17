//
//  Alert.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit

struct Alert{
    var alert : UIAlertController
    var title : String
    var message : String
    var viewController : UIViewController
    
    init(title:String, message:String, viewController:UIViewController) {
        self.title = title
        self.message = message
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.viewController = viewController
    }
    
    func popUpDefaultAlert(action:((UIAlertAction)->())?){
        let actionDefault = UIAlertAction(title: "확인", style: .default,handler: action)
        self.alert.addAction(actionDefault)
        self.viewController.present(alert, animated: true, completion: nil)
    }
}

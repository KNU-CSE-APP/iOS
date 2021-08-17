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
    
    func popUpNormalAlert(action:((UIAlertAction)->())?){
        let actionCancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let actionDefault = UIAlertAction(title: "확인", style: .default,handler: action)
        self.alert.addAction(actionCancel)
        self.alert.addAction(actionDefault)
        self.viewController.present(alert, animated: true, completion: nil)
    }
}

import YPImagePicker

struct ActionSheet{
    let actionSheet = UIAlertController()
    var viewController : UIViewController
    var editActioon:((UIAlertAction) -> Void)?
    var removeAction:((UIAlertAction) -> Void)?
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
    mutating func popUpActionSheet(edit_text:String, editAction:@escaping((UIAlertAction) -> Void), remove_text:String, removeAction:@escaping((UIAlertAction) -> Void), cancel_text:String){
        
        self.editActioon = editAction
        self.removeAction = removeAction
        
        let editBtn = UIAlertAction(title: edit_text, style: .default, handler: self.editActioon)
        
        let removeBtn = UIAlertAction(title: remove_text, style: .default, handler: self.removeAction)
        
        let cancelBtn = UIAlertAction(title: cancel_text, style: .cancel, handler: nil)
        
        self.actionSheet.addAction(editBtn)
        self.actionSheet.addAction(removeBtn)
        self.actionSheet.addAction(cancelBtn)
        
        self.viewController.present(self.actionSheet, animated: true, completion: nil)
    }
    
    mutating func popUpDeleteActionSheet(remove_text:String, removeAction:@escaping((UIAlertAction) -> Void), cancel_text:String){
        
        self.removeAction = removeAction
        
        let removeBtn = UIAlertAction(title: remove_text, style: .default, handler: self.removeAction)
        
        let cancelBtn = UIAlertAction(title: cancel_text, style: .cancel, handler: nil)
        
        self.actionSheet.addAction(removeBtn)
        self.actionSheet.addAction(cancelBtn)
        
        self.viewController.present(self.actionSheet, animated: true, completion: nil)
    }
    
}

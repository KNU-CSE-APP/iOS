//
//  UIViewController + Extension.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

extension UIViewController{
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
    
    func hideBackTitle(){
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
}

extension UIViewController{
    
    func pushView<T:UIViewController>(identifier:String, typeOfVC:T.Type){
        guard let VC = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else{
            return
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func presentView<T:UIViewController>(identifier:String, typeOfVC:T.Type){
        guard let VC = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else{
            return
        }
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    func logOut(){
        guard StorageManager.shared.readUser() != nil else {
            print("유저 정보 없음")
            self.navigationController?.popViewController(animated: true)
            return
        }
        if StorageManager.shared.deleteUser(){
            print("삭제성공")
            self.navigationController?.popViewController(animated: true)
        }else{
            print("삭제싪패")
        }
    }
    
    func popTwiceView(){
        guard let viewControllers = self.navigationController?.viewControllers else {
            return
        }
        self.navigationController?.popToViewController(viewControllers[viewControllers.count-3], animated: true)
    }
    
    func getTopViewController()->UIViewController?{
        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }
        return viewControllers[viewControllers.count-2]
    }
}

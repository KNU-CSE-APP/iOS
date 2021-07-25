//
//  BoardWriteView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/26.
//

import UIKit

class BoardWriteView:UIViewController, ViewProtocol{
    
    var titleField:UITextField!{
        didSet{
            titleField.placeholder = "제목"
            titleField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
    }
    
    var contentField:UITextView!{
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "게시물 작성")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initUI() {
        
    }
    
    func addView() {
        
    }
    
    func setUpConstraints() {
        
    }
    
    
}

extension BoardWriteView{
    func setNavigationTitle(title:String){
        self.navigationItem.title = title
    }
}

//
//  NoticeView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/18.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class NoticeView : UIViewController, WKUIDelegate{
    
    var webView : WKWebView!{
        didSet{
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            
            let URL = URL(string:"https://computer.knu.ac.kr/06_sub/02_sub.html")
            let request = URLRequest(url: URL!)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "공지사항"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setupConstraints()
    }
    
    func initUI(){
        webView = WKWebView()
    }
    
    func addView(){
        self.view.addSubview(webView)
    }
    
    func setupConstraints(){
        webView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
}
//
//  TabView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/17.
//

import UIKit
import Photos

class TabView : UITabBarController{
    
    // Override selectedViewController for User initiated changes
    override var selectedViewController: UIViewController? {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    // Override selectedIndex for Programmatic changes
    override var selectedIndex: Int {
        didSet {
            tabChangedTo(selectedIndex: selectedIndex)
        }
    }
    
    @IBOutlet weak var customTabBar: UITabBar!{
        didSet{
            customTabBar.tintColor = Color.mainColor
        }
    }
    
    var searchBtn:UIBarButtonItem!{
        didSet{
            searchBtn.style = .plain
            searchBtn.tintColor = .white
            searchBtn.target = self
            let image = UIImage(systemName: "magnifyingglass")
            searchBtn.image = image
            searchBtn.action = #selector(pushBoardSearchView)
        }
    }

    var writeBoardhBtn:UIBarButtonItem!{
        didSet{
            writeBoardhBtn.style = .plain
            writeBoardhBtn.tintColor = .white
            writeBoardhBtn.target = self
            let image = UIImage(systemName: "pencil")
            writeBoardhBtn.image = image
            writeBoardhBtn.action = #selector(pushBoardWriteView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //push했기때문에 backbutton 없애기
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    override func viewDidLoad() {
        self.delegate = self
        self.initUI()
        self.requestNotiAuth()
    }
    
    func initUI() {
        self.searchBtn = UIBarButtonItem()
        self.writeBoardhBtn = UIBarButtonItem()
    }
}

extension TabView:UITabBarControllerDelegate{
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print(self.selectedIndex)
    }
    
    @objc func pushBoardWriteView(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardWriteView") as? BoardWriteView
        pushVC?.parentType = .Write
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    @objc func pushBoardSearchView(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardSearchView") as? BoardSearchView
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func tabChangedTo(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            self.navigationItem.title = "공지사항"
            self.navigationItem.rightBarButtonItems = nil
        case 1:
            self.navigationItem.title = "강의실 예약"
            self.navigationItem.rightBarButtonItems = nil
        case 2:
            self.navigationItem.title = "자유게시판"
            self.navigationItem.backButtonTitle = ""
            break
        case 3:
            self.navigationItem.title = "마이페이지"
            self.navigationItem.rightBarButtonItems = nil
        default:
            
            break
        }
    }
    
    func setNavigationItemWithSearchWrite(){
        self.navigationItem.rightBarButtonItems = [searchBtn, writeBoardhBtn]
    }
    
    func setNavigationItemWithSearch(){
        self.navigationItem.rightBarButtonItems = [searchBtn]
    }
}

extension TabView : UNUserNotificationCenterDelegate{
    func requestNotiAuth() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { isSuccess, error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                
            }
        }
    }
}


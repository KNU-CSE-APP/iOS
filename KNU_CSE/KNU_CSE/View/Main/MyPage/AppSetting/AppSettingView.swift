//
//  AppSettingView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class AppSettingView:UIViewController, ViewProtocol{
    
    let settingTitle:[String] = ["푸쉬 알림", "소리"]
    
    var tableView:UITableView!{
        didSet{
            tableView.isScrollEnabled = false
            tableView.dataSource = self
            tableView.register(AppSettingCell.self, forCellReuseIdentifier: AppSettingCell.identifier)
            tableView.rowHeight = 50
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.separatorInset.left = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTitle(title: "환경설정")
        self.hideBackTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        addView()
        setUpConstraints()
    }
    
    func initUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
    }
    
    func addView() {
        self.view.addSubview(self.tableView)
    }
    
    func setUpConstraints() {
        self.tableView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}


extension AppSettingView:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppSettingCell.identifier, for: indexPath) as? AppSettingCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setTitle(title: settingTitle[indexPath.row])
        
        switch indexPath.row {
        case 0:
            cell.setListener{ [weak self] btn in
                if btn.isOn {
                    // 등록된 토큰이 있다면
                }
                else {
                    // 등록된 토큰이 있는데 off하면 해당 토큰으로 notification이 오지 못하도록
                }
            }
        case 1:
            cell.setListener{ btn in
                if btn.isOn {
                    print("on")
                }
                else {
                    print("off")
                }
            }
        default:
            break
        }
        return cell
    }
}

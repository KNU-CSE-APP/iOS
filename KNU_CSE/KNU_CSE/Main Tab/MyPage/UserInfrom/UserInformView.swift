//
//  MyPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class UserInformView:UIViewController, ViewProtocol{
    
    let profile_width_hegiht:CGFloat = 150
    let image_width_height:CGFloat = 150 * 0.2
    let titleList:[String] = ["이름", "학번", "닉네임"]
    
    var profileBtn:UIButton!{
        didSet{
            do{
                let url = URL(string: "https://file.mk.co.kr/meet/neds/2021/04/image_readtop_2021_330747_16177500644599916.jpg")
                let data =  try Data(contentsOf: url!)
                
                let image = UIImage(data: data)?.resized(toWidth: profile_width_hegiht)
                profileBtn.clipsToBounds = true
                profileBtn.setImage(image, for: .normal)
                profileBtn.layer.borderWidth = 1
                profileBtn.layer.borderColor = UIColor.lightGray.cgColor
                profileBtn.layer.cornerRadius = profile_width_hegiht * 0.5
                profileBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }catch {}
           
        }
    }
    
    var cameraImage:UIButton!{
        didSet{
            let image = UIImage(systemName: "camera.fill")?.resized(toWidth: 25)
            cameraImage.setImage(image, for: .normal)
            cameraImage.backgroundColor = .white
            
            cameraImage.layer.borderWidth = 0.5
            cameraImage.layer.borderColor = UIColor.lightGray.cgColor
            cameraImage.layer.cornerRadius = self.image_width_height * 0.5
        }
    }
    
    var tableView:UITableView!{
        didSet{
            tableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.identifier)
            tableView.isScrollEnabled = false
            tableView.dataSource = self
            tableView.rowHeight = 50
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.separatorInset.left = 0
            tableView.backgroundColor = Color.backColor
            self.view.backgroundColor = Color.backColor
        }
    }
    
    var confirmBtn:UIButton!{
        didSet{
            confirmBtn.setTitle("완료", for: .normal)
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
            confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            confirmBtn.backgroundColor = .lightGray
            confirmBtn.isEnabled = false
            confirmBtn.addAction {
                self.navigationController?.popViewController(animated: true)
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI() {
        self.profileBtn = UIButton()
        self.cameraImage = UIButton()
        self.tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        self.confirmBtn = UIButton()
    }
    
    func addView() {
        _ = [self.profileBtn, self.cameraImage, self.tableView, self.confirmBtn].map{
            self.view.addSubview($0)
        }
    }
    
    func setUpConstraints() {
        let image_rate:CGFloat = 0.34
        
        self.profileBtn.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.profile_width_hegiht)
            make.height.equalTo(self.profile_width_hegiht)
        }
        
        self.cameraImage.snp.makeConstraints{ make in
            make.width.equalTo(self.image_width_height)
            make.height.equalTo(self.image_width_height)
            make.centerX.equalTo(profileBtn.snp.centerX).offset(profile_width_hegiht * image_rate)
            make.centerY.equalTo(profileBtn.snp.centerY).offset(profile_width_hegiht * image_rate)
        }
        
        self.tableView.snp.makeConstraints{ make in
            make.top.equalTo(self.profileBtn.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.confirmBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
    }
}

extension UserInformView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.identifier, for: indexPath) as? ProfileTableCell else{
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        
        switch indexPath.row {
        case 0:
            cell.setTitle(title: titleList[indexPath.row], content: "노준석")
        case 1:
            cell.setTitle(title: titleList[indexPath.row], content: "2016117285")
        case 2:
            cell.setTitle(title: titleList[indexPath.row], content: "IYNONE")
            cell.setEditable()
            cell.setListener { [weak self] origin_text, last_text in
                if origin_text != last_text{
                    self?.addBtnAction()
                }else{
                    self?.removeBtnAction()
                }
            }
        default:
            break
        }
        
        return cell
    }
    
}

extension UserInformView:UITextFieldDelegate{
    
}

extension UserInformView{
    func addBtnAction(){
        self.confirmBtn.backgroundColor = Color.mainColor
        self.confirmBtn.isEnabled = true
    }
    
    func removeBtnAction(){
        self.confirmBtn.backgroundColor = .lightGray.withAlphaComponent(0.5)
        self.confirmBtn.isEnabled = false
    }
}

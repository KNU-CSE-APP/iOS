//
//  MyPageView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/29.
//

import UIKit

class UserInformView:BaseUIViewController, ViewProtocol{
    
    let profile_width_hegiht:CGFloat = 150
    let image_width_height:CGFloat = 150 * 0.2
    let titleList:[String] = ["이메일", "이름", "학번", "닉네임"]
    
    var userInformationViewModel:UserInformViewModel = UserInformViewModel()
    
    var profileBtn:UIButton!{
        didSet{
            do{
                if let url = URL(string: userInformationViewModel.model.imagePath){
                    let data =  try Data(contentsOf: url)
                    let image = UIImage(data: data)?.resized(toWidth: profile_width_hegiht)
                    profileBtn.setImage(image, for: .normal)
                }else {
                    let image = UIImage(systemName: "person.circle.fill")!.resized(toWidth: profile_width_hegiht)!
                    self.profileBtn.setImage(image.withTintColor(.lightGray.withAlphaComponent(0.4)), for: .normal)
                }
                
                profileBtn.clipsToBounds = true
                profileBtn.layer.borderWidth = 1
                profileBtn.layer.borderColor = UIColor.lightGray.cgColor
                profileBtn.layer.cornerRadius = profile_width_hegiht * 0.5
                profileBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                profileBtn.showsTouchWhenHighlighted = true
                profileBtn.addAction { [weak self] in
                    self?.addActionSheet()
                }
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
            
            cameraImage.addAction { [weak self] in
                self?.addActionSheet()
            }
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
            self.BindingSetUserInform()
            confirmBtn.addAction {
//                self.navigationController?.popViewController(animated: true)
                self.userInformationViewModel.setUserInform()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BindingGetUserInform()
        self.BindingResetImage()
        self.userInformationViewModel.getUserInform()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(title: "회원정보")
        self.hideBackTitle()
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
        
        let profile:Profile! = self.userInformationViewModel.model
        switch indexPath.row {
        case 0:
            cell.setTitle(title: self.titleList[indexPath.row], content: profile.email)
        case 1:
            cell.setTitle(title: self.titleList[indexPath.row], content: profile.username)
        case 2:
            cell.setTitle(title: self.titleList[indexPath.row], content: profile.studentId)
        case 3:
            cell.setTitle(title: self.titleList[indexPath.row], content: profile.nickname)
            cell.setEditable()
            cell.setUpEditCellConstraints()
            cell.setListener { [weak self] origin_text, last_text in
                self?.userInformationViewModel.model.editedNickname = last_text
                if origin_text != last_text && last_text != ""{
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

extension UserInformView{
    func addBtnAction(){
        self.confirmBtn.backgroundColor = Color.mainColor
        self.confirmBtn.isEnabled = true
    }
    
    func removeBtnAction(){
        self.confirmBtn.backgroundColor = .lightGray.withAlphaComponent(0.5)
        self.confirmBtn.isEnabled = false
    }
    
    func addActionSheet(){
        var actionSheet = ActionSheet(viewController: self)
        actionSheet.popUpActionSheet(edit_text: "프로필 이미지 변경", editAction: { [weak self] action in
            self?.presentPhotoView()
        }, remove_text: "프로필 이미지 삭제", removeAction:{ [weak self] action in
            self?.userInformationViewModel.resetImage()
        }
    , cancel_text: "취소")
    }
    
    func presentPhotoView(){
        guard let VC = storyboard?.instantiateViewController(withIdentifier: "PhotoView") as? PhotoView else{
            return
        }
        VC.modalPresentationStyle = .overFullScreen
        VC.setListener{ [weak self] image, url in
            do{
                self?.profileBtn.setImage(image.resized(toWidth: (self?.profile_width_hegiht)!), for: .normal)
                if self?.userInformationViewModel.model.imagePath != url{
                    self?.addBtnAction()
                    self?.userInformationViewModel.model.imageData = image.jpegData(compressionQuality: 0.5)
                }
            }
        }
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    func setOriginProfile(){
        let image = UIImage(systemName: "person.circle.fill")!.resized(toWidth: profile_width_hegiht)!
        self.profileBtn.setImage(image.withTintColor(.lightGray.withAlphaComponent(0.4)), for: .normal)
    }
}

extension UserInformView{
    func BindingGetUserInform(){
        self.userInformationViewModel.getInformlistener.binding(successHandler: { response in
            if response.success {
                if let profile = response.response {
                    self.userInformationViewModel.model = profile
                }
            }
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            self.indicator.viewController = self
            self.indicator.startIndicator()
        }, endHandler: {
            if self.userInformationViewModel.model != nil{
                self.initUI()
                self.addView()
                self.setUpConstraints()
            }
            self.indicator.stopIndicator()
        })
    }
    
    func BindingSetUserInform(){
        self.userInformationViewModel.setInformlistener.binding(successHandler: {result in
            if result.success{
                Alert(title: "성공", message: "회원정보가 변경되었습니다.", viewController: self).popUpDefaultAlert(action: { action in
//                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                if let error = result.error?.message {
                    Alert(title: "실패", message: error, viewController: self).popUpDefaultAlert(action: { action in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }, failHandler: { Error in
            print(Error)
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
    
    func BindingResetImage(){
        self.userInformationViewModel.resetImagelistener.binding(successHandler: { [weak self] result in
            if result.success{
                self?.setOriginProfile()
//                if self?.userInformationViewModel.model.imagePath != nil{
//                    self?.addBtnAction()
//                }
//                let image = UIImage(systemName: "person.circle.fill")!.resized(toWidth: self!.profile_width_hegiht)!.withTintColor(.lightGray.withAlphaComponent(0.4))
//                self?.userInformationViewModel.model.imageData = image.jpegData(compressionQuality: 1)
            }else{
                if let error = result.error?.message {
                    Alert(title: "실패", message: error, viewController: self!).popUpDefaultAlert(action: { action in
                    self?.navigationController?.popViewController(animated: true)
                })
                }
            }
            
        }, failHandler: { Error in
            Alert(title: "실패", message: "네트워크 상태를 확인하세요", viewController: self).popUpDefaultAlert(action: nil)
        }, asyncHandler: {
            
        }, endHandler: {
            
        })
    }
}

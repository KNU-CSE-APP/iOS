//
//  PhotoView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/30.
//

import UIKit
import YPImagePicker

class PhotoView:UIViewController,ViewProtocol{
    
    var listener:((UIImage, String) -> Void)?
    
    var picker:YPImagePicker!{
        didSet{
            picker.didFinishPicking { [weak self] items, cancelled in
                if cancelled {

                }else{
                    if let photo = items.singlePhoto, let action = self?.listener{

                        let imgName = "\(UUID().uuidString).jpg"
                        let documentDirectory = NSTemporaryDirectory()
                        let localPath = documentDirectory.appending(imgName)

                        let image = photo.image
                        let data = image.jpegData(compressionQuality: 0.5)! as NSData
                        data.write(toFile: localPath, atomically: true)
                        //let url = URL.init(fileURLWithPath: localPath)
                        action(photo.image, localPath)
                   }
                }
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    var config:YPImagePickerConfiguration!{
        didSet{
            config.screens = [.library]
            config.library.mediaType = .photo
            config.wordings.libraryTitle = "사진"
            config.wordings.albumsTitle = "앨범"
            config.wordings.filter = "필터"
            config.wordings.next = "확인"
            config.wordings.cancel = "취소"
        }
   }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI() {
        self.config = YPImagePickerConfiguration()
        self.picker = YPImagePicker(configuration: config)
    }
    
    func addView() {
        self.view.addSubview(self.picker.view)
    }
    
    func setUpConstraints() {
        self.picker.view.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension PhotoView{
    func setListener(listener:@escaping(UIImage, String)->Void){
        self.listener = listener
    }
}

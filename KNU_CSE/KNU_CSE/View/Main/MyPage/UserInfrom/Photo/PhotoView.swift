//
//  PhotoView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/07/30.
//

import UIKit
import YPImagePicker

class PhotoView:UIViewController,ViewProtocol{
    
    private var listener:((UIImage, String) -> Void)?
    private var initlistener: (()->Void)?
    
    public var isMutltiSelection: Bool = false
    private var picker:YPImagePicker!{
        didSet{
            picker.didFinishPicking { [weak self] items, cancelled in
                if cancelled {

                }else{
                    for item in items{
                        switch item{
                            case .photo(let p):
                                self?.initlistener?()
                                if let action = self?.listener {
                                    let photo = p
                                    let imgName = "\(UUID().uuidString).jpg"
                                    let documentDirectory = NSTemporaryDirectory()
                                    let localPath = documentDirectory.appending(imgName)

                                    let image = photo.image
                                    let data = image.jpegData(compressionQuality: 0)! as NSData
                                    data.write(toFile: localPath, atomically: true)
                                    //let url = URL.init(fileURLWithPath: localPath)
                                    action(photo.image, localPath)
                               }
                            default:
                                break
                        }
                    }
                }
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private var config:YPImagePickerConfiguration!{
        didSet{
            config.screens = [.library]
            config.library.mediaType = .photo
            config.wordings.libraryTitle = "앨범"
            config.wordings.albumsTitle = "앨범"
            config.wordings.filter = "필터"
            config.wordings.next = "확인"
            config.wordings.cancel = "취소"
            config.wordings.done = "확인"
            if isMutltiSelection {
                config.library.maxNumberOfItems = 10
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
    
    func setInitListener(listener:@escaping()->Void){
        self.initlistener = listener
    }
}

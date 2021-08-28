//
//  PhPickerView.swift
//  KNU_CSE
//
//  Created by junseok on 2021/08/25.
//

import UIKit
import PhotosUI

class PHPickerView: UIViewController, ViewProtocol{
    
    lazy var pickerView:PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .livePhotos])
        
        var pickerView = PHPickerViewController(configuration: configuration)
        
        return pickerView
    }()
    
    override func viewDidLoad() {
        self.initUI()
        self.addView()
        self.setUpConstraints()
    }
    
    func initUI() {
        
    }
    
    func addView() {
    }
    
    func setUpConstraints() {
    }
    
}

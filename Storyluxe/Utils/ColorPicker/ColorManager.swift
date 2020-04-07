//
//  GroupManager.swift
//  OmniSense
//
//  Created by Sergey Koval on 23.12.2019.
//  Copyright © 2019 AntEtc, Inc. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    private init(){}
    
    // MARK: - Vibration Editor
    
    func colorPicker() -> UIView? {
        let currentWindow = UIApplication.shared.keyWindow
        let view = UIView(frame: currentWindow!.bounds)
        view.layer.backgroundColor = UIColor(white: 0, alpha: 0.3).cgColor
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        let height: CGFloat = 300
        let editor = ColorPicker(frame: CGRect(x: 10, y: (view.frame.height - height)/2, width: view.frame.width - 20, height: height), base: view)
        view.addSubview(editor)
        view.alpha = 0
        return view
    }
}

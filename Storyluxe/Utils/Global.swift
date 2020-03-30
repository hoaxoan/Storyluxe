//
//  Global.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation
import UIKit

class Global: NSObject {
    static let shared = Global()
    private override init() {}
    
    // MARK: - UI elements
    
    func button(_ image: String, _ frame: CGRect, _ tint: UIColor?) -> UIButton {
        let button = UIButton(frame: frame)
        var image = UIImage(named: image)?.resize(frame.size.width - 5)
        if let tint = tint {
            image = image?.tint(color: tint)
        }
        button.setImage(image, for: .normal)
        return button
    }
    
    func tabButton(_ image: String, _ name: String, _ view: UIView, _ x: CGFloat, _ tint: UIColor?) -> (UIButton, UIView) {
        let width: CGFloat = 70
        let background = UIView(frame: CGRect(origin: CGPoint(x: x, y: view.frame.size.height - (width + 55)), size: CGSize(width: width, height: width + 25)))
        background.backgroundColor = .clear
        
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        var image = UIImage(named: image)?.resize(width - 30)
        if let tint = tint {
            image = image?.tint(color: tint)
        }
        button.setImage(image, for: .normal)
        background.addSubview(button)
        
        let title = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: button.bounds.maxY), size: CGSize(width: width, height: 20)))
        title.textAlignment = .center
        title.textColor = .lightGray
        title.text = name
        title.font = .systemFont(ofSize: 14)
        background.addSubview(title)
        
        return (button, background)
    }
    
    func avatar(_ image: String) -> UIImageView {
        let size: CGFloat = 40
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        imageView.image = UIImage(named: image)?.resize(size)
        imageView.layer.cornerRadius = size/2
        imageView.layer.masksToBounds = true
        return imageView
    }
}

// MARK: - Extensions

extension UIImage {
    
    func resize(_ dimension: CGFloat, opaque: Bool = false, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width / size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIImage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
    
    func tint(color: UIColor, _ blendMode: CGBlendMode = .normal) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(blendMode)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

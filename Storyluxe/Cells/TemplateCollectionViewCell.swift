//
//  TemplateCollectionViewCell.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class TemplateCollectionViewCell: UICollectionViewCell {
    
    // frames
    
    private let background: UIView = {
        let background = UIView()
        background.backgroundColor = veryLightGrayTint
        background.layer.cornerRadius = 10
        background.layer.masksToBounds = true
        return background
    }()
    
    private let frameView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = pinkTint.cgColor
        imageView.layer.borderWidth = 0.0
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            frameView.image = image
        }
    }
    
    // placeholders
    
    var frameType: FrameType? {
        didSet {
            var imageCenter = frameView.center
            switch frameType {
            case .one:
                imageCenter.y -= 13
                let button1 = button(CGSize(width: frame.width * 0.75, height: frame.height * 0.57), imageCenter)
                insertSubview(button1, belowSubview: frameView)
            case .two:
                let width: CGFloat = frame.width * 0.56
                let height: CGFloat = frame.height * 0.43
                
                imageCenter.y -= 45
                imageCenter.x -= 44
                let button1 = button(CGSize(width: width, height: height), imageCenter)
                button1.rotate(degrees: -2.5)
                background.addSubview(button1)
                
                imageCenter = frameView.center
                imageCenter.y += 26
                imageCenter.x += 48
                let button2 = button(CGSize(width: width, height: height), imageCenter)
                button2.rotate(degrees: 2.5)
                background.addSubview(button2)
            case .three:
                let width: CGFloat = frame.width * 1.03
                let height: CGFloat = frame.height * 0.32
                
                imageCenter.y -= 78
                let button1 = button(CGSize(width: width, height: height), imageCenter)
                button1.rotate(degrees: 5.8)
                background.addSubview(button1)
                
                imageCenter = frameView.center
                imageCenter.y += 41
                let button2 = button(CGSize(width: width, height: height), imageCenter)
                button2.rotate(degrees: -1.6)
                background.addSubview(button2)
                
                imageCenter = frameView.center
                imageCenter.y += 166
                let button3 = button(CGSize(width: width, height: height), imageCenter)
                button3.rotate(degrees: -3.5)
                background.addSubview(button3)
            case .four:
                let width: CGFloat = frame.width * 0.55
                let height: CGFloat = frame.height * 0.44
                
                // right side
                imageCenter = frameView.center
                imageCenter.y -= 80
                imageCenter.x += 43
                let button2 = button(CGSize(width: width, height: height), imageCenter)
                button2.rotate(degrees: -1.4)
                background.addSubview(button2)
                
                imageCenter = frameView.center
                imageCenter.y += 66
                imageCenter.x += 49
                let button4 = button(CGSize(width: width, height: height), imageCenter)
                button4.rotate(degrees: -1.2)
                background.addSubview(button4)
                
                // left side
                imageCenter = frameView.center
                imageCenter.y -= 68
                imageCenter.x -= 51
                let button1 = button(CGSize(width: width, height: height), imageCenter)
                button1.rotate(degrees: -1.2)
                background.addSubview(button1)

                imageCenter = frameView.center
                imageCenter.y += 80
                imageCenter.x -= 54
                let button3 = button(CGSize(width: width, height: height), imageCenter)
                button3.rotate(degrees: -1.0)
                background.addSubview(button3)
            default: break }
        }
    }
    
    // lock
    
    private let lock: UIView = {
        let lock = UIButton(frame: CGRect(origin: .zero, size: .init(width: 40, height: 40)))
        lock.backgroundColor = veryLightGrayTint
        lock.layer.cornerRadius = 10
        lock.layer.masksToBounds = true
        return lock
    }()
    
    override var isSelected: Bool {
        didSet {
            frameView.layer.borderWidth = isSelected ? 3.0 : 0.0
        }
    }
    
    // init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        background.frame = bounds
        addSubview(background)
        
        frameView.frame = bounds
        addSubview(frameView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    func button(_ size: CGSize, _ center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: size))
        button.backgroundColor = .lightGray
        button.setImage(UIImage(named: "plus-small")?.tint(color: .white), for: .normal)
        button.center = center
        button.isEnabled = false
        return button
    }
}

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}

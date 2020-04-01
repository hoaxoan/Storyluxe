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
    
    func button(_ image: String, _ frame: CGRect, _ tint: UIColor?, _ size: ButtonSize = .normal) -> UIButton {
        let button = UIButton(frame: frame)
        
        var inset: CGFloat = 5
        switch size {
        case .small:
            inset = 15
        case .verysmall:
            inset = 20
        default: break
        }
        
        var image = UIImage(named: image)?.resize(frame.width - inset)
        if let tint = tint {
            image = image?.tint(color: tint)
        }
        button.setImage(image, for: .normal)
        return button
    }
    
    func tabButton(_ image: String, _ name: String, _ view: UIView, _ x: CGFloat, _ tint: UIColor?, _ isSmall: Bool = false, _ isModal: Bool = false) -> (UIButton, UIView) {
        
        let width: CGFloat = isSmall ? 60 : 70
        
        let background = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width + 25)))
        background.center = CGPoint(x: x, y: view.frame.size.height - (width + (isModal ? 60 : 10)))
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
        title.font = .systemFont(ofSize: isSmall ? 12 : 14)
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
    
    // MARK: - Collages
    
    func testCollages() -> [Collage] {
        return [Collage(id: UUID().uuidString,
                        isPremium: false,
                        set: Frame(thumbnail: Image(withImage: UIImage(named: "brian")!),
                                   template: Image(withImage: UIImage(named: "instant_1f")!),
                                   type: .one,
                                   aspect: .aspect9_16)),
                Collage(id: UUID().uuidString,
                        isPremium: true,
                        set: Frame(thumbnail: Image(withImage: UIImage(named: "nichole")!),
                                   template: Image(withImage: UIImage(named: "instant_2f")!),
                                   type: .two,
                                   aspect: .aspect9_16)),
                Collage(id: UUID().uuidString,
                        isPremium: true,
                        set: Frame(thumbnail: Image(withImage: UIImage(named: "brian")!),
                                   template: Image(withImage: UIImage(named: "instant_3f")!),
                                   type: .three,
                                   aspect: .aspect9_16)),
                Collage(id: UUID().uuidString,
                        isPremium: false,
                        set: Frame(thumbnail: Image(withImage: UIImage(named: "nichole")!),
                                   template: Image(withImage: UIImage(named: "instant_4f")!),
                                   type: .four,
                                   aspect: .aspect9_16))]
    }
    
    func save<T: Encodable>(_ items: [T]?, key: String) {
        guard let items = items else { return }
        do {
            let data = try PropertyListEncoder().encode(items)
            let itemsData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            UserDefaults.standard.set(itemsData, forKey: key)
        } catch {
            print("⚠️ save items failed = \(error.localizedDescription)")
        }
    }
    
    func restore<T: Decodable>(_ key: String) -> [T]? {
        
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let itemsData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data
                let items = try PropertyListDecoder().decode([T].self, from: itemsData!)
                return items
            } catch {
                print("⚠️ restore items failed = \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    func testSets() -> [TemplateSet] {
        let set1 = [Template(filename: "instant_1f", isPremium: false, type: .one, collage: testCollages()[0]),
                    Template(filename: "instant_2f", isPremium: true, type: .two, collage: testCollages()[1]),
                    Template(filename: "instant_3f", isPremium: true, type: .three, collage: testCollages()[2]),
                    Template(filename: "instant_4f", isPremium: false, type: .four, collage: testCollages()[3])]
        let set2 = [Template(filename: "instant_4f", isPremium: true, type: .four, collage: testCollages()[0]),
                    Template(filename: "instant_2f", isPremium: false, type: .two, collage: testCollages()[1]),
                    Template(filename: "instant_1f", isPremium: true, type: .one, collage: testCollages()[2]),
                    Template(filename: "instant_3f", isPremium: false, type: .three, collage: testCollages()[3])]
        
        let flame = Image.init(withImage: UIImage(named: "flame")!.tint(color: pinkTint))
        let sets = [TemplateSet(title: nil, image: flame, set: set1),
                    TemplateSet(title: "film", image: nil, set: set2),
                    TemplateSet(title: "love", image: nil, set: set1),
                    TemplateSet(title: "paper", image: nil, set: set2),
                    TemplateSet(title: "tape", image: nil, set: set1),
                    TemplateSet(title: "element", image: nil, set: set2),
                    TemplateSet(title: "collage", image: nil, set: set1),
                    TemplateSet(title: "neon", image: nil, set: set2)]
        
        return sets
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

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}

extension CALayer {
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
        self.shadowRadius = 7
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "contentLayer" {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "contentLayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

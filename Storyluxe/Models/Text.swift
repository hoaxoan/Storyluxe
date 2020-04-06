//
//  Text.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation
import UIKit

struct Text: Codable {
    var id: String = UUID().uuidString
    var text: String
    var color: Color
    var font: Font
    var alignment: Alignment
    var location: Location
    var height: CGFloat = 100
    var center: CGPoint = .zero
}

struct Location: Codable {
    let x: CGFloat
    let y: CGFloat
    
    func point() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

struct Font: Codable {
    var name: String
    var size: CGFloat
    
    func font() -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

struct Alignment: Codable {
    var state: Align
    
    func align() -> NSTextAlignment {
        switch state {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        }
    }
}

struct Color: Codable {
    var hex: String
    
    func color() -> UIColor {
        return UIColor(hex: hex) ?? UIColor.black
    }
}


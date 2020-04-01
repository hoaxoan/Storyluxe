//
//  Constants.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation
import UIKit

let blackTint = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
let pinkTint = UIColor(red: 234/255, green: 71/255, blue: 183/255, alpha: 1.0)
let blueTint = UIColor(red: 114/255, green: 210/255, blue: 233/255, alpha: 1.0)
let lightGrayTint = UIColor(white: 0.7, alpha: 1)
let veryLightGrayTint = UIColor(white: 0.93, alpha: 1.0)

// kets
let allTemplatesKey = "allTemplatesKey"
let userCollagesKey = "userCollagesKey"

// enums
enum ButtonSize {
    case normal
    case small
    case verysmall
}

enum FrameType: Int, Codable {
    case one
    case two
    case three
    case four
    case none
}

enum Aspect: Int, Codable {
    case aspect4_5
    case aspect9_16
}

enum Align: Int, Codable {
    case left
    case center
    case right
}

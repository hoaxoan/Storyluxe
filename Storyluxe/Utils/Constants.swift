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

// keys
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

enum BackdropType: Int, Codable {
    case camera
    case colorPicker
    case image
}


// defaults

let buttonsF = ["F8", "F7", "F6", "F5", "F4", "F3", "F2", "F1",]
let buttonsP = ["P4", "P3", "P2", "P1",]
let buttonsT = ["T6", "T5", "T4", "T3", "T2", "T1",]
let buttonsE = ["E5", "E4", "E3", "E2", "E1",]

let settingsTitles = [["Get Unlimited Access"],
                      ["Storyluxe", "Nichole", "Brian", "Shop", "Terms of Use", "Privacy Policy", "Credits"],
                      ["Contact Support", "Leave Rating"]]

let settingsImages = ["icon-big", "brian", "nichole", "icon-big"]

let legalText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Mollis nunc sed id semper risus in. Felis donec et odio pellentesque diam volutpat commodo sed egestas. Nulla facilisi nullam vehicula ipsum. Diam volutpat commodo sed egestas egestas fringilla phasellus faucibus scelerisque. Bibendum at varius vel pharetra vel. Etiam sit amet nisl purus in mollis nunc. Feugiat nisl pretium fusce id velit ut tortor. Ac tincidunt vitae semper quis lectus nulla at volutpat. At imperdiet dui accumsan sit amet nulla. Massa sapien faucibus et molestie ac feugiat sed lectus. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. Fames ac turpis egestas maecenas pharetra convallis.

Euismod lacinia at quis risus. Diam donec adipiscing tristique risus nec feugiat in fermentum. Sagittis purus sit amet volutpat consequat mauris nunc congue nisi. Bibendum neque egestas congue quisque egestas diam. Et molestie ac feugiat sed lectus. Maecenas accumsan lacus vel facilisis volutpat. Cum sociis natoque penatibus et magnis. Luctus venenatis lectus magna fringilla urna. Gravida dictum fusce ut placerat orci nulla pellentesque dignissim. Augue mauris augue neque gravida in. Lorem ipsum dolor sit amet consectetur adipiscing. Massa sapien faucibus et molestie ac feugiat. Id velit ut tortor pretium viverra suspendisse potenti nullam ac. Porttitor eget dolor morbi non arcu. Nisl condimentum id venenatis a condimentum vitae. Feugiat nisl pretium fusce id velit ut tortor pretium viverra. Ut faucibus pulvinar elementum integer enim. Magna sit amet purus gravida quis blandit.
"""

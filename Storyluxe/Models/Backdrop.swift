//
//  Backdrop.swift
//  Storyluxe
//
//  Created by Sergey Koval on 02.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation

struct Backdrop: Codable {
    var filename: String
    var isPremium: Bool
    var type: BackdropType
}

struct BackdropSet: Codable {
    var title: String?
    var set: [Backdrop]
    var installed: Bool
}

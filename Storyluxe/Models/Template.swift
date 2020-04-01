//
//  Set.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation

struct Template: Codable {
    var filename: String
    var isPremium: Bool
    var type: FrameType
    var collage: Collage
}

struct TemplateSet: Codable {
    var title: String?
    var image: Image?
    var set: [Template]
    var installed: Bool
}

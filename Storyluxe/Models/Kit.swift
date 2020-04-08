//
//  Frame.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import Foundation
import UIKit

struct Kit: Codable {
    var thumbnail: Image
    var template: Image
    var type: FrameType
    var aspect: Aspect
    var images: [Image]?
    var border: Color?
    var backdrop: Image?
    var branding: Image?
    var texts: [Text]?
    var canChangeBorder: Bool
}

struct Image: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

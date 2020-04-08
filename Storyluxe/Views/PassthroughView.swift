//
//  PassthroughView.swift
//  Storyluxe
//
//  Created by Sergey Koval on 08.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class PassthroughView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

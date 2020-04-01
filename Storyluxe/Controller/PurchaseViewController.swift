//
//  PurchaseViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 01.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {

    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let width: CGFloat = 200
        let label = UILabel(frame: CGRect(origin: CGPoint(x: (view.frame.width - width)/2, y: top), size: CGSize(width: width, height: size.height)))
        label.textAlignment = .center
        label.textColor = blueTint
        label.text = "Purchase view controller"
        label.font = .boldSystemFont(ofSize: 15)
        view.addSubview(label)
        
        let dismiss = Global.shared.button("close-black", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
    }
    

    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

}

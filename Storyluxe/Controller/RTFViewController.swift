//
//  RTFViewController.swift
//  IPNAlite
//
//  Created by Sergey Koval on 3/22/19.
//  Copyright © 2019 Sergey Koval. All rights reserved.
//

import UIKit

class RTFViewController: UIViewController {

    lazy var content: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let width: CGFloat = view.frame.width - 80
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 40, y: top), size: CGSize(width: width, height: size.height)))
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Legal"
        label.font = .boldSystemFont(ofSize: 20)
        view.addSubview(label)
        
        content.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70)
        view.addSubview(content)
        
        let dismiss = Global.shared.button("close-black", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        let docName = NSLocalizedString("help_en", comment: "")
        if let rtfPath = Bundle.main.url(forResource: docName, withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                content.attributedText = attributedStringWithRtf
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

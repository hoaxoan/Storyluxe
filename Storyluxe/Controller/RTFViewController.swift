//
//  RTFViewController.swift
//  IPNAlite
//
//  Created by Sergey Koval on 3/22/19.
//  Copyright © 2019 Sergey Koval. All rights reserved.
//

import UIKit

class RTFViewController: UIViewController {

    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("mainMenu_Help", comment: "")
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView(_:)))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let docName = NSLocalizedString("help_text", comment: "")
        if let rtfPath = Bundle.main.url(forResource: docName, withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                content.attributedText = attributedStringWithRtf
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

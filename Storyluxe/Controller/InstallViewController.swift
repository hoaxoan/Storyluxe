//
//  InstallViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 02.04.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class InstallViewController: UIViewController {

    var setImage: UIImageView = {
       let background = UIImageView()
        background.image = UIImage(named: "invite")
        return background
    }()
    
    var set: TemplateSet? {
        didSet {
            dump(set)
            if let preview = set?.preview {
                setImage.frame = view.bounds
                setImage.image = UIImage(named: preview)
                view.addSubview(setImage)
                view.sendSubviewToBack(setImage)
            }
        }
    }
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let width: CGFloat = 200
        let label = UILabel(frame: CGRect(origin: CGPoint(x: (view.frame.width - width)/2, y: top), size: CGSize(width: width, height: size.height)))
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "Templates by"
        label.font = .boldSystemFont(ofSize: 15)
        view.addSubview(label)
        
        let dismiss = Global.shared.button("close-black", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        let y = view.frame.height - 200
        let install = UIButton(frame: CGRect(x: 30, y: y, width: view.frame.width - 60, height: 80))
        install.backgroundColor = blueTint
        install.setTitle("Install", for: .normal)
        install.titleLabel?.font = .boldSystemFont(ofSize: 20)
        install.setTitleColor(.white, for: .normal)
        install.layer.cornerRadius = 30
        install.layer.masksToBounds = true
        install.addTarget(self, action: #selector(uninstall), for: .touchUpInside)
        view.addSubview(install)
    }

    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uninstall() {
        var allSets = Global.shared.templateSets()
        if let index = allSets.firstIndex(where: {$0.title == set?.title}) {
            allSets[index].installed = true
            Global.shared.save(allSets, key: allTemplatesKey)
            dismiss(animated: true, completion: nil)
        }
    }
}

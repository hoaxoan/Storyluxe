//
//  EditorViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    var isModernAspect = true
    var aspect = UIButton()
    var aspectCenter: CGPoint = .zero
    var image = UIImageView()
    var imageCenter: CGPoint = .zero
    
    // sizes
    let size = CGSize(width: 35, height: 35)
    let top: CGFloat = 20
    let left: CGFloat = 25
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = pinkTint
        view.backgroundColor = blackTint
        setupUI()
    }

    // MARK: - UI
    
    func setupUI() {
        // top buttons
        
        // more
        let more = Global.shared.button("more-vertical", CGRect(origin: CGPoint(x: 20, y: top), size: size), lightGrayTint, .small)
        more.addTarget(self, action: #selector(menu), for: .touchUpInside)
        view.addSubview(more)
        
        // aspect
        aspect.frame = CGRect(origin: CGPoint(x: 1.5*left + size.width, y: top), size: CGSize(width: 25, height: size.height))
        aspect.setTitle("9:16", for: .normal)
        aspect.titleLabel?.font = .systemFont(ofSize: 6)
        aspect.titleLabel?.textAlignment = .center
        aspect.setTitleColor(lightGrayTint, for: .normal)
        aspect.layer.cornerRadius = 3
        aspect.layer.borderColor = lightGrayTint.cgColor
        aspect.layer.borderWidth = 1
        aspect.addTarget(self, action: #selector(aspectUpdate), for: .touchUpInside)
        view.addSubview(aspect)
        aspectCenter = aspect.center
        
        // text
        let email = Global.shared.button("text", CGRect(origin: CGPoint(x: (view.frame.width - 35)/2, y: top), size: size), lightGrayTint)
        email.addTarget(self, action: #selector(text), for: .touchUpInside)
        view.addSubview(email)
        
        // close
        let dismiss = Global.shared.button("close-white", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        // image
        image.image = UIImage(named: "nichole")
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        
        image.frame = CGRect(origin: CGPoint(x: left, y: 2*top + size.height), size: CGSize(width: view.frame.width - (2 * left), height: view.frame.height - 250))
        view.addSubview(image)
        imageCenter = image.center
        
        // bottom buttons
        
        let offset = view.frame.width/5
        var centers = [CGFloat]()
        for i in 0...4 {
            centers.append(CGFloat(i + 1)*offset - 1.5*left)
        }
        
        let (button1, border) = Global.shared.tabButton("borders", "Borders", view, centers[0], .white, true, true)
        button1.addTarget(self, action: #selector(borders), for: .touchUpInside)
        view.addSubview(border)
        
        let (button2, brand) = Global.shared.tabButton("icon-trans", "Branding", view, centers[1], nil, true, true)
        button2.addTarget(self, action: #selector(branding), for: .touchUpInside)
        view.addSubview(brand)

        let (button3, templates) = Global.shared.tabButton("templates", "Templates", view, centers[2], .white, true, true)
        button3.addTarget(self, action: #selector(template), for: .touchUpInside)
        view.addSubview(templates)

        let (button4, camera) = Global.shared.tabButton("backdrop", "Backdrop", view, centers[3], nil, true, true)
        button4.addTarget(self, action: #selector(backdrop), for: .touchUpInside)
        view.addSubview(camera)
        
        let (button5, save) = Global.shared.tabButton("export", "Export", view, centers[4], .white, true, true)
        button5.addTarget(self, action: #selector(export), for: .touchUpInside)
        view.addSubview(save)
    }
    
    // MARK: - Button actions
    
    // top buttons
    
    @objc func menu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            //
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = pinkTint
        present(alert, animated: true, completion: nil)
    }
    
    @objc func aspectUpdate() {
        isModernAspect = !isModernAspect
        aspect.setTitle(isModernAspect ? "9:16" : "4:5", for: .normal)
        aspect.frame = CGRect(origin: CGPoint(x: 1.5*left + size.width, y: top), size: CGSize(width: 25, height: isModernAspect ? size.height : size.height*0.85))
        aspect.center = aspectCenter
        
        image.frame = CGRect(origin: CGPoint(x: left, y: 2*top + size.height), size: CGSize(width: view.frame.width - (2 * left), height: view.frame.height - (isModernAspect ? 250 : 350)))
        image.center = imageCenter
    }
    
    @objc func text() {
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // bottom buttons
    
    @objc func borders() {
        
    }
    
    @objc func branding() {
        
    }
    
    @objc func template() {
        
    }
    
    @objc func backdrop() {
        
    }
    
    @objc func export() {
        
    }
}

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
    let top: CGFloat = 20
    let offset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let dismiss = Global.shared.button("close-black", CGRect(origin: CGPoint(x: view.frame.width - 50, y: top), size: size), lightGrayTint, .verysmall)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        view.addSubview(label("Restore Subscription", blueTint, 16, top, true))
        view.addSubview(label("Unlimited Access", pinkTint, 22, 7*top, true))
        view.addSubview(label("$0.99 / month", .black, 28, 10*top, true))
        view.addSubview(label("all templates", .black, 18, 14*top, false, true))
        view.addSubview(label("all backdrops", .black, 18, 16*top, false, true))
        view.addSubview(label("all filters", .black, 18, 18*top, false, true))
        view.addSubview(label("all fonts", .black, 18, 20*top, false, true))
        view.addSubview(label("custom branding", .black, 18, 22*top, false, true))
        view.addSubview(label("updated weekly", .black, 18, 24*top, false, true))
        
        let subscribe = UIButton(frame: CGRect(x: 1.5*offset, y: 27*top, width: view.frame.width - 3*offset, height: 80))
        subscribe.backgroundColor = blueTint
        subscribe.setTitle("Subscribe Now\n(7 Day Free Trial)", for: .normal)
        subscribe.titleLabel?.font = .systemFont(ofSize: 20)
        subscribe.titleLabel?.numberOfLines = 0
        subscribe.titleLabel?.textAlignment = .center
        subscribe.setTitleColor(.white, for: .normal)
        subscribe.layer.cornerRadius = 10
        subscribe.layer.masksToBounds = true
        subscribe.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        view.addSubview(subscribe)
        
        let legal = UITextView(frame: CGRect(x: top, y: view.frame.height - 4*offset, width: view.frame.width - 2*top, height: 2*offset))
        legal.text = legalText
        legal.textColor = .gray
        legal.font = .systemFont(ofSize: 10)
        view.addSubview(legal)
        
        let buttonSize = CGSize(width: 2*offset, height: top)
        let buttonY = view.frame.height - 1.7*offset
        let terms = UIButton(frame: CGRect(origin: CGPoint(x: top, y: buttonY), size: buttonSize))
        terms.setTitle("Terms of Use", for: .normal)
        terms.setTitleColor(.black, for: .normal)
        terms.titleLabel?.font = .systemFont(ofSize: 12)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        view.addSubview(terms)
        
        let privacy = UIButton(frame: CGRect(origin: CGPoint(x: view.frame.width - top - buttonSize.width, y: buttonY), size: buttonSize))
        privacy.setTitle("Privacy Policy", for: .normal)
        privacy.setTitleColor(.black, for: .normal)
        privacy.titleLabel?.font = .systemFont(ofSize: 12)
        privacy.titleLabel?.textAlignment = .right
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        view.addSubview(privacy)
    }
    
    // MARK: - Setup UI
    
    func label(_ text: String, _ color: UIColor, _ fontSize: CGFloat, _ y: CGFloat, _ centered: Bool, _ checked: Bool = false) -> UIView {
        
        let height: CGFloat = 40
        
        let frame = CGRect(x: offset, y: y, width: view.frame.width - 2*offset, height: height)
        let background = UIView(frame: frame)
        
        let label = UILabel(frame: CGRect(origin: .zero, size: background.frame.size))
        label.textAlignment = centered ? .center : .left
        label.textColor = color
        label.text = text
        label.font = .systemFont(ofSize: fontSize)
        background.addSubview(label)
        
        if checked {
            let side: CGFloat = 14
            let check = UIImage(named: "check-white")?.tint(color: .black).resize(side)
            
            var x: CGFloat = 0
            if centered {
                let center = label.center
                label.sizeToFit()
                label.center = center
                x = label.frame.origin.x - side/2
                label.frame.origin.x += side/2 + 10
            }
            else {
                x = offset
                label.frame.origin.x = offset + side + 10
            }

            let imageView = UIImageView(image: check)
            imageView.contentMode = .center
            imageView.frame = CGRect(origin: CGPoint(x: x, y: (height - side)/2), size: CGSize(width: side, height: side))
            
            background.addSubview(imageView)
        }
        
        return background
    }

    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc func purchase() {
        print(#function)
    }
    
    @objc func termsTapped() {
        print(#function)
    }
    
    @objc func privacyTapped() {
        print(#function)
    }
}

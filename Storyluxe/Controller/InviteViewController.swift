//
//  InviteViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit
import BRYXBanner

class InviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let background = UIImageView(frame: view.bounds)
        background.image = UIImage(named: "invite")
        view.addSubview(background)
        
        let width: CGFloat = 150
        let label = UILabel(frame: CGRect(origin: CGPoint(x: (view.frame.width - width)/2, y: 55), size: CGSize(width: width, height: 25)))
        label.textAlignment = .center
        label.textColor = .lightGray
        label.text = "Invite your friends"
        label.font = .boldSystemFont(ofSize: 15)
        view.addSubview(label)
        
        let dismiss = UIButton(frame: CGRect(x: view.frame.width - 50, y: 50, width: 25, height: 25))
        dismiss.setImage(UIImage(named: "close-black"), for: .normal)
        dismiss.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(dismiss)
        
        let y = view.frame.height - 150
        let height: CGFloat = 50
        let firstWidth: CGFloat = 60
        
        let invite = UIButton(frame: CGRect(x: 20, y: y, width: firstWidth, height: height))
        invite.backgroundColor = pinkTint
        invite.setImage(UIImage(named: "share")?.tint(color: .white), for: .normal)
        invite.addTarget(self, action: #selector(share), for: .touchUpInside)
        view.addSubview(invite)
        
        let copy = UIButton(frame: CGRect(x: invite.frame.maxX + 10, y: y, width: view.frame.width - firstWidth - 50, height: height))
        copy.backgroundColor = pinkTint
        copy.setTitle("Copy Link", for: .normal)
        copy.setTitleColor(.white, for: .normal)
        copy.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        view.addSubview(copy)
    }
    

    // MARK: - Actions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc func copyLink() {
        UIPasteboard.general.string = "https://www.apple.com"
        let banner = Banner(title: "Copy Link!", subtitle: nil, image: nil, backgroundColor: blueTint)
        banner.titleLabel.textAlignment = .center
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    @objc func share() {
        let items = [URL(string: "https://www.apple.com")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

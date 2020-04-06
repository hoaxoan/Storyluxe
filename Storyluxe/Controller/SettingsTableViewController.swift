//
//  SettingsTableViewController.swift
//  Storyluxe
//
//  Created by Sergey Koval on 30.03.2020.
//  Copyright © 2020 Sergey Koval. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.tintColor = pinkTint
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let button = UIBarButtonItem(title: "Support", style: .done, target: self, action: #selector(emailSupport))
        navigationItem.rightBarButtonItem = button
        
        navigationController?.navigationBar.tintColor = pinkTint
    }

    // MARK: - Actions

    @objc func emailSupport() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Device cannot send emails.")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        settingsTitles.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitles[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "SUBSCRIPTION"
        case 1:
            return "ABOUT"
        case 2:
            return "FEEDBACK"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = settingsTitles[indexPath.section][indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.textColor = pinkTint
            cell.accessoryType = .none
        case 1:
            cell.textLabel?.textColor = indexPath.row < 4 ? .black : .gray
            cell.accessoryType = .disclosureIndicator
            if indexPath.row < 4 {
                let image = settingsImages[indexPath.row]
                let size: CGFloat = 40
                cell.imageView?.image = UIImage(named: image)?.resize(size)
                cell.imageView?.layer.cornerRadius = size/2
                cell.imageView?.layer.masksToBounds = true
            }
        case 2:
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - Delegates

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//  MenuViewController.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//


import UIKit
import SlideMenuControllerSwift
import MessageUI

enum MenuList: Int {
    case Home = 0
    case LiveStatus = 1
    case History = 2
    case YourKids = 3
    case Complain = 4
    case Logout = 5
}


class MenuViewController: BaseViewController {
    
    let menuList = ["LOGOUT"]
    let iconsList = ["logout"]

    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil),
                               forCellReuseIdentifier: MenuTableViewCell.Identifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.Identifier,
                                                 for: indexPath) as? MenuTableViewCell
        if let c = cell {
            c.menuLabel.text = menuList[indexPath.row]
            c.iconImageView.image = UIImage(named: iconsList[indexPath.row])
            return c
        }
        return UITableViewCell()
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case MenuList.Logout.rawValue:
            Utilities.clearAuthToken()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            _ = appDelegate?.slideMenu?.navigationController?.popToRootViewController(animated: true)
            appDelegate?.slideMenu = nil
        default: break
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate Method
extension MenuViewController: MFMailComposeViewControllerDelegate {
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        // TODO: set recipients
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}

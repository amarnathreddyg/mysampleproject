//
//  BaseViewController.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class BaseViewController: UIViewController {

    var showHamburger = false
    var showTitle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if showHamburger {
            let hamburgerIcon = UIButton(frame: CGRect(x: 15.0, y: 25.0, width: 35.0, height: 35.0))
            hamburgerIcon.addTarget(self, action: #selector(BaseViewController.openSideMenu), for: .touchUpInside)
            hamburgerIcon.tintColor = UIColor.black
            hamburgerIcon.setImage(UIImage(named: "complain"), for: .normal)
            view.addSubview(hamburgerIcon)
        }
        if showTitle {
            let titleLabel = UILabel(frame: CGRect(x: 70.0, y: 25.0,
                                                   width: UIScreen.main.bounds.width-70.0,
                                                   height: 35.0))
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byCharWrapping
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            titleLabel.text = screenTitle()
            view.addSubview(titleLabel)
        }
    }
    
    func screenTitle() -> String {
        return NSLocalizedString("Home", comment: "")
    }

    func openSideMenu() {
        slideMenu()?.openLeft()
    }
    
    func slideMenu() -> SlideMenuController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.slideMenu
    }
    
    func changeMainViewController(vc: UIViewController) {
        let slideNavigationController = UINavigationController(rootViewController: vc)
        slideNavigationController.isNavigationBarHidden = true
        slideMenu()?.changeMainViewController(slideNavigationController,
                                              close: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

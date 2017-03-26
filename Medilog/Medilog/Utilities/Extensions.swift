//
//  Extensions.swift
//  Medilog
//
//  Created by Amarnath on 25/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension UIViewController {
    
    func registerForKeyboardDidShowNotification(_ constraint: NSLayoutConstraint, _ offset: CGFloat? = 0.0, shouldUseTabHeight:Bool? = false, usingBlock block: ((Notification) -> Void)? = nil) -> Any {
        
        return NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil, using: { (notification) -> Void in
            let userInfo = notification.userInfo!
            let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
//            if shouldUseTabHeight == true {
//                constraint.constant = keyboardHeight + offset! - TabBarHeight
//            } else {
//                constraint.constant = keyboardHeight + offset!
//            }
            constraint.constant = keyboardHeight + offset!
            
            block?(notification)
        })
    }
    
    func registerForKeyboardWillHideNotification(_ constraint: NSLayoutConstraint, _ offset: CGFloat? = 0.0, usingBlock block: ((Notification) -> Void)? = nil) -> Any {
        
        return NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: { (notification) -> Void in
            constraint.constant = 0.0 + offset!
            block?(notification)
        })
    }
}

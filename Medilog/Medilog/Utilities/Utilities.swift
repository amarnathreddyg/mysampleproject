//
//  Utilities.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//


import UIKit
import ReachabilitySwift
import Unbox
import Toaster

let NetworkStatusChangeNotification = ReachabilityChangedNotification

class Utilities {
    
    static let shared = Utilities()
    var isOpen = true
    fileprivate var reachability = Reachability()

    fileprivate init() { }
    
//MARK: - Reachability Methods
    
    fileprivate func startReachabilityNotifier() {
        do {
            try self.reachability!.startNotifier()
        } catch let error as NSError {
            debugPrint(error as AnyObject)
        }
    }
    
    func setupReachability() {
        self.startReachabilityNotifier()
    }
    
    func isNetworkReachable() -> Bool {
        return (reachability?.isReachable) ?? false
    }
    
    func removeReachabilityObserver() {
        reachability?.stopNotifier()
        reachability = nil
    }

//MARK: - Alert & Activity Methods
    
    class func showToastWithMessage(_ message: String) {
        Toast(text: message).show()
    }
    
    class func showHUD(to view: UIView, _ message: String?) {
        Utilities.hideHUD(from: view)
        UIApplication.shared.beginIgnoringInteractionEvents()
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    class func hideHUD(from view: UIView) {
        MBProgressHUD.hide(for: view, animated: false)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
//MARK: - LifeCycle Methods
    
    deinit {
        removeReachabilityObserver()
    }
    
    class func showNoInternetMessage() {
        Utilities.showToastWithMessage("Please check your internet.")
    }
    
    class func saveAuthToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "AUTH_TOKEN")
        UserDefaults.standard.synchronize()
    }
    
    class func getAuthToken() -> String {
        if let token =  UserDefaults.standard.value(forKey: "AUTH_TOKEN") as? String {
            debugPrint(token)
            return token;
        }
        return ""
    }
    
    class func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: "AUTH_TOKEN")
    }
}



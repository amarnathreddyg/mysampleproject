//
//  LoginViewController.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(endEditingNow))
        let toolbarButtons = [space, space, item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        phoneField.inputAccessoryView = keyboardDoneButtonView
    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction func registerTapped(sender: Any) {
        
//        self.performSegue(withIdentifier: "OTPVC", sender: nil)
//        return
        guard ((phoneField.text?.characters.count)! == 10 ) else {
            Utilities.showToastWithMessage("Please enter valid mobile number.")
            return
        }
        
        guard Utilities.shared.isNetworkReachable() else {
            Utilities.showNoInternetMessage()
            return
        }
        

        Utilities.showHUD(to: self.view, "")
        ApiManager.shared.register(phoneNumber: phoneField.text!) { (isSuccess, object) in
            DispatchQueue.main.async(execute: {
                debugPrint(isSuccess)
                debugPrint(object ?? "Object error")
                Utilities.hideHUD(from: self.view)
                if isSuccess == true {
                    self.performSegue(withIdentifier: "OTPVC", sender: nil)
                } else if (object != nil) {
                    let object_ = object as? [String:AnyObject]
                    Utilities.showToastWithMessage(object_?["message"] as! String)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension LoginViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = true
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
    }
    
}


//
//  LoginViewController.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TextFieldCell.nib(), forCellReuseIdentifier: TextFieldCell.cellIdentifier())
    }
    
    func addInputAccessoryView(forField txtField:UITextField) {
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(endEditingNow))
        let toolbarButtons = [space, space, item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        txtField.inputAccessoryView = keyboardDoneButtonView

    }
    
    func endEditingNow(){
        self.view.endEditing(true)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func loginTapped(sender: Any) {
        
        guard Utilities.shared.isNetworkReachable() else {
            Utilities.showNoInternetMessage()
            return
        }

//        Utilities.showHUD(to: self.view, "")
//        ApiManager.shared.login(email: "", password: "") { (isSuccess, object) in
//            DispatchQueue.main.async(execute: {
//                debugPrint(isSuccess)
//                debugPrint(object ?? "Object error")
//                Utilities.hideHUD(from: self.view)
//                if isSuccess == true {
//                    //self.performSegue(withIdentifier: "OTPVC", sender: nil)
//                } else if (object != nil) {
//                    let object_ = object as? [String:AnyObject]
//                    Utilities.showToastWithMessage(object_?["message"] as! String)
//                }
//            })
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.cellIdentifier()) as! TextFieldCell
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row

        switch indexPath.row {
            
        case 0:
            cell.loadCell(withText: "", placeholder: "Email", keyboardType: .emailAddress)
        case 1:
            cell.loadCell(withText: "", placeholder: "Password", isSecured: true)
        default:
            cell.loadCell(withText: "", placeholder: "")

        }

        return cell
    }
}

extension LoginViewController: UITextFieldDelegate {

    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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


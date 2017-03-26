//
//  RegisterViewController.swift
//  Medilog
//
//  Created by Amarnath on 25/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit
import Toaster

enum RegistrationField: Int {
    case firstName
    case lastName
    case sex
    case email
    case confirmEmail
    case password
    case confirmPassword

}


class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!

    fileprivate var registration = Registration()
    fileprivate var currentRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboard notifications
        _ = registerForKeyboardDidShowNotification(tableBottomConstraint, shouldUseTabHeight: false)
        _ = registerForKeyboardWillHideNotification(tableBottomConstraint)

        tableView.register(TextFieldCell.nib(), forCellReuseIdentifier: TextFieldCell.cellIdentifier())

        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func createAccount(_ sender:Any) {
        
        view.endEditing(true)
        if isValidData() {
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
        }
    }
            
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex == 0 ? currentRow - 1 : currentRow + 1
        
        if let cell_ = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TextFieldCell {
            cell_.textField.becomeFirstResponder()
        } else {
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
            currentRow = index
        }
    }
    
    fileprivate func relaodSegment() {
        if currentRow == 0 {
            segmentControl.setEnabled(false, forSegmentAt: 0)
            segmentControl.setEnabled(true, forSegmentAt: 1)
        } else if currentRow == RegistrationField.confirmPassword.rawValue {
            segmentControl.setEnabled(false, forSegmentAt: 1)
            segmentControl.setEnabled(true, forSegmentAt: 0)
        } else {
            segmentControl.setEnabled(true, forSegmentAt: 0)
            segmentControl.setEnabled(true, forSegmentAt: 1)
        }
    }
    
    fileprivate func isValidData() -> Bool {
        
        
        if let firstName_ = registration.firstName, firstName_.trim().characters.count > 0 {
            registration.firstName = firstName_
        } else {
            showToastWithMessage("Please enter first name.")
            return false
        }
        
        if let lastName_ = registration.lastName, lastName_.trim().characters.count > 0 {
            registration.lastName = lastName_
        } else {
            showToastWithMessage("Please enter last name.")
            return false
        }
        
        if let sex = registration.sex {
            registration.sex = sex
        } else {
            showToastWithMessage("Please select sex.")
            return false
        }
        
        if let email_ = registration.email, email_.trim().characters.count > 0 {
            guard Utilities.isValidEmail(testStr: email_) == true else {
                showToastWithMessage("Please enter valid email.")
                return false
            }
            registration.email = email_
        } else {
            showToastWithMessage("Please enter email.")
            return false
        }
        
        
        guard registration.email == registration.confirmEmail else {
            showToastWithMessage("Email and confirm email should be same.")
            return false
        }
        
        if let password_ = registration.password, password_.characters.count > 0 {
            registration.password = password_
        } else {
            showToastWithMessage("Please enter password.")
            return false
        }
        
        
        if let retypePassword_ = registration.confirmPassword, retypePassword_.characters.count > 0 {
            registration.confirmPassword = retypePassword_
        } else {
            showToastWithMessage("Please enter confirm password.")
            return false
        }
        
        guard registration.password!.characters.count >= MinPasswordCharacters || registration.confirmPassword!.characters.count >= MinPasswordCharacters  else {
            showToastWithMessage("Password must be atleast 6 characters in length.")
            return false
        }
        
        guard registration.password == registration.confirmPassword else {
            showToastWithMessage("Password and Retype password should be same.")
            return false
        }
        
        
        return true
    }
    
    fileprivate func showToastWithMessage(_ message: String) {
        
        //self.view.hideToastActivity()
        //self.view.makeToast(message)
        Toast(text: message).show()
    }

}


extension RegisterViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.cellIdentifier()) as! TextFieldCell
        cell.selectionStyle = .none
        cell.textField.keyboardType = .asciiCapable
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        cell.textField.inputAccessoryView = toolBar
        
        switch indexPath.row {
            
            case RegistrationField.firstName.rawValue:
                cell.loadCell(withText: "", placeholder: "First Name")
            case RegistrationField.lastName.rawValue:
                cell.loadCell(withText: "", placeholder: "Last Name")
            case RegistrationField.sex.rawValue:
                cell.loadCell(withText: "", placeholder: "Sex")
            case RegistrationField.email.rawValue:
                cell.loadCell(withText: "", placeholder: "Email", keyboardType: .emailAddress)
            case RegistrationField.confirmEmail.rawValue:
                cell.loadCell(withText: "", placeholder: "Confirm Email", keyboardType: .emailAddress)
            case RegistrationField.password.rawValue:
                cell.loadCell(withText: "", placeholder: "Password (min 6 char)", isSecured: true)
            case RegistrationField.confirmPassword.rawValue:
                cell.loadCell(withText: "", placeholder: "Retype Password", isSecured: true)
            default:
                cell.loadCell(withText: "", placeholder: "")
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if currentRow == indexPath.row {
            let cell_ = cell as! TextFieldCell
            cell_.textField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentRow = textField.tag
        tableView.scrollToRow(at: IndexPath(row: textField.tag, section: 0), at: .none, animated: true)
        relaodSegment()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

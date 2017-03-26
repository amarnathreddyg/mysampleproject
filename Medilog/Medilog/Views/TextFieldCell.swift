//
//  TextFieldCell.swift
//  Medilog
//
//  Created by Amarnath on 25/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 15.0, height: 15.0))
        textField.leftView = paddingView;
        textField.leftViewMode = .always

        // Initialization code
    }

    class func nib() -> UINib {
        return UINib(nibName: "TextFieldCell", bundle: nil)
    }
    
    class func cellIdentifier() -> String {
        return "TextFieldCell"
    }
    

    func loadCell(withText text:String, placeholder placeholderText:String, isSecured secured:Bool? = false, keyboardType type:UIKeyboardType? = .default) {
        
        textField.keyboardType = type!
        textField.isSecureTextEntry = secured!
        
        if text.characters.count != 0 {
            textField.text = text
        }
        
        if placeholderText.characters.count != 0 {
            textField.placeholder = placeholderText
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

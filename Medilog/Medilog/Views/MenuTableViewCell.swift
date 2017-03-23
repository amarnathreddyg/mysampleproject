//
//  MenuTableViewCell.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static let Identifier = "MenuCellIdentifier"
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

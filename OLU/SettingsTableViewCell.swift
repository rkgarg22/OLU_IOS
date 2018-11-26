//
//  SettingsTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var buttonText: UILabelCustomClass!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var titlelabel: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

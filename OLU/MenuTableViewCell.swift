//
//  MenuTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 25/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var seeBtn: UIButton!
    @IBOutlet var titleLabel: UILabelCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

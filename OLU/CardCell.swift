//
//  addressCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 17/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet var cardLabel: UILabelCustomClass!
    @IBOutlet var selectedImageView : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  FAQTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 03/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet var plusButton: UIButtonCustomClass!
    @IBOutlet var answerLabel: UILabelCustomClass!
    @IBOutlet var questLabel: UILabelCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

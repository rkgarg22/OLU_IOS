//
//  ChatTwoCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class ChatTwoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabelCustomClass!
    @IBOutlet weak var timeLabel: UILabelCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   func resulDictList(resultdict:NSDictionary) {
    let messgaeString = resultdict.value(forKey: "message") as! String
    nameLabel.text = messgaeString
    }

}

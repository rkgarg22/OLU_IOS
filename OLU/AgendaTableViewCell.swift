//
//  AgendaTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 28/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var nameLabel: UILabelCustomClass!
    @IBOutlet var profilePic: UIImageViewCustomClass!
    @IBOutlet var timeLabel: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resultDictDetails(resultDict :NSDictionary){
        categoryLabel.text = resultDict.value(forKey: "category") as? String
        let firstName = resultDict.value(forKey: "firstName") as? String
        let lastName = resultDict.value(forKey: "lastName") as? String
        nameLabel.text = firstName! + lastName!
        let iconImageString = resultDict.value(forKey: "") as! String
        if iconImageString != ""{
            profilePic.sd_setImage(with: URL(string: iconImageString ), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
        }
        timeLabel.text = resultDict.value(forKey: "") as! String
    }

}

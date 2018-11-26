//
//  LocationTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 16/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet var rating: CosmosView!
    @IBOutlet var descriptionLabel: UILabelCustomClass!
    @IBOutlet var titlelabel: UILabelCustomClass!
    @IBOutlet var enterBtn: UIButton!
    @IBOutlet var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func resulDictList(resultdict:NSDictionary) {
        print("resultDict=",resultdict)
        titlelabel.text = (resultdict.value(forKey: "firstName") as! String) + " " + (resultdict.value(forKey: "lastName") as! String)
        descriptionLabel.text = resultdict.value(forKey: "categoryName") as? String
        rating.rating = Double(resultdict.value(forKey: "reviews") as! Int)
    }
}

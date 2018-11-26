//
//  AllTrainingTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 17/06/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class AllTrainingTableViewCell: UITableViewCell {
    
    @IBOutlet var reservarBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var priceLabel: UILabelCustomClass!
    @IBOutlet var profileView: UIImageView!
    @IBOutlet var descriptionLabel: UILabelCustomClass!
    @IBOutlet var nameLabel: UILabelCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func resulDictList(resultdict:NSDictionary) {
        nameLabel.text = (resultdict.value(forKey: "firstName") as! String) + " " + (resultdict.value(forKey: "lastName") as! String)
        descriptionLabel.text = resultdict.value(forKey: "categoryName") as? String
        
        let price = resultdict.value(forKey: "price") as! String
        if(price != ""){
//            let myDouble = Double(price)
//            let priceConv = getConvertedPriceString(myDouble:myDouble!)
            priceLabel.text = "$" + price
        }else{
            priceLabel.text = ""
        }
        
        ratingView.rating = Double(resultdict.value(forKey: "reviews") as! Int)
        
        if let iconImageString = resultdict.value(forKey: "userImageUrl"){
            if iconImageString as! String != ""{
                profileView.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
            }else{
                profileView.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
            }
        }
    }
    
}

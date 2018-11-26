//
//  CategoryTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 27/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var resarvarView: UIViewCustomClass!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var circleLabel: UILabelCustomClass!
    @IBOutlet var descriptionLabel: UILabelCustomClass!
    @IBOutlet var reserveBtn: UIButton!
    @IBOutlet var plusButton: NSLayoutConstraint!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var nameLabel: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  UserPayemntCell.swift
//  OLU
//
//  Created by DIKSHA on 29/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class UserPayemntCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabelCustomClass!
    @IBOutlet weak var nameLabel: UILabelCustomClass!
    @IBOutlet weak var dateLabel: UILabelCustomClass!
    @IBOutlet weak var priceLabel: UILabelCustomClass!
    @IBOutlet weak var referenceLabel: UILabelCustomClass!
    @IBOutlet weak var statusLabel: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func resultDictForPayment(resultDict:NSDictionary) {
        let amount = resultDict.value(forKey: "amount") as! String
        priceLabel.text = "$" + amount
        dateLabel.text = resultDict.value(forKey: "date") as? String
        nameLabel.text = resultDict.value(forKey: "categoryName") as? String
        timeLabel.text = convertTime(timeString: (resultDict.value(forKey: "time") as? String)!)
        referenceLabel.text = resultDict.value(forKey: "reference") as? String
        
        let paymentStatus = resultDict.value(forKey: "paymentStatus") as AnyObject
        if paymentStatus .isEqual(1) {
            statusLabel.text = "APROBADO"
        }else if paymentStatus.isEqual(0){
            statusLabel.text = "RECHAZADO"
        }else{
            statusLabel.text = "PENDIENTE"
        }
    }
    
    func convertTime(timeString:String) -> String{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        inFormatter.dateFormat = "HH:mm:ss"
        
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        outFormatter.dateFormat = "hh:mm a"
        
        let date = inFormatter.date(from: timeString)!
        let stringTime = outFormatter.string(from: date)
        return stringTime
    }
    
}

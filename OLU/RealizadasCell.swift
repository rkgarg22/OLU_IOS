//
//  RealizadasCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 18/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class RealizadasCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabelCustomClass!
    @IBOutlet var nameLabel: UILabelCustomClass!
    @IBOutlet var catName: UILabelCustomClass!
    @IBOutlet var catImage: UIImageView!
    @IBOutlet var dateLabel: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func resultDict(resultDict:NSDictionary) {
        let startTime = resultDict.value(forKey: "bookingStart") as! String
        let endTime = resultDict.value(forKey: "bookingEnd") as! String
        timeLabel.text = getTimeInFormat(time: startTime) + " - " + getTimeInFormat(time: endTime)
        catName.text = resultDict.value(forKey: "category") as? String
        dateLabel.text = resultDict.value(forKey: "bookingDate") as? String
        let firsrtName = resultDict.value(forKey: "firstName") as! String
        let lastName = resultDict.value(forKey: "lastName") as! String
        let catId = resultDict.value(forKey: "categoryID") as! Int
        nameLabel.text = firsrtName + " " + lastName
        catImage.image = setCat(catId: catId)
    }
    
    func resultDictForPayment(resultDict:NSDictionary) {
        let endTime = resultDict.value(forKey: "bookingEnd") as! String
        let amount = resultDict.value(forKey: "amount") as! String
    
        let amountInDocuble = Double(amount)
        let final = String(format: "%.3f", amountInDocuble!)
        timeLabel.text = "$" + final + "\n" + getTimeInFormat(time: endTime)
        catName.text = resultDict.value(forKey: "category") as? String
        dateLabel.text = resultDict.value(forKey: "date") as? String
        let firsrtName = resultDict.value(forKey: "firstName") as! String
        let lastName = resultDict.value(forKey: "lastName") as! String
        let catId = resultDict.value(forKey: "categoryID") as! Int
        nameLabel.text = firsrtName + " " + lastName
        catImage.image = setCat(catId: catId)
    }
    
    func getTimeInFormat(time: String)-> String{
        var timeFormat = String()
        
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        let dateConverted = dateFormatter.date(from: time)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a" //Your date format
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        timeFormat = timeFormatter.string(from: dateConverted!)
        
        return timeFormat
    }
    
    // auto fill category type
    func setCat(catId :Int)-> UIImage {
        
        var catImage = UIImage()
        switch catId {
        case 1 :
            catImage = #imageLiteral(resourceName: "boxingIcon")
            break;
        case 2 :
            catImage = #imageLiteral(resourceName: "watchIcon")
            
        case 3 :
            catImage = #imageLiteral(resourceName: "timerIcon")
            
        case 4 :
            catImage = #imageLiteral(resourceName: "roleIcon")
            
        case 5 :
            catImage = #imageLiteral(resourceName: "heartIcon")
            
        case 11 :
            catImage = #imageLiteral(resourceName: "shoesIcon")
            
        case 10 :
            catImage = #imageLiteral(resourceName: "Gimnasia")
            
        case 9 :
            catImage = #imageLiteral(resourceName: "theraphyIcon")
            
        case 8 :
            catImage = #imageLiteral(resourceName: "masajes")
            
        case 12 :
            catImage = #imageLiteral(resourceName: "masajes")
            
        default:
            print("")
        }
        return catImage
    }
    
    
}

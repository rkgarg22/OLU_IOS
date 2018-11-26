//
//  PendingCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 18/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class PendingCell: UITableViewCell {

    @IBOutlet var crossBtn: UIButton!
    @IBOutlet var phoneRingingBtn: UIButton!
    @IBOutlet var messageBtn: UIButton!
    @IBOutlet var directionBtn: UIButton!
    @IBOutlet var timeLabel: UILabelCustomClass!
    @IBOutlet var dateLabel: UILabelCustomClass!
    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var nameLabel: UILabelCustomClass!
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
        timeLabel.text = "\(getTimeInFormat(time: startTime)) - \(getTimeInFormat(time: endTime))"
        let catId = resultDict.value(forKey: "categoryID") as! Int
        let catName = getCatName(catID: catId)
        categoryLabel.text = catName
        
        let selectedDate = resultDict.value(forKey: "bookingDate") as? String
 
        dateLabel.text = getDateInFormat(selectedDate: selectedDate!)
        let firstName = resultDict.value(forKey: "firstName") as! String
        let lastName = resultDict.value(forKey: "lastName") as! String
        nameLabel.text = firstName + " " + lastName
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
    
    func getDateInFormat(selectedDate: String)->String{
        var convertedDate = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        let firstConvertedDate = dateFormatter.date(from: selectedDate) //according to date
        
        dateFormatter.dateFormat = "MMMM" //month
        dateFormatter.locale =  NSLocale(localeIdentifier: "es") as Locale?
        let monthName = dateFormatter.string(from: firstConvertedDate!)
        
        dateFormatter.dateFormat = "dd"
        let dateWeek = dateFormatter.string(from: firstConvertedDate!)
        convertedDate = dateWeek + "/" + monthName.capitalized
        return convertedDate
    }

}

//
//  TodaysBookingTableViewCell.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class TodaysBookingTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var nameLable: UILabelCustomClass!
    @IBOutlet var profilePic: UIImageViewCustomClass!
    @IBOutlet var startTimeLabel: UILabelCustomClass!
    
    @IBOutlet var nameLableForCompleteSession: UILabelCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func resulDictDisplay(resultDict:NSDictionary){
        print(resultDict)
        if resultDict.value(forKey: "isAgenda") as? Int ?? 0 == 1 {
            nameLable.text = resultDict.value(forKey: "agendaText") as? String
            nameLableForCompleteSession.isHidden = true
            nameLable.isHidden = false
            profilePic.isHidden = true
            self.backgroundColor = UIColor.white
        } else {
            profilePic.isHidden = false
            let firstName = resultDict.value(forKey: "firstName") as! String
            let lastName = resultDict.value(forKey: "lastName") as! String
            
            if(resultDict.value(forKey: "status") as! Int == 3){
                nameLable.text = "\(firstName) \(lastName)"
                nameLableForCompleteSession.isHidden = true
                nameLable.isHidden = false
                self.backgroundColor = UIColor.white
            }else{
                nameLableForCompleteSession.text = "\(firstName) \(lastName)"
                nameLableForCompleteSession.isHidden = false
                nameLable.isHidden = true
                self.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
            }
            
            if let iconImageString = resultDict.value(forKey: "userImageUrl") as? String{
                if iconImageString != ""{
                    profilePic.sd_setImage(with: URL(string: iconImageString ), placeholderImage: #imageLiteral(resourceName: "UserDummyPic"))
                }else{
                    profilePic.sd_setImage(with: URL(string: iconImageString ), placeholderImage: #imageLiteral(resourceName: "UserDummyPic"))
                }
            }
        }
        
        categoryLabel.text =  resultDict.value(forKey: "category") as? String
        let startTime = resultDict.value(forKey: "bookingStart") as! String
        startTimeLabel.text = "\(getTimeInFormat(time: startTime))"
        
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
    
}

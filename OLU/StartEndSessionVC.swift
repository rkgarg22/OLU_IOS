//
//  StartEndSessionVC.swift
//  OLU
//
//  Created by DIKSHA on 19/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class StartEndSessionVC: UIViewController,bookingStatusChangeAlamofire,confirmBookingAlamofire {
    
    @IBOutlet weak var dayDateLabel: UILabelCustomClass!
    @IBOutlet weak var endTimeLabel: UILabelCustomClass!
    @IBOutlet weak var startTimeLabel: UILabelCustomClass!
    @IBOutlet weak var monthLabel: UILabelCustomClass!
    @IBOutlet weak var weekdayName: UILabelCustomClass!
    @IBOutlet weak var catNameLabel: UILabelCustomClass!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabelCustomClass!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet var sessionButton: UIButton!
    
    var bookingId = Int()
    var status = Int()
    var bookingDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoFill()
    }
    
    func autoFill() {
        bookingId = bookingDict.value(forKey: "bookingID") as? Int ?? 0
        if( UserDefaults.standard.value(forKey: "sessionStartBookingDict")  != nil){
            sessionButton.isHidden = true
        }else{
            sessionButton.isHidden = false
        }
        
        startTimeLabel.text = getTimeInformat(startTime: (bookingDict.value(forKey: "bookingStart") as? String)!)
        endTimeLabel.text = getTimeInformat(startTime: (bookingDict.value(forKey: "bookingEnd") as? String)!)
        nameLabel.text = (bookingDict.value(forKey: "firstName") as! String) + " " + (bookingDict.value(forKey: "lastName") as! String)
        if let iconImageString = bookingDict.value(forKey: "userImageUrl"){
            if iconImageString as! String != ""{
                profilePic.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage:nil)
            }
            else{
                profilePic.image = #imageLiteral(resourceName: "UserImage")
            }
        }
        // calculate date
        let dateString = bookingDict.value(forKey: "bookingDate") as! String
        print("dateString==",dateString)
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        let dateConverted = dateFormatter.date(from: dateString) //according to date format your date string
        
        monthLabel.text =  getMonthName(date: dateConverted!)
        weekdayName.text = getWeekdayName(date: dateConverted!)
        dayDateLabel.text = getDay(date: dateConverted!)
        setCat()
    }
    
    func getTimeInformat(startTime:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let timeConverter = dateFormatter.date(from: startTime)
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeConverter!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // auto fill category type
    func setCat() {
        let catId = bookingDict.value(forKey: "categoryID") as! Int
        
        switch catId {
        case 1 :
            catImage.image = #imageLiteral(resourceName: "boxingIcon")
            catNameLabel.text = "Kickboxing"
            break;
        case 2 :
            catImage.image = #imageLiteral(resourceName: "watchIcon")
            catNameLabel.text = "Entrenamiento Funcional"
            break;
        case 3 :
            catImage.image = #imageLiteral(resourceName: "timerIcon")
            catNameLabel.text = "Stretching"
            break;
        case 4 :
            catImage.image = #imageLiteral(resourceName: "roleIcon")
            catNameLabel.text = "Yoga"
            break;
        case 5 :
            catImage.image = #imageLiteral(resourceName: "heartIcon")
            catNameLabel.text = "Pilates"
            break ;
        case 11 :
            catImage.image = #imageLiteral(resourceName: "shoesIcon")
            catNameLabel.text = "Dance Fit"
            break;
        case 10 :
            catImage.image = #imageLiteral(resourceName: "Gimnasia")
            catNameLabel.text = "Gimnasia Adulto Mayor"
            break;
        case 9 :
            catImage.image = #imageLiteral(resourceName: "theraphyIcon")
            catNameLabel.text = "Fisioterapia"
            break;
        case 8 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            catNameLabel.text = "Masajes Deportivos"
            break;
        case 12 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            catNameLabel.text = "Masajes Deportivos"
            break;
        default:
            catImage.image = #imageLiteral(resourceName: "masajes")
            
        }
    }
    
    //MARK: - Home Button Action
    @IBAction func startSessionAction(_ sender: Any) {
        status = 4
        statusChange(state: "4")
    }
    
    //MARK: - Home Button Action
    @IBAction func endSessionAction(_ sender: Any) {
        status = 1
        statusChange(state: "1")
    }
    
    //MARK: - Home Button Action
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func statusChange(state:String){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.bookingStatusChangeDelegate = self
            AlamofireWrapper.sharedInstance.bookingStatusChange(bookingID: String(bookingId), state: state)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func bookingStatusChangeResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            if(status == 1){
                UserDefaults.standard.set("1", forKey: "isAvailAble");
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrainerHomeScreen"), object:nil);
                let myVC = storyboard?.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
                myVC.nameString = (bookingDict.value(forKey: "firstName") as! String) + " " + (bookingDict.value(forKey: "lastName") as! String)
                navigationController?.pushViewController(myVC, animated: true)
            }else{
                sessionButton.isHidden = true
                UserDefaults.standard.set("0", forKey: "isAvailAble");
                UserDefaults.standard.set(bookingDict, forKey: "sessionStartBookingDict")
               
                let bookingId = bookingDict.value(forKey: "bookingID") as! Int
                applicationDelegate.removeNotification(bookingIdString: String(bookingId))
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @IBAction func mapaBtnClick(_ sender: UIButton){
        let alertController = UIAlertController(title:"Seleccionar opción", message: "", preferredStyle: .alert)
        // Create the actions
        let wazeAction = UIAlertAction(title:"WAZE", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (self.bookingDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.bookingDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    if let url = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        else{
                            let itunesUrl = URL(string: wazeItunesUrl)
                            UIApplication.shared.open(itunesUrl!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        
        let googleMapAction = UIAlertAction(title: "GOOGLE MAPS", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (self.bookingDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.bookingDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    let url = URL(string: "http://maps.google.com/?saddr=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&daddr=\(latitude),\(longitude)")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(wazeAction)
        alertController.addAction(googleMapAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func chatBtnClick(_ sender: UIButton){
        let firsrtName = bookingDict.value(forKey: "firstName") as! String
        let lastName = bookingDict.value(forKey: "lastName") as! String
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChatVc") as! ChatVC
        myVC.toUserId = bookingDict.value(forKey: "userID") as! Int
        myVC.userName = firsrtName + " " + lastName
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func phoneBtnClick(_ sender: UIButton){
        let phone = bookingDict.value(forKey: "phone") as! String
        if(phone != ""){
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func crossBtnClick(_ sender: UIButton){
        let bookingId = bookingDict.value(forKey: "bookingID") as! Int
        updateOrderStatusAPI(status: "2", bookingID: bookingId,isPaymentRequire: "0")
    }
    
    func updateOrderStatusAPI(status:String, bookingID: Int,isPaymentRequire: String){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.confirmBookingDelegate = self
            AlamofireWrapper.sharedInstance.confirmBooking(bookingID: String(bookingID)  , status: status,isPaymentRequire: isPaymentRequire)
        }
    }
    func confirmBookingResults(dictionaryContent: NSDictionary) {
        let bookingId = bookingDict.value(forKey: "bookingID") as! Int
        applicationDelegate.removeNotification(bookingIdString: String(bookingId))
        applicationDelegate.dismissProgressView(view: self.view)
        let suucess = dictionaryContent.value(forKey: "success") as AnyObject
        if suucess.isEqual(1){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrainerHomeScreen"), object:nil);
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

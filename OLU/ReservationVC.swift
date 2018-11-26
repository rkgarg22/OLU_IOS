//
//  ReservationVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 05/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import WebKit
import CoreLocation

class ReservationVC: UIViewController ,bookingAlamoFire ,paymentInitiateAlamofire  ,WKUIDelegate, WKNavigationDelegate, MarkCardSelectedProtocol {
    @IBOutlet var okBtnView: UIViewCustomClass!
    @IBOutlet weak var priceFinal: UILabelCustomClass!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var contactLabel: UILabelCustomClass!
    @IBOutlet var groupView: UIView!
    @IBOutlet var overLayView: UIView!
    @IBOutlet var groupImage: UIImageView!
    @IBOutlet var catLabel: UILabelCustomClass!
    @IBOutlet var groupName: UILabelCustomClass!
    @IBOutlet var catName: UILabelCustomClass!
    @IBOutlet var catImage: UIImageView!
    @IBOutlet var numberOfPeopleLabel: UILabelCustomClass!
    @IBOutlet var dateLabel: UILabelCustomClass!
    @IBOutlet var priceLabel: UILabelCustomClass!
    @IBOutlet var locationLabel: UILabelCustomClass!
    @IBOutlet var ratingReviews: CosmosView!
    @IBOutlet var contactNumber: UILabelCustomClass!
    @IBOutlet var nameLabel: UILabelCustomClass!
    @IBOutlet var profilePic: UIImageViewCustomClass!
    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var monthLabel: UILabelCustomClass!
    @IBOutlet var weekdaylabel: UILabelCustomClass!
    var trainerDetailDict = NSDictionary()
    var localSavedDict = NSMutableDictionary()
    var webView: WKWebView!
    var requestID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        startFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let text =  webView.url?.absoluteString
        if text == "http://ec2-13-58-57-186.us-east-2.compute.amazonaws.com/api/payment/return/" {
            webView.removeFromSuperview()
            callMarkSelectCardAPI(requestID: requestID)
        }
        else if (text?.contains("https://test.placetopay.com/redirection/cancel/"))! {
            webView.removeFromSuperview()
        }
    }
    
    func webView(_ webView:WKWebView, didFinish navigation: WKNavigation) {
        print("didFinsh")
    }
    
    func setPrice() {
        let count = localSavedDict.value(forKey: "groupCategory") as? String ?? "0"
        let catID = localSavedDict.value(forKey: "catId") as! Int
     //let categoryDict = getCategoryDict()
        let catArray = trainerDetailDict.value(forKey: "category") as! NSArray
        for dict in catArray {
            let currentDict = dict as! NSDictionary
            let catIdTrainer = currentDict.value(forKey: "categoryID") as! Int
            if catID == catIdTrainer {
            
                var price = String()
                if count == "1" {
                    price = currentDict.value(forKey: "singlePrice")  as? String ?? "0"
                }
                else if count == "2" {
                    price = currentDict.value(forKey: "groupPrice2")  as? String ?? "0"
                }
                else if count == "3" {
                    price = currentDict.value(forKey: "companyPrice")  as? String ?? "0"
                }
                else if count == "4" {
                    price = currentDict.value(forKey: "groupPrice3")  as? String ?? "0"
                }
                else {
                    price = currentDict.value(forKey: "groupPrice4")  as? String ?? "0"
                }
                priceFinal.text = price
                let priceInt = (price as NSString).floatValue
                let newPrice = priceInt + 2.000
                priceLabel.text = String(format: "%.3f", newPrice)
                break
            }
        }
    }
    
    func getCategoryDict()-> NSDictionary{
        var retunDict = NSDictionary()
        let catId = localSavedDict.value(forKey: "catId") as! Int
        let categoryArray = trainerDetailDict.value(forKey: "category")  as? NSArray
        for cat in categoryArray! {
            let catDict = cat as! NSDictionary
            let id = catDict["categoryID"] as! Int
            if(id == catId){
                retunDict = catDict
            }
        }
        return retunDict
    }
    
    func startFunc() {
        nameLabel.text = (trainerDetailDict.value(forKey: "firstName") as! String) + " " + (trainerDetailDict.value(forKey: "lastName") as! String)
        if let iconImageString = trainerDetailDict.value(forKey: "userImageUrl"){
            if iconImageString as! String != ""{
                profilePic.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage: #imageLiteral(resourceName: "UserImage"))
            }
        }
        let address = localSavedDict.value(forKey: "address") as! String
        locationLabel.text = address
        setPrice()
        ratingReviews.rating = Double(trainerDetailDict.value(forKey: "reviews") as! Int)
        
        // calculate date
        let dateSelectedString = localSavedDict.value(forKey: "selectedDate") as! String
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        var dateConverted = dateFormatter.date(from: dateSelectedString)
        
        if(dateConverted == nil){
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateConverted = dateFormatter.date(from: dateSelectedString)
        }
        
        monthLabel.text =  getMonthName(date: dateConverted!)
        weekdaylabel.text = getWeekdayName(date: dateConverted!)
        dateLabel.text = getDay(date: dateConverted!)
        setCat()
        
        //calculate time
        let startTime = localSavedDict.value(forKey: "selectedTime") as? String
        getEndTime(startTime: startTime!, dateConverted: dateConverted!)
    }
    
    func getEndTime(startTime:String,dateConverted:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        var timeConverter = dateFormatter.date(from: startTime)
        
        if(timeConverter == nil){
            dateFormatter.dateFormat = "HH:mm:ss"
            timeConverter = dateFormatter.date(from: startTime)
        }
        
        let calendar = Calendar.current
        let endTimeDate = calendar.date(byAdding: .hour, value: 1, to: timeConverter!)
        
        endTime.text = dateFormatter.string(from: endTimeDate!)
        timeLabel.text = dateFormatter.string(from: timeConverter!)
    }
    
    // auto fill category type
    func setCat() {
        print("localSavedDict",localSavedDict)
        let catId = localSavedDict.value(forKey: "catId") as! Int
        switch catId {
        case 1 :
            catImage.image = #imageLiteral(resourceName: "boxingIcon")
            catName.text = "Kickboxing"
            catLabel.text = "Kickboxing"
        case 2 :
            catImage.image = #imageLiteral(resourceName: "watchIcon")
            catName.text = "Entrenamiento Funcional"
            catLabel.text = "Entrenamiento Funcional"
        case 3 :
            catImage.image = #imageLiteral(resourceName: "timerIcon")
            catName.text = "Stretching"
            catLabel.text = "Stretching"
        case 4 :
            catImage.image = #imageLiteral(resourceName: "roleIcon")
            catName.text = "Yoga"
            catLabel.text = "Yoga"
        case 5 :
            catImage.image = #imageLiteral(resourceName: "heartIcon")
            catName.text = "Pilates"
            catLabel.text = "Pilates"
        case 11 :
            catImage.image = #imageLiteral(resourceName: "shoesIcon")
            catName.text = "Dance Fit"
            catLabel.text = "Dance Fit"
        case 10 :
            catImage.image = #imageLiteral(resourceName: "Gimnasia")
            catName.text = "Gimnasia Adulto Mayor"
            catLabel.text = "Gimnasia Adulto Mayor"
        case 9 :
            catImage.image = #imageLiteral(resourceName: "theraphyIcon")
            catName.text = "Fisioterapia"
            catLabel.text = "Fisioterapia"
        case 8 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            catName.text = "Masajes Deportivos"
            catLabel.text = "Masajes Deportivos"
        case 12 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            catName.text = "Masajes Deportivos"
            catLabel.text = "Masajes Deportivos"
        default:
            catImage.image = #imageLiteral(resourceName: "masajes")
            catName.text = "Masajes Deportivos"
        }
        groupSelected()
    }
    
    //auto fill number of people
    func groupSelected() {
        let groupId = localSavedDict.value(forKey: "groupCategory") as! String
        
        switch groupId {
        case "3" :
            groupName.text = "Empersarial"
            groupImage.image = #imageLiteral(resourceName: "companyTrainee")
        case "1" :
            groupName.text = "Individual"
            groupImage.image = #imageLiteral(resourceName: "personCalendar")
        default:
            if groupId == "2" {
                groupName.text = "Grupo 2"
            }
            else if groupId == "4" {
                groupName.text = "Grupo 3"
            }
            else if groupId == "5" {
                groupName.text = "Grupo 4"
            }
            groupImage.image = #imageLiteral(resourceName: "groupImage")
        }
    }
    
    func bookingConfirmed(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.checkWalletDelegate = self
            AlamofireWrapper.sharedInstance.checkWallet()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func bookingResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            overLayView.isHidden = false
            //let paymentRequire = dictionaryContent.value(forKey: "paymentRequire") as AnyObject
            //if paymentRequire .isEqual(1) {
              //  showAlert(self, message: paymentFromCardWarning, title: appName)
            //}
        }
        else{
            let isTokenSaved = dictionaryContent.value(forKey: "isTokenSaved") as! Int
            if isTokenSaved == 0 {
                showPopForPaymentAlert()
            }
            else{
                let error = dictionaryContent.value(forKey: "error") as! String
                showAlert(self, message: error, title: appName)
            }
        }
    }
    
    func showPopForPaymentAlert(){
        let alertController = UIAlertController(title:paymentConfirmPopUp, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.paymentInitiate()
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showWalletAlert(){
        let alertController = UIAlertController(title:appName, message: paymentFromCardWarning, preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.hitBookingApi()
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ComparePlanVc") as! ComparePlanVC
            self.navigationController?.pushViewController(myVC, animated: true)
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    func loadWebView(url:String) {
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(webView)
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    func paymentInitiate(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.paymentInitiateDelegate = self
            AlamofireWrapper.sharedInstance.getPayementInitiate()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func paymentInitiateResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            let isTokenAvailable = resultDict.value(forKey: "isTokenAvailable") as! Int
            if isTokenAvailable == 0 {
                let processUrlDict = resultDict.value(forKey: "processUrl") as! NSDictionary
                let processUrl = processUrlDict.value(forKey: "processURL") as! String
                let processUrlString = processUrl
                requestID = processUrlDict.value(forKey: "requestId") as! String
                self.loadWebView(url: processUrlString)
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func placeToPay(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVc") as! WebViewVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        bookingConfirmed()
    }
    
    func hitBookingApi() {
        var trainerUserID = Int();
        trainerUserID = trainerDetailDict.value(forKey: "userID") as! Int
        let catId = localSavedDict.value(forKey: "catId") as! Int
        let dateString = localSavedDict.value(forKey: "selectedDate") as! String
        let time = localSavedDict.value(forKey: "selectedTime") as? String
        let groupId = localSavedDict.value(forKey: "groupCategory") as! String
        let lat = localSavedDict.value(forKey: "latitude") as! String
        let long = localSavedDict.value(forKey: "longitude") as! String
        let address = localSavedDict.value(forKey: "address") as! String
        AlamofireWrapper.sharedInstance.bookingDelegate = self
        AlamofireWrapper.sharedInstance.booking(trainerUserID: trainerUserID, catId: catId, bookingdate: dateString, bookingTime: time!, priceGroup: groupId, lat: lat, long: long, address: address)
    }
    
    func callMarkSelectCardAPI(requestID:String){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.markSelectedCardDelegate = self
            AlamofireWrapper.sharedInstance.markCardSelected(requestID: requestID)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getMarkSelectedCardData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            bookingConfirmed()
        }
        else {
            applicationDelegate.dismissProgressView(view: self.view)
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

extension ReservationVC: checkWalletProtocol {
    func checkWalletResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let walletAmount = dictionaryContent.value(forKey: "result") as? Double ?? 0.0
            if walletAmount == 0 {
                hitBookingApi()
            } else {
                let labelTextAmount = (priceLabel.text! as NSString).doubleValue
                if walletAmount < labelTextAmount {
                    showWalletAlert()
                } else {
                    hitBookingApi()
                }
            }
        }
        else{
                let error = dictionaryContent.value(forKey: "error") as! String
                showAlert(self, message: error, title: appName)
        }
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

//
//  SideBarVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import UserNotifications

class SideBarVC: UIViewController ,isAvailableAlamofire ,logoutAlamoFire, profileAlamofire, bookingStatusChangeAlamofire, onGoingAgendaProtocol {
    
   
    
    var isAvailable = String()
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var localButton: UIButton!
    @IBOutlet var sessionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        getMyProfileApiHit()
        getOnGoingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLockBtnStatus()
        if UserDefaults.standard.value(forKey: "sessionStartBookingDict") != nil{
            sessionButton.isHidden = false
            let image = UIImage(named: "finakizar")
            sessionButton.setImage(image, for: UIControlState.normal)
        }else{
            sessionButton.isHidden = true
        }
    }
    
    func onGoingData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            if let result = dictionaryContent.value(forKey: "result") as? AnyObject{
                 UserDefaults.standard.set(result, forKey: "sessionStartBookingDict")
            }
        }else{
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logOut()
    }
    
    func startFunc() {
        if  let isAvailableString =  UserDefaults.standard.value(forKey: "isAvailAble") as? String {
            if isAvailableString == "1" {
                localButton.isSelected = true
            }
            else{
                localButton.isSelected = false
            }
        }
    }
    
    func fireLocalNotifcation() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func scheduleLocalNotification() {
        let dataDict = ["isLocalNotification":"1"] as Any  // send data
        let content = UNMutableNotificationContent()
        content.title = "Has cumplido 24 horas como no disponible!"
        content.body = "No Olvides estar disponible para ser visible a miles de usuarios."
        content.userInfo = dataDict as! [AnyHashable : Any]
        content.categoryIdentifier = lockedNotificationIdentifier
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let userCalendar = Calendar.current
        var components = userCalendar.dateComponents([.hour, .minute], from: tomorrow!)
        components.hour = components.hour
        components.minute = components.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: lockedNotificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    func removeNotification(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == lockedNotificationIdentifier {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func checkLockBtnStatus(){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            let originalUrl = baseUrl+"trainerAvailable/?userID=\(getUserID())&lang=es="
            let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            print(urlString)
            Alamofire.request(urlString).responseJSON {
                (response:DataResponse<Any>) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response = ",response.result.value!)
                        let dictionaryContent: NSDictionary = response.result.value as! NSDictionary
                        applicationDelegate.dismissProgressView(view: self.view)
                        let success = dictionaryContent.value(forKey: "success") as AnyObject
                        if success .isEqual(1) {
                            let result = dictionaryContent.value(forKey: "result") as AnyObject
                            if(result .isEqual(1)){
                                UserDefaults.standard.set("1", forKey: "isAvailAble")
                            }else{
                                UserDefaults.standard.set("0", forKey: "isAvailAble")
                            }
                            self.startFunc()
                        }
                        else {
                            let error = dictionaryContent.value(forKey: "error") as! String
                            showAlert(self, message: error, title: appName)
                        }
                    }
                    break
                case .failure(_):
                    if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                        // no internet connection
                        print("noIntenetError=",err)
                    }
                    print("error",response.result.error!)
                    break
                }
            }
        }
    }
    
    func isAvailableResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            UserDefaults.standard.set(isAvailable, forKey: "isAvailAble")
            if(isAvailable == "1"){
                removeNotification();
            }else{
                fireLocalNotifcation()
            }
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @IBOutlet var termsConditionsButton: UIButton!
    @IBAction func lockButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isAvailable = "1"
        }
        else{
            isAvailable = "0"
        }
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.isAvailableDelegate = self
            AlamofireWrapper.sharedInstance.isAvailable(isAvailbale: isAvailable)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
        
    }
    @IBAction func termsConditionsButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "terms"
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    @IBAction func historyButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PendingVc") as! PendingVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as! ProfileVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func beginTrainingButton(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "sessionStartBookingDict") != nil{
            statusChange(state: "1")
        }
    }
    
    func logOut() {
        let alertController = UIAlertController(title:logoutAlert, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.logoutApiHit()
            
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func logoutApiHit() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.logoutDelegate = self
            AlamofireWrapper.sharedInstance.logOut()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func logoutResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            
            var firebaseToken = ""
            if UserDefaults.standard.value(forKey: USER_DEFAULT_DEVICETOKEN) != nil {
                firebaseToken = UserDefaults.standard.value(forKey: USER_DEFAULT_DEVICETOKEN) as! String
            }
            
            // Clearing NSUserDefault
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            // re-saving firebase token if previous exist
            if firebaseToken != "" {
                UserDefaults.standard.set(firebaseToken, forKey: USER_DEFAULT_DEVICETOKEN)
            }
            removeNotification()
            self.navigationController?.popToRootViewController(animated:true)
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func getMyProfileApiHit() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.profileDelegate = self
            AlamofireWrapper.sharedInstance.getProfileTrainer()
        }
    }
    
    func getOnGoingData() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.onGoingAgendaDelegate = self
            AlamofireWrapper.sharedInstance.getOnGoingSession()
        }
    }
    
    func profileResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            ratingView.rating = Double(resultDict.value(forKey: "reviews") as! Int)
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            applicationDelegate.dismissProgressView(view: self.view)
            showAlert(self, message: error, title: appName)
        }
    }
    
    func statusChange(state:String){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            let dict = UserDefaults.standard.value(forKey: "sessionStartBookingDict") as! NSDictionary
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.bookingStatusChangeDelegate = self
            AlamofireWrapper.sharedInstance.bookingStatusChange(bookingID: String(dict.value(forKey: "bookingID") as? Int ?? 0), state: state)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func bookingStatusChangeResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            UserDefaults.standard.set("1", forKey: "isAvailAble");
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTrainerHomeScreen"), object:nil);
            let bookingDict = UserDefaults.standard.value(forKey: "sessionStartBookingDict") as! NSDictionary
            let nameString = bookingDict.value(forKey: "firstName") as? String ?? ""
            let myVC = storyboard?.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            myVC.nameString = nameString
            navigationController?.pushViewController(myVC, animated: true)
            
            // let image = UIImage(named: "inicier")
            //  sessionButton.setImage(image, for: UIControlState.normal)
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

//
//  AppDelegate.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 18/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import FBSDKLoginKit
import Firebase
import UserNotifications
import UserNotificationsUI
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,confirmBookingAlamofire {
    
    var bookingIdString = String()
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    let manager = Alamofire.NetworkReachabilityManager(host:"www.apple.com")
    var isConnectedToNetwork = true
    
    
    var nibContents = Bundle.main.loadNibNamed("ConfirmPopUp", owner: self, options: nil)
    var nibContentsUser = Bundle.main.loadNibNamed("userPopUP", owner: self, options: nil)
    var userInfoDict = NSDictionary()
    var status = String()
    
    var latitude = Double()
    var longitude = Double()
    
    var isOnChatScreen = false;
    var isSessionAccept = false;
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - reachabilityManager
        manager?.listener = { status in
            print(String(describing: status))
            if String(describing: status) == "notReachable" || String(describing: status) == "unknown"{
                self.isConnectedToNetwork = false
            }
            else{
                self.isConnectedToNetwork = true
            }
        }
        manager?.startListening()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key){
            if UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String == "user" {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVc") as!HomeVC
                (self.window?.rootViewController as! UINavigationController).pushViewController(initialViewController, animated: false)
            }
            else{
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewcontroller") as!SWRevealViewController
                (self.window?.rootViewController as! UINavigationController).pushViewController(initialViewController, animated: false)
            }
        }
        else{
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "EntryVc") as!EntryVC
            (self.window?.rootViewController as! UINavigationController).pushViewController(initialViewController, animated: false)
        }
        
        GMSPlacesClient.provideAPIKey("AIzaSyARJmB3y4deCSnvKvOPPEwh8dICbpyjic0")
        GMSServices.provideAPIKey("AIzaSyARJmB3y4deCSnvKvOPPEwh8dICbpyjic0")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self as MessagingDelegate
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert,.sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func googleAnalytics(messgae: String){
        Analytics.logEvent ( messgae , parameters : nil)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        //        userInfoDict = userInfo as NSDictionary
        //        if userInfoDict["bookingType"] != nil {
        //            setNotificaitonPopUp()
        //        }else{
        //            let makeChatDict: NSDictionary = ["messageToID": Int(userInfoDict.value(forKey: "toUserID") as! String)!, "message": userInfoDict.value(forKey: "message") as! String]
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil, userInfo: makeChatDict as? [AnyHashable : Any])
        //        }
    }
    
    func setNotificaitonPopUp(){
        let bookingType = userInfoDict.value(forKey: "bookingType") as! String
        if bookingType == "0" {
            showRequestView(dict: userInfoDict)
        }
        else{
            showUserPopUp(bookingType: bookingType, dict: userInfoDict)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - ProgressIndicator view start
    func startProgressView(view:UIView){
        let spinnerActivity = MBProgressHUD.showAdded(to: view, animated: true);
        spinnerActivity.mode = MBProgressHUDMode.indeterminate
    }
    
    //MARK: - ProgressIndicator View Stop
    func dismissProgressView(view:UIView)  {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let token = Messaging.messaging().fcmToken {
            UserDefaults.standard.set(String(describing:token), forKey: USER_DEFAULT_DEVICETOKEN)
            let loginCheck = UserDefaults.standard.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key)
            if(loginCheck){
                AlamofireWrapper.sharedInstance.updateDeviceToken(firebaseTokenID: token)
            }
        }
    }
    @objc func confirmOrderApiHit(sender:UIButton){
        var status = String()
        if sender.tag == 4 {
            status = "3"
            isSessionAccept = true
        }
        else if sender.tag == 5 {
            status = "2"
            isSessionAccept = false
        }
        else{
            status = "3"
            isSessionAccept = true
        }
        if applicationDelegate.isConnectedToNetwork {
            AlamofireWrapper.sharedInstance.confirmBookingDelegate = self
            AlamofireWrapper.sharedInstance.confirmBooking(bookingID: bookingIdString  , status: status,isPaymentRequire: "0")
        }
    }
    
    @objc func mapBtnClick(sender:UIButton){
        let alertController = UIAlertController(title:"Seleccionar opción", message: "", preferredStyle: .alert)
        // Create the actions
        let wazeAction = UIAlertAction(title:"WAZE", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (self.userInfoDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.userInfoDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
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
            if let latitude = (self.userInfoDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.userInfoDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
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
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showRequestView(dict:NSDictionary){
        bookingIdString = dict.value(forKey: "bookingID") as! String
        let nameString = dict.value(forKey: "firstName") as! String
        let catString = dict.value(forKey: "categoryName") as! String
        let timeStartString = dict.value(forKey: "bookingStart") as! String
        let endTime = dict.value(forKey: "bookingEnd") as! String
        let dateString = dict.value(forKey: "bookingDate") as! String
        let addressString = dict.value(forKey: "bookingAddress") as! String
        let bookingFor =  dict.value(forKey: "bookingFor") as! String
        
        
        if in15Min() {
            
            let convEndTime = convertTime(timeString: endTime)
            let convStartTime = convertTime(timeString: timeStartString)
            let nibMainview = nibContents![0] as! UIView
            
            let acceptBtn = (nibMainview.viewWithTag(4)! as! UIButton)
            acceptBtn.addTarget(self, action: #selector(confirmOrderApiHit), for: .touchUpInside)
            
            let cancelBtn = (nibMainview.viewWithTag(5)! as! UIButton)
            cancelBtn.addTarget(self, action: #selector(confirmOrderApiHit), for: .touchUpInside)
            
            let mapbtn = (nibMainview.viewWithTag(11)! as! UIButton)
            mapbtn.addTarget(self, action: #selector(mapBtnClick), for: .touchUpInside)
            
            let name = (nibMainview.viewWithTag(6)! as! UILabel)
            let cat = (nibMainview.viewWithTag(7)! as! UILabel)
            let dateText = (nibMainview.viewWithTag(8)! as! UILabel)
            let timeText = (nibMainview.viewWithTag(9)! as! UILabel)
            let locationTextView = (nibMainview.viewWithTag(10)! as! UILabel)
            let crossBtn = (nibMainview.viewWithTag(15)! as! UIButton)
            let groupName = (nibMainview.viewWithTag(84)! as! UILabel)
            let groupImage = (nibMainview.viewWithTag(82)! as! UIImageView)
            let countlabel = (nibMainview.viewWithTag(83)! as! UILabel)
            
            
            switch  bookingFor {
            case "3" :
                countlabel.isHidden = true
                groupName.text = "Empresarial"
                groupImage.image = #imageLiteral(resourceName: "companyTrainee")
            case "1" :
                countlabel.isHidden = true
                groupName.text = "Individual"
                groupImage.image = #imageLiteral(resourceName: "personCalendar")
            default:
                if bookingFor == "2" {
                    countlabel.isHidden = false
                    countlabel.text = "2"
                    groupName.text = "Grupal"
                }
                else if bookingFor == "4" {
                    countlabel.isHidden = false
                    countlabel.text = "3"
                    groupName.text = "Grupal"
                }
                else if bookingFor == "5" {
                    countlabel.isHidden = false
                    countlabel.text = "4"
                    groupName.text = "Grupal"
                }
                groupImage.image = #imageLiteral(resourceName: "greyBack")
            }
            
            
            crossBtn.addTarget(self, action: #selector(crossBtnAction), for: UIControlEvents.touchUpInside)
            
            name.text = nameString
            cat.text = catString
            
            dateText.text = getDateInFormat(selectedDate: dateString)
            timeText.text = "\(convStartTime) - \(convEndTime)"
            locationTextView.text = addressString
            
            let vcArray = (applicationDelegate.window?.rootViewController as! UINavigationController).viewControllers
            let currentViewController = vcArray.last
            currentViewController?.view.addSubview(nibMainview)
            nibMainview.frame.size = CGSize(width: (currentViewController?.view.frame.width)!, height: (currentViewController?.view.frame.height)!)
            nibMainview.center = (currentViewController?.view.center)!
        }
    }
    
    func showUserPopUp(bookingType:String ,dict:NSDictionary){
        let bookingType = dict.value(forKey: "bookingType") as! String
        let nibMainview = nibContentsUser![0] as! UIView
        let okBtn = (nibMainview.viewWithTag(3)! as! UIButton)
        okBtn.addTarget(self, action: #selector(okBtnAction), for: UIControlEvents.touchUpInside)
        
        let labelTitle = nibMainview.viewWithTag(1)! as! UILabel
        let labelDesc = nibMainview.viewWithTag(2)! as! UILabel
        
        switch bookingType {
        case "1": //end session
            labelDesc.text = endSession
            break
            
        case "2": //cancel
            labelTitle.text = declineTitle
            labelDesc.text = declineMessage
            break
            
        case "3": // accept
            let bookingAcceptedTime = dict.value(forKey: "bookingUpdated") as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //Your date format
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            let booingAcceptedDateConverted = dateFormatter.date(from: bookingAcceptedTime)
            dateFormatter.dateFormat = "HH:mm a" //Your date format
            let acceptedTime = dateFormatter.string(from: booingAcceptedDateConverted!)
            
            labelTitle.text = acceptTitle
            if(isAfter2hour()){
                labelDesc.text = acceptMessage
            }else{
                labelDesc.text = "Ten en cuenta que solo durante los próximos 15 minutos contados a partir de las " + acceptedTime + " podrás cancelar sin cobro. A partir de ese momento, si cancelas te será cobrada la totalidad de la actividad."
            }
            break
            
        case "4": //start session
            labelDesc.text = startSesion
            break
            
        case "6": //auto Cancel
            // labelTitle.text = startSesion
            labelDesc.text = autoCancelMessage
            break
            
        case "5": // if trainer cancel
            labelTitle.text = cancelTitle
            labelDesc.text = cancelMessage
            break
            
        case "7": //If user cancel
            let nameString = dict.value(forKey: "firstName") as! String
            labelTitle.text = cancelTitle
            labelDesc.text = nameString + " ha tenido que cancelar la sesión."
            break
            
        default:
            print("")
        }
        
        let vcArray = (applicationDelegate.window?.rootViewController as! UINavigationController).viewControllers
        let currentViewController = vcArray.last
        currentViewController?.view.addSubview(nibMainview)
        nibMainview.frame.size = CGSize(width: (currentViewController?.view.frame.width)!, height: (currentViewController?.view.frame.height)!)
        nibMainview.center = (currentViewController?.view.center)!
        currentViewController?.view.bringSubview(toFront: okBtn)
    }
    
    func confirmBookingResults(dictionaryContent: NSDictionary) {
        hideView()
        if(isSessionAccept){
            if(isMoreThan30Min(sessionDict: userInfoDict)){
                let bookingIdString = userInfoDict.value(forKey: "bookingID") as! String
                setLocalNotifcationForSession(sessionDict: userInfoDict, bookingID: bookingIdString)
            }
        }else{
            let bookingIdString = userInfoDict.value(forKey: "bookingID") as! String
            removeNotification(bookingIdString: bookingIdString)
        }
        print("dictionaryContent",dictionaryContent)
    }
    
    func serverError() {
        hideView()
    }
    
    @objc func crossBtnAction(sender:UIButton) {
        hideView()
    }
    
    @objc func hideView(){
        let nibMainview = nibContents![0] as! UIView
        nibMainview.removeFromSuperview()
    }
    
    @objc func hideUserView(bookingType: String){
        let nibMainview = nibContentsUser![0] as! UIView
        nibMainview.removeFromSuperview()
        
        if(bookingType == "2" || bookingType == "5" || bookingType == "6"){
            if UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String == "user"{
                let listingDict = NSMutableDictionary()
                listingDict["catId"] = Int(userInfoDict.value(forKey: "categoryID") as! String)
                listingDict["selectedDate"] =  userInfoDict.value(forKey: "bookingDate") as! String
                listingDict["groupCategory"] = userInfoDict.value(forKey: "bookingFor") as! String
                listingDict["selectedTime"] = userInfoDict.value(forKey: "bookingStart") as! String
                listingDict["latitude"] = userInfoDict.value(forKey: "bookingLatitude") as! String
                listingDict["longitude"] = userInfoDict.value(forKey: "bookingLongitude") as! String
                listingDict["address"] = userInfoDict.value(forKey: "address") as! String
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "AllTrainerListVc") as! AllTrainerListVC
                myVC.listingDict = listingDict
                (self.window?.rootViewController as! UINavigationController).pushViewController(myVC, animated: true)
            }
        }else if(bookingType == "1"){
            UserDefaults.standard.set(userInfoDict, forKey: "sessionStartBookingDict")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            bookingIdString = userInfoDict.value(forKey: "bookingID") as! String
            let nameString = userInfoDict.value(forKey: "firstName") as! String
            let myVC = storyboard.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            myVC.nameString = nameString
            (self.window?.rootViewController as! UINavigationController).pushViewController(myVC, animated: true)
        }else if(bookingType == "7"){
            bookingIdString = userInfoDict.value(forKey: "bookingID") as! String
            removeNotification(bookingIdString: bookingIdString)
        }
    }
    
    @objc func okBtnAction(sender:UIButton) {
        let bookingType = userInfoDict.value(forKey: "bookingType") as! String
        switch bookingType {
        case "1": 
            hideUserView(bookingType: bookingType)
            break
            
        case "2": //cancel
            hideUserView(bookingType: bookingType)
            break
            
        case "3":
            hideUserView(bookingType: bookingType)// accept
            break
            
        case "4": //start session
            hideUserView(bookingType: bookingType)
            break
            
        case "5": //start session
            hideUserView(bookingType: bookingType)
            break
            
        default:
            hideUserView(bookingType: bookingType)
        }
    }
    
    func setLocalNotifcationForSession(sessionDict: NSDictionary, bookingID: String) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotificationForSession(sessionDict: sessionDict,bookingID: bookingID)
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotificationForSession(sessionDict: sessionDict, bookingID: bookingID)
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func scheduleLocalNotificationForSession(sessionDict: NSDictionary, bookingID: String) {
        let timeStartString = sessionDict.value(forKey: "bookingStart") as! String
        let dateString = sessionDict.value(forKey: "bookingDate") as! String
        let bookingStartDateTime = dateString + " " + timeStartString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        let firstConvertedDate = dateFormatter.date(from: bookingStartDateTime) //according to date
        
        let userCalendar = Calendar.current
        
        let dataDict = ["isLocalNotification":"1"] as Any  // send data
        let content = UNMutableNotificationContent()
        content.title = recordatorio
        content.body = NSString.localizedUserNotificationString(forKey: subjectLocal,arguments: nil)
        content.userInfo = dataDict as! [AnyHashable : Any]
        content.categoryIdentifier = bookingIdString
        
        let tomorrow = Calendar.current.date(byAdding: .minute, value: -30, to: firstConvertedDate!)
        let components = userCalendar.dateComponents([.year,.month,.day,.hour, .minute], from: tomorrow!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: bookingIdString, content: content, trigger: trigger)
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
    
    func removeNotification(bookingIdString:String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == bookingIdString {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
}
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        userInfoDict = userInfo as NSDictionary
        if(userInfoDict["isLocalNotification"] != nil){
             completionHandler([.alert])
        }else{
            if userInfoDict["bookingType"] != nil {
                setNotificaitonPopUp()
            }else{
                let makeChatDict: NSDictionary = ["messageToID": Int(userInfoDict.value(forKey: "toUserID") as! String)!, "message": userInfoDict.value(forKey: "message") as! String ,"messageTime" : userInfoDict.value(forKey: "messageTime") as! NSString]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil, userInfo: makeChatDict as? [AnyHashable : Any])
                
                if(!applicationDelegate.isOnChatScreen){
                    completionHandler([.alert])
                }
            }
        }
        // Change this to your preferred presentation option
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        userInfoDict = userInfo as NSDictionary
        if(userInfoDict["isLocalNotification"] != nil){
            
        }else{
            if userInfoDict["bookingType"] != nil {
                setNotificaitonPopUp()
            }else{
                let firsrtName = userInfoDict.value(forKey: "firstName") as! String
                let lastName = userInfoDict.value(forKey: "lastName") as! String
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "ChatVc") as! ChatVC
                myVC.toUserId = Int(userInfoDict.value(forKey: "userID") as! String)!
                myVC.userName = firsrtName + " " + lastName
                (self.window?.rootViewController as! UINavigationController).pushViewController(myVC, animated: true)
            }
        }
        completionHandler()
    }
    
    func isAfter2hour()-> Bool{
        let bookingCreated = userInfoDict.value(forKey: "bookingCreated") as! String
        let bookingStartTime = userInfoDict.value(forKey: "bookingStart") as! String
        let date = userInfoDict.value(forKey: "bookingDate") as! String
        let bookingStartDateTime  = date + " " + bookingStartTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        
        let booingCreatedDateConverted = dateFormatter.date(from: bookingCreated)
        let booingStartDateConverted = dateFormatter.date(from: bookingStartDateTime)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.hour,.minute], from: booingCreatedDateConverted!, to: booingStartDateConverted!)
        let diffHour = components.hour!
        
        if(diffHour<2){
            return false
        }else{
            return true
        }
    }
    
    func isMoreThan30Min(sessionDict: NSDictionary)->Bool{
        let bookingStartTime = sessionDict.value(forKey: "bookingStart") as! String
        let date = sessionDict.value(forKey: "bookingDate") as! String
        let bookingStartDateTime  = date + " " + bookingStartTime
        
        let currenDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let currentDateString = dateFormatter.string(from: currenDate)
        let currentDateObject = dateFormatter.date(from: currentDateString)
        
        let bookingStartDateTimeConverted = dateFormatter.date(from: bookingStartDateTime)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.hour,.minute], from: currentDateObject!, to: bookingStartDateTimeConverted!)
        let diffMin = components.minute!
        
        if(diffMin>30){
            return true
        }else{
            return false
        }
    }
    
    
    func in15Min()-> Bool{
        let bookingCreated = userInfoDict.value(forKey: "bookingCreated") as! String
        let currenDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let currentDateString = dateFormatter.string(from: currenDate)
        let currentDateObject = dateFormatter.date(from: currentDateString)
        let booingCreatedDateConverted = dateFormatter.date(from: bookingCreated)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.hour,.minute], from: booingCreatedDateConverted!, to: currentDateObject!)
        let diffMin = components.minute!
        
        if(diffMin<15){
            return true
        }else{
            return false
        }
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: USER_DEFAULT_DEVICETOKEN)
        print("Firebase registration token: \(fcmToken)")
        AlamofireWrapper.sharedInstance.updateDeviceToken(firebaseTokenID: fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}

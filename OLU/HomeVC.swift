//
//  HomeVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 24/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation


class HomeVC: UIViewController ,logoutAlamoFire ,MFMailComposeViewControllerDelegate,updateLocationAlamofire ,CLLocationManagerDelegate{
    
    @IBOutlet var ingresaBtn2: UIViewCustomClass!
    @IBOutlet var ingresaBtn3: UIViewCustomClass!
    @IBOutlet var ingresaBtn1: UIViewCustomClass!
    @IBOutlet var ingresaBtn4: UIViewCustomClass!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var demandLabel: UILabel!
    @IBOutlet weak var walletlabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var promoLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var promoButton: UIButton!
    
    @IBOutlet var profileImageUrl: UIImageView!
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
        applicationDelegate.googleAnalytics(messgae: "Applicaiton Start")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let imageUrlString = UserDefaults.standard.value(forKey: USER_DEFAULT_ImageUrl_Key) as? String ?? ""
        if imageUrlString != ""{
            profileImageUrl.sd_setImage(with: URL(string: imageUrlString ), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: to get current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //        applicationDelegate.startProgressView(view: self.view)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    //MARK: - mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        let userLocation:CLLocation = locations[0] as CLLocation
        applicationDelegate.latitude = userLocation.coordinate.latitude
        applicationDelegate.longitude = userLocation.coordinate.longitude
        updateLocationApiHit()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    
    func updateLocationApiHit() {
        AlamofireWrapper.sharedInstance.updateLocationDelegate = self
        AlamofireWrapper.sharedInstance.updateLocation(lat: applicationDelegate.latitude, long: applicationDelegate.longitude)
    }
    
    //MARK:- UIButton
    //share btn
    @IBAction func shareBtn(_ sender: UIButtonCustomClass){
        // text to share
        let text = "Olu. App te contenta con los mejores, donde quieras y cuando quieras. \n¡Te invito a descargarla! \n\nhttps://apple.co/2Ri0hgk"
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func placeToPay(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVc") as! WebViewVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func myProfileBtn(_ sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "MenuVc") as! MenuVC
        navigationController?.pushViewController(myVC, animated: true)
        
       // let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
       // navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func pendingBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PendingVc") as! PendingVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    // onDemandBtn.tag=1 //walletBtn.tag=2 //menuBtn.tag=3
    @IBAction func enterBtn(_ sender: UIButtonCustomClass){
        if sender.tag == 1 {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriesVc") as! categoriesVC
            myVC.isOpenFirstCat = false
            navigationController?.pushViewController(myVC, animated: true)
        }
        else if sender.tag == 2 {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ComparePlanVc") as! ComparePlanVC
            navigationController?.pushViewController(myVC, animated: true)
        }
        else  {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriesVc") as! categoriesVC
            myVC.isOpenFirstCat = false
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    //promoBtn
    @IBAction func promoBtn(_ sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "AllTrainerListVc") as! AllTrainerListVC
        myVC.isComingFromMenu = true
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //shareBtn
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //about
    @IBAction func settingActionOneBtn(_ sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "About"
        myVC.pageId = 17
        navigationController?.pushViewController(myVC, animated: true)
    }
    //open mail composer
    @IBAction func settingActionTwo(_ sender: UIButtonCustomClass){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    //logout
    @IBAction func settingsActionFour(_ sender: UIButtonCustomClass){
        logOut()
    }
    
    @IBAction func settingsActionFive(_ sender: UIButtonCustomClass){
        
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
            
            self.navigationController?.popToRootViewController(animated:true)
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["hola@oluapp.com"])
        mailComposerVC.setMessageBody("OLU App", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingActionThree(_ sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "CondtionsPolicyEntryVC") as! CondtionsPolicyEntryVC
        navigationController?.pushViewController(myVC, animated: true)
    }
}

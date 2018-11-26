//
//  TrainerLoginVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TrainerLoginVC: UIViewController ,UITextFieldDelegate ,LogInServiceAlamoFire ,RegistrationServiceAlamoFire ,CLLocationManagerDelegate{
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var fbLogin: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var dontHaveAccLabel: UILabel!
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var logInWithFbLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    var dict = NSDictionary()
    var locationManager:CLLocationManager!
    var latitude = Double()
    var longitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Status Color
    func startFunc() {
        determineMyCurrentLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        print("longitude==  ",longitude)
        print("latitude==",latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyBoardHeight
        self.ScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.ScrollView.contentInset = contentInset
    }
    
    
    //MARK: - API Reponse
    func RegistrationResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        
        if success .isEqual(1) {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "TutorialVc") as! TutorialVC
            navigationController?.pushViewController(myVC, animated: true)
            UserDefaults.standard.set(true, forKey: USER_DEFAULT_LOGIN_CHECK_Key)
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            print("resultDict",resultDict)
            
            let userId = resultDict.value(forKey:"userID") as! Int
            UserDefaults.standard.set(userId, forKey: USER_DEFAULT_USERID_Key)
            
            let firstName = resultDict.value(forKey:"firstName") as! String
            let lastName = resultDict.value(forKey:"lastname") as! String
            let name = firstName + lastName
            UserDefaults.standard.set(name, forKey: USER_DEFAULT_NAME_Key)
            UserDefaults.standard.set("1", forKey: "isAvailAble")
            let email = resultDict.value(forKey:"email") as! String
            UserDefaults.standard.set(email, forKey: USER_DEFAULT_EMAIL_Key)
            
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    //MARK: - API Reponse
    func logInResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            let isApprove = resultDict.value(forKey: "isApprove") as AnyObject
            if(isApprove.isEqual(1)){
                UserDefaults.standard.set(true, forKey: USER_DEFAULT_LOGIN_CHECK_Key)
                UserDefaults.standard.setValue("trainer", forKey: USER_DEFAULT_USERTYPE)
                
                let userId = resultDict.value(forKey:"userID") as! Int
                UserDefaults.standard.set(userId, forKey: USER_DEFAULT_USERID_Key)
                
                let firstName = resultDict.value(forKey:"firstName") as! String
                UserDefaults.standard.set(firstName, forKey: USER_DEFAULT_FIRSTNAME_Key)
                
                let lastName = resultDict.value(forKey:"lastName") as! String
                UserDefaults.standard.set(lastName, forKey: USER_DEFAULT_SECONDNAME_Key)
                
                let email = resultDict.value(forKey:"emailAddress") as! String
                UserDefaults.standard.set(email, forKey: USER_DEFAULT_EMAIL_Key)
                
                let dob = resultDict.value(forKey:"dob") as! String
                UserDefaults.standard.set(dob, forKey: USER_DEFAULT_DOB_Key)
                
                let gender = resultDict.value(forKey:"gender") as! String
                UserDefaults.standard.set(gender, forKey: USER_DEFAULT_GENDER_Key)
                
                let phone = resultDict.value(forKey:"phone") as! String
                UserDefaults.standard.set(phone, forKey: USER_DEFAULT_PHONE_Key)
                
                let description = resultDict.value(forKey:"description") as! String
                UserDefaults.standard.set(description, forKey: USER_DEFAULT_DESCRIPTION_Key)
                
                let imageUrl = resultDict.value(forKey:"userImageUrl") as! String
                UserDefaults.standard.set(imageUrl, forKey: USER_DEFAULT_ImageUrl_Key)
                
                let name = firstName + lastName
                UserDefaults.standard.set(name, forKey: USER_DEFAULT_NAME_Key)
                UserDefaults.standard.set("1", forKey: "isAvailAble")
                
                let array = resultDict.value(forKey:"categories") as! NSArray
                UserDefaults.standard.set(array, forKey: USER_DEFAULT_CATEGORY_Key)
                
                afterloginSuccess()
            }else{
                showAlert(self, message: trainerRegistrationVerifyMessage, title: appName)
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    // server error
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    // after login success
    func afterloginSuccess() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SWRevealViewcontroller") as! SWRevealViewController
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    //    // Fb Login Getting User Data
    //    func getFBUserData(){
    //        if((FBSDKAccessToken.current()) != nil){
    //            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email ,gender"]).start(completionHandler: { (connection, result, error) -> Void in
    //                if (error == nil){
    //                    self.dict = result as! [String : AnyObject] as NSDictionary
    //                    var firstName = String()
    //                    if self.dict.value(forKey: "first_name") != nil{
    //                        firstName = (self.dict.value(forKey: "first_name") as? String)!
    //                    }
    //
    //                    var lastName = String()
    //                    if self.dict.value(forKey: "last_name") != nil{
    //                        lastName = (self.dict.value(forKey: "last_name") as? String)!
    //                    }
    //
    //                    var fbEmail = String()
    //                    if self.dict.value(forKey: "email") != nil {
    //                        fbEmail = self.dict.value(forKey: "email") as! String
    //                    }
    //
    //                    else{
    //                        showAlert(self, message: "You canot login through facebook", title: appName)
    //                    }
    //
    //                    var gender = String()
    //                    if  self.dict.value(forKey: "gender") != nil{
    //
    //                        gender = self.dict.value(forKey: "gender") as! String
    //                    }
    //
    //                    var fbId = String()
    //                    if self.dict.value(forKey: "id") != nil {
    //                        fbId = self.dict.value(forKey: "id") as! String
    //                    }
    //                    self.fbApiHit(firstName:firstName,lastName:lastName,fbEmail:fbEmail,gender:gender,fbId:fbId)
    //                }
    //                else{
    //                    print("errorfb =",error!)
    //                }
    //            })
    //        }
    //    }
    //
    //    //MARK:- Facebook Login Api Hit
    //    func fblogin(){
    //        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    //        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
    //            if (error == nil){
    //                let fbloginresult : FBSDKLoginManagerLoginResult = result!
    //                if fbloginresult.grantedPermissions != nil {
    //                    if(fbloginresult.grantedPermissions.contains("email"))
    //                    {
    //                        self.getFBUserData()
    //                        fbLoginManager.logOut()
    //                    }
    //                }
    //            }
    //        }
    //
    //    }
    //
    //
    //    func fbApiHit(firstName:String,lastName:String,fbEmail:String,gender:String,fbId:String){
    //
    //
    //        let signUpParameters: [String : Any]  =
    //            [
    //                "userImageUrl": "",
    //                "firstName": firstName,
    //                "lastName": lastName,
    //                "emailAddress": fbEmail,
    //                "password": "",
    //                "facebookId": "",
    //                "latitude": latitude,
    //                "longitude": longitude,
    //                "userType": 2,
    //                "firebaseTokenId": "",
    //                "deviceType": "iOS"
    //        ]
    //
    //        //        // no internet check condition
    //        if applicationDelegate.isConnectedToNetwork {
    //            applicationDelegate.startProgressView(view: self.view)
    //            AlamofireWrapper.sharedInstance.registrationDelegate = self
    //            AlamofireWrapper.sharedInstance.resgistration(signUpParameters)
    //        }
    //        else {
    //
    //            showAlert(self, message: noInternetString, title: appName)
    //        }
    //
    //
    //    }
    
    func logInApiHit(){
        let loginParameter: [String : Any]  =
            [
                "emailAddress": emailText.text!,
                "password": passwordText.text!,
                "firebaseTokenId":getDeviceToken(),
                "deviceType":"iOS",
                "userType" : "1"
        ]
        
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.logInDelegate = self
            AlamofireWrapper.sharedInstance.logIn(loginParameter)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    //MARK:- UIButton
    //forgot password
    @IBAction func forgotPasswordBtn(_ sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVc") as! ForgotPasswordVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //signUp Button
    @IBAction func signUpBtn(_ sender: UIButtonCustomClass) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "OptionsVc") as! OptionsVC
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    //facebook button
    @IBAction func faceBookLogInBtn(_ sender: UIButtonCustomClass) {
        
    }
    
    // login button
    @IBAction func logInBtn(_ sender: UIButtonCustomClass){
        // afterloginSuccess()
        if(((emailText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterEmail,
                      title:appName )
        }
            
        else if(((passwordText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterPassword, title: appName)
        }
        else{
            logInApiHit()
        }
    }
    
    //MARK: - Validation for email format
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult =  emailTest.evaluate(with: testStr)
        return emailResult
    }
    
    //MARK: - Text field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}


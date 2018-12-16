//
//  SignUpVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 21/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SignUpVC: UIViewController ,UITextFieldDelegate  ,RegistrationServiceAlamoFire,CLLocationManagerDelegate {
    
    @IBOutlet var genderText: UITextFieldCustomClass!
    @IBOutlet var dateOfBirth: UITextFieldCustomClass!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var contactText: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var iAcceptLabel: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var locationManager:CLLocationManager!
    var latitude = Double()
    var longitude = Double()
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        //        CLLocationManagerDelegate = self
        determineMyCurrentLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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
    
    
    // MARK: Keyboard notifications methods
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
    
    func SignUpApiHit(){
        let firstNameValue = (firstNameText.text?.trimmingCharacters(in: .whitespaces))
        let lastNameValue = (lastNameText.text?.trimmingCharacters(in: .whitespaces))
        let emailValue = emailText.text?.trimmingCharacters(in: .whitespaces)
        let passwordValue = passwordText.text?.trimmingCharacters(in: .whitespaces)
        let gendertextValue = genderText.text?.trimmingCharacters(in: .whitespaces)
        let dateOfBirthValue = dateOfBirth.text?.trimmingCharacters(in: .whitespaces)
        let contactString = contactText.text?.trimmingCharacters(in: .whitespaces)
        
        let signUpParameters: [String : Any]  =
            [
                "userImageUrl": "",
                "firstName": firstNameValue!,
                "lastName": lastNameValue!,
                "emailAddress": emailValue!,
                "password": passwordValue!,
                "dob": dateOfBirthValue!,
                "gender" : gendertextValue!,
                "facebookId": "",
                "latitude": latitude,
                "longitude": longitude,
                "userType": 1,
                "firebaseTokenId": getDeviceToken(),
                "deviceType": "iOS",
                "phone":contactString!,
                "age":19
        ]
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.registrationDelegate = self
            AlamofireWrapper.sharedInstance.resgistration(signUpParameters)
        }
        else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    //MARK: - Validation for email format
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult =  emailTest.evaluate(with: testStr)
        return emailResult
    }
    
    //MARK: - API Reponse
    func RegistrationResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            UserDefaults.standard.set(true, forKey: USER_DEFAULT_LOGIN_CHECK_Key)
            UserDefaults.standard.setValue("user", forKey: USER_DEFAULT_USERTYPE)
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            print("resultDict",resultDict)
            let userId = resultDict.value(forKey:"userID") as! Int
            UserDefaults.standard.set(userId, forKey: USER_DEFAULT_USERID_Key)
            
            let firstName = resultDict.value(forKey:"firstName") as! String
            UserDefaults.standard.set(firstName, forKey: USER_DEFAULT_FIRSTNAME_Key)
            
            let lastName = resultDict.value(forKey:"lastName") as! String
            UserDefaults.standard.set(lastName, forKey: USER_DEFAULT_SECONDNAME_Key)
            
            let name = firstName + lastName
            UserDefaults.standard.set(name, forKey: USER_DEFAULT_NAME_Key)
            
            let email = resultDict.value(forKey:"emailAddress") as! String
            UserDefaults.standard.set(email, forKey: USER_DEFAULT_EMAIL_Key)
            
            let dob = dateOfBirth.text
            UserDefaults.standard.set(dob, forKey: USER_DEFAULT_DOB_Key)
            
            let gender = genderText.text
            UserDefaults.standard.set(gender, forKey: USER_DEFAULT_GENDER_Key)
            
            let phone = contactText.text?.trimmingCharacters(in: .whitespaces)
            UserDefaults.standard.set(phone, forKey: USER_DEFAULT_PHONE_Key)
            
            let imageUrl = resultDict.value(forKey:"userImageUrl") as! String
            UserDefaults.standard.set(imageUrl, forKey: USER_DEFAULT_ImageUrl_Key)
            
            afterSignUpSuccess()
        }
        else{
            applicationDelegate.dismissProgressView(view: self.view)
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    //MARK:- UIButton
    //check password
    @IBAction func checkBtn(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func termsConditionBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.pageId = 28
        navigationController?.pushViewController(myVC, animated: true)
    }
    //signUp Button
    @IBAction func signUpBtn(_ sender: UIButtonCustomClass) {
        if(((firstNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterFirstName, title: appName)
        }
        else if !(checkSpecialletter(stringValue: firstNameText.text!.trimmingCharacters(in: .whitespaces))) {
            showAlert(self, message: thereSpecialCharterThere, title: appName)
        }
        else if(((lastNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterlastName, title: appName)
        } else if !(checkSpecialletter(stringValue: lastNameText.text!.trimmingCharacters(in: .whitespaces))) {
            showAlert(self, message: thereSpecialCharterThere, title: appName)
        }
//        else if
//            (((dateOfBirth.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
//            showAlert(self, message:enterDateOfBirth , title: appName)
//        }
//        else if
//            (((genderText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
//            showAlert(self, message:enterGender , title: appName)
//        }
        else if
            (((emailText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message:enterEmail , title: appName)
        }
        else if !(isValidEmail(testStr:(emailText.text!.trimmingCharacters(in: .whitespaces)))){
            showAlert(self, message: validEmail, title: appName)
        }
        else if(((passwordText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterPassword, title: appName)
        }
        else if (((confirmPasswordText.text?.trimmingCharacters(in: .whitespaces).isEmpty)))!{
            showAlert(self, message: confirmPassword, title: appName)
        }
        else if (passwordText.text != confirmPasswordText.text){
            showAlert(self, message: misMatchPassword, title: appName)
        }
        else{
            SignUpApiHit()
        }
    }
    
    func checkSpecialletter(stringValue : String)-> Bool {
        let charactersetValue = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        if stringValue.rangeOfCharacter(from: charactersetValue.inverted) != nil {
            return false
        }
        else {
            return true
        }
    }
    
    //back button
    @IBAction func backBtn(_ sender: UIButtonCustomClass) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func openGenderOption() {
        // Create the actions
        let alertController = UIAlertController(title:"Género", message: nil, preferredStyle: .alert)
        // Create the actions
        let FemaleAction = UIAlertAction(title:"Hombre", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.genderText.text = "Hombre"
        }
        let MaleAction = UIAlertAction(title:"Mujer", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.genderText.text = "Mujer"
        }
        let otherAction = UIAlertAction(title:"Sin especificar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.genderText.text = "Sin especificar"
        }
        let cancelAction = UIAlertAction(title:"Cancel" , style: UIAlertActionStyle.cancel){
            UIAlertAction in
            
        }
        // Add the actions
        alertController.addAction(FemaleAction)
        alertController.addAction(MaleAction)
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Text field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(SignUpVC.doneButtonTapped(_:)))
        doneButton.tintColor = UIColor.white
        let items:Array = [doneButton]
        toolbar.items = items
        if textField == genderText {
            openGenderOption()
            return false
        }
        else if textField == dateOfBirth
        {
            textField.inputView = datePicker
            datePicker.datePickerMode = .date
            textField.inputAccessoryView = toolbar
            datePicker.addTarget(self, action: #selector(SignUpVC.dateChanged(_:)), for: .valueChanged)
        }
        return true
    }
    
    func afterSignUpSuccess() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TutorialVc") as! TutorialVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneButtonTapped(_ sender: AnyObject) {
        dateOfBirth.resignFirstResponder()
    }
}

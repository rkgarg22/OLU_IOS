//
//  TrainerRegisterVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 26/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class TrainerEditProfile: UIViewController ,UITextFieldDelegate  ,editProfileAlamofire ,UITextViewDelegate{
    @IBOutlet var activadesText: UITextFieldCustomClass!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabelCustomClass!
    @IBOutlet var genderText: UITextFieldCustomClass!
    @IBOutlet var dateOfBirth: UITextFieldCustomClass!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var contactText: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var iAcceptLabel: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    //  var locationManager:CLLocationManager!
    
    var datePicker = UIDatePicker()
    var formArray = NSMutableArray()
    var profilePic = UIImage()
    var profileDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        descriptionView.layer.cornerRadius = 10
        autoFill()
    }
    
    func autoFill() {
        let firstNameString = profileDict.value(forKey: "firstName") as? String ?? ""
        let lastNameString = profileDict.value(forKey: "lastName") as? String ?? ""
        let dob = profileDict.value(forKey: "dob") as? String ?? ""
        let genderString = profileDict.value(forKey: "gender") as? String ?? ""
        
        let email = profileDict.value(forKey: "emailAddress") as? String ?? ""
        let phoneNumber = profileDict.value(forKey: "phone") as? String ?? ""
        
        let description = profileDict.value(forKey: "description") as? String ?? ""
        
        let array = profileDict.value(forKey: "category") as? NSArray
        formArray = array?.mutableCopy() as! NSMutableArray
        
        dateOfBirth.text = dob
        genderText.text = genderString
        firstNameText.text = firstNameString
        lastNameText.text = lastNameString
        emailText.text = email
        contactText.text = phoneNumber
        descriptionView.text = description
        
        if(description != ""){
            descriptionLabel.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFormArraylist(_:)), name: NSNotification.Name(rawValue: "formArray"), object: nil)
    }
    
    //MARK: - selectedParent list from notification
    @objc func getFormArraylist(_ notification: NSNotification){
        formArray = notification.object as! NSMutableArray
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
    
    func updateProfileApiHit(){
        let firstNameValue = (firstNameText.text?.trimmingCharacters(in: .whitespaces))
        let lastNameValue = (lastNameText.text?.trimmingCharacters(in: .whitespaces))
        let gendertextValue = genderText.text?.trimmingCharacters(in: .whitespaces)
        let dateOfBirthValue = dateOfBirth.text?.trimmingCharacters(in: .whitespaces)
        let contactString = contactText.text?.trimmingCharacters(in: .whitespaces)
        let description = descriptionView.text?.trimmingCharacters(in: .whitespaces)
        let jsonString = json(from: formArray)
        
        let updateParameter: [String : Any]  =
            [
                "userID":getUserID(),
                "firstName": firstNameValue!,
                "lastName": lastNameValue!,
                "dob": dateOfBirthValue!,
                "gender" : gendertextValue!,
                "phone":contactString!,
                "description":description!,
                "categories1": jsonString!
        ]
        
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.editProfileDelegate = self
            if profilePic.imageAsset != nil{
                let imageData = (UIImagePNGRepresentation(profilePic) as Data?)!
                AlamofireWrapper.sharedInstance.updateTrainerProfile(updateParameter , imageData: imageData as Data)
            }
            else{
                AlamofireWrapper.sharedInstance.updateTrainerProfile(updateParameter , imageData: nil)
            }
            
        }
        else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    //MARK: - Validation for email format
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult =  emailTest.evaluate(with: testStr)
        return emailResult
    }
    
    
    func editProfileResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            
            let alertController = UIAlertController(title:profileVerificaitonMessage, message: nil, preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
                UIAlertAction in
                  self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
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
        myVC.pageId = 21
        navigationController?.pushViewController(myVC, animated: true)
    }
    //signUp Button
    @IBAction func signUpBtn(_ sender: UIButtonCustomClass) {
        if(((firstNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterFirstName, title: appName)
        }
        else if(((lastNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterlastName, title: appName)
        }
        else if
            (((dateOfBirth.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message:enterDateOfBirth , title: appName)
        }
        else if
            
            (((genderText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message:enterGender , title: appName)
        }
        else if
            (((emailText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message:enterEmail , title: appName)
        }
        else if !(isValidEmail(testStr:(emailText.text!.trimmingCharacters(in: .whitespaces)))){
            showAlert(self, message: validEmail, title: appName)
        }
        
        else if ((descriptionView.text?.trimmingCharacters(in: .whitespaces).isEmpty))!{
            showAlert(self, message: enterDescription, title: appName)
        }
        else if (formArray.count == 0){
            showAlert(self, message: selectForm, title: appName)
        }
        else{
            updateProfileApiHit()
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
        else if textField == dateOfBirth{
            textField.inputView = datePicker
            datePicker.datePickerMode = .date
            textField.inputAccessoryView = toolbar
            datePicker.addTarget(self, action: #selector(SignUpVC.dateChanged(_:)), for: .valueChanged)
        }
        else if textField == activadesText {
            firstNameText.becomeFirstResponder()
            nextActivadesScreen()
            //            firstNameText.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func activadesAction(_ sender: Any) {
        nextActivadesScreen()
        
    }
    func nextActivadesScreen() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerRegisterFormVc") as! TrainerRegisterFormVC
        myVC.catDisplayArray = formArray
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
    
    // MARK: Textview delegates
    
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        descriptionLabel.text = ""
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.darkGray
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(TrainerRegisterVC.doneButton(_:)))
        doneButton.tintColor = UIColor.white
        let items:Array = [doneButton]
        toolbar.items = items
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    @objc func doneButton(_ sender: AnyObject) {
        descriptionView.resignFirstResponder()
    }
    
}



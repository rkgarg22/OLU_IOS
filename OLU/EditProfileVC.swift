//
//  EditProfileVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 15/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController ,UITextFieldDelegate ,editProfileAlamofire {
    
    
    @IBOutlet var genderText: UITextFieldCustomClass!
    @IBOutlet var dateOfBirth: UITextFieldCustomClass!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var iAcceptLabel: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    var datePicker = UIDatePicker()
    var image = UIImage()
    var isEdited = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        autoFill()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func autoFill() {
        let firstNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_FIRSTNAME_Key) as? String ?? ""
        let lastNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_SECONDNAME_Key) as? String ?? ""
        let dob = UserDefaults.standard.value(forKey: USER_DEFAULT_DOB_Key) as? String ?? ""
        let genderString = UserDefaults.standard.value(forKey: USER_DEFAULT_GENDER_Key) as? String ?? ""
        
        let email = UserDefaults.standard.value(forKey: USER_DEFAULT_EMAIL_Key) as? String ?? ""
        let phoneNumber = UserDefaults.standard.value(forKey: USER_DEFAULT_PHONE_Key) as? String ?? ""
        
        dateOfBirth.text = dob
        genderText.text = genderString
        firstNameText.text = firstNameString
        lastNameText.text = lastNameString
        emailText.text = email
        phoneNumberText.text = phoneNumber
    }
    
    //back button
    @IBAction func backBtn(_ sender: UIButtonCustomClass) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //back button
    @IBAction func enterBtn(_ sender: UIButtonCustomClass) {
        if(((firstNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterFirstName, title: appName)
        }
        else if(((lastNameText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message: enterlastName, title: appName)
        }
//        else if
//            (((dateOfBirth.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
//            showAlert(self, message:enterDateOfBirth , title: appName)
//        }
//        else if
//            
//            (((genderText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
//            showAlert(self, message:enterGender , title: appName)
//        }
        else{
            editApiHit()
        }
    }
    
    func editApiHit(){
        if isEdited {
        let firstNameValue = (firstNameText.text?.trimmingCharacters(in: .whitespaces))
        let lastNameValue = (lastNameText.text?.trimmingCharacters(in: .whitespaces))
        let gendertextValue = genderText.text?.trimmingCharacters(in: .whitespaces)
        let dateOfBirthValue = dateOfBirth.text?.trimmingCharacters(in: .whitespaces)
        let phoneValue = phoneNumberText.text?.trimmingCharacters(in: .whitespaces)
        let editProfileParameters: [String : Any]  =
            [
                "userID":getUserID(),
                "firstName":firstNameValue! ,
                "lastName":lastNameValue! ,
                "dob":dateOfBirthValue! ,
                "gender":gendertextValue!,
                "phone":phoneValue!
        ]
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.editProfileDelegate = self
            if image.imageAsset != nil{
                let data = (UIImagePNGRepresentation(image) as Data?)!
                AlamofireWrapper.sharedInstance.editUserProfile(editProfileParameters , imageData: data)
            }
            else{
                AlamofireWrapper.sharedInstance.editUserProfile(editProfileParameters , imageData: nil)
            }
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
        }
        else
        {
            showAlert(self, message: nothingToUpdate, title: appName)
        }
    }
    
    func startFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        firstNameText.text = UserDefaults.standard.value(forKey: USER_DEFAULT_FIRSTNAME_Key) as? String
        lastNameText.text = UserDefaults.standard.value(forKey: USER_DEFAULT_SECONDNAME_Key) as? String
        
    }
    
    func openTermsCondition(){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "terms"
        myVC.pageId = 28
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func openPrivacyPolicy() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "policy"
        myVC.pageId = 19
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func editProfileResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
                        let firstName = firstNameText.text
                        UserDefaults.standard.set(firstName, forKey: USER_DEFAULT_FIRSTNAME_Key)
                        let lastName = lastNameText.text
                        UserDefaults.standard.set(lastName, forKey: USER_DEFAULT_SECONDNAME_Key)
                        let gender = genderText.text
                        UserDefaults.standard.set(gender, forKey: USER_DEFAULT_GENDER_Key)
                        let dob = dateOfBirth.text
                        UserDefaults.standard.set(dob, forKey: USER_DEFAULT_DOB_Key)
                        let phone = phoneNumberText.text
                        UserDefaults.standard.set(phone, forKey: USER_DEFAULT_PHONE_Key)
            
                        let imageUrl = dictionaryContent.value(forKey: "result") as! String
                        UserDefaults.standard.set(imageUrl, forKey: USER_DEFAULT_ImageUrl_Key)
            
            let alertController = UIAlertController(title:profileVerificaitonMessage, message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            
        }
        else{
            applicationDelegate.dismissProgressView(view: self.view)
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    
    func openGenderOption() {
        isEdited = true
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
    
    //MARK: - Text field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isEdited = true
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(EditProfileVC.doneButtonTapped(_:)))
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
            datePicker.addTarget(self, action: #selector(EditProfileVC.dateChanged(_:)), for: .valueChanged)
        }
        return true
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

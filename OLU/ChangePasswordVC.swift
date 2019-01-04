//
//  ChangePasswordVC.swift
//  OLU
//
//  Created by Rohit Garg on 30/12/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import Foundation
class ChangePasswordVC: UIViewController ,UITextFieldDelegate, ChangePasswordProtocol {
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var oldPasswordText: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var oluTeamView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        if UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String == "user"{
            oluTeamView.isHidden = true;
        }else{
            oluTeamView.isHidden = true;
        }
        
        let oldPassword = UserDefaults.standard.value(forKey: USER_DEFAULT_USERPASSWORD_Key) as? String ?? ""
        oldPasswordText.text = oldPassword
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        //        CLLocationManagerDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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
    
    func resetPasswordAPiHit(){
        let oldPassword = oldPasswordText.text?.trimmingCharacters(in: .whitespaces)
        let passwordValue = passwordText.text?.trimmingCharacters(in: .whitespaces)
        let resetPasswordDict: [String : Any]  =
            [
                "userID": getUserID(),
                "newPassword": passwordValue!,
                "oldPassword": oldPassword!
        ]
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            UserDefaults.standard.set(passwordValue!, forKey: USER_DEFAULT_USERPASSWORD_Key)
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.changePasswordDalegate = self
            AlamofireWrapper.sharedInstance.resetPassword(resetPasswordDict)
        }
        else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            openAlert(message: "¡La contraseña ha sido guardada exitosamente!")
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
    
    func openAlert(message: String) {
        let alertController = UIAlertController(title:message, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String == "user"{
                if let vc = self.navigationController?.viewControllers.filter({ $0 is MenuVC }).first {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }else{
                if let vc = self.navigationController?.viewControllers.filter({ $0 is ProfileVC }).first {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //signUp Button
    @IBAction func signUpBtn(_ sender: UIButtonCustomClass) {
        if (((oldPasswordText.text!.trimmingCharacters(in: .whitespaces).isEmpty))){
            showAlert(self, message:enterPassword , title: appName)
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
            resetPasswordAPiHit()
        }
    }
    
    //back button
    @IBAction func backBtn(_ sender: UIButtonCustomClass) {
        _ = navigationController?.popViewController(animated: true)
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
        return true
    }
}

//
//  ForgotPasswordVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 17/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,ForgotPasswordAlamofire {
    
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        _ = navigationController?.popViewController(animated: true)
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
    
    @IBAction func confirmBtnClick(_ sender: UIButtonCustomClass){
        let email = emailText.text!.trimmingCharacters(in: .whitespaces)
        if(email.isEmpty){
            showAlert(self, message: enterEmail,
                      title:appName )
        }
        else if !(isValidEmail(testStr:email)){
            showAlert(self, message: validEmail, title: appName)
        }
        else{
            forgotPasswordApiCall(email: email)
        }
    }
    
    func forgotPasswordApiCall(email: String) {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.forgotPasswordAlamofire = self
            AlamofireWrapper.sharedInstance.forgotPassword(email: email)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            openAlert(message: passwordSent)
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
    
    func openAlert(message: String) {
        let alertController = UIAlertController(title:message, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
             _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

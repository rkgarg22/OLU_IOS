//
//  SettingsVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController  ,UITableViewDelegate ,UITableViewDataSource ,logoutAlamoFire{
 
    var menuDict = NSDictionary()
    @IBOutlet var settingsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuDict = ["imageArray":[#imageLiteral(resourceName: "faQ"),#imageLiteral(resourceName: "tuttorial"),#imageLiteral(resourceName: "termsConditions"),#imageLiteral(resourceName: "contactUs"),#imageLiteral(resourceName: "closeSession")],"nameArray":["FAQ","Tutorial" ,"Terminos y condiciones" ,"Contactanos" ,"Cerrar sesion"],"buttonText":["Ver","Ver","Ver","Lr","Cerrar"]]
        settingsTable.reloadData()
        settingsTable.layoutIfNeeded()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (menuDict.value(forKey: "imageArray") as! NSArray).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        let imageArr = menuDict.value(forKey: "imageArray") as! NSArray
        let titleArr =  menuDict.value(forKey: "nameArray") as! NSArray
        let buttonTextArr = menuDict.value(forKey: "buttonText") as! NSArray
        cell.iconImage.image = imageArr[indexPath.row] as?UIImage
        cell.titlelabel.text = titleArr[indexPath.row] as? String
        cell.buttonText.text = buttonTextArr[indexPath.row] as? String
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let indexPath = indexPath.row
            
        switch (indexPath)
        {
        case 0:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "FAQVc") as! FAQVC
            navigationController?.pushViewController(myVC, animated: true)
            break
            
        case 1:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "FAQVc") as! FAQVC
            navigationController?.pushViewController(myVC, animated: true)
            break
        case 2:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
            navigationController?.pushViewController(myVC, animated: true)
            break
        case 3:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
            navigationController?.pushViewController(myVC, animated: true)
            break
        case 4:
           logOut()
            break
      
        default:
            print("Home Button clicked")
        }
        
    }
  
    func logOut() {
        let alertController = UIAlertController(title:"", message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Yes", style: UIAlertActionStyle.default) {
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
            showAlert(self, message: "No internet", title: appName)
        }
    }
    
    func logoutResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            self.logOutAfter()
            
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
    
    func logOutAfter() {
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
}

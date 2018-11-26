//
//  UserPaymentVC.swift
//  OLU
//
//  Created by DIKSHA on 29/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class UserPaymentVC: UIViewController , UITableViewDelegate ,UITableViewDataSource, paymentHistoryForUserAlamofire{
    
    var historyARray = NSArray()
    @IBOutlet var paymentTable: UITableView!
    //@IBOutlet weak var noDatalabel: UILabelCustomClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentHistoryApiHit()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getPaymentHistoryApiHit() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.paymentHistoryForUserDelegate = self
            AlamofireWrapper.sharedInstance.getPaymentHistoryForUser()
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    
    func paymentHistoryResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            historyARray = dictionaryContent.value(forKey: "result") as! NSArray
            paymentTable.reloadData()
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
        if historyARray.count == 0 {
            //noDatalabel.isHidden = false
            paymentTable.isHidden = true
        }
        else{
            // noDatalabel.isHidden = true
            paymentTable.isHidden = false
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return historyARray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserPayemntCell
        var resultDict = NSDictionary()
        resultDict = historyARray[indexPath.row] as! NSDictionary
        cell.resultDictForPayment(resultDict: resultDict)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

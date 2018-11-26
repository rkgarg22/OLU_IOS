//
//  PayementHistoryVC.swift
//  OLU
//
//  Created by DIKSHA on 19/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class PayementHistoryVC: UIViewController,UITableViewDelegate ,UITableViewDataSource ,paymentHistoryAlamofire {
    
    var historyARray = NSArray()
    @IBOutlet weak var pendingTable: UITableView!
    @IBOutlet weak var noDatalabel: UILabelCustomClass!
    @IBOutlet weak var totalPriceLabel: UILabelCustomClass!
    @IBOutlet var pendingPaymentBtn: UIButton!
    @IBOutlet var completedPaymentBtn: UIButton!
    var isSelected = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyProfileApiHit(isPaid: "0")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func realizadosBtn(_ sender: Any) {
        isSelected = 1;
        historyARray = []
        getMyProfileApiHit(isPaid: "1")
        completedPaymentBtn.isSelected = true
        pendingPaymentBtn.isSelected = false
    }
    
    @IBAction func pendingBtn(_ sender: Any) {
        isSelected = 0;
        historyARray = []
        getMyProfileApiHit(isPaid: "0")
        completedPaymentBtn.isSelected = false
        pendingPaymentBtn.isSelected = true
    }
    
    func getMyProfileApiHit(isPaid: String) {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.paymentHistoryDelegate = self
            AlamofireWrapper.sharedInstance.getPaymentHistoryTrainer(desc: "", isPAid: isPaid)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func setTotalPrice(){
        var totalPrice = 0.0
        for index in 0...historyARray.count-1{
            var resultDict = NSDictionary()
            resultDict = historyARray[index] as! NSDictionary
            let amount = resultDict.value(forKey: "amount") as! String
            let amountInDocuble = Double(amount)
            totalPrice = totalPrice + amountInDocuble!;
        }
        
        //let priceConv = getConvertedPriceString(myDouble:totalPrice)
        let final = String(format: "%.3f", totalPrice)
        totalPriceLabel.text = final
    }
    
    func paymentHistoryResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            historyARray = dictionaryContent.value(forKey: "result") as! NSArray
            pendingTable.reloadData()
            setTotalPrice()
        }
        else{
            totalPriceLabel.text = ""
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
        if historyARray.count == 0 {
            noDatalabel.isHidden = false
            pendingTable.isHidden = true
            
            if(isSelected == 1){
                noDatalabel.text = "¡Muy pronto verás aquí los pagos de OLU!"
            }else{
                noDatalabel.text = "OLU Datos no encontrados"
            }
        }
        else{
            noDatalabel.isHidden = true
            pendingTable.isHidden = false
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RealizadasCell
        var resultDict = NSDictionary()
        resultDict = historyARray[indexPath.row] as! NSDictionary
        cell.resultDictForPayment(resultDict: resultDict)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

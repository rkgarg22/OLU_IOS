//
//  ComparePlanVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 05/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import WebKit

class ComparePlanVC: UIViewController ,paymentInitiateAlamofire  ,paymentCollectAlamofire ,WKUIDelegate, WKNavigationDelegate, MarkCardSelectedProtocol{
    
    
    var webView: WKWebView!
    @IBOutlet var overLayView: UIView!
    var planID = String()
    var requestID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let text =  webView.url?.absoluteString
        if text == "http://ec2-13-58-57-186.us-east-2.compute.amazonaws.com/api/payment/return/" {
            webView.removeFromSuperview()
            callMarkSelectCardAPI(requestID: requestID)
        }
        else if (text?.contains("https://test.placetopay.com/redirection/cancel/"))! {
            webView.removeFromSuperview()
        }
        print("urlString==",text!)
        
    }
    
    func webView(_ webView:WKWebView, didFinish navigation: WKNavigation) {
        print("didFinsh")
    }
    
    @IBAction func planThree(_ sender: Any) {
        planID = "3"
        openAlert(message: plan3Confirmation)
    }
    
    @IBAction func planTwo(_ sender: Any) {
        openAlert(message: plan2Confirmation)
        planID = "2"
    }
    
    @IBAction func planOne(_ sender: Any) {
        openAlert(message: plan1Confirmation)
        planID = "1"
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func YesPopupBtn(_ sender: Any) {
        overLayView.isHidden = true
        let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriesVc") as! categoriesVC
        myVC.isOpenFirstCat = true
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func noPopupBtn(_ sender: Any) {
        overLayView.isHidden = true
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func webViewGoBackBtn(_ sender: Any) {
        webView.isHidden = true
        webView.goBack()
    }
    
    func openAlert(message: String) {
        let alertController = UIAlertController(title:message, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.paymentInitiate()
            
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func loadWebView(url:String) {
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(webView)
        overLayView.isHidden = true
        //         view = webView
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func paymentCollect(planID:String ,token:String) {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getPaymentCollectionDelegate = self
            AlamofireWrapper.sharedInstance.getPayementCollect(planID: planID,token :token)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func paymentInitiate(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.paymentInitiateDelegate = self
            AlamofireWrapper.sharedInstance.getPayementInitiate()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func paymentInitiateResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            let cardDetailDict = resultDict.value(forKey: "cardDetails") as! NSArray
            let isTokenAvailable = resultDict.value(forKey: "isTokenAvailable") as! Int
            if isTokenAvailable == 1 {
                let cardDict = cardDetailDict[0] as! NSDictionary
                let token = cardDict.value(forKey: "token") as! String
                paymentCollect(planID: planID, token: token)
            }
            else{
                let processUrlDict = resultDict.value(forKey: "processUrl") as! NSDictionary
                let processUrl = processUrlDict.value(forKey: "processURL") as! String
                let processUrlString = processUrl
                requestID = processUrlDict.value(forKey: "requestId") as! String
                showPopForPaymentAlert(processUrlString: processUrlString)
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
            
        }
    }
    
    func paymentCollectResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            overLayView.isHidden = false
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func showPopForPaymentAlert(processUrlString: String){
        let alertController = UIAlertController(title:paymentConfirmPopUp, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.loadWebView(url: processUrlString)
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish Loading")
    }
    
    private func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!) {
        if (navigationAction.navigationType == WKNavigationType.backForward ) {
            print("back forward")
        }
    }
    
    func callMarkSelectCardAPI(requestID:String){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.markSelectedCardDelegate = self
            AlamofireWrapper.sharedInstance.markCardSelected(requestID: requestID)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getMarkSelectedCardData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            paymentInitiate()
        }
        else {
            applicationDelegate.dismissProgressView(view: self.view)
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

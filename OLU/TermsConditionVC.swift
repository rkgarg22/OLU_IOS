//
//  TermsConditionVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import WebKit

class TermsConditionVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var titlelabeltwo: UILabelCustomClass!
    @IBOutlet var titleLabelOne: UILabelCustomClass!
    @IBOutlet var webView: UIWebView!
    var isfromType = String()
    var pageId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        staretFunc()
    }
    
    func staretFunc() {
        applicationDelegate.startProgressView(view: self.view)
        if isfromType == "terms" {
            titleLabelOne.text = "TÉRMINOS"
            titlelabeltwo.text = "Y CONDICIONES"
            if UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String == "user"{
                let url =  URL(string: "http://3.16.104.146/api/pages/?userID=62&pageID=28&language=es&lang=es")
                let myRequest = URLRequest(url: url!)
                webView.loadRequest(myRequest)
            }else{
                let url =  URL(string: "http://3.16.104.146/api/pages/?userID=62&pageID=21&language=es&lang=es")
                let myRequest = URLRequest(url: url!)
                webView.loadRequest(myRequest)
            }
        }
        else if isfromType == "policy"{
            titleLabelOne.text = "POLÍTICAS"
            titlelabeltwo.text = "PRIVACIDAD"
            let url =  URL(string: "http://3.16.104.146/api/pages/?userID=62&pageID=19&language=es&lang=es")
            let myRequest = URLRequest(url: url!)
            webView.loadRequest(myRequest)
        }
        else{
            titleLabelOne.text = "QUIÉNES"
            titlelabeltwo.text = "SOMOS"
            
            let url =  URL(string: "http://3.16.104.146/api/pages/?userID=62&pageID=17&language=es&lang=es")
            let myRequest = URLRequest(url: url!)
            webView.loadRequest(myRequest)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        applicationDelegate.dismissProgressView(view: self.view)
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
    @IBAction func crossBtn(_ sender: Any) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

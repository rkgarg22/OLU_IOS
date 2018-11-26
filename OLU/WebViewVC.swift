//
//  WebViewVC.swift
//  OLU
//
//  Created by DIKSHA on 20/11/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.placetopay.com")
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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

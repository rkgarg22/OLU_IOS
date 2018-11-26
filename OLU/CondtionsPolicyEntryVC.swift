//
//  CondtionsPolicyEntryVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 26/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class CondtionsPolicyEntryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: Any) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsBtn(sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "terms"
        myVC.pageId = 28
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func policyBtn(sender: UIButtonCustomClass){
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TermsConditionVc") as! TermsConditionVC
        myVC.isfromType = "policy"
        myVC.pageId = 19
        navigationController?.pushViewController(myVC, animated: true)
    }
}

//
//  MyPayementVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 03/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit


class MyPayementVC: UIViewController {

    @IBOutlet var cardBtnText: UILabel!
    @IBOutlet var cardLabel: UILabel!
    @IBOutlet var cashLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cardBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func cashBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "UserPaymentVC") as! UserPaymentVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

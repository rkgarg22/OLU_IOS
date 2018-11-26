//
//  EntryVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 11/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class EntryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func traineeButton(_ sender: Any) {
       
        let myVC = storyboard?.instantiateViewController(withIdentifier: "LogInVc") as! LogInVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //MARK:- UIButton
    //forgot password
    @IBAction func coachButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerLoginVc") as! TrainerLoginVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func traineBtn(sender: UIButtonCustomClass){
       
        
    }
    @IBAction func coachBtn(sender: UIButtonCustomClass){
        
    }
    
    
    

}

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
        showUserPopUp();
        
    }
    
    //MARK:- UIButton
    //forgot password
    @IBAction func coachButton(_ sender: Any) {
        showTrainerPopUp();
    }
    
    @IBAction func traineBtn(sender: UIButtonCustomClass){
       
        
    }
    @IBAction func coachBtn(sender: UIButtonCustomClass){
        
    }
    
    func showUserPopUp() {
        let alertController = UIAlertController(title:userIntroPopup, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInVc") as! LogInVC
            self.navigationController?.pushViewController(myVC, animated: true)
            
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showTrainerPopUp() {
        let alertController = UIAlertController(title:trainerIntroPopUp, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainerLoginVc") as! TrainerLoginVC
            self.navigationController?.pushViewController(myVC, animated: true)
            
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

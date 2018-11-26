//
//  SearchAllListVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 27/06/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class SearchAllListVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate {

    var listArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllTrainingTableViewCell
       
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
      
        return true
    }
 
}

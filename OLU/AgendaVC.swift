//
//  AgendaVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 28/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class AgendaVC: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var agendaTable: UITableView!
    var agendaArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       agendaTable.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return agendaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AgendaTableViewCell
        return cell
    }
}

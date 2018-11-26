//
//  FAQVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 03/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit


class FAQVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate {

    @IBOutlet var faqTable: UITableView!
    
    var indexPathValue = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
faqTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func plusBtn(sender:UIButton){
        let cell = faqTable.cellForRow(at: indexPathValue) as! FAQTableViewCell
        if sender.isSelected {
         cell.answerLabel.numberOfLines = 1
            sender.isSelected = false
        }
        else{
            cell.answerLabel.numberOfLines = 0
            sender.isSelected = true
          }
    }
    
    @IBAction func crossBtn(_ sender: Any) {
    }
    
    @IBAction func backBtn(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FAQTableViewCell
        indexPathValue = indexPath
        cell.plusButton.addTarget(self, action: #selector(plusBtn), for: .touchDragInside)
        
        return cell
    }
    

}

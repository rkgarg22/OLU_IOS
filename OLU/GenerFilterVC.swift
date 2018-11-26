//
//  GenerFilterVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 16/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos

class GenerFilterVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate  {
    @IBOutlet var boyView: UIViewCustomClass!
    @IBOutlet var girlView: UIViewCustomClass!
    @IBOutlet var catTableHeight: NSLayoutConstraint!
    @IBOutlet var catTableView: UITableView!
    @IBOutlet var boyBtn: UIButton!
    @IBOutlet var girlBtn: UIButton!
    
    var genderString = String()
    var images = NSArray()
    var highlightedImages = NSArray()
    var menuDict = NSDictionary()
    var selectedBool = Bool()
    var isSelectedIndex = Int()
    var catId = Int()
    var isBoySelected = Bool()
    var isGirlSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isBoySelected = false
        isGirlSelected = false
        catTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        isSelectedIndex = getIndex(catId: catId)
        menuDict = ["imageArray":[#imageLiteral(resourceName: "boxingIcon"),#imageLiteral(resourceName: "watchIcon"),#imageLiteral(resourceName: "timerIcon"),#imageLiteral(resourceName: "roleIcon"),#imageLiteral(resourceName: "heartIcon"),#imageLiteral(resourceName: "shoesIcon"),#imageLiteral(resourceName: "Gimnasia"),#imageLiteral(resourceName: "theraphyIcon"),#imageLiteral(resourceName: "masajes")],"nameArray":["Kickboxing","Entrenamiento Funcional" ,"Stretching" ,"Yoga" ,"Pilates" ,"Dance Fit" ,"Gimnasia Adulto Mayor","Fisioterapia","Masajes Deportivos"] ,"descriptionArray":[kickBoxingDescription,cardioCrossfitDescription,strectingDescription,yogaDescription,pilatesDescription,danzaFitDescription,fisioterapiaDescription ]]
        catTableView.reloadData()
        catTableView.layoutIfNeeded()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == catTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    catTableHeight.constant = newSize.height
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func boyBtn(_ sender: UIButton) {
        if(isBoySelected){
            isBoySelected = false
            genderString = ""
            boyView.backgroundColor = UIColor.init(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
        }else{
            isBoySelected = true
            genderString = "Hombre"
            boyView.backgroundColor = UIColor.init(red: 0, green: 151/255, blue: 167/255, alpha: 1)
        }
    }
    
    @IBAction func girlBtn(_ sender: UIButton) {
        if(isGirlSelected){
            isGirlSelected = false
            genderString = ""
            girlView.backgroundColor = UIColor.init(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
        }else{
            isGirlSelected = true
            genderString = "Mujer"
            girlView.backgroundColor = UIColor.init(red: 0, green: 151/255, blue: 167/255, alpha: 1)
        }
    }
    
    @IBAction func enterBtn(_ sender: AnyObject) {
        if(isGirlSelected && isBoySelected){
            genderString = ""
        }
        let genderDict : [String:Any] = ["gender":genderString ,"cat":catId]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "genderDict"), object:genderDict);
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClearBtn(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearFilter"), object:nil);
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func plusButton(sender: UIButton) {
        selectedBool = true
        sender.isSelected = !sender.isSelected
        //        indexpathValue = sender.tag
        let indexPath = IndexPath(item :sender.tag, section: 0)
        catTableView.reloadRows(at: [indexPath], with: .automatic)
        catTableView.layoutIfNeeded()
    }
    
    @objc func selectCat(indexPathValue:Int) {
        
        let indexValue = indexPathValue
        switch indexValue {
        case 0:
            catId = 1
        case 1 :
            catId = 2
        case 2:
            catId = 3
        case 3:
            catId = 4
        case 4:
            catId = 5
        case 5 :
            catId = 11
        case 6 :
            catId = 10
        case 7:
            catId = 9
        case 8 :
            catId = 8
        case 9 :
            catId = 12
        default:
            print("Default Case")
        }
        //        let myVC = storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
        //        myVC.catId = catId
        //        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func getIndex(catId:Int)->Int{
        var indexValue = Int()
        switch catId {
        case 1:
            indexValue = 0
        case 2 :
            indexValue = 1
        case 3:
            indexValue = 2
        case 4:
            indexValue = 3
        case 5:
            indexValue = 4
        case 11 :
            indexValue = 5
        case 10 :
            indexValue = 6
        case 9:
            indexValue = 7
        case 8 :
            indexValue = 8
        case 12 :
            indexValue = 9
        default:
            print("Default Case")
        }
        return indexValue
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let array = menuDict.value(forKey: "imageArray") as! NSArray
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        let imageArr = menuDict.value(forKey: "imageArray") as! NSArray
        let titleArr =  menuDict.value(forKey: "nameArray") as! NSArray
        let descriptionArr =  menuDict.value(forKey: "descriptionArray") as! NSArray
        cell.iconImage.image = imageArr[indexPath.row] as?UIImage
        cell.nameLabel.text = titleArr[indexPath.row] as? String
        if indexPath.row == isSelectedIndex {
            cell.circleLabel.backgroundColor = UIColor.init(red: 0, green: 151/255, blue: 167/255, alpha: 1)
            cell.nameLabel.textColor = UIColor.init(red: 0, green: 151/255, blue: 167/255, alpha: 1)
        }
        else{
            cell.circleLabel.backgroundColor = UIColor.init(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
            cell.nameLabel.textColor = UIColor.gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        isSelectedIndex = indexPath.row
        selectCat(indexPathValue: isSelectedIndex)
        catTableView.reloadData()
    }
}

//
//  TrainerRegisterFormVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 26/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class TrainerRegisterFormVC: UIViewController ,UITextFieldDelegate,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet var viewHidden: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var catTable: UITableView!
    @IBOutlet var catDisplayTable: UITableView!
    @IBOutlet var catSelect: UITextField!
    @IBOutlet var onePerson: UITextFieldCustomClass!
    @IBOutlet var twoPerson: UITextFieldCustomClass!
    @IBOutlet var threePerson: UITextFieldCustomClass!
    @IBOutlet var fourPerson: UITextFieldCustomClass!
    @IBOutlet var companyPerson: UITextFieldCustomClass!
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var catView: UIView!
    var catArray = NSArray()
    var catDisplayArray = NSMutableArray()
    var isEdit = Bool()
    var indexValue = Int()
    var selectedCatID = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        catDisplayTable.tableFooterView = UIView()
        catTable.tableFooterView = UIView()
        catArray = ["Kickboxing","Entrenamiento Funcional" ,"Stretching" ,"Yoga" ,"Pilates" ,"Dance Fit" ,"Gimnasia Adulto","Fisioterapia","Masajes Deportivos"]
        mainView.isHidden = true
        catTable.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterFormVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterFormVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        var contentInset:UIEdgeInsets = self.ScrollView.contentInset
        contentInset.bottom = keyBoardHeight
        self.ScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.ScrollView.contentInset = contentInset
    }
    
    func autoFill(indexValue:Int) {
        var dict = NSDictionary()
        dict = catDisplayArray[indexValue] as! NSDictionary
        var catID = dict.value(forKey: "CategryID") as? Int
        if(catID == nil){
            catID = dict.value(forKey: "CategoryID") as? Int
        }
        selectedCatID = catID!
        catSelect.text  = getCatName(catID: selectedCatID)
        
        onePerson.text = dict.value(forKey: "singlePrice") as? String
        twoPerson.text = dict.value(forKey: "groupPrice2") as? String
        threePerson.text = dict.value(forKey: "groupPrice3") as? String
        fourPerson.text = dict.value(forKey: "groupPrice4") as? String
        companyPerson.text = dict.value(forKey: "companyPrice") as? String
    }
    
    //forgot password
    @IBAction func plusBtn(_ sender: UIButtonCustomClass){
        isEdit = false
        mainView.isHidden = false
        catView.isHidden = false
        viewHidden.isHidden = false
    }
    
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //forgot password
    @IBAction func enterBtn(_ sender: UIButtonCustomClass){
        mainView.isHidden = true
        viewHidden.isHidden = true
        
        //price
        textFieldDidEndEditing(onePerson)
        textFieldDidEndEditing(twoPerson)
        textFieldDidEndEditing(threePerson)
        textFieldDidEndEditing(fourPerson)
        textFieldDidEndEditing(companyPerson)
        let onPerson = onePerson.text
        let twoPersonPrice = twoPerson.text
        let threePersonPrice = threePerson.text
        let fourPersonPrice = fourPerson.text
        let companyPrice =  companyPerson.text
        
        if(onPerson == "" && twoPersonPrice == "" && threePersonPrice == "" && fourPersonPrice == "" && companyPrice == "" ){
            showAlert(self, message: addCategoryMessage, title: appName)
        }else{
            let formDetailDict: [String : Any]  =
                [
                    "CategryID": selectedCatID,
                    "singlePrice": onPerson!,
                    "groupPrice2": twoPersonPrice!,
                    "groupPrice3": threePersonPrice!,
                    "groupPrice4": fourPersonPrice!,
                    "companyPrice": companyPrice!
            ]
            if isEdit {
                catDisplayArray.replaceObject(at: indexValue, with: formDetailDict)
            }
            else{
                catDisplayArray.add(formDetailDict)
            }
            
            catDisplayTable.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formArray"), object:catDisplayArray);
            
            onePerson.text = "";
            twoPerson.text = "";
            threePerson.text = "";
            fourPerson.text = "";
            companyPerson.text = "";
        }
        
    }
    
    @objc func deleteBtn(sender:UIButton) {
        catDisplayArray.removeObject(at: sender.tag)
        catDisplayTable.reloadData()
    }
    
    func convertPrice(price:NSString)-> String{
        let double = (price as NSString).doubleValue
        let priceConv = getConvertedPriceString(myDouble:double)
        return priceConv
    }
    
    func getCatId(indexValue:Int) ->Int{
        var catId = Int()
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
        return catId
    }
    
    func getCatName(catID:Int)->String {
        
        var catName = String()
        
        switch catID {
        case 1 :
            catName = "Kickboxing"
            break;
        case 2 :
            catName = "Entrenamiento Funcional"
            break;
        case 3 :
            catName = "Stretching"
            break;
        case 4 :
            catName = "Yoga"
            break;
        case 5 :
            catName = "Pilates"
            break;
        case 11 :
            catName = "Dance Fit"
            break;
        case 10 :
            catName = "Gimnasia Adulto Mayor"
            break;
        case 9 :
            catName = "Fisioterapia"
            break;
        case 8 :
            catName = "Masajes Deportivos"
            break;
        case 12 :
            catName = "Masajes Deportivos"
        default:
            
            catName = "Masajes Deportivos"
        }
        return catName
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1 {
            return catDisplayArray.count
        }
        else{
            return catArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainerFormCell
            print(catDisplayArray)
            var dict = NSDictionary()
            dict = catDisplayArray[indexPath.row] as! NSDictionary
            var catID = dict.value(forKey: "CategryID") as? Int
            if(catID == nil){
                catID = dict.value(forKey: "CategoryID") as? Int
            }
            cell.catLabel.text = getCatName(catID: catID!)
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainerFormCell
            cell.catLabel.text = catArray[indexPath.row] as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2 {
            let cell = catTable.cellForRow(at: indexPath) as! TrainerFormCell
            catSelect.text = cell.catLabel.text
            catTable.isHidden = true
            selectedCatID = getCatId(indexValue: indexPath.row)
        }
        else {
            indexValue = indexPath.row
            isEdit = true
            mainView.isHidden = false
            catView.isHidden = false
            viewHidden.isHidden = false
            autoFill(indexValue: indexValue)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(TrainerRegisterFormVC.doneButtonTapped(_:)))
        doneButton.tintColor = UIColor.white
        let items:Array = [doneButton]
        toolbar.items = items
        if textField == catSelect {
            catTable.isHidden = false
            return false
        }
        else {
            textField.inputAccessoryView = toolbar
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == onePerson {
            let oneprice = onePerson.text
            if(!(oneprice?.contains("."))!){
                let onPersonCon = convertPrice(price: oneprice! as NSString)
                let newString = onPersonCon.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                onePerson.text = newString
            }
        }
        else if textField == twoPerson {
            let twoPerson = self.twoPerson.text
            if(!(twoPerson?.contains("."))!){
                let twoPersonCon = convertPrice(price: twoPerson! as NSString)
                let twoPersonStringn = twoPersonCon.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                self.twoPerson.text = twoPersonStringn
            }
        }
        else if textField == fourPerson {
            let fourPerson = self.fourPerson.text
            if(!(fourPerson?.contains("."))!){
                let fourPersonCon = convertPrice(price: fourPerson! as NSString)
                let newString = fourPersonCon.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                self.fourPerson.text = newString
            }
        }
        else if textField == companyPerson {
            let companyPerson = self.companyPerson.text
            if(!(companyPerson?.contains("."))!){
                let companyPersonCon = convertPrice(price: companyPerson! as NSString)
                let newString = companyPersonCon.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                self.companyPerson.text = newString
            }
        }
        else if textField == threePerson {
            let threePerson = self.threePerson.text
            if(!(threePerson?.contains("."))!){
                let threeCon = convertPrice(price: threePerson! as NSString)
                let newString = threeCon.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                self.threePerson.text = newString
            }
        }
    }
    
    @objc func doneButtonTapped(_ sender: UITextField) {
        onePerson.resignFirstResponder()
        twoPerson.resignFirstResponder()
        threePerson.resignFirstResponder()
        fourPerson.resignFirstResponder()
        companyPerson.resignFirstResponder()
    }
    
}

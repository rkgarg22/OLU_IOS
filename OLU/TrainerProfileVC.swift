//
//  TrainerProfileVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 16/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage


class TrainerProfileVC: UIViewController ,trainerProfileAlamoFire,UIScrollViewDelegate ,ZFTokenFieldDelegate ,ZFTokenFieldDataSource {
    
    
    @IBOutlet weak var tagView: ZFTokenField!
    @IBOutlet var catCollectionViewheight: NSLayoutConstraint!
    @IBOutlet var priceLabel: UILabelCustomClass!
    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var userProfile: UIImageViewCustomClass!
    @IBOutlet var descriptionLabel: UILabelCustomClass!
    @IBOutlet var trainerRating: CosmosView!
    @IBOutlet var secondName: UILabelCustomClass!
    @IBOutlet var firstName: UILabelCustomClass!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var tagViewHeight: NSLayoutConstraint!
    var trainerId = Int()
    var agendaArray = NSArray()
    var selectedDict = NSDictionary()
    var localSavedDict = NSMutableDictionary()
    var isFromTrainerList = false
    var categoryArray = NSArray()
    var tagViewCurrentIndex =  Int()
    var dict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tagview deletegate call
        tagView.dataSource = self
        tagView.delegate = self
        getTrainerProfile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTrainerProfile() {
        print("localSaved==",localSavedDict)
        let catId = localSavedDict.value(forKey: "catId") as! Int
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.trainerProfileDelegate = self
            AlamofireWrapper.sharedInstance.trainerProfile(trainerUserID: trainerId, categoryID: catId)
        }else{
            showAlert(self, message: "No internet", title: appName)
        }
    }
    
    func trainerProfileResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            dict  = dictionaryContent.value(forKey: "result") as! NSDictionary
            let firsrNameStr  = dict.value(forKey: "firstName") as? String
            firstName.text = firsrNameStr?.uppercased();
            let secondNameStr = dict.value(forKey: "lastName") as? String
            secondName.text = secondNameStr?.uppercased()
            descriptionLabel.text = dict.value(forKey: "description") as? String
            categoryArray = dict.value(forKey: "category") as! NSArray
            setPrice(dict: dict)
            
            
            if let iconImageString = dict.value(forKey: "userImageUrl"){
                if iconImageString as! String != ""{
                    userProfile.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
                }
            }
            let  reviews = dict.value(forKey: "reviews") as! Int
            trainerRating.rating = Double(reviews)
            let category = localSavedDict.value(forKey: "categoryName") as! String
            categoryLabel.text = category
            tagView.reloadData()
            tagView.layoutIfNeeded()
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    func setPrice(dict:NSDictionary) {
        let count = localSavedDict.value(forKey: "groupCategory") as? String ?? "0"
        var price = String()
        if count == "1" {
            price = dict.value(forKey: "singlePrice")  as? String ?? "0"
        }
        else if count == "2" {
            price = dict.value(forKey: "groupPrice2")  as? String ?? "0"
        }
        else if count == "3" {
            price = dict.value(forKey: "companyPrice")  as? String ?? "0"
        }
        else if count == "4" {
            price = dict.value(forKey: "groupPrice3")  as? String ?? "0"
        }
        else if count == "5" {
            price = dict.value(forKey: "groupPrice4")  as? String ?? "0"
        }else{
            price = dict.value(forKey: "singlePrice")  as? String ?? "0"
            if(price == "0"){
                price = dict.value(forKey: "groupPrice2")  as? String ?? "0"
                if(price  == "0"){
                    price = dict.value(forKey: "groupPrice3")  as? String ?? "0"
                    if(price == "0"){
                         price = dict.value(forKey: "groupPrice4")  as? String ?? "0"
                        if(price == "0"){
                            price = dict.value(forKey: "companyPrice")  as? String ?? "0"
                        }
                    }
                }
            }
        }
        priceLabel.text = "$" + price
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func expandDescriptionBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            descriptionLabel.numberOfLines = 0
        }
        else {
            descriptionLabel.numberOfLines = 1
        }
    }
    
    @objc func changeCat(sender:UIButton) {
        tagViewCurrentIndex = sender.tag
        var dict = NSDictionary()
        dict = categoryArray[tagViewCurrentIndex] as! NSDictionary
        print(dict)
        let catId = dict.value(forKey: "categoryID") as! Int
        let catName = getCatName(catID: catId)
        categoryLabel.text = catName
        setPrice(dict: dict)
        localSavedDict["catId"] = catId
    }
    
    
    @IBAction func reservarBtn(_ sender: Any) {
        if (isFromTrainerList){
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
            myVC.catId = localSavedDict.value(forKey: "catId") as! Int
            myVC.isFromTrainerList = true
            myVC.trainerDetailDictFromTrainerListScreen = dict
            navigationController?.pushViewController(myVC, animated: true)
        }else{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
            myVC.trainerDetailDict = dict
            myVC.localSavedDict = localSavedDict
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func agendaBtn(_ sender: Any) {
        print("dict=",dict)
        print("localSavedDict",localSavedDict)
        let dataDict = NSMutableDictionary()
        dataDict["catId"] = localSavedDict.value(forKey: "catId") as! Int
        dataDict["trainerId"] = trainerId
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
        myVC.dataDict = dataDict
        myVC.isFromAgenda = true
        myVC.resultDict = dict
        navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func callBtn(_ sender: Any) {
       // let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
       // navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func messageBtn(_ sender: Any) {
//        let firstName = dict.value(forKey: "firstName") as! String
//        let lastName = dict.value(forKey: "lastName") as! String
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChatVc") as! ChatVC
//        myVC.toUserId = dict.value(forKey: "userID") as! Int
//        myVC.userName = firstName + " " + lastName
//        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func dollarBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    // MARK: ZFTokenField datasource
    
    internal func lineHeightForToken(in tokenField: ZFTokenField!) -> CGFloat{
        return 50
    }
    
    internal func numberOfToken(in tokenField: ZFTokenField!) -> UInt{
        return UInt(categoryArray.count)
    }
    
    internal func tokenField(_ tokenField: ZFTokenField!, viewForTokenAt index: UInt) -> UIView!{
        var dict = NSDictionary()
        tagViewCurrentIndex = Int(index)
        dict = categoryArray[Int(index)] as! NSDictionary
        let name = dict.value(forKey: "categoryName") as? String ?? "check value"
        var nibContents = Bundle.main.loadNibNamed("TokenView", owner: nil, options: nil)
        let view = nibContents![0] as! UIView
        let label = (view.viewWithTag(2)! as! UILabel)
        let button = (view.viewWithTag(3)! as! UIButton)
        label.text = " " + name + "     "
        button.tag = Int(index)
        button.addTarget(self, action: #selector(changeCat), for: .touchUpInside)
        var size = CGSize()
        size = label.sizeThatFits(CGSize(width: label.frame.width + 10, height:50) )
        view.frame = CGRect(x: 0, y: 0, width: size.width, height: 50)
        view.layoutIfNeeded()
        return view
    }
    
    // MARK: ZFTokenField delegate
    
    internal func tokenMarginInToken(in tokenField: ZFTokenField!) -> CGFloat{
        return 5
    }
    
    internal func tokenFieldShouldEndEditing(_ textField: ZFTokenField!) -> Bool{
        
        return true
    }
    
    internal func tokenFieldDidBeginEditing(_ tokenField: ZFTokenField!) {
        
        
    }
}

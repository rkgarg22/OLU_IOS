//
//  AllTrainerListVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 16/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import CoreLocation

class AllTrainerListVC: UIViewController ,UITableViewDataSource ,UITableViewDelegate ,UITextFieldDelegate ,listingAlamoFire,CLLocationManagerDelegate{
    
    @IBOutlet var trainerListTable: UITableView!
    @IBOutlet var noDataFoundLabel: UILabel!
    @IBOutlet var searchText: UITextField!
    
    var listingDict = NSMutableDictionary()
    var long = String()
    var lat = String()
    var listArray = NSArray()
    var isComingFromMenu = false
    var intialSlectedCategoryID = Int()
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lat = listingDict.value(forKey: "latitude") as? String ?? ""
        long = listingDict.value(forKey: "longitude") as? String ?? ""
        if let catId = listingDict.value(forKey: "catId") as? Int {
            intialSlectedCategoryID = catId
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getlist(_:)), name: NSNotification.Name(rawValue: "genderDict"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateList(_:)), name: NSNotification.Name(rawValue: "updateLatLong"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearFilter(_:)), name: NSNotification.Name(rawValue: "clearFilter"), object: nil)
        
        trainerListTable.tableFooterView = UIView()
        trainerListTable.isHidden = true
                //lat = "6.19690922304067";
               //long = "-75.5703850098067";
         //getListingApi(genderString: "", lat:lat,long: long)
        if(lat == "" && long == ""){
            determineMyCurrentLocation()
        }else{
            getListingApi(genderString: "", lat:lat,long: long)
        }
        
        //determineMyCurrentLocation()
    }
    
    //MARK: to get current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //        applicationDelegate.startProgressView(view: self.view)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }else{
            getListingApi(genderString: "", lat:lat,long: long)
        }
    }
    
    //MARK: - mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        let userLocation:CLLocation = locations[0] as CLLocation
        lat  = String(userLocation.coordinate.latitude)
        long  = String(userLocation.coordinate.longitude)
        getListingApi(genderString: "", lat:lat,long: long)
    }
    
    @objc func clearFilter(_ notification: NSNotification){
        listingDict["catId"] = intialSlectedCategoryID
        getListingApi(genderString : "",lat:lat ,long:long)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        trainerListTable.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - WhereLocation from notification
    @objc func updateList(_ notification: NSNotification){
        listArray = []
        let dict = notification.object as! NSDictionary
        if(dict["lat"] != nil && dict["long"] != nil){
            let latString = dict.value(forKey: "latitude") as! String
            let longString = dict.value(forKey: "longitude") as! String
            getListingApi(genderString : "" ,lat:latString ,long:longString)
        }
    }
    
    //MARK: - WhereLocation from notification
    @objc func getlist(_ notification: NSNotification){
        listArray = []
        let dict = notification.object as! NSDictionary
        let genderString = dict.value(forKey: "gender") as! String
        listingDict["catId"] = dict.value(forKey: "cat") as! Int
        getListingApi(genderString : genderString ,lat:lat ,long:long)
    }
    
    @IBAction func directionFilter(_ sender: Any) {
        searchText.text = ""
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVc") as! ChangeLocationVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        searchText.text = ""
        let myVC = storyboard?.instantiateViewController(withIdentifier: "GenerFilterVc") as! GenerFilterVC
        if let catId = listingDict.value(forKey: "catId") as? Int {
            myVC.catId = catId
        }else{
            myVC.catId = 0
        }
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getListingApi(genderString : String ,lat : String , long : String) {
        var selectedDateString = String()
        var selectedTimeString = String()
        var catIdString = Int()
        var selectGroupString = String()
        
        if let selectedDate = listingDict.value(forKey: "selectedDate") as? String {
            selectedDateString = selectedDate
        }
        if  let selectedTime = listingDict.value(forKey: "selectedTime") as? String {
            selectedTimeString = selectedTime
        }
        if let catId = listingDict.value(forKey: "catId") as? Int {
            catIdString = catId
        }
        if let selectGroup = listingDict.value(forKey: "groupCategory") as? String {
            selectGroupString = selectGroup
        }

        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.listingDelegate = self
            AlamofireWrapper.sharedInstance.listing(searchText: searchText.text!, category: catIdString, date: selectedDateString, time: selectedTimeString, language: "en", gender: genderString, rating: 0, latitude: lat, longitude: long ,selectGroup: selectGroupString)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func listingResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            trainerListTable.isHidden = false
            listArray = dictionaryContent.value(forKey: "result") as! NSArray
            trainerListTable.reloadData()
            if listArray.count != 0 {
                trainerListTable.isHidden = false
            }
            else {
                trainerListTable.isHidden = true
            }
        }
        else{
        }
        if listArray.count == 0 {
            noDataFoundLabel.isHidden = false
            trainerListTable.isHidden = true
        }
        else{
            noDataFoundLabel.isHidden = true
            trainerListTable.isHidden = false
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @objc func plusBtn(sender:UIButton) {
        var dict = NSDictionary()
        dict = listArray[sender.tag] as! NSDictionary
        listingDict["catId"] = dict.value(forKey: "categoryID") as! Int 
        listingDict["categoryName"] = dict.value(forKey: "categoryName") as! String
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerProfileVc") as! TrainerProfileVC
        myVC.trainerId = dict.value(forKey: "userID") as! Int
        myVC.localSavedDict = listingDict
        if(isComingFromMenu){
            myVC.isFromTrainerList = true
        }else{
            myVC.isFromTrainerList = false
        }
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @objc func reservarAction(sender:UIButton) {
        var trainerDict = NSDictionary()
        trainerDict = listArray[sender.tag] as! NSDictionary
        if(isComingFromMenu){
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
            myVC.catId = trainerDict.value(forKey: "categoryID") as! Int
            myVC.isFromTrainerList = true
            myVC.trainerDetailDictFromTrainerListScreen = trainerDict
            navigationController?.pushViewController(myVC, animated: true)
        } else {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
            myVC.localSavedDict = listingDict
            myVC.trainerDetailDict = trainerDict
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllTrainingTableViewCell
        cell.plusBtn.tag = indexPath.row
        cell.reservarBtn.tag = indexPath.row
        cell.reservarBtn.addTarget(self, action: #selector(reservarAction), for: .touchUpInside)
        cell.plusBtn.addTarget(self, action: #selector(plusBtn), for: .touchUpInside)
        var resultDict = NSDictionary()
        resultDict = listArray[indexPath.row] as! NSDictionary
        cell.resulDictList(resultdict: resultDict)
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        getListingApi(genderString: "" ,lat: lat ,long: long)
        return true
    }
}

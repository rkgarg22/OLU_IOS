//
//  LocationVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 15/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps


class LocationVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource,listingAlamoFire ,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var trainerListTable: UITableView!
    
    @IBOutlet var listaBtn: UIButton!
    @IBOutlet var mapaBtn: UIButton!
    
    var trainerListArray = NSArray()
    var listingDict = NSMutableDictionary()
    var locationManager:CLLocationManager!
    var latitude = Double()
    var longitude = Double()
    var addressString = String()
    var localSavedDict = NSDictionary()
    var intialSlectedCategoryID = Int()
    var annotationalArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        intialSlectedCategoryID = (listingDict.value(forKey: "catId") as? Int)!
        //trainerListTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        determineMyCurrentLocation()
        listaBtn.isSelected = false
        mapaBtn.isSelected = true
        mapView.isHidden = false
        trainerListTable.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if let obj = object as? UITableView {
    //            if obj == trainerListTable && keyPath == "contentSize" {
    //                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
    //                    tableHeight.constant = newSize.height
    //                }
    //            }
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getlist(_:)), name: NSNotification.Name(rawValue: "genderDict"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateList(_:)), name: NSNotification.Name(rawValue: "updateLatLong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearFilter(_:)), name: NSNotification.Name(rawValue: "clearFilter"), object: nil)
    }
    
    
    @objc func clearFilter(_ notification: NSNotification){
        let lat: String = String(latitude)
        let long: String = String(longitude)
        listingDict["catId"] = intialSlectedCategoryID
        getListingApi(genderString : "",lat:lat ,long:long)
    }
    
    
    //MARK: - WhereLocation from notification
    @objc func updateList(_ notification: NSNotification){
        let dict = notification.object as! NSDictionary
        print("dict",dict)
        
        latitude = (dict.value(forKey: "latitude") as AnyObject).doubleValue
        longitude = (dict.value(forKey: "longitude") as AnyObject).doubleValue
        self.addressString = dict.value(forKey: "address") as! String
        
        let latString = dict.value(forKey: "latitude") as! String
        let longString = dict.value(forKey: "longitude") as! String
        getListingApi(genderString : "",lat:latString ,long:longString)
    }
    
    //MARK: - WhereLocation from notification
    @objc func getlist(_ notification: NSNotification){
        let dict = notification.object as! NSDictionary
        print("dict",dict)
        let genderString = dict.value(forKey: "gender") as! String
        listingDict["catId"] = dict.value(forKey: "cat") as! Int
        getListingApi(genderString : genderString,lat:"" ,long:"")
    }
    
    //MARK: to get current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //        applicationDelegate.startProgressView(view: self.view)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        else {
            getListingApi(genderString: "",lat:"",long: "")
        }
    }
    
    //MARK: -update Address According to change in region in map
    func centerMapOnLocation(coordinates:CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 18.0)
        mapView.camera = camera
        let marker: GMSMarker = GMSMarker(position: coordinates)
        marker.map = mapView
    }
    
    //MARK: - mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        let userLocation:CLLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        reverseGeocodeCoordinate(coordinate: userLocation)
        setUserCurrentLocation()
        let lat: String = String(latitude)
        let long: String = String(longitude)
        getListingApi(genderString: "",lat:lat,long: long)
    }
    
    func setUserCurrentLocation(){
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 18.0)
        mapView.camera = camera
        let marker: GMSMarker = GMSMarker(position: coordinates)
        marker.icon = UIImage(named:"currentLocationIcon")
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let index = annotationalArray.index(of: marker)
        let dict = trainerListArray[index] as! NSDictionary
        listingDict["latitude"] = String(latitude)
        listingDict["longitude"] = String(longitude)
        listingDict["address"] = self.addressString
        listingDict["catId"] = dict.value(forKey: "categoryID") as! Int
        listingDict["categoryName"] = dict.value(forKey: "categoryName") as! String
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerProfileVc") as! TrainerProfileVC
        myVC.localSavedDict = listingDict
        myVC.trainerId = dict.value(forKey: "userID") as! Int
        myVC.isFromTrainerList = false
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    func getListingApi(genderString : String ,lat:String,long:String) {
        trainerListArray = []
        trainerListTable.reloadData()
        trainerListTable.layoutIfNeeded()
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
            AlamofireWrapper.sharedInstance.listing(searchText: "", category: catIdString, date:selectedDateString , time: selectedTimeString, language: "es", gender: genderString, rating: 0 ,latitude:"\(lat)" ,longitude:"\(long)", selectGroup: selectGroupString)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func listingResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            trainerListArray = dictionaryContent.value(forKey: "result") as! NSArray
            trainerListTable.reloadData()
            trainerListTable.layoutIfNeeded()
            markAnotations()
            setUserCurrentLocation()
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
    
    func markAnotations() {
        annotationalArray = []
        mapView.clear()
        for item in trainerListArray {
            let dict = item as! NSDictionary
            let latitude = (dict.value(forKey: "latitude") as AnyObject).doubleValue
            let longitude = (dict.value(forKey: "longitude") as AnyObject).doubleValue
            let nameString = (dict.value(forKey: "firstName") as! String) + " " + (dict.value(forKey: "lastName") as! String)
            let coordinate = CLLocationCoordinate2DMake(latitude! ,longitude!);
            let marker = GMSMarker(position: coordinate)
            marker.title = nameString
            marker.icon = UIImage(named:"userIcon")
            marker.map = mapView
            marker.snippet = nameString
            annotationalArray.add(marker)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "marker"
        var view: MKAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
            if(annotation.title == nil || annotation.title == "" ){
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.image = UIImage(named:"currentLocationIcon")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else{
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.image = UIImage(named:"userIcon")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        } else {
            // 5
            if(annotation.title == nil || annotation.title == "" ){
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.image = UIImage(named:"currentLocationIcon")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else{
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.image = UIImage(named:"userIcon")
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        return view
    }
    
    @objc func enterBtn(_ sender:UIButton) {
        var dict = NSDictionary()
        dict = trainerListArray[sender.tag] as! NSDictionary
        listingDict["latitude"] = String(latitude)
        listingDict["longitude"] = String(longitude)
        listingDict["address"] = self.addressString
        listingDict["catId"] = dict.value(forKey: "categoryID") as! Int
        listingDict["categoryName"] = dict.value(forKey: "categoryName") as! String
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerProfileVc") as! TrainerProfileVC
        myVC.localSavedDict = listingDict
        myVC.trainerId = dict.value(forKey: "userID") as! Int
        myVC.isFromTrainerList = false
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func listBtnClick(_ sender: AnyObject) {
        listaBtn.isSelected = true
        mapaBtn.isSelected = false
        mapView.isHidden = true
        trainerListTable.isHidden = false
    }
    
    @IBAction func mapaBtnClick(_ sender: AnyObject) {
        listaBtn.isSelected = false
        mapaBtn.isSelected = true
        mapView.isHidden = false
        trainerListTable.isHidden = true
    }
    
    @IBAction func filterBtn(_ sender: AnyObject) {
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
    
    @IBAction func menuBTn(_ sender: AnyObject) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func searchLocationBtn(_ sender: AnyObject) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "AllTrainerListVc") as! AllTrainerListVC
        listingDict["latitude"] = String(latitude)
        listingDict["longitude"] = String(longitude)
        listingDict["address"] = self.addressString
        myVC.listingDict = listingDict
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func changeLocation(_ sender: AnyObject) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVc") as! ChangeLocationVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return trainerListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        let count = indexPath.row + 1
        cell.countLabel.text = "0\(count)"
        cell.enterBtn.tag = indexPath.row
        cell.enterBtn.addTarget(self, action: #selector(enterBtn), for: .touchUpInside)
        var resultDict = NSDictionary()
        resultDict = trainerListArray[indexPath.row] as! NSDictionary
        cell.resulDictList(resultdict: resultDict)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocation) {
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(coordinate.coordinate) { (response, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }else{
                self.addressString  = (response?.firstResult()?.lines![0])!
            }
        }
    }
    
}

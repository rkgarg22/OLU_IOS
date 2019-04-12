//
//  ChangeLocationVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 16/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit
import CoreLocation
import Alamofire

protocol UpdateLocationForExistingSession {
    func getLocation(address:String, latitude:String, longitude:String)
}

class ChangeLocationVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UITextFieldDelegate ,CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    
    //@IBOutlet var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet var directionText: UIImageView!
    @IBOutlet var chanegDirectionLabel: UITableView!
    @IBOutlet var savedLocationTableView: UITableView!
    @IBOutlet var placesLabel: UITextField!
    var locationArray = NSMutableArray()
    
    var listingDict = NSMutableDictionary()
    var trainerDetailDict = NSDictionary()
    var isComingFrom2hrCondition = false;
    var isFromTrainerList = false
    var addressString = String()
    var locationManager:CLLocationManager!
    
    var latitude = String()
    var longitude = String()
    var addess = String()
    var savedLocationArray =  [[String: Any]]()
    var isLocationFilled = false;
    var isFromUpdateSessionLocation = false
    var selectedSessionDictForUpdateLocation = NSDictionary()
    var updateLocationDelegate:UpdateLocationForExistingSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if(self.isFromUpdateSessionLocation == false){
            determineMyCurrentLocation()
        }else{
            self.placesLabel.text = selectedSessionDictForUpdateLocation.value(forKey: "bookingAddress") as? String
            let latitude = (selectedSessionDictForUpdateLocation.value(forKey: "bookingLatitude") as AnyObject).doubleValue
            let longitude = (selectedSessionDictForUpdateLocation.value(forKey: "bookingLongitude") as AnyObject).doubleValue
            let coordinates = CLLocationCoordinate2DMake(latitude ?? 0, longitude ?? 0)
            self.centerMapOnLocation(coordinates: coordinates)
        }
        chanegDirectionLabel.tableFooterView = UIView()
        startFunc()
        
        if  let alreadySavedLocation = UserDefaults.standard.array(forKey: "savedLocation") as? [[String: Any]] {
            savedLocationArray = alreadySavedLocation
            if savedLocationArray.count != 0 {
                savedLocationTableView.isHidden = false
                savedLocationTableView.reloadData()
            }
        }
        chanegDirectionLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeLocationVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeLocationVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        //bottomContraint.constant = keyBoardHeight + 10
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.chanegDirectionLabel.contentInset = contentInset
        //bottomContraint.constant = 10
    }
    
    //MARK: to get current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //        applicationDelegate.startProgressView(view: self.view)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: -update Address According to change in region in map
    func centerMapOnLocation(coordinates:CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 18.0)
        mapView.camera = camera
        self.latitude = String(coordinates.latitude)
        self.longitude = String(coordinates.longitude)
    }
    
    //MARK: - mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        let userLocation:CLLocation = locations[0] as CLLocation
        reverseGeocodeCoordinate(coordinate: userLocation)
        let coordinates: CLLocationCoordinate2D = (manager.location?.coordinate)!
        self.centerMapOnLocation(coordinates: coordinates)
    }
    
    func getLatLongFromAddress1(address: String){
        let gecoder = CLGeocoder();
        gecoder.geocodeAddressString(address) { (placemarks, error) in
            if((error) != nil){
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.latitude = String(coordinates.latitude)
                self.longitude = String(coordinates.longitude)
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
            }
        }
    }
    
    func getLatLongFromAddress(address: String) {
        let originalUrl = "https://maps.googleapis.com/maps/api/geocode/json?" + "address=\(address)&key=AIzaSyARJmB3y4deCSnvKvOPPEwh8dICbpyjic0"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    let resultDict = dataDict.value(forKey: "results") as! NSDictionary
                    let geometryDict = resultDict.value(forKey: "geometry") as! NSDictionary
                    print(geometryDict)
                }
                break
            case .failure(_):
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocation) {
        if(!isLocationFilled){
            let geoCoder = GMSGeocoder()
            geoCoder.reverseGeocodeCoordinate(coordinate.coordinate) { (response, error) in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }else{
                    self.placesLabel.text = response?.firstResult()?.lines![0]
                }
            }
        }else{
            isLocationFilled = false
        }
        //        if(!isLocationFilled){
        //            CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
        //                if error != nil {
        //                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
        //                    return
        //                }
        //                else{
        //                    if (placemarks?.count)! > 0 {
        //                        self.addressString = "";
        //                        let placemark = placemarks?[0] as! CLPlacemark
        //                        if placemark.thoroughfare != nil {
        //                            self.addressString = self.addressString + (placemark.thoroughfare!) + ", "
        //                        }
        //                        if placemark.subLocality != nil {
        //                            self.addressString = self.addressString + (placemark.subLocality!) + ", "
        //                        }
        //
        //                        if placemark.locality != nil {
        //                            self.addressString = self.addressString + (placemark.locality!)
        //                        }
        //                        self.placesLabel.text = self.addressString
        //                    }
        //                    else {
        //                        print("Problem with the data received from geocoder")
        //                    }
        //                }
        //            })
        //        }else{
        //            isLocationFilled = false
        //        }
    }
    
    func GetPlaceDataByPlaceID(pPlaceID: String){
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("\(place.coordinate.latitude)")
                print("\(place.coordinate.longitude)")
                
                let coordinates: CLLocationCoordinate2D = place.coordinate
                self.centerMapOnLocation(coordinates: coordinates)
                
                UserDefaults.standard.set(place.coordinate.latitude, forKey: USER_DEFAULT_LATITUDE_Key)
                UserDefaults.standard.set(place.coordinate.longitude, forKey: USER_DEFAULT_LONGITUDE_Key)
                self.callForListApi(lat: "\(place.coordinate.latitude)", long: "\(place.coordinate.longitude)")
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }
    
    func callForListApi(lat:String ,long:String) {
        latitude = lat;
        longitude = long;
    }
    
    func getCoordinateBounds(latitude:CLLocationDegrees ,
                             longitude:CLLocationDegrees,
                             distance:Double = 0.001)->GMSCoordinateBounds{
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + distance, longitude: center.longitude + distance)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - distance, longitude: center.longitude - distance)
        
        return GMSCoordinateBounds(coordinate: northEast,
                                   coordinate: southWest)
    }
    
    func generateData(withKey key: String){
        if(key != ""){
            if self.locationArray.count != 0 {
                self.chanegDirectionLabel.isHidden = false
            }else{
                self.chanegDirectionLabel.isHidden = true
            }
            self.savedLocationTableView.isHidden = true
            var searchBound:GMSCoordinateBounds? = nil;
            if(latitude != "" && longitude != ""){
                searchBound = getCoordinateBounds(latitude: Double(latitude)!, longitude: Double(longitude)!, distance: 0.45)
            }
            
            let applyFilter = GMSAutocompleteFilter()
            applyFilter.country = Locale.current.regionCode
            
            let _placesClient = GMSPlacesClient()
            _placesClient.autocompleteQuery(key, bounds: searchBound, filter: applyFilter, callback: {(_ results: [GMSAutocompletePrediction]?, _ error: Error?) -> Void in
                if error == nil{
                    self.locationArray = NSMutableArray()
                    for result in results!{
                        self.locationArray.add(result)
                        self.chanegDirectionLabel.isHidden = false
                    }
                    print(results as Any)
                    self.chanegDirectionLabel.reloadData()
                }
                else {
                    print("error placing searching \(String(describing: error))")
                }
            })
        }else{
            self.chanegDirectionLabel.isHidden = true
            self.savedLocationTableView.isHidden = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude =  position.target.latitude
        let longitude =  position.target.longitude
        self.latitude = String(latitude)
        self.longitude = String(longitude)
        let clLocationCoordinates = CLLocation(latitude: latitude, longitude: longitude)
        reverseGeocodeCoordinate(coordinate: clLocationCoordinates)
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: AnyObject) {
        let addressText = (placesLabel.text?.trimmingCharacters(in: .whitespaces))
        if(isFromUpdateSessionLocation){
            if(latitude != "" && longitude != "" && addressText != ""){
                updateLocationDelegate.getLocation(address: addressText!, latitude: latitude, longitude: longitude);
                _ = navigationController?.popViewController(animated: true)
            }else{
                showAlert(self, message: selectLatLong, title: appName)
            }
        }else{
            if(isComingFrom2hrCondition){
                if(latitude != "" && longitude != "" && addressText != ""){
                    listingDict["latitude"] = latitude
                    listingDict["longitude"] = longitude
                    listingDict["address"] = placesLabel.text
                    saveLocationLocal(currentAddresss: placesLabel.text!)
                    if(isFromTrainerList){
                        let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
                        myVC.localSavedDict = listingDict
                        myVC.trainerDetailDict = trainerDetailDict
                        navigationController?.pushViewController(myVC, animated: true)
                    }else{
                        let myVC = storyboard?.instantiateViewController(withIdentifier: "AllTrainerListVc") as! AllTrainerListVC
                        myVC.listingDict = listingDict
                        navigationController?.pushViewController(myVC, animated: true)
                    }
                }else{
                    showAlert(self, message: selectLatLong, title: appName)
                }
            }else{
                if(latitude != "" && longitude != "" && addressText != ""){
                    listingDict["latitude"] = latitude
                    listingDict["longitude"] = longitude
                    listingDict["address"] = addressText
                    saveLocationLocal(currentAddresss: placesLabel.text!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLatLong"), object:listingDict);
                    _ = navigationController?.popViewController(animated: true)
                }else{
                    showAlert(self, message: selectLatLong, title: appName)
                }
            }
        }
    }
    
    func saveLocationLocal(currentAddresss: String){
        if(!isLocationAvailable(currentAddress: currentAddresss)){
            if  let alreadySavedLocation = UserDefaults.standard.array(forKey: "savedLocation") as? [[String: Any]] {
                if(alreadySavedLocation.count==2){
                    savedLocationArray = alreadySavedLocation
                    savedLocationArray.remove(at: 0);
                }
                savedLocationArray.append(["latitude": latitude, "longitude": longitude, "address": placesLabel.text ?? ""])
            }else{
                savedLocationArray.append(["latitude": latitude, "longitude": longitude, "address": placesLabel.text ?? ""])
            }
            UserDefaults.standard.set(savedLocationArray, forKey: "savedLocation")
        }
    }
    
    func isLocationAvailable(currentAddress: String) -> Bool{
        var isLocationPresent : Bool = false
        for item in savedLocationArray{
            let address = item["address"] as? String
            if(address == currentAddress){
                isLocationPresent = true
                break;
            }
        }
        return isLocationPresent
    }
    
    @IBAction func menuBtn(_ sender: AnyObject) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBOutlet var menuBtn: UIButtonCustomClass!
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView.tag==1){
            return savedLocationArray.count
        }else{
            return locationArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addressCell
        if(tableView.tag==1){
            if savedLocationArray.count != 0 {
                let locDict = savedLocationArray[indexPath.row]
                cell.placesLabel.text =  locDict["address"] as? String
            }
        }else{
            let prediction : GMSAutocompletePrediction = locationArray.object(at: indexPath.row) as! GMSAutocompletePrediction
            UserDefaults.standard.set(prediction.attributedFullText.string, forKey: USER_DEFAULT_ADDRESS_Key)
            cell.placesLabel.text =  prediction.attributedFullText.string
        }
        tableView.separatorStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag==1){
            let cell = savedLocationTableView.cellForRow(at: indexPath) as! addressCell
            let locDict = savedLocationArray[indexPath.row]
            placesLabel.text = cell.placesLabel.text
            latitude =  (locDict["latitude"] as? String)!
            longitude =  (locDict["longitude"] as? String)!
        }else{
            let cell = chanegDirectionLabel.cellForRow(at: indexPath) as! addressCell
            let prediction : GMSAutocompletePrediction = locationArray.object(at: indexPath.row) as! GMSAutocompletePrediction
            let placeID = prediction.placeID as! String
            GetPlaceDataByPlaceID(pPlaceID: placeID)
            placesLabel.text = cell.placesLabel.text
            chanegDirectionLabel.isHidden = true
            isLocationFilled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        generateData(withKey: textField.text!)
        // self.latitude = "";
        // self.longitude = "";
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            //self.chanegDirectionLabel.isHidden = false
            self.savedLocationTableView.isHidden = true
            if(latitude == "" && longitude == ""){
                // getLatLongFromAddress(address: textField.text!)
            }
        }else{
            self.chanegDirectionLabel.isHidden = true
            self.savedLocationTableView.isHidden = true
        }
        textField.endEditing(true)
        return false
    }
    
}

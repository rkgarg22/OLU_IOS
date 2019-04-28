//
//  PendingVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 18/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit


class PendingVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,PendingAlamofire ,confirmBookingAlamofire, UIPickerViewDelegate, UIPickerViewDataSource, UpdateLocationForExistingSession, SessionUpdateProtocol{
    
    
    
    @IBOutlet weak var totalPrice: UILabelCustomClass!
    @IBOutlet weak var categoryLabel: UILabelCustomClass!
    @IBOutlet weak var nameLabel: UILabelCustomClass!
    @IBOutlet weak var dateLabel: UILabelCustomClass!
    
    @IBOutlet weak var timeLabel: UILabelCustomClass!
    @IBOutlet weak var addressLabel: UILabelCustomClass!
    @IBOutlet weak var numberOfPersona: UILabelCustomClass!
    @IBOutlet weak var editarView: UIView!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    @IBOutlet weak var countlabel: UILabelCustomClass!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet var overLayView: UIView!
    @IBOutlet var timeText: UILabelCustomClass!
    @IBOutlet var dateText: UILabelCustomClass!
    @IBOutlet var catText: UILabelCustomClass!
    @IBOutlet var nameText: UILabelCustomClass!
    @IBOutlet var locationTextView: UILabelCustomClass!
    @IBOutlet var noDataFoundLabel: UILabelCustomClass!
    @IBOutlet var viewTrainer: UIView!
    @IBOutlet var pendingTrainer: UIButton!
    @IBOutlet var acceptedTrainer: UIButton!
    @IBOutlet var completedTrainer: UIButton!
    @IBOutlet var pendingBtn: UIButtonCustomClass!
    @IBOutlet var realizadas: UIButtonCustomClass!
    @IBOutlet var pendingTableView: UITableView!
    @IBOutlet var realizadasTableView: UITableView!
    @IBOutlet var acceptBtn: UIButton!
    @IBOutlet var declineBtn: UIButton!
    @IBOutlet weak var acceptedLbl: UILabelCustomClass!
    
    @IBOutlet var noOfPersonPickerView: UIPickerView!
    @IBOutlet var pickerDoneBtn: UIButton!
    var resultArray = NSMutableArray()
    var selectedBtn = UIButton()
    var selectedOption = 0
    var isTrainer = false
    var isCancelAPIHit = false
    var selectedIndex = -1;
    var popupDict = NSDictionary()
    var isPaymentRequire = "0"
    var isSelectedAcceptedUserBtn : Bool = false
    var isFromAcc : Bool = false
    var selectedInValueFromPicker = -1;
    var pickerData: [String] = [String]()
    var selectedDict = NSDictionary()
    
    var selectedAddress: String = ""
    var selectedLongitude: String = ""
    var selectedLatitude: String = ""
    var selectBookingFor: String = ""
    var apiStatus = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overLayView.isHidden = true
        let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String
        if userType == "trainer" {
            //totalHeight.constant = 60
            viewTrainer.isHidden = false
            acceptedLbl.isHidden = true
            isTrainer = true
            apiStatus = "0"
            pendingListApiHit(status: "0")
            pendingBtn.setTitle("PENDIENTES", for: UIControlState.normal)
            pendingBtn.setTitle("PENDIENTES", for: UIControlState.selected)
        }else{
            //totalHeight.constant = 0
            pendingBtn.setTitle("AGENDADA", for: UIControlState.normal)
            pendingBtn.setTitle("AGENDADA", for: UIControlState.selected)
            acceptedLbl.isHidden = false
            apiStatus = "3"
            pendingListApiHit(status: "3")
        }
        pendingTableView.tableFooterView = UIView()
        realizadasTableView.tableFooterView = UIView()
        self.noOfPersonPickerView.delegate = self
        self.noOfPersonPickerView.dataSource = self
        pickerData = ["1", "2", "3", "4", "Empresarial"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickerDoneBtnClick(_ sender: Any){
        numberOfPersona.text = pickerData[selectedInValueFromPicker];
        noOfPersonPickerView.isHidden = true
        pickerDoneBtn.isHidden = true
        
        if (pickerData[selectedInValueFromPicker] == "1"){
            selectBookingFor = "1"
        }else if (pickerData[selectedInValueFromPicker] == "2"){
            selectBookingFor = "2"
        }else if (pickerData[selectedInValueFromPicker] == "3"){
            selectBookingFor = "4"
        }else if (pickerData[selectedInValueFromPicker] == "4"){
            selectBookingFor = "5"
        }else if (pickerData[selectedInValueFromPicker] == "Empresarial"){
            selectBookingFor = "3"
        }
    }
    
    @IBAction func addressBtnClick(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVc") as! ChangeLocationVC
        myVC.selectedSessionDictForUpdateLocation = selectedDict
        myVC.isFromUpdateSessionLocation = true
        myVC.updateLocationDelegate = self
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func gurdadBtnClick(_ sender: Any){
        if applicationDelegate.isConnectedToNetwork {
             applicationDelegate.startProgressView(view: self.view)
            let bookingID = selectedDict.value(forKey: "bookingID") as? Int ?? 0
            AlamofireWrapper.sharedInstance.sessionUpdateProtocol = self
            AlamofireWrapper.sharedInstance.sessionUpdate(bookingID: String(bookingID), bookingType: selectBookingFor, latitude: selectedLatitude, longitude: selectedLongitude, address: selectedAddress)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let suucess = dictionaryContent.value(forKey: "success") as AnyObject
        if suucess.isEqual(1){
            noOfPersonPickerView.isHidden = true
            pickerDoneBtn.isHidden = true
            editarView.isHidden = true
            resultArray = []
            pendingListApiHit(status: apiStatus)
        }else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func getLocation(address: String, latitude: String, longitude: String) {
        selectedAddress = address;
        selectedLatitude = latitude;
        selectedLongitude = longitude;
        
        addressLabel.text =  "\(directionText) \(selectedAddress)"
    }
    
    @IBAction func numberOfPerson(_ sender: Any) {
        noOfPersonPickerView.isHidden = false
        pickerDoneBtn.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedInValueFromPicker = row;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func acceptedUserBtn(_ sender: Any) {
        if !isSelectedAcceptedUserBtn {
            isSelectedAcceptedUserBtn = true
            isFromAcc = true
            selectedOption = 2
            resultArray = []
            pendingBtn.isSelected = false
            realizadas.isSelected = false
            pendingTableView.isHidden = true
            realizadasTableView.isHidden = true
            acceptedLbl.textColor = UIColor(red: 0/255, green: 151/255, blue: 167/255, alpha: 1.0)
            apiStatus = "0"
            pendingListApiHit(status: "0")
        }
    }
    
    
    @IBAction func accptBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title:"¿Estás  seguro que deseas confirmar la reserva?", message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.isCancelAPIHit = false
            let bookingID = self.popupDict.value(forKey: "bookingID") as! Int
            self.updateOrderStatusAPI(status: "3", bookingID: bookingID,isPaymentRequire: "0")
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func declineBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title:"¿Seguro que quieres rechazar el trabajo?", message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.isCancelAPIHit = true
            let bookingID = self.popupDict.value(forKey: "bookingID") as! Int
            self.updateOrderStatusAPI(status: "2", bookingID: bookingID,isPaymentRequire: "0")
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func mapaBtnClick(_ sender: UIButton){
        let alertController = UIAlertController(title:"Seleccionar opción", message: "", preferredStyle: .alert)
        // Create the actions
        let wazeAction = UIAlertAction(title:"WAZE", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (self.popupDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.popupDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    if let url = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        else{
                            let itunesUrl = URL(string: wazeItunesUrl)
                            UIApplication.shared.open(itunesUrl!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        let googleMapAction = UIAlertAction(title: "GOOGLE MAPS", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (self.popupDict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (self.popupDict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    let url = URL(string: "http://maps.google.com/?saddr=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&daddr=\(latitude),\(longitude)")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(wazeAction)
        alertController.addAction(googleMapAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pendingBtn(_ sender: UIButton) {
        if !sender.isSelected {
            isFromAcc = false
            isSelectedAcceptedUserBtn = false
            selectedOption = 0
            acceptedLbl.textColor = UIColor(red: 69/255, green: 89/255, blue: 103/255, alpha: 1.0)
            resultArray = []
            pendingBtn.isSelected = true
            realizadas.isSelected = false
            pendingTableView.isHidden = true
            realizadasTableView.isHidden = true
            let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as! String
            if userType == "trainer" {
                apiStatus = "3"
                pendingListApiHit(status: "3")
            }
            else{
                apiStatus = "3"
                pendingListApiHit(status: "3")
            }
        }
    }
    
    @IBAction func realizadasBtn(_ sender: UIButton) {
        if !sender.isSelected {
            isFromAcc = false
            isSelectedAcceptedUserBtn = false
            acceptedLbl.textColor = UIColor(red: 69/255, green: 89/255, blue: 103/255, alpha: 1.0)
            selectedOption = 1
            resultArray = []
            pendingBtn.isSelected = false
            realizadas.isSelected = true
            pendingTableView.isHidden = true
            realizadasTableView.isHidden = true
            apiStatus = "1"
            pendingListApiHit(status: "1")
        }
    }
    
    @IBAction func statusChangeList(_ sender: UIButton) {
        resultArray = []
        if sender.tag == 0 {
            selectedOption = 0 // Pending
            if !sender.isSelected {
                pendingTrainer.isSelected = true
                acceptedTrainer.isSelected = false
                completedTrainer.isSelected = false
                pendingTableView.isHidden = true
                realizadasTableView.isHidden = true
                apiStatus = "0"
                pendingListApiHit(status: "0")
            }
        }
        else if sender.tag == 1 {
            selectedOption = 1 // realizados
            if !sender.isSelected {
                acceptedTrainer.isSelected = true
                pendingTrainer.isSelected = false
                completedTrainer.isSelected = false
                pendingTableView.isHidden = true
                realizadasTableView.isHidden = true
                apiStatus = "1"
                pendingListApiHit(status: "1")
            }
        }
        else
        {
            if !sender.isSelected {
                selectedOption = 2 // accepted
                acceptedTrainer.isSelected = false
                pendingTrainer.isSelected = false
                completedTrainer.isSelected = true
                pendingTableView.isHidden = true
                realizadasTableView.isHidden = true
                apiStatus = "3"
                pendingListApiHit(status: "3")
            }
        }
    }
    
    @IBOutlet var menuBtn: UIButtonCustomClass!
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    func pendingListApiHit(status:String) {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getPendingDelegate = self
            AlamofireWrapper.sharedInstance.getPendingLsit(status: status)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getPendingResults(dictionaryContent: NSDictionary){
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            print("start",resultArray)
            let dataArray = dictionaryContent.value(forKey: "result") as! NSArray
            resultArray = dataArray.mutableCopy() as! NSMutableArray
            pendingTableView.reloadData()
            realizadasTableView.reloadData()
        }
        else {
            if resultArray.count != 0 {
                let error = dictionaryContent.value(forKey: "error") as! String
                showAlert(self, message: error, title: appName)
            }
        }
        if resultArray.count == 0 {
            pendingTableView.isHidden = true
            realizadasTableView.isHidden = true
            if (selectedOption == 0){
                noDataFoundLabel.text = "No tienes reservas programadas!"
            }else{
                noDataFoundLabel.text = "¡Aún no tienes OLU actividades!"
            }
            noDataFoundLabel.isHidden = false
        }
        else{
            if (selectedOption == 0 || selectedOption == 2){
                pendingTableView.isHidden = false
                realizadasTableView.isHidden = true
            }
            else{
                pendingTableView.isHidden = true
                realizadasTableView.isHidden = false
            }
            noDataFoundLabel.isHidden = true
        }
    }
    
    @IBAction func crossBtn(_ sender: Any){
        overLayView.isHidden = true
    }
    
    func openRequestPopUp(dict:NSDictionary ) {
        overLayView.isHidden = false
        nameText.text = dict.value(forKey: "firstName") as? String
        catText.text = dict.value(forKey: "category") as? String
        let dateString = dict.value(forKey: "bookingDate") as? String
        let timeString = dict.value(forKey: "bookingStart") as! String
        let bookingAddress = dict.value(forKey: "bookingAddress") as! String
        let bookingFor =  dict.value(forKey: "bookingFor") as! Int
        
        switch  bookingFor {
        case 3 :
            countlabel.isHidden = true
            groupName.text = "Empresarial"
            groupImage.image = #imageLiteral(resourceName: "companyTrainee")
        case 1 :
            countlabel.isHidden = true
            groupName.text = "Individual"
            groupImage.image = #imageLiteral(resourceName: "personCalendar")
        default:
            if bookingFor == 2 {
                countlabel.isHidden = false
                countlabel.text = "2"
                groupName.text = "Grupal"
            }
            else if bookingFor == 4 {
                countlabel.text = "3"
                countlabel.isHidden = false
                groupName.text = "Grupal"
            }
            else if bookingFor == 5 {
                countlabel.text = "4"
                countlabel.isHidden = false
                groupName.text = "Grupal"
            }
            groupImage.image = #imageLiteral(resourceName: "greyBack")
        }
        let convStartTime = convertTime(timeString: timeString)
        timeText.text = "\(convStartTime)"
        dateText.text = getDateInFormat(selectedDate: dateString!)
        locationTextView.text = bookingAddress
    }
    
    func updateOrderStatusAPI(status:String, bookingID: Int,isPaymentRequire: String){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.confirmBookingDelegate = self
            AlamofireWrapper.sharedInstance.confirmBooking(bookingID: String(bookingID)  , status: status,isPaymentRequire: isPaymentRequire)
        }
    }
    func confirmBookingResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        overLayView.isHidden =  true
        let suucess = dictionaryContent.value(forKey: "success") as AnyObject
        if suucess.isEqual(1){
            if(isCancelAPIHit){
                isCancelAPIHit = false
                let dict = resultArray[selectedIndex] as! NSDictionary
                let bookingId = dict.value(forKey: "bookingID") as! Int
                applicationDelegate.removeNotification(bookingIdString: String(bookingId))
                resultArray.removeObject(at: selectedIndex)
                pendingTableView.reloadData()
                if resultArray.count == 0  {
                    noDataFoundLabel.isHidden = true
                }
                selectedIndex = -1
            }else{
                let dict = resultArray[selectedIndex] as! NSDictionary
                let bookingId = dict.value(forKey: "bookingID") as! Int
                if(applicationDelegate.isMoreThan30Min(sessionDict: dict)){
                    applicationDelegate.setLocalNotifcationForSession(sessionDict: dict, bookingID: String(bookingId))
                }
                resultArray.removeObject(at: selectedIndex)
                pendingTableView.reloadData()
                if resultArray.count == 0  {
                    noDataFoundLabel.isHidden = true
                }
                selectedIndex = -1
            }
        }
    }
    
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @objc func cancelBtn(sender:UIButton) {
        var message = String()
        if(isTrainer){
            message = cancelAlertTrainer
        }else{
            message = checkCancelMessage(indexValue: sender.tag)
        }
        let alertController = UIAlertController(title:message, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.cancelHistoryList(indexValue: sender.tag)
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkCancelMessage(indexValue:Int)-> String{
        var message = String()
        var dict = NSDictionary()
        dict = resultArray[indexValue] as! NSDictionary
        let bookingCreated = dict.value(forKey: "bookingCreated") as! String
        let bookingStartTime = dict.value(forKey: "bookingStart") as! String
        let bookingAcceptedTime = dict.value(forKey: "bookingAccepted") as! String
        let date = dict.value(forKey: "bookingDate") as! String
        let bookingStartDateTime  = date + " " + bookingStartTime
        
        let currenDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let currentDateString = dateFormatter.string(from: currenDate)
        let currentDateObject = dateFormatter.date(from: currentDateString)
        
        let booingCreatedDateConverted = dateFormatter.date(from: bookingCreated)
        let booingStartDateConverted = dateFormatter.date(from: bookingStartDateTime)
        let booingAcceptedDateConverted = dateFormatter.date(from: bookingAcceptedTime)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.hour,.minute], from: booingCreatedDateConverted!, to: booingStartDateConverted!)
        let diffHour = components.hour!
        let diffMinutesFromCreated = components.minute!
        
        let componentsMinute = cal.dateComponents([.minute], from: booingAcceptedDateConverted!, to: currentDateObject!)
        let minutesDiff = componentsMinute.minute!
        
        let componentsMinuteFromStartDate = cal.dateComponents([.minute], from: currentDateObject!, to: booingStartDateConverted!)
        let minutesDiffFromStartClass = componentsMinuteFromStartDate.minute!
        
        if(diffHour<2){
            //            if(diffMinutesFromCreated <= 45){
            //                message = cancelMessageForNext45;
            //                isPaymentRequire = "1"
            //            }
            if(minutesDiff <= 15){
                message = cancelMessageForFirst15;
                isPaymentRequire = "0"
            }else if(minutesDiff >= 15){
                message = cancelMessageForAfter15;
                isPaymentRequire = "1"
            }
        }else{
            //            if(diffMinutesFromCreated <= 45){
            //                message = cancelMessageForNext45;
            //                isPaymentRequire = "1"
            //            }else
            if(minutesDiffFromStartClass > 75){
                message = cancelMessageForMore75;
                isPaymentRequire = "0"
            }else{
                message = cancelMessageForAfter15;
                isPaymentRequire = "1"
            }
        }
        return message
    }
    
    func cancelHistoryList(indexValue:Int){
        isCancelAPIHit = true
        selectedIndex = indexValue
        var dict = NSDictionary()
        dict = resultArray[indexValue] as! NSDictionary
        let bookingId = dict.value(forKey: "bookingID") as! Int
        updateOrderStatusAPI(status: "2", bookingID: bookingId,isPaymentRequire: isPaymentRequire)
    }
    
    @objc func messageBtn(sender:UIButton) {
        var dict = NSDictionary()
        dict = resultArray[sender.tag] as! NSDictionary
        let firsrtName = dict.value(forKey: "firstName") as! String
        let lastName = dict.value(forKey: "lastName") as! String
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChatVc") as! ChatVC
        myVC.toUserId = dict.value(forKey: "userID") as! Int
        myVC.userName = firsrtName + " " + lastName
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @objc func phoneRingingBtn(sender:UIButton) {
        var dict = NSDictionary()
        dict = resultArray[sender.tag] as! NSDictionary
        let phone = dict.value(forKey: "phone") as! String
        if(phone != ""){
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @objc func mapabtnClick(sender:UIButton) {
        var dict = NSDictionary()
        dict = resultArray[sender.tag] as! NSDictionary
        let alertController = UIAlertController(title:"Seleccionar opción", message: "", preferredStyle: .alert)
        // Create the actions
        let wazeAction = UIAlertAction(title:"WAZE", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (dict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (dict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    if let url = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        else{
                            let itunesUrl = URL(string: wazeItunesUrl)
                            UIApplication.shared.open(itunesUrl!, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        let googleMapAction = UIAlertAction(title: "GOOGLE MAPS", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if let latitude = (dict.value(forKey: "bookingLatitude") as AnyObject).doubleValue {
                if let longitude = (dict.value(forKey: "bookingLongitude") as AnyObject).doubleValue {
                    let url = URL(string: "http://maps.google.com/?saddr=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&daddr=\(latitude),\(longitude)")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(wazeAction)
        alertController.addAction(googleMapAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editarViewCloseBtn(_ sender: Any){
        editarView.isHidden = true
    }
    
    @objc func editarBtnClick(sender:UIButton) {
        selectedDict = resultArray[sender.tag] as! NSDictionary
        editarView.isHidden = false
        categoryLabel.text = selectedDict.value(forKey: "category") as? String
        
        let firsrtName = selectedDict.value(forKey: "firstName") as! String
        let lastName = selectedDict.value(forKey: "lastName") as! String
        nameLabel.text = firsrtName + " " + lastName
        dateLabel.text = selectedDict.value(forKey: "bookingDate") as? String
        
        let startTime = selectedDict.value(forKey: "bookingStart") as! String
        let endTime = selectedDict.value(forKey: "bookingEnd") as! String
        timeLabel.text = "\(getTimeInFormat(time: startTime)) - \(getTimeInFormat(time: endTime))"
        addressLabel.text =  "\(directionText) \(selectedDict.value(forKey: "bookingAddress") as! String)"
        
        let bookingFor =  selectedDict.value(forKey: "bookingFor") as! Int
        switch  bookingFor {
        case 3 :
            numberOfPersona.text =  "Empresarial"
        case 1 :
            numberOfPersona.text =  "1"
        default:
            if bookingFor == 2 {
                numberOfPersona.text =  "2"
            }
            else if bookingFor == 4 {
                numberOfPersona.text =  "3"
            }
            else if bookingFor == 5 {
                numberOfPersona.text =  "4"
            }
        }
        selectedAddress = selectedDict.value(forKey: "bookingAddress") as! String;
        selectedLongitude = selectedDict.value(forKey: "bookingLongitude") as! String
        selectedLatitude = selectedDict.value(forKey: "bookingLatitude") as! String
        selectBookingFor = String(bookingFor)
    }
    
    func getTimeInFormat(time: String)-> String{
        var timeFormat = String()
        
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        let dateConverted = dateFormatter.date(from: time)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a" //Your date format
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        timeFormat = timeFormatter.string(from: dateConverted!)
        
        return timeFormat
    }
    
    //MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PendingCell
            var resultDict = NSDictionary()
            resultDict = resultArray[indexPath.row] as! NSDictionary
            cell.resultDict(resultDict: resultDict)
            if isFromAcc {
                cell.heightView.constant = 0
            } else {
                cell.heightView.constant = 100
            }
            
            cell.crossBtn.tag = indexPath.row
            cell.messageBtn.tag = indexPath.row
            cell.phoneRingingBtn.tag = indexPath.row
            cell.directionBtn.tag = indexPath.row
            cell.editarBtn.tag = indexPath.row
            cell.crossBtn.addTarget(self, action: #selector(cancelBtn), for: .touchUpInside)
            cell.messageBtn.addTarget(self, action: #selector(messageBtn), for: .touchUpInside)
            cell.phoneRingingBtn.addTarget(self, action: #selector(phoneRingingBtn), for: .touchUpInside)
            cell.directionBtn.addTarget(self, action: #selector(mapabtnClick), for: .touchUpInside)
            cell.editarBtn.addTarget(self, action: #selector(editarBtnClick), for: .touchUpInside)
            
            let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String
            if userType == "trainer" {
                cell.addressLabel.text = ""
                cell.numberOfperson.text = ""
                cell.editarBtn.isHidden = true
            }else{
                cell.addressLabel.isHidden = false
                cell.numberOfperson.isHidden = false
                cell.editarBtn.isHidden = false
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RealizadasCell
            var resultDict = NSDictionary()
            resultDict = resultArray[indexPath.row] as! NSDictionary
            cell.resultDict(resultDict: resultDict)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if tableView.tag == 1 {
                if(isTrainer){
                    if(selectedOption == 0){
                        selectedIndex = indexPath.row
                        popupDict = resultArray[indexPath.row] as! NSDictionary
                        openRequestPopUp(dict: popupDict)
                    }else if(selectedOption == 2){
                        var bookingDict = NSDictionary()
                        bookingDict = resultArray[indexPath.row] as! NSDictionary
                        let myVC = storyboard?.instantiateViewController(withIdentifier: "StartEndSessionVc") as! StartEndSessionVC
                        myVC.bookingDict = bookingDict
                        navigationController?.pushViewController(myVC, animated: true)
                    }
                }
            }
        }
    }
}

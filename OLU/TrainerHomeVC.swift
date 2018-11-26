//
//  TrainerHomeVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import FSCalendar
import CoreLocation


class TrainerHomeVC: UIViewController,SWRevealViewControllerDelegate ,UITableViewDelegate ,UITableViewDataSource ,todayBookingAlamofire ,FSCalendarDelegate,FSCalendarDataSource,updateLocationAlamofire ,CLLocationManagerDelegate{
    
    var eventListArray = NSArray()
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var menuBtn: UIButtonCustomClass!
    @IBOutlet weak var eventListTable: UITableView!
    @IBOutlet var noBookingLabel: UILabelCustomClass!
    @IBOutlet var titulaTextField: UITextFieldCustomClass!
    @IBOutlet var dayTextField: UITextFieldCustomClass!
    @IBOutlet var startTimeTextField: UITextFieldCustomClass!
    @IBOutlet var endTimeTextField: UITextFieldCustomClass!
    @IBOutlet var repeatTextField: UITextFieldCustomClass!
    @IBOutlet var createAgendaView: UIViewCustomClass!
    @IBOutlet var eliminarButton: UIButtonCustomClass!
    
    var selectedDate = String()
    var lastSelectedDay = ""
    var lastSelectedStartTime = ""
    var lastSelectedEndTime = ""
    var agendaType = ""
    var agendaID = Int()
    let dateformatter = DateFormatter()
    
    private let pickerArray :Array<String> = ["Solo hoy", "Cada día", "Todas las semanas", "Cada mes", "Cada Año"]
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateformatter.locale = Locale(identifier: "es")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTodayBooking(_:)), name: NSNotification.Name(rawValue: "updateTrainerHomeScreen"), object: nil)
        
        self.calendarView.locale = Locale(identifier: "es")
        menuBtn.tintColor = UIColor.white
        let todayDate = Date()
        selectedDate =  self.dateFormatter1.string(from: todayDate)
        todayBookingApiHit(date:selectedDate )
        eventListTable.tableFooterView = UIView()
        determineMyCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WhereLocation from notification
    @objc func updateTodayBooking(_ notification: NSNotification){
        todayBookingApiHit(date:selectedDate )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.revealViewController() != nil{
            if(revealViewController().frontViewPosition == FrontViewPosition.right){
                revealViewController().frontViewPosition = FrontViewPosition.left
            }
        }
    }
    
    //MARK: to get current location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        //        applicationDelegate.startProgressView(view: self.view)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    //MARK: - mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.delegate = nil
        let userLocation:CLLocation = locations[0] as CLLocation
        if(applicationDelegate.latitude != userLocation.coordinate.latitude && applicationDelegate.longitude != userLocation.coordinate.longitude){
            applicationDelegate.latitude = userLocation.coordinate.latitude
            applicationDelegate.longitude = userLocation.coordinate.longitude
            updateLocationApiHit()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    func updateLocationApiHit() {
        AlamofireWrapper.sharedInstance.updateLocationDelegate = self
        AlamofireWrapper.sharedInstance.updateLocation(lat: applicationDelegate.latitude, long: applicationDelegate.longitude)
    }
    
    
    func todayBookingApiHit(date:String) {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.todayBookingDelegate = self
            AlamofireWrapper.sharedInstance.bookingToday(date:date)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func todayBookingResults(dictionaryContent: NSDictionary) {
        eventListArray=[]
        eventListTable.reloadData()
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            eventListArray = dictionaryContent.value(forKey: "result") as! NSArray
            eventListTable.reloadData()
        }
        else {
            if eventListArray.count != 0 {
                let error = dictionaryContent.value(forKey: "error") as! String
                showAlert(self, message: error, title: appName)
            }
        }
        if eventListArray.count == 0 {
            noBookingLabel.isHidden = false
        }
        else {
            noBookingLabel.isHidden = true
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    //MARK: - Home Button Action
    @IBAction func homeAction(_ sender: Any) {
        if self.revealViewController() != nil{
            if(revealViewController().frontViewPosition != FrontViewPosition.right){
                revealViewController().frontViewPosition = FrontViewPosition.right
            }
            else{
                revealViewController().frontViewPosition = FrontViewPosition.left
            }
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        agendaID = 0
        eliminarButton.isHidden = true
        createAgendaView.isHidden = false
        repeatTextField.text = pickerArray[0]
        
        dateformatter.dateFormat = "dd-MM-yyyy"
        let date = dateformatter.date(from: selectedDate)
        dayTextField.text = getWeekdayName(date: date!) + ", " + getMonthName(date: date!) + " " + getDay(date: date!)
        
        dateformatter.dateFormat = "yyyy-MM-dd"
        lastSelectedDay = dateformatter.string(from: date!)
        
        agendaType = String(0)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        clearAgenda()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteAgenda()
    }
    
    @IBAction func guardarAction(_ sender: Any) {
        if !((titulaTextField.text!.isEmpty) || dayTextField.text!.isEmpty || startTimeTextField.text!.isEmpty || endTimeTextField.text!.isEmpty || repeatTextField.text!.isEmpty) {
            if agendaID != 0 {
                updateAgenda()
            } else {
                createAgenda()
            }
            
        } else {
            showAlert(self, message: "Todos los campos son obligatorios", title: appName)
        }
    }
    
    func clearAgenda() {
        titulaTextField.text = ""
        dayTextField.text = ""
        startTimeTextField.text = ""
        endTimeTextField.text = ""
        repeatTextField.text = ""
        lastSelectedDay = ""
        lastSelectedStartTime = ""
        lastSelectedEndTime = ""
        agendaType = ""
        createAgendaView.isHidden = true
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return eventListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodaysBookingTableViewCell
        var dict = NSDictionary()
        dict = eventListArray[indexPath.row] as! NSDictionary
        cell.resulDictDisplay(resultDict: dict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var bookingDict = NSDictionary()
        bookingDict = eventListArray[indexPath.row] as! NSDictionary
        if bookingDict.value(forKey: "isAgenda") as? Int ?? 0 == 1 {
            agendaID = bookingDict.value(forKey: "agendaID") as? Int ?? 0
            eliminarButton.isHidden = false
            openAgenda(dict: bookingDict)
        } else if(bookingDict.value(forKey: "status") as! Int == 3){
            let myVC = storyboard?.instantiateViewController(withIdentifier: "StartEndSessionVc") as! StartEndSessionVC
            myVC.bookingDict = bookingDict
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    func getWeekdayName(date:Date)-> String{
        // get current week day name
        let formatterWeek = DateFormatter()
        formatterWeek.dateFormat = "EEEE" // weekday name
        formatterWeek.locale =  NSLocale(localeIdentifier: "es") as Locale?
        let dayInWeek = formatterWeek.string(from: date)
        return dayInWeek.capitalized
    }
    
    //get day
    func getDay(date:Date)-> String{
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd"
        let dateWeek = formatterDate.string(from: date)
        return dateWeek
    }
    
    //get month Name
    func getMonthName(date:Date)-> String{
        var monthName = String()
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.dateFormat = "LLL" //month
        dateFormatterMonth.locale =  NSLocale(localeIdentifier: "es") as Locale?
        monthName = dateFormatterMonth.string(from: date)
        return monthName.capitalized
    }
    
    func openAgenda(dict: NSDictionary) {
        createAgendaView.isHidden = false
        titulaTextField.text = dict["agendaText"] as? String ?? ""
        
        lastSelectedDay = dict["bookingDate"] as? String ?? ""
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date = dateformatter.date(from: lastSelectedDay)
        //dateformatter.dateFormat = "EEEE, MMM d"
        //let dateText = dateformatter.string(from: date!)
        dayTextField.text = getWeekdayName(date: date!) + ", " + getMonthName(date: date!) + " " + getDay(date: date!)
        
        lastSelectedStartTime = dict["bookingStart"] as? String ?? ""
        lastSelectedEndTime = dict["bookingEnd"] as? String ?? ""
        
        
        dateformatter.dateFormat = "HH:mm:ss"
        let startTime = dateformatter.date(from: lastSelectedStartTime)
        let endTime = dateformatter.date(from: lastSelectedEndTime)
        
        dateformatter.dateFormat = "hh:mm a"
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        //dateformatter.timeZone = TimeZone(secondsFromGMT: 0) //Current time zone
        startTimeTextField.text = dateformatter.string(from: startTime!)
        endTimeTextField.text = dateformatter.string(from: endTime!)
        
        agendaType = dict["agendaType"] as? String ?? ""
        repeatTextField.text = pickerArray[Int(agendaType)!]
    }
    
    //MARK: - Did Select calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        eventListArray = []
        eventListTable.reloadData()
        selectedDate = self.dateFormatter1.string(from: date)
        todayBookingApiHit(date:selectedDate)
    }
    
    func createAgenda() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.createAgendaDelegate = self
            let param = [
                "userID": getUserID(),
                "agenda_text": titulaTextField.text!,
                "agenda_date": lastSelectedDay,
                "agenda_start_time": lastSelectedStartTime,
                "agenda_end_time": lastSelectedEndTime,
                "agenda_type": agendaType
                ] as [String : Any]
            print(param)
            view.endEditing(true)
            AlamofireWrapper.sharedInstance.createAgenda(param)
        } else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func updateAgenda() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.updateAgendaDelegate = self
            let param = [
                "userID": getUserID(),
                "agendaID": agendaID,
                "agenda_text": titulaTextField.text!,
                "agenda_date": lastSelectedDay,
                "agenda_start_time": lastSelectedStartTime,
                "agenda_end_time": lastSelectedEndTime,
                "agenda_type": agendaType
                ] as [String : Any]
            view.endEditing(true)
            print(param)
            AlamofireWrapper.sharedInstance.updateAgenda(param)
        } else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func deleteAgenda() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.deleteAgendaDelegate = self
            AlamofireWrapper.sharedInstance.deleteAgenda(agendaId: agendaID)
        } else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
}

extension TrainerHomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dayTextField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.datePickerActionForDayField(_:)), for: .valueChanged)
        } else if textField == startTimeTextField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            textField.inputView = datePicker
            // datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            datePicker.addTarget(self, action: #selector(self.datePickerActionForStartTimeField(_:)), for: .valueChanged)
        } else if textField == endTimeTextField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.datePickerActionForEndTimeField(_:)), for: .valueChanged)
        } else if textField == repeatTextField {
            let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            picker.reloadAllComponents()
            textField.inputView = picker
        }
    }
    
    @objc func datePickerActionForStartTimeField(_ sender: UIDatePicker){
        dateformatter.dateFormat = "hh:mm a"
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        //dateformatter.timeZone = TimeZone(secondsFromGMT: 0)
        let timeText = dateformatter.string(from: sender.date)
        startTimeTextField.text = timeText
        dateformatter.dateFormat = "HH:mm:ss"
        lastSelectedStartTime = dateformatter.string(from: sender.date)
    }
    
    @objc func datePickerActionForEndTimeField(_ sender: UIDatePicker){
        dateformatter.dateFormat = "hh:mm a"
        let timeText = dateformatter.string(from: sender.date)
        endTimeTextField.text = timeText
        dateformatter.dateFormat = "HH:mm:ss"
        lastSelectedEndTime = dateformatter.string(from: sender.date)
    }
    
    @objc func datePickerActionForDayField(_ sender: UIDatePicker){
        //dateformatter.dateFormat = "EEEE,MMM d"
        let dateText = getWeekdayName(date: sender.date) + ", " + getMonthName(date: sender.date) + " " + getDay(date: sender.date)
        dayTextField.text = dateText
        dateformatter.dateFormat = "yyyy-MM-dd"
        lastSelectedDay = dateformatter.string(from: sender.date)
    }
}

extension TrainerHomeVC: createAgendaProtocol {
    func createAgendaResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            clearAgenda()
            todayBookingApiHit(date:selectedDate )
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

extension TrainerHomeVC: deleteAgendaProtocol {
    func deleteAgendaResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            clearAgenda()
            todayBookingApiHit(date:selectedDate )
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

extension TrainerHomeVC: updateAgendaProtocol {
    func updateAgendaResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            clearAgenda()
            todayBookingApiHit(date:selectedDate )
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
}

extension TrainerHomeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repeatTextField.text = pickerArray[row]
        agendaType = String(row)
    }
}

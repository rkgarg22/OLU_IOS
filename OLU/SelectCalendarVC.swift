//
//  SelectCalendarVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 15/04/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import FSCalendar


class SelectCalendarVC: UIViewController ,FSCalendarDelegate,FSCalendarDataSource,agendaAlamofire {
    
    @IBOutlet var grayBackColor: UIImageView!
    @IBOutlet var groupTick: UILabel!
    @IBOutlet var countTick: UILabel!
    @IBOutlet var personTick: UILabel!
    @IBOutlet var timeBtn: UIButtonCustomClass!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var pickerDoneBtn: UIButtonCustomClass!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var activityView: UIView!
    @IBOutlet var countView: UIViewCustomClass!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var countLabel: UILabelCustomClass!
    @IBOutlet var confirmLabel: UILabelCustomClass!
    
    @IBOutlet var singleBtn: UIButtonCustomClass!
    @IBOutlet var companyBtn: UIButtonCustomClass!
    @IBOutlet var groupBtn: UIButtonCustomClass!
    
    var catId = Int()
    var listingDict = NSMutableDictionary()
    var groupSelectionString = String()
    var isFromAgenda = Bool()
    var dataDict = NSMutableDictionary()
    var resultDict = NSDictionary()
    var isFromTrainerList = false
    var trainerDetailDictFromTrainerListScreen = NSDictionary()
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFunc() {
        if isFromAgenda {
           // confirmLabel.text = "Confirmar"
        }
        listingDict["catId"] = catId
        self.calendar.locale = Locale(identifier: "es")
        countView.cornerRadius = countView.frame.height/2
        let currentDate = NSDate()
        let selectedDate = self.dateFormatter1.string(from: currentDate as Date)
        listingDict["selectedDate"] = selectedDate
    }
    
    
    //MARK: - Button
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func donedatePicker(_ sender: Any) {
        datePickerView.isHidden = true
        timePicker.isHidden = true
        pickerDoneBtn.isHidden = true
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        listingDict["selectedTime"] = dateFormatter.string(from:sender.date)
        print("listingDict",listingDict)
        timeBtn.setTitle(dateFormatter.string(from:sender.date), for: .normal)
        //        datePickerView.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countButton(_ sender: Any) {
    }
    
    @IBAction func confirmBtn(_ sender: AnyObject) {
        let currentDate = Date()
        let currentDateString = dateFormatter1.string(from: currentDate)
        let count = countLabel.text
        listingDict["count"] = count
        var timeTrainer = String()
        var dateTrainer = String()
        var groupSelectedTrainer = String()
        listingDict["groupCategory"] = groupSelectionString
        var timeDiff = Int()
        if  let selectedDate = listingDict.value(forKey: "selectedDate") as? String {
            dateTrainer = selectedDate
        }
        if let selectedTime = listingDict.value(forKey: "selectedTime") as? String {
            timeDiff = selectedTimeFifteenMinCheck()
            timeTrainer = selectedTime
        }
        if let groupSelected = listingDict.value(forKey: "groupCategory") as? String {
            groupSelectedTrainer = groupSelected
        }
        if dateTrainer == ""{
            showAlert(self, message: enterDate, title: appName)
        }
        else if timeTrainer == "" {
            showAlert(self, message: enterTime, title: appName)
        }
        else if groupSelectedTrainer == "" {
            showAlert(self, message: groupSelectedAlert, title: appName)
        }
        else if timeDiff <= 15 && dateTrainer == currentDateString{
            showAlert(self, message: fifteenMinCheckAlert, title: appName)
        }
        else{
            if isFromAgenda {
                hitAgendaApi()
            }
            else if (isFromTrainerList){
                let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVc") as! ChangeLocationVC
                myVC.listingDict = listingDict
                myVC.isComingFrom2hrCondition = true
                myVC.isFromTrainerList = true
                myVC.trainerDetailDict = trainerDetailDictFromTrainerListScreen
                navigationController?.pushViewController(myVC, animated: true)
                
            }else{
                goToTrainerList()
            }
        }
    }
    
    func hitAgendaApi() {
        let trainerID = dataDict.value(forKey: "trainerId") as! Int
        let catId = dataDict.value(forKey: "catId") as! Int
        let selectedDate = listingDict["selectedDate"]
        let time = listingDict["selectedTime"] as! String
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.agendaDelegate = self
            AlamofireWrapper.sharedInstance.agenda(trainerId: trainerID, categoryId: String(catId), date: selectedDate as! String, time: time)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getAgendaResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            
            let success = dictionaryContent.value(forKey: "success") as AnyObject
            if success.isEqual(1) {
                let resultString = dictionaryContent.value(forKey: "result") as! String
                if resultString == "True" {
                    agendaAlert()
                }
            }
            else {
                let errror = dictionaryContent.value(forKey: "error") as! String
                showAlert(self, message: errror, title: appName)
            }
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    
    func agendaAlert() {
        let alertController = UIAlertController(title:areYouSureReserver, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.moveToReserverScreen()
            
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func moveToReserverScreen() {
        listingDict["catId"] = dataDict.value(forKey: "catId") as! Int
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ReservationVc") as! ReservationVC
        myVC.trainerDetailDict = resultDict
        myVC.localSavedDict = listingDict
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func goToTrainerList() {
        let currenDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let currentDateString = formatter.string(from: currenDate)
        let currentDateObject = formatter.date(from: currentDateString)
        
        let selectedDate = listingDict.value(forKey: "selectedDate") as! String
        let selectedTime = listingDict.value(forKey: "selectedTime") as! String
        let selectedDateTime = selectedDate + " " + selectedTime
        let selectedDateObject = formatter.date(from: selectedDateTime)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.hour], from: currentDateObject!, to: selectedDateObject!)
        let diff = components.hour!
        
        if  diff < 2 {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "LocationVc") as! LocationVC
            myVC.listingDict = listingDict
            navigationController?.pushViewController(myVC, animated: true)
        }
        else{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ChangeLocationVc") as! ChangeLocationVC
            myVC.listingDict = listingDict
            myVC.isComingFrom2hrCondition = true
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
    func selectedTimeFifteenMinCheck()-> Int {
        let currenDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let currentDateString = formatter.string(from: currenDate)
        let currentDateObject = formatter.date(from: currentDateString)
        
        let selectedDate = listingDict.value(forKey: "selectedDate") as! String
        let selectedTime = listingDict.value(forKey: "selectedTime") as! String
        let selectedDateTime = selectedDate + " " + selectedTime
        let selectedDateObject = formatter.date(from: selectedDateTime)
        
        let cal = Calendar.current
        let components = cal.dateComponents([.minute], from: currentDateObject!, to: selectedDateObject!)
        let diff = components.minute
        print("selectedTimeFifteenMinCheck==",diff!)
        return diff!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = self.dateFormatter1.string(from: date)
        listingDict["selectedDate"] = selectedDate
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
//        let calendarDate = Date()
//        if(date < calendarDate){
//            return false
//        }
//        else if calendarDate == date {
//            return true
//        }
//        else{
//            return true
//        }
//    }
    
    @IBAction func cancelBtn(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func companyBtn(_ sender: UIButton) {
        companyBtn.isSelected = true
        singleBtn.isSelected = false
        countView.backgroundColor = UIColor.init(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
        groupSelectionString = "3"
        listingDict["groupCategory"] = groupSelectionString
    }
    
    @IBAction func minusBtn(_ sender: Any) {
        companyBtn.isSelected = false
        singleBtn.isSelected = false
        countView.backgroundColor = UIColor.init(red: 109/255, green: 110/255, blue: 112/255, alpha: 1)
        let countValue = countLabel.text
        var countToInt = Int(countValue!)  as! Int
        print("countToIntminus",countToInt)
        if countToInt != 2 {
            countToInt = countToInt - 1
            countLabel.text = String(countToInt)
        }
        if(countToInt == 2){
            groupSelectionString = "2";
        }else if(countToInt == 3){
            groupSelectionString = "4";
        }else if(countToInt==4){
            groupSelectionString = "5"
        }
    }
    @IBAction func plusBtn(_ sender: Any) {
        companyBtn.isSelected = false
        singleBtn.isSelected = false
        countView.backgroundColor = UIColor.init(red: 109/255, green: 110/255, blue: 112/255, alpha: 1)
        let countValue = countLabel.text
        var countToInt = Int(countValue!) as! Int
        print("countToIntPlus",countToInt)
        if countToInt != 4 {
            countToInt = countToInt + 1
            countLabel.text = String(countToInt)
        }
        if(countToInt == 2){
            groupSelectionString = "2";
        }else if(countToInt == 3){
            groupSelectionString = "4";
        }else if(countToInt==4){
            groupSelectionString = "5"
        }
    }
    
    @IBAction func OnePersonBtn(_ sender: UIButton) {
        countView.backgroundColor = UIColor.init(red: 216/255.0, green: 224/255.0, blue: 228/255.0, alpha: 1)
        companyBtn.isSelected = false
        singleBtn.isSelected = true
        groupSelectionString = "1"
    }
    
    @IBAction func groupBtn(_ sender: UIButton) {
        countView.backgroundColor = UIColor.init(red: 109/255.0, green: 110/255.0, blue: 112/255.0, alpha: 1)
        singleBtn.isSelected = false
        companyBtn.isSelected = false
        groupSelectionString = "2"
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        timeBtn.backgroundColor = UIColor(red: 109/255 , green: 110/255 , blue: 112/255 , alpha:1.0)
        datePickerView.isHidden = false
        timePicker.isHidden = false
        pickerDoneBtn.isHidden = false
        timePicker.datePickerMode = .time
        
        //let date = Date()
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.minuteInterval = 15
        //timePicker.minimumDate = date
        timePicker.addTarget(self, action: #selector( SelectCalendarVC.dateChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func editBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var cancelBtn: UIButtonCustomClass!
}


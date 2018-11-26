//
//  HistorialVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 05/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos

class RatingVC: UIViewController, RatingAlamofire, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var dateLabel: UILabelCustomClass!
    @IBOutlet var categoryLabel: UILabelCustomClass!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var monthLabel: UILabelCustomClass!
    @IBOutlet var weekdaylabel: UILabelCustomClass!
    @IBOutlet var catImage: UIImageView!
    
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabelCustomClass!
    @IBOutlet weak var ScrollView: UIScrollView!
    var bookingDict = NSDictionary()
    var nameString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingDict = UserDefaults.standard.value(forKey: "sessionStartBookingDict") as! NSDictionary
        startFunc()
        descriptionView.layer.cornerRadius = 10
        
        timeLabel.text = getTimeInformat(startTime: (bookingDict.value(forKey: "bookingStart") as? String)!)
        endTime.text = getTimeInformat(startTime: (bookingDict.value(forKey: "bookingEnd") as? String)!)
        
        // calculate date
        let dateString = bookingDict.value(forKey: "bookingDate") as! String
        print("dateString==",dateString)
        // date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let dateConverted = dateFormatter.date(from: dateString) //according to date format your date string
        
        monthLabel.text =  getMonthName(date: dateConverted!)
        weekdaylabel.text = getWeekdayName(date: dateConverted!)
        dateLabel.text = getDay(date: dateConverted!)
        setCat()
        
        let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String
        if userType == "trainer" {
            titleLabel.text = "¿Como calificarías a \(nameString) como usuario?"
            
        }
        else{
            titleLabel.text = "¿Cómo  calificarías  el servicio prestado por \(nameString)?"
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func getTimeInformat(startTime:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" //Your date format
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let timeConverter = dateFormatter.date(from: startTime)
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeConverter!)
        
    }
    
    
    // auto fill category type
    func setCat() {
        var catId : Int = 1;
        if(bookingDict.value(forKey: "categoryID") as? Int != nil){
            catId = bookingDict.value(forKey: "categoryID") as! Int
        }else{
            catId = Int(bookingDict.value(forKey: "categoryID") as! String)!
        }
        switch catId {
        case 1 :
            catImage.image = #imageLiteral(resourceName: "boxingIcon")
            categoryLabel.text = "Kickboxing"
            break;
        case 2 :
            catImage.image = #imageLiteral(resourceName: "watchIcon")
            categoryLabel.text = "Entrenamiento Funcional"
            break;
        case 3 :
            catImage.image = #imageLiteral(resourceName: "timerIcon")
            categoryLabel.text = "Stretching"
            break;
        case 4 :
            catImage.image = #imageLiteral(resourceName: "roleIcon")
            categoryLabel.text = "Yoga"
            break;
        case 5 :
            catImage.image = #imageLiteral(resourceName: "heartIcon")
            categoryLabel.text = "Pilates"
            break ;
        case 11 :
            catImage.image = #imageLiteral(resourceName: "shoesIcon")
            categoryLabel.text = "Dance Fit"
            break;
        case 10 :
            catImage.image = #imageLiteral(resourceName: "Gimnasia")
            categoryLabel.text = "Gimnasia Adulto Mayor"
            break;
        case 9 :
            catImage.image = #imageLiteral(resourceName: "theraphyIcon")
            categoryLabel.text = "Fisioterapia"
            break;
        case 8 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            categoryLabel.text = "Masajes Deportivos"
            break;
        case 12 :
            catImage.image = #imageLiteral(resourceName: "masajes")
            categoryLabel.text = "Masajes Deportivos"
            break;
        default:
            catImage.image = #imageLiteral(resourceName: "masajes")
            
        }
    }
    
    func startFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(TrainerRegisterVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: Any){
        if(rating.rating != 0){
            ratingAPI()
        }else{
            showAlert(self, message: enterRating, title: appName)
        }
    }
    
    func ratingAPI(){
        var bookingID : Int = 1;
        if(bookingDict.value(forKey: "bookingID") as? Int != nil){
            bookingID = bookingDict.value(forKey: "bookingID") as! Int
        }else{
            bookingID = Int(bookingDict.value(forKey: "bookingID") as! String)!
        }
        
        let ratingParameter: [String : Any]  =
            [
                "userID": getUserID(),
                "bookingID": bookingID,
                "rating": rating.rating,
                "comment": descriptionView.text!,
                ]
        
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.ratingAlamofire = self
            AlamofireWrapper.sharedInstance.giveRating(ratingParameter)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    // server error
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    func getResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String
            if userType == "trainer" {
                openAlert(message: ratingMessage)
            }else{
                openAlert(message: ratingMessageFromUserSide)
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func openAlert(message: String) {
        let alertController = UIAlertController(title:message, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            UserDefaults.standard.set(nil, forKey: "sessionStartBookingDict")
            let userType = UserDefaults.standard.value(forKey: USER_DEFAULT_USERTYPE) as? String
            if userType == "trainer" {
                if let vc = self.navigationController?.viewControllers.filter({ $0 is SWRevealViewController }).first {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }else{
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVc") as! MenuVC
                self.navigationController?.pushViewController(myVC, animated: true)
            }
        }
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Keyboard notifications methods
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(SignUpVC.doneButtonTapped(_:)))
        doneButton.tintColor = UIColor.white
        let items:Array = [doneButton]
        toolbar.items = items
        
        return true
    }
    
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        descriptionLabel.isHidden = true
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.darkGray
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(TrainerRegisterVC.doneButton(_:)))
        doneButton.tintColor = UIColor.white
        let items:Array = [doneButton]
        toolbar.items = items
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    @objc func doneButton(_ sender: AnyObject) {
        if(descriptionView.text == ""){
            descriptionLabel.isHidden = false
        }else{
            descriptionLabel.isHidden = true
        }
        descriptionView.resignFirstResponder()
    }
    
}

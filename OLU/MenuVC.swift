//
//  MenuVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 25/03/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit


class MenuVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,getMyProfileAlamofire ,UIImagePickerControllerDelegate , UINavigationControllerDelegate ,editProfileAlamofire  ,addPromoCodeAlamofire{
    
    
    @IBOutlet var walletMoney: UILabelCustomClass!
    @IBOutlet var catNameThree: UILabelCustomClass!
    @IBOutlet var catNameTwo: UILabelCustomClass!
    @IBOutlet var firstName: UILabelCustomClass!
    @IBOutlet var secondName: UILabelCustomClass!
    @IBOutlet var imageurl: UIImageView!
    @IBOutlet var catNameOne: UILabelCustomClass!
    @IBOutlet var catFirst: UIImageView!
    @IBOutlet var catSecond: UIImageView!
    @IBOutlet var catThree: UIImageView!
    @IBOutlet var tableHeight: NSLayoutConstraint!
    @IBOutlet var menuTable: UITableView!
    @IBOutlet var promoCodeText: UITextField!
    
    let picker = UIImagePickerController()
    var chosenImage : UIImage?
    var menuDict = NSDictionary()
    var imageArray = NSArray()
    var isUpdated = Bool()
    var nibContentsUser = Bundle.main.loadNibNamed("promoCodePopUp", owner: self, options: nil)
    var promoCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        startFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- FUNCTIONS
    //StartFunc
    func startFunc(){
        getMyProfileApiHit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let firstNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_FIRSTNAME_Key) as? String ?? ""
        let lastNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_SECONDNAME_Key) as? String ?? ""
        
        firstName.text = firstNameString
        secondName.text = lastNameString
    }
    
    func getMyProfileApiHit() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getMyProfileDelegate = self
            AlamofireWrapper.sharedInstance.getMyProfileLsit()
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func updateImage(){
        
        let firstNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_FIRSTNAME_Key) as? String ?? ""
        let lastNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_SECONDNAME_Key) as? String ?? ""
        let dob = UserDefaults.standard.value(forKey: USER_DEFAULT_DOB_Key) as? String ?? ""
        let genderString = UserDefaults.standard.value(forKey: USER_DEFAULT_GENDER_Key) as? String ?? ""
        let phoneNumber = UserDefaults.standard.value(forKey: USER_DEFAULT_PHONE_Key) as? String ?? ""
        
        let editProfileParameters: [String : Any]  =
            [
                "userID":getUserID(),
                "firstName":firstNameString ,
                "lastName":lastNameString ,
                "dob":dob ,
                "gender":genderString,
                "phone":phoneNumber
        ]
        // no internet check condition
        
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.editProfileDelegate = self
            if chosenImage?.imageAsset != nil{
                let data = (UIImageJPEGRepresentation(chosenImage!, 1.0) as Data?)!
                AlamofireWrapper.sharedInstance.editUserProfile(editProfileParameters , imageData: data as Data)
            }
            else{
                AlamofireWrapper.sharedInstance.editUserProfile(editProfileParameters , imageData: nil)
            }
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func editProfileResults(dictionaryContent: NSDictionary) {
        print("response==",dictionaryContent)
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let imageUrl = dictionaryContent.value(forKey: "result") as! String
            UserDefaults.standard.set(imageUrl, forKey: USER_DEFAULT_ImageUrl_Key)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    
    func getMyprofileResults(dictionaryContent: NSDictionary) {
        //MARK: - API Reponse
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            let imageUrlString = resultDict.value(forKey: "image") as! String
            if imageUrlString != ""{
                imageurl.sd_setImage(with: URL(string: imageUrlString ), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
            }
            firstName.text = resultDict.value(forKey: "firstName") as? String
            secondName.text = resultDict.value(forKey: "lastName") as? String
            let wallet = resultDict.value(forKey: "wallet") as! Int
            walletMoney.text = String(wallet) + ".000"
            let catArray = resultDict.value(forKey: "categories") as! NSArray
            if catArray.count != 0 {
                let dictOne = catArray[0] as! NSDictionary
                let catId1 = dictOne.value(forKey: "categoryID") as? Int
                catFirst.image = catImage(catID: catId1!)
                catNameOne.text = dictOne.value(forKey: "name") as? String
                if catArray.count > 1 {
                    let dictOne = catArray[0] as! NSDictionary
                    let catId1 = dictOne.value(forKey: "categoryID") as! Int
                    catFirst.image = catImage(catID: catId1)
                    catNameOne.text = dictOne.value(forKey: "name") as? String
                    
                    let dictTwo = catArray[1] as! NSDictionary
                    let catId2 = dictTwo.value(forKey: "categoryID") as! Int
                    catSecond.image = catImage(catID: catId2)
                    catNameTwo.text = dictTwo.value(forKey: "name") as? String
                }
                if  catArray.count > 2 {
                    let catId1 = dictOne.value(forKey: "categoryID") as! Int
                    catFirst.image = catImage(catID: catId1)
                    catNameOne.text = dictOne.value(forKey: "name") as? String
                    
                    let dictTwo = catArray[1] as! NSDictionary
                    let catId2 = dictTwo.value(forKey: "categoryID") as! Int
                    catSecond.image = catImage(catID: catId2)
                    catNameTwo.text = dictTwo.value(forKey: "name") as? String
                    
                    let dictThree = catArray[2] as! NSDictionary
                    let catId3 = dictThree.value(forKey: "categoryID") as! Int
                    catThree.image = catImage(catID: catId3)
                    catNameThree.text = dictThree.value(forKey: "name") as? String
                }
            }
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func catImage(catID:Int) -> UIImage{
        var imageCat = UIImage()
        switch catID {
        case 1:
            imageCat = #imageLiteral(resourceName: "boxingIcon")
        case 2 :
            imageCat = #imageLiteral(resourceName: "watchIcon")
        case 3:
            imageCat = #imageLiteral(resourceName: "timerIcon")
        case 4:
            imageCat = #imageLiteral(resourceName: "roleIcon")
        case 5:
            imageCat = #imageLiteral(resourceName: "heartIcon")
        case 11 :
            imageCat = #imageLiteral(resourceName: "shoesIcon")
        case 10 :
            imageCat = #imageLiteral(resourceName: "Gimnasia")
        case 9:
            imageCat = #imageLiteral(resourceName: "theraphyIcon")
        case 8 :
            imageCat = #imageLiteral(resourceName: "masajes")
        default:
            print("Default Case")
        }
        return imageCat
    }
    
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @IBAction func uploadProfile(_ sender: Any) {
        
    }
    //MARK:- ImagePickerFromCamera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title:appName, message: noCamera, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK" , style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: -ImgePickerFromGallery
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        isUpdated = true
        chosenImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        chosenImage = resizeImage(image: chosenImage!, targetSize:CGSize(width: 200.0, height: 200.0))
        imageurl.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    //MARK:- ImagepickerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UIButton
    //menu password
    @IBAction func editProfile(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVc") as! EditProfileVC
        if(chosenImage != nil){
            myVC.image = chosenImage!
        }
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    @IBAction func menuBtn(_ sender: UIButtonCustomClass){
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func sesinesBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PendingVc") as! PendingVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func pagoBtn(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "MyPayementVc") as! MyPayementVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func VerBtn(_ sender: Any) {
        showPromoCodePopUp()
    }
    
    //back password
    @IBAction func backBtn(_ sender: UIButtonCustomClass){
        if isUpdated {
            let alert = UIAlertController(title:imageUpload, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"Si", style: .default, handler: { _ in
                self.updateImage()
            }))
            
            alert.addAction(UIAlertAction(title:"No", style: .default, handler: { _ in
                if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }))
            
            alert.addAction(UIAlertAction.init(title:"Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let imageArr = menuDict.value(forKey: "imageArray") as! NSArray
        let titleArr =  menuDict.value(forKey: "nameArray") as! NSArray
        cell.iconImage.image = imageArr[indexPath.row] as?UIImage
        cell.titleLabel.text = titleArr[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let indexPath = indexPath.row
        switch (indexPath){
        case 0:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriesVc") as! categoriesVC
            myVC.isOpenFirstCat = true
            navigationController?.pushViewController(myVC, animated: true)
        case 1:
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "SelectCalendarVc") as! SelectCalendarVC
            navigationController? .pushViewController(Object, animated: true)
        case 2:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ComparePlanVc") as! ComparePlanVC
            navigationController?.pushViewController(myVC, animated: true)
        case 3:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "HistorialVc") as! HistorialVC
            navigationController?.pushViewController(myVC, animated: true)
        case 4:
            let myVC = storyboard?.instantiateViewController(withIdentifier: "MyPayementVc") as! MyPayementVC
            navigationController?.pushViewController(myVC, animated: true)
        case 5:
            print("")
            let Object = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVc") as! SettingsVC
            navigationController? .pushViewController(Object, animated: true)
        case 6:
            print("")
        default:
            print("Home Button clicked")
        }
    }
    
    @IBAction func updateProfileBtn(_ sender: Any) {
        let alert = UIAlertController(title:ChooseImageString, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:Camera, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title:Gallery, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title:"Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPromoCodePopUp(){
        let nibMainview = nibContentsUser![0] as! UIView
        let okBtn = (nibMainview.viewWithTag(3)! as! UIButton)
        let crossBtn = (nibMainview.viewWithTag(15)! as! UIButton)
//        let promoText = (nibMainview.viewWithTag(20)! as! UITextField)
        okBtn.addTarget(self, action: #selector(okBtnAction), for: UIControlEvents.touchUpInside)
//        promoCode = promoText.text!
        crossBtn.addTarget(self, action: #selector(crossBtnAction), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(nibMainview)
        
        nibMainview.frame.size = CGSize(width: (self.view.frame.width), height: (self.view.frame.height))
        nibMainview.center = (self.view.center)
    }
    
    @objc func okBtnAction(sender:UIButton) {
        let nibMainview = nibContentsUser![0] as! UIView
        let promoCodeString = (nibMainview.viewWithTag(20)! as! UITextField)
        promoCode = promoCodeString.text!
        if promoCode == "" {
            showAlert(self, message: enterPromoCode, title: appName)
        }
        else{
            // no internet check condition
            if applicationDelegate.isConnectedToNetwork {
                applicationDelegate.startProgressView(view: self.view)
                AlamofireWrapper.sharedInstance.addPromoCodeDelegate = self
                AlamofireWrapper.sharedInstance.addPromoCode(promoCode: promoCode)
            }
            else{
                showAlert(self, message: noInternetConnection, title: appName)
            }
       }
            }
    
    func addPromoCodeResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let nibMainview = nibContentsUser![0] as! UIView
            nibMainview.removeFromSuperview()
        }
        else {
             let error = dictionaryContent.value(forKey: "error") as! String
            let alertController = UIAlertController(title:error, message: "", preferredStyle: .alert)
            // Create the actions
            let YesAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let nibMainview = self.nibContentsUser![0] as! UIView
                nibMainview.removeFromSuperview()
                
            }
            let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            
            alertController.addAction(YesAction)
            alertController.addAction(NoAction)
            self.present(alertController, animated: true, completion: nil)

            showAlert(self, message: error, title: appName)
        }
    }

    @objc func crossBtnAction(sender:UIButton) {
        let nibMainview = nibContentsUser![0] as! UIView
        nibMainview.removeFromSuperview()
    }
    
}

//
//  ProfileVC.swift
//  OLU
//
//  Created by DIKSHA on 19/08/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Cosmos

class ProfileVC: UIViewController  ,UIImagePickerControllerDelegate , UINavigationControllerDelegate ,profileAlamofire, imageUpdateChangeAlamofire{
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    var isUpdated = Bool()
    var profileDict = NSDictionary()
    
    let picker = UIImagePickerController()
    var chosenImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyProfileApiHit()
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMyProfileApiHit() {
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.profileDelegate = self
            AlamofireWrapper.sharedInstance.getProfileTrainer()
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func profileResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            profileDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            let firstName = profileDict.value(forKey: "firstName") as? String ?? ""
            let lastName = profileDict.value(forKey: "lastName") as? String ?? ""
            nameLabel.text = "\(firstName) \(lastName)"
            phoneNumber.text = profileDict.value(forKey: "phone") as? String ?? ""
            email.text = profileDict.value(forKey: "emailAddress") as? String ?? ""
            rating.rating = Double(profileDict.value(forKey: "reviews") as! Int)
            if let iconImageString = profileDict.value(forKey: "userImageUrl"){
                if iconImageString as! String != ""{
                    profilePic.sd_setImage(with: URL(string: iconImageString as! String), placeholderImage:#imageLiteral(resourceName: "UserDummyPic"))
                }
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            applicationDelegate.dismissProgressView(view: self.view)
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError(){
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @IBAction func editProfileBtn(_ sender: UIButtonCustomClass) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerEditProfileVC") as! TrainerEditProfile
        myVC.profileDict = profileDict
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        if isUpdated {
            let alert = UIAlertController(title:imageUpload, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"Si", style: .default, handler: { _ in
                self.updateProfileApiHit()
            }))
            
            alert.addAction(UIAlertAction(title:"No", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            alert.addAction(UIAlertAction.init(title:"Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func updateProfileApiHit(){
        //        let firstNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_FIRSTNAME_Key) as? String ?? ""
        //        let lastNameString = UserDefaults.standard.value(forKey: USER_DEFAULT_SECONDNAME_Key) as? String ?? ""
        //        let dob = UserDefaults.standard.value(forKey: USER_DEFAULT_DOB_Key) as? String ?? ""
        //        let genderString = UserDefaults.standard.value(forKey: USER_DEFAULT_GENDER_Key) as? String ?? ""
        //
        //        let email = UserDefaults.standard.value(forKey: USER_DEFAULT_EMAIL_Key) as? String ?? ""
        //        let phoneNumber = UserDefaults.standard.value(forKey: USER_DEFAULT_PHONE_Key) as? String ?? ""
        //        let description = UserDefaults.standard.value(forKey: USER_DEFAULT_DESCRIPTION_Key) as? String ?? ""
        //
        //        let formArray = UserDefaults.standard.value(forKey: USER_DEFAULT_CATEGORY_Key) as! NSMutableArray
        //        let jsonString = json(from: formArray)
        
        let updateParameter: [String : Any]  =
            [
                "userID":getUserID()
        ]
        
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.imageUpdateChangeDelegate = self
            if chosenImage?.imageAsset != nil{
                let imageData = (UIImagePNGRepresentation(chosenImage!) as Data?)!
                AlamofireWrapper.sharedInstance.updateImage(updateParameter , imageData: imageData as Data)
            }
        }
        else {
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func imageUpdateChangeResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            // let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            //let imageUrl = resultDict.value(forKey:"userImageUrl") as! String
            //UserDefaults.standard.set(imageUrl, forKey: USER_DEFAULT_ImageUrl_Key)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            applicationDelegate.dismissProgressView(view: self.view)
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    
    //upload profile pic Button
    @IBAction func uploadProfileImage(_ sender: UIButtonCustomClass) {
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
    
    //ver Button
    @IBAction func locationVerBtn(_ sender: UIButtonCustomClass) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PendingVc") as! PendingVC
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //ver Button
    @IBAction func pagosVerBtn(_ sender: UIButtonCustomClass) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PayementHistoryVc") as! PayementHistoryVC
        navigationController?.pushViewController(myVC, animated: true)
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
        profilePic.image = chosenImage
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
}

//
//  OptionsVC.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 01/07/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit

class OptionsVC: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet var profilePicImage: UIImageView!
    @IBOutlet weak var profilePic: UIButton!
    var chosenImage = UIImage()
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //profile button
    @IBAction func editProfileBtn(_ sender: UIButtonCustomClass) {
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
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    //profile button
    @IBAction func enterBtn(_ sender: UIButtonCustomClass) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerRegisterVc") as! TrainerRegisterVC
        myVC.profilePic = chosenImage
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    //profile button
    @IBAction func forumButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TrainerRegisterVc") as! TrainerRegisterVC
        myVC.profilePic = chosenImage
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
        chosenImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        chosenImage = resizeImage(image: chosenImage, targetSize:CGSize(width: 200.0, height: 200.0))
        profilePicImage.image = chosenImage
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

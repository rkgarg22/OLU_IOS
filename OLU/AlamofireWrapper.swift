//
//  AlmofireWrapper.swift
//  OLU
//
//  Created by DIKSHA SHARMA on 05/05/18.
//  Copyright © 2018 DIKSHA SHARMA. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- Protocol
protocol LogInServiceAlamoFire:class {
    func logInResults(dictionaryContent: NSDictionary)
    func serverError()
    
}
protocol SignUpServiceAlamoFire:class{
    func SignUpResults(dictionaryContent: NSDictionary)
    func serverError()
    
}

protocol RegistrationServiceAlamoFire:class{
    func RegistrationResults(dictionaryContent: NSDictionary)
    func serverError()
    
}

protocol logoutAlamoFire:class{
    func logoutResults(dictionaryContent: NSDictionary)
    func serverError()
    
}

protocol listingAlamoFire:class{
    func listingResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol trainerProfileAlamoFire:class{
    func trainerProfileResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol bookingAlamoFire:class{
    func bookingResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol isAvailableAlamofire:class{
    func isAvailableResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol todayBookingAlamofire:class{
    func todayBookingResults(dictionaryContent: NSDictionary)
    func serverError()
}
protocol PendingAlamofire:class{
    func getPendingResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol getMyProfileAlamofire:class{
    func getMyprofileResults(dictionaryContent: NSDictionary)
    func serverError()
}
protocol editProfileAlamofire:class{
    func editProfileResults(dictionaryContent: NSDictionary)
    func serverError()
}
protocol confirmBookingAlamofire:class{
    func confirmBookingResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol messageAlamofire:class{
    func getMessageResults(dictionaryContent: NSDictionary)
    func sendMessageResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol agendaAlamofire:class{
    func getAgendaResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol getTextPagesAlamofire:class{
    func getTextPagesResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol ProcessUrlAlamofire:class{
    func getProcessUrlResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol paymentInitiateAlamofire:class{
    func paymentInitiateResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol paymentCollectAlamofire:class{
    func paymentCollectResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol profileAlamofire:class{
    func profileResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol paymentHistoryAlamofire:class{
    func paymentHistoryResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol paymentHistoryForUserAlamofire:class{
    func paymentHistoryResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol ForgotPasswordAlamofire:class{
    func getResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol RatingAlamofire:class{
    func getResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol bookingStatusChangeAlamofire:class{
    func bookingStatusChangeResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol imageUpdateChangeAlamofire:class{
    func imageUpdateChangeResults(dictionaryContent: NSDictionary)
    func serverError()
}

protocol DeleteCardAlamofire:class{
    func getDeleteCardResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol updateLocationAlamofire:class{
    //    func updateLocationResults(dictionaryContent: NSDictionary)
    //    func serverError()
}

protocol addPromoCodeAlamofire:class{
    func addPromoCodeResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol checkWalletProtocol:class{
    func checkWalletResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol createAgendaProtocol:class{
    func createAgendaResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol updateAgendaProtocol:class{
    func updateAgendaResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol deleteAgendaProtocol:class{
    func deleteAgendaResult(dictionaryContent: NSDictionary)
    func serverError()
}

protocol onGoingAgendaProtocol:class{
    func onGoingData(dictionaryContent: NSDictionary)
    func serverError()
}

protocol MarkCardSelectedProtocol:class{
    func getMarkSelectedCardData(dictionaryContent: NSDictionary)
    func serverError()
}

protocol CardListProtocol:class{
    func getCardListData(dictionaryContent: NSDictionary)
    func serverError()
}

protocol ChangePasswordProtocol:class{
    func getData(dictionaryContent: NSDictionary)
    func serverError()
}

protocol SessionUpdateProtocol:class{
    func getData(dictionaryContent: NSDictionary)
    func serverError()
}

class AlamofireWrapper: NSObject {
    
    class var sharedInstance: AlamofireWrapper{
        struct Singleton{
            static let instance = AlamofireWrapper()
        }
        return Singleton.instance
    }
    //MARK: - Delegate
    var logInDelegate:  LogInServiceAlamoFire?
    var signUpDelegate: SignUpServiceAlamoFire?
    var registrationDelegate: RegistrationServiceAlamoFire?
    var logoutDelegate: logoutAlamoFire?
    var listingDelegate: listingAlamoFire?
    var trainerProfileDelegate: trainerProfileAlamoFire?
    var bookingDelegate: bookingAlamoFire?
    var isAvailableDelegate:  isAvailableAlamofire?
    var todayBookingDelegate:  todayBookingAlamofire?
    var getPendingDelegate:  PendingAlamofire?
    var getMyProfileDelegate:  getMyProfileAlamofire?
    var editProfileDelegate:  editProfileAlamofire?
    var confirmBookingDelegate:  confirmBookingAlamofire?
    var getMessageDelegate:  messageAlamofire?
    var sendMessageDelegate:  messageAlamofire?
    var agendaDelegate:  agendaAlamofire?
    var getTextDelegate:  getTextPagesAlamofire?
    var paymentInitiateDelegate:  paymentInitiateAlamofire?
    var profileDelegate:  profileAlamofire?
    var paymentHistoryDelegate:  paymentHistoryAlamofire?
    var paymentHistoryForUserDelegate:  paymentHistoryForUserAlamofire?
    var getPaymentCollectionDelegate: paymentCollectAlamofire?
    var bookingStatusChangeDelegate: bookingStatusChangeAlamofire?
    var imageUpdateChangeDelegate: imageUpdateChangeAlamofire?
    var updateLocationDelegate: updateLocationAlamofire?
    var forgotPasswordAlamofire: ForgotPasswordAlamofire?
    var ratingAlamofire: RatingAlamofire?
    var processAlamofire : ProcessUrlAlamofire?
    var deleteCardAlamofire : DeleteCardAlamofire?
    var addPromoCodeDelegate : addPromoCodeAlamofire?
    let alomafire =  Alamofire.SessionManager.default
    var checkWalletDelegate: checkWalletProtocol?
    var createAgendaDelegate: createAgendaProtocol?
    var deleteAgendaDelegate: deleteAgendaProtocol?
    var updateAgendaDelegate: updateAgendaProtocol?
    var onGoingAgendaDelegate: onGoingAgendaProtocol?
    var markSelectedCardDelegate: MarkCardSelectedProtocol?
    var getCardListDelegate: CardListProtocol?
    var changePasswordDalegate: ChangePasswordProtocol?
    var sessionUpdateProtocol: SessionUpdateProtocol?
    //MARK:- SignUpFunction
    func resgistration(_ parameters:[String : Any]) {
        print(parameters)
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request(baseUrl + "users/registration/index.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.registrationDelegate?.RegistrationResults(dictionaryContent:dataDict)
                }
                break
            case .failure(_):
                self.registrationDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- CreateChildProfileFunction
    func SignUp(_ parameters:[String : Any] ,imageData: Data?) {
        print("parameters",parameters)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "imageUrl", fileName: "imageUrl.jpeg", mimeType: "imageUrl/png")
            }
            
        }, to: baseUrl+"users/trainerSignup/index.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    print(response.result)
                    if let JSON = response.result.value {
                        let dataDict: NSDictionary = JSON as! NSDictionary
                        self.signUpDelegate?.SignUpResults(dictionaryContent: dataDict)
                    }
                }
                
            case .failure( _):
                self.signUpDelegate?.serverError()
            }
        }
    }
    
    
    
    //MARK:- SignUpFunction
    func logIn(_ parameters:[String : Any]) {
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let urlString = baseUrl + "users/login/index.php"
        print("urlString",urlString)
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.logInDelegate?.logInResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.logInDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func addPromoCode(promoCode:String) {
        
        let originalUrl = baseUrl+"promoCode/?userID=\(getUserID())&promoCode=\(promoCode)"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.addPromoCodeDelegate?.addPromoCodeResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.addPromoCodeDelegate?.serverError()
                } else {
                    self.addPromoCodeDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    
    func logInGET() {
        let originalUrl = baseUrl+"users/login/userindex.php?emailAddress=final@user.com&password=12345&firebaseTokenId=&deviceType=iOS"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.paymentInitiateDelegate?.paymentInitiateResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.paymentInitiateDelegate?.serverError()
                } else {
                    self.paymentInitiateDelegate?.serverError()
                }
                
                break
            }
        }
    }
    
    //        //MARK:- logout
    func logOut() {
        let originalUrl = baseUrl+"users/logout/index.php/?userID=\(getUserID())"
        print("originalUrl==",originalUrl)
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.logoutDelegate?.logoutResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.logoutDelegate?.serverError()
                } else {
                    self.logInDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func listing(searchText:String ,category :Int ,date:String ,time : String ,language:String ,gender:String,rating:Double ,latitude:String ,longitude : String ,selectGroup:String) {
        var stringCat = String()
        if  category == 0 {
            stringCat = ""
        }
        else
        {
            stringCat = String(category)
        }
        
        let  Url = baseUrl + "userListing/?userID=\(getUserID())&searchText=\(searchText)&latitude=\(latitude)&longitude=\(longitude)&category=\(stringCat)&offSet=1&date=\(date)&time=\(time)&language=en&gender=\(gender)&rating=&selectGroup=\(selectGroup)"
        
        //
        let urlString :String = Url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("urlString",urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.listingDelegate?.listingResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.listingDelegate?.serverError()
                } else {
                    self.listingDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func trainerProfile(trainerUserID:Int ,categoryID:Int) {
        let originalUrl = baseUrl+"userDetails/?userID=\(getUserID())&trainerUserID=\(trainerUserID)&language=en&category=\(categoryID)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.trainerProfileDelegate?.trainerProfileResults(dictionaryContent: dataDict)                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.trainerProfileDelegate?.serverError()
                } else {
                    self.trainerProfileDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func booking(trainerUserID:Int ,catId:Int ,bookingdate:String ,bookingTime:String,priceGroup
        :String ,lat:String ,long:String ,address:String) {
        let originalUrl = baseUrl+"booking/?userID=\(getUserID())&bookinguserID=\(trainerUserID)&categoryID=\(catId)&bookingDate=\(bookingdate)&bookingTime=\(bookingTime)&bookingType=\(priceGroup)&latitude=\(lat)&longitude=\(long)&address=\(address)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.bookingDelegate?.bookingResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.bookingDelegate?.serverError()
                } else {
                    self.bookingDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func isAvailable(isAvailbale:String) {
        let originalUrl = baseUrl+"users/isAvailable/?userID=\(getUserID())&isAvailable=\(isAvailbale)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.isAvailableDelegate?.isAvailableResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.isAvailableDelegate?.serverError()
                } else {
                    self.isAvailableDelegate?.serverError()
                }
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func bookingToday(date:String) {
        let originalUrl = baseUrl+"todayBooking/?userID=\(getUserID())&language=es&date=\(date)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.todayBookingDelegate?.todayBookingResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.todayBookingDelegate?.serverError()
                } else {
                    self.todayBookingDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func getPendingLsit(status:String) {
        
        let originalUrl = baseUrl+"bookingHistory/?userID=\(getUserID())&status=\(status)&lang=en"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getPendingDelegate?.getPendingResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.isAvailableDelegate?.serverError()
                } else {
                    self.isAvailableDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- trainerListing
    func getMyProfileLsit() {
        let originalUrl = baseUrl+"users/myProfile/?userID=\(getUserID())&language=es"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getMyProfileDelegate?.getMyprofileResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.getMyProfileDelegate?.serverError()
                } else {
                    self.getMyProfileDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- SignUpFunction  trainer
    func editUserProfile(_ parameters:[String : Any],imageData: Data?) {
        print(parameters)
        //MARK: Update User Profile Function
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-type": "multipart/form-data"
        ]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "imageUrl", fileName: "imageUrl.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: baseUrl+"users/userUpdateProfile/", method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { DataResponse in
                    print(DataResponse.result.value!)
                    if let JSON = DataResponse.result.value {
                        let dataDict: NSDictionary = JSON as! NSDictionary
                        self.editProfileDelegate?.editProfileResults(dictionaryContent: dataDict)
                    }
                }
            case .failure( _):
                self.editProfileDelegate?.serverError()
            }
        }
    }
    
    //MARK:- trainerListing
    func confirmBooking(bookingID :String ,status:String, isPaymentRequire: String) {
        let originalUrl = baseUrl+"bookingConfirm/?userID=\(getUserID())&bookingID=\(bookingID)&state=\(status)&isPaymentRequire=\(isPaymentRequire)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.confirmBookingDelegate?.confirmBookingResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.confirmBookingDelegate?.serverError()
                } else {
                    self.confirmBookingDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func bookingStatusChange(bookingID :String ,state:String) {
        let originalUrl = baseUrl+"bookingStateChange/?userID=\(getUserID())&bookingID=\(bookingID)&state=\(state)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.bookingStatusChangeDelegate?.bookingStatusChangeResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    self.bookingStatusChangeDelegate?.serverError()
                } else {
                    self.bookingStatusChangeDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func getMessageLsit(toUserId:String) {
        let originalUrl = baseUrl+"messages/list/index.php/?userID=\(getUserID())&userIDTo=\(toUserId)"
        print("url=",originalUrl)
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getMessageDelegate?.getMessageResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    print("noIntenetError=",err)
                    self.getMyProfileDelegate?.serverError()
                } else {
                    self.getMyProfileDelegate?.serverError()
                }
                
                print("error",response.result.error!)
                break
            }
        }
    }
    //MARK:- SignUpFunction
    func sendMessage(_ parameters:[String : Any]) {
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        print(parameters)
        Alamofire.request(baseUrl + "messages/send/index.php", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.sendMessageDelegate?.sendMessageResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.sendMessageDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    //MARK:- UpdateDeviceToken
    func updateDeviceToken(firebaseTokenID:String) {
        let originalUrl = baseUrl+"users/UpdateDeviceToken/?userID=\(getUserID())&firebaseTokenId=\(firebaseTokenID)&lang=es"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    UserDefaults.standard.set(String(describing:firebaseTokenID), forKey: USER_DEFAULT_DEVICETOKEN)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    
                } else {
                    self.agendaDelegate?.serverError()
                    print("error",response.result.error!)
                }
                
                break
            }
        }
    }
    
    //MARK:- agenda api
    func agenda(trainerId:Int ,categoryId:String ,date:String,time:String) {
        let originalUrl = baseUrl+"users/trainerAvailable?userID=\(getUserID())&trainerUserID=\(trainerId)&categoryId=\(categoryId)&date=\(date)&time=\(time)"
        
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.agendaDelegate?.getAgendaResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    
                } else {
                    
                }
                
                break
            }
        }
    }
    
    
    //MARK:- Text Pages
    func getTextPages(pageID:Int) {
        let originalUrl = baseUrl+"pages/?userID=\(getUserID())&pageID=\(pageID)&language=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getTextDelegate?.getTextPagesResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    
                } else {
                    
                }
                
                break
            }
        }
    }
    
    //MARK:- Text Pages
    func getPayementInitiate() {
        let originalUrl = baseUrl+"payment/initiate/?userID=\(getUserID())"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.paymentInitiateDelegate?.paymentInitiateResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.paymentInitiateDelegate?.serverError()
                } else {
                    self.paymentInitiateDelegate?.serverError()
                }
                
                break
            }
        }
    }
    
    
    //MARK:- Text Pages
    func getPayementCollect(planID:String ,token :String) {
        let originalUrl = baseUrl+"payment/collect/?userID=\(getUserID())&token=\(token)&planID=\(planID)&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getPaymentCollectionDelegate?.paymentCollectResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.getPaymentCollectionDelegate?.serverError()
                } else {
                    self.getPaymentCollectionDelegate?.serverError()
                }
                
                break
            }
        }
    }
    //    http://ec2-13-58-57-186.us-east-2.compute.amazonaws.com/api/payment/collect/?userID=70&token=623acda6eabcbbe9833d91c3b9a4f6f767e1b73eaeb05d39811b61540b10febd&lang=es
    
    
    //MARK:- Text Pages
    func getProfileTrainer() {
        let originalUrl = baseUrl+"users/trainerProfile/?userID=\(getUserID())&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.profileDelegate?.profileResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.profileDelegate?.serverError()
                } else {
                    self.profileDelegate?.serverError()
                }
                
                break
            }
        }
    }
    
    
    //MARK:- Text Pages
    func getPaymentHistoryTrainer(desc:String , isPAid:String) {
        let originalUrl = baseUrl+"payment/paymentHistory/?userID=\(getUserID())&order=DESC&isPaid=\(isPAid)&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.paymentHistoryDelegate?.paymentHistoryResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.paymentHistoryDelegate?.serverError()
                } else {
                    self.paymentHistoryDelegate?.serverError()
                }
                
                break
            }
        }
    }
    
    
    func getPaymentHistoryForUser() {
        let originalUrl = baseUrl+"payment/paymentHistoryUser/?userID=\(getUserID())&order=DESC&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.paymentHistoryForUserDelegate?.paymentHistoryResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.paymentHistoryForUserDelegate?.serverError()
                } else {
                    self.paymentHistoryForUserDelegate?.serverError()
                }
                
                break
            }
        }
    }
    
    func forgotPassword(email: String) {
        let originalUrl = baseUrl+"users/forgotPassword/?emailAddress=\(email)"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.forgotPasswordAlamofire?.getResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    self.forgotPasswordAlamofire?.serverError()
                } else {
                    self.forgotPasswordAlamofire?.serverError()
                }
                break
            }
        }
    }
    
    
    // Rating API
    
    func giveRating(_ parameters:[String : Any]) {
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let urlString = baseUrl + "trainingComplete/index.php"
        print("urlString",urlString)
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.ratingAlamofire?.getResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.ratingAlamofire?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    
    //MARK:- CreateChildProfileFunction
    func updateImage(_ parameters:[String : Any] ,imageData: Data?) {
        print("parameters",parameters)
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-type": "multipart/form-data"
        ]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "imageUrl", fileName: "imageUrl.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: baseUrl+"users/updateUserImage/",method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    print(response.result)
                    if let JSON = response.result.value {
                        let dataDict: NSDictionary = JSON as! NSDictionary
                        self.imageUpdateChangeDelegate?.imageUpdateChangeResults(dictionaryContent: dataDict)
                    }
                }
                
            case .failure( _):
                self.imageUpdateChangeDelegate?.serverError()
            }
        }
    }
    
    //MARK:- update Location
    func updateLocation(lat:Double ,long:Double) {
        let originalUrl = baseUrl+"users/updateUserLocation/?userID=\(getUserID())&latitude=\(lat)&longitude=\(long )"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    
                    break
                }
            }
        }
    }
    
    //Update Trainer Profile
    func updateTrainerProfile(_ parameters:[String : Any],imageData: Data?) {
        print(parameters)
        //MARK: Update User Profile Function
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-type": "multipart/form-data"
        ]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "imageUrl", fileName: "imageUrl.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: baseUrl+"users/trainerUpdate/", method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { DataResponse in
                    print(DataResponse.result.value!)
                    if let JSON = DataResponse.result.value {
                        let dataDict: NSDictionary = JSON as! NSDictionary
                        self.editProfileDelegate?.editProfileResults(dictionaryContent: dataDict)
                    }
                }
            case .failure( _):
                self.editProfileDelegate?.serverError()
            }
        }
    }
    
    func getProcessUrl() {
        let originalUrl = baseUrl+"payment/paymentProcessUrl/?userID=\(getUserID())"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.processAlamofire?.getProcessUrlResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.processAlamofire?.serverError()
                } else {
                    self.processAlamofire?.serverError()
                }
                break
            }
        }
    }
    
    func getPaymentCollectRequest(requestId : Int) {
        let originalUrl = baseUrl+"payment/paymentCollectReq/?userID=\(getUserID())&requestId=" + String(requestId)
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getPaymentCollectionDelegate?.paymentCollectResults(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.getPaymentCollectionDelegate?.serverError()
                } else {
                    self.getPaymentCollectionDelegate?.serverError()
                }
                break
            }
        }
    }
    
    func deletCard(requestId : String) {
        let originalUrl = baseUrl+"payment/deletePayment/?userID=\(getUserID())&requestId=" + requestId
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.deleteCardAlamofire?.getDeleteCardResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.deleteCardAlamofire?.serverError()
                } else {
                    self.deleteCardAlamofire?.serverError()
                }
                break
            }
        }
    }
    
    func checkWallet() {
        let originalUrl = baseUrl + "wallet/?userID=\(getUserID())&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.checkWalletDelegate?.checkWalletResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                if let err = response.result.error! as? URLError, err.code == .notConnectedToInternet {
                    // no internet connection
                    self.checkWalletDelegate?.serverError()
                } else {
                    self.checkWalletDelegate?.serverError()
                }
                break
            }
        }
    }
    
    func createAgenda(_ parameters:[String : Any]) {
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let urlString = baseUrl + "agenda/create/"
        print("urlString",urlString)
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.createAgendaDelegate?.createAgendaResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.createAgendaDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func updateAgenda(_ parameters:[String : Any]) {
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let urlString = baseUrl + "agenda/update/?lang=es"
        print("urlString",urlString)
        Alamofire.request(urlString , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.updateAgendaDelegate?.updateAgendaResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.updateAgendaDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func deleteAgenda(agendaId: Int) {
        let originalUrl = baseUrl + "agenda/delete/?userID=\(getUserID())&agendaID=\(agendaId)&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.deleteAgendaDelegate?.deleteAgendaResult(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.deleteAgendaDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func getOnGoingSession() {
        let originalUrl = baseUrl + "bookingPending/?userID=\(getUserID())&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.onGoingAgendaDelegate?.onGoingData(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.onGoingAgendaDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func markCardSelected(requestID: String) {
        let originalUrl = baseUrl + "payment/selectCard/?userID=\(getUserID())&requestId=\(requestID)&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.markSelectedCardDelegate?.getMarkSelectedCardData(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.markSelectedCardDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func getCardList() {
        let originalUrl = baseUrl + "payment/cardList/?userID=\(getUserID())&lang=es"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.getCardListDelegate?.getCardListData(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.getCardListDelegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    func resetPassword(_ parameters:[String : Any]) {
        print(parameters)
        let headers:HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request(baseUrl + "users/resetPassword/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.changePasswordDalegate?.getData(dictionaryContent:dataDict)
                }
                break
            case .failure(_):
                self.changePasswordDalegate?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
    
    
    func sessionUpdate(bookingID : String, bookingType: String,latitude: String, longitude:String, address:String) {
        let originalUrl = baseUrl + "bookingUpdate/?userID=\(getUserID())&bookingID=\(bookingID)&bookingType=\(bookingType)&latitude=\(latitude)&longitude=\(longitude)&address=\(address)"
        let urlString :String = originalUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        Alamofire.request(urlString).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response = ",response.result.value!)
                    let dataDict: NSDictionary = response.result.value as! NSDictionary
                    self.sessionUpdateProtocol?.getData(dictionaryContent: dataDict)
                }
                break
            case .failure(_):
                self.sessionUpdateProtocol?.serverError()
                print("error",response.result.error!)
                break
            }
        }
    }
}

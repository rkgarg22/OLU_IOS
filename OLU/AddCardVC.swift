

import UIKit
import WebKit

class AddCardVC: UIViewController,UITableViewDelegate ,UITableViewDataSource, paymentInitiateAlamofire, ProcessUrlAlamofire, WKUIDelegate, WKNavigationDelegate, paymentCollectAlamofire, DeleteCardAlamofire ,addPromoCodeAlamofire, MarkCardSelectedProtocol,CardListProtocol{
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var cardTableView: UITableView!
    
    var cardArray = NSArray()
    var processUrl = String()
    var requestID = Int()
    var selectedIndex = Int()
    var webView: WKWebView!
    var promoCode = String()
    var isDeletingSelectedOne = Bool()
    var nibContentsUser = Bundle.main.loadNibNamed("promoCodePopUp", owner: self, options: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.separatorStyle = .none
        isDeletingSelectedOne = false
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        getCardList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        let text =  webView.url?.absoluteString
        if (text == "http://ec2-13-58-57-186.us-east-2.compute.amazonaws.com/api/payment/return/") {
            webView.removeFromSuperview()
            getPaymentCollectAPI()
        }
        else if (text?.contains("redirection/cancel/"))! {
            webView.removeFromSuperview()
        }
        
        print("urlString==",text!)
    }
    
    func webView(_ webView:WKWebView, didFinish navigation: WKNavigation) {
        print("didFinsh")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish Loading")
    }
    
    private func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!) {
        if (navigationAction.navigationType == WKNavigationType.backForward ) {
            print("back forward")
        }
    }
    
    func loadWebView() {
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(webView)
        let myURL = URL(string: processUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func paymentInitiate(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.paymentInitiateDelegate = self
            AlamofireWrapper.sharedInstance.getPayementInitiate()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func processUrlAPI(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.processAlamofire = self
            AlamofireWrapper.sharedInstance.getProcessUrl()
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getPaymentCollectAPI(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getPaymentCollectionDelegate = self
            AlamofireWrapper.sharedInstance.getPaymentCollectRequest(requestId: requestID)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func deleteCard(){
        // no internet check condition
        if applicationDelegate.isConnectedToNetwork {
            let dict = cardArray[selectedIndex] as! NSDictionary
            let id = dict.value(forKey: "requestId") as! String
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.deleteCardAlamofire = self
            AlamofireWrapper.sharedInstance.deletCard(requestId: id)
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getDeleteCardResult(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let dict = cardArray[selectedIndex] as! NSDictionary
            let defaultCard = dict.value(forKey: "defaultCard") as AnyObject
            if defaultCard .isEqual(1){
                isDeletingSelectedOne = true
            }else{
                isDeletingSelectedOne = false
            }
            
            showCardDeletePopUp()
            getCardList()
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func getResult(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            paymentInitiate()
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func paymentCollectResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            getCardList()
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func getProcessUrlResult(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            processUrl = resultDict.value(forKey: "processURL") as! String
            requestID = resultDict.value(forKey: "requestId") as! Int
            showPopForPaymentAlert()
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func paymentInitiateResults(dictionaryContent: NSDictionary){
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            cardArray = resultDict.value(forKey: "cardDetails") as! NSArray
            if(cardArray.count > 0){
                cardTableView.reloadData()
            }
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
    }
    
    @IBAction func promoBtn(_ sender: Any) {
        showPromoCodePopUp()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardBtn(_ sender: Any) {
        processUrlAPI()
    }
    
    func showPopForPaymentAlert(){
        let alertController = UIAlertController(title:paymentConfirmPopUp, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.loadWebView()
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cardArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "BORRAR"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardCell
        let dict = cardArray[indexPath.row] as! NSDictionary
        let cardNumber = dict.value(forKey: "cardNumber") as! String
        cell.cardLabel.text = "XXXX XXXX XXXX " + cardNumber
        let success = dict.value(forKey: "defaultCard") as AnyObject
        if success .isEqual(1) {
            let image = UIImage(named: "checked")
            cell.selectedImageView.image = image
        }else{
            let image = UIImage(named: "unchecked")
            cell.selectedImageView.image = image
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deletdCardBtn), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let dict = cardArray[indexPath.row] as! NSDictionary
        let defaultCard = dict.value(forKey: "defaultCard") as AnyObject
        let requestID = dict.value(forKey: "requestId") as! String
        if defaultCard .isEqual(1){
        }else{
            switchSelectedCardPopup(requestID: requestID);
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            selectedIndex = indexPath.row
//            deleteCard();
//        }
//    }
    
    @objc func deletdCardBtn(sender:UIButton) {
        selectedIndex = sender.tag
        deleteCard();
    }
    
    func showPromoCodePopUp(){
        let nibMainview = nibContentsUser![0] as! UIView
        let okBtn = (nibMainview.viewWithTag(3)! as! UIButton)
        let promoCodeString = (nibMainview.viewWithTag(20)! as! UITextField)
        let crossBtn = (nibMainview.viewWithTag(15)! as! UIButton)
        
        okBtn.addTarget(self, action: #selector(okBtnAction), for: UIControlEvents.touchUpInside)
        
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
    
    @IBAction func placeToPay(_ sender: Any) {
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
            showAlert(self, message: error, title: appName)
        }
    }
    
    @objc func crossBtnAction(sender:UIButton) {
        let nibMainview = nibContentsUser![0] as! UIView
        nibMainview.removeFromSuperview()
    }
    
    func switchSelectedCardPopup(requestID: String){
        let alertController = UIAlertController(title:switchSelectedCardConfirmation, message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"Si", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.callMarkSelectCardAPI(requestID: requestID)
        }
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func getCardList(){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getCardListDelegate = self
            AlamofireWrapper.sharedInstance.getCardList()
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getCardListData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            //let resultDict = dictionaryContent.value(forKey: "result") as! NSDictionary
            if( dictionaryContent.value(forKey: "result") is NSNull){
                cardArray = NSArray()
                cardTableView.reloadData()
                
            }else{
                cardArray = dictionaryContent.value(forKey: "result") as! NSArray
                if(cardArray.count > 0){
                    cardTableView.reloadData()
                }
            }
            
            if(isDeletingSelectedOne && cardArray.count>0){
                let dict = cardArray[0] as! NSDictionary
                let requestID = dict.value(forKey: "requestId") as! String
                callMarkSelectCardAPI(requestID: requestID)
                isDeletingSelectedOne = false
            }else if(cardArray.count==1){
                let dict = cardArray[0] as! NSDictionary
                let defaultCard = dict.value(forKey: "defaultCard") as AnyObject
                if defaultCard .isEqual(0) {
                    let requestID = dict.value(forKey: "requestId") as! String
                    callMarkSelectCardAPI(requestID: requestID)
                    isDeletingSelectedOne = false
                }
            }else{
                isDeletingSelectedOne = false
            }
        }
        else {
            cardArray = NSArray()
            cardTableView.reloadData()
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    
    func callMarkSelectCardAPI(requestID:String){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.markSelectedCardDelegate = self
            AlamofireWrapper.sharedInstance.markCardSelected(requestID: requestID)
        }
        else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getMarkSelectedCardData(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            getCardList()
        }
        else {
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
    }
    
    
    func showCardDeletePopUp(){
        let alertController = UIAlertController(title:"Tarjeta eliminada exitosamente.", message: "", preferredStyle: .alert)
        // Create the actions
        let YesAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        alertController.addAction(YesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

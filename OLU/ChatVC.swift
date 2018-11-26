import UIKit

class ChatVC: UIViewController ,messageAlamofire  ,UITextViewDelegate ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var viewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var chatTable: UITableView!
    @IBOutlet var messageText: UITextView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var noMessage: UILabel!
    @IBOutlet var messageHeading: UILabel!
    
    var listArray = NSMutableArray()
    var toUserId = Int()
    var userName = String()
    var layoutSubViewBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTable(_:)), name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
        
        messageHeading.text = userName
        chatTable.tableFooterView = UIView()
        getInboxMessage()
        noMessage.isHidden = false
        addKeyboardObserver()
        
        applicationDelegate.isOnChatScreen = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        applicationDelegate.isOnChatScreen = false;
        NotificationCenter.default.removeObserver("reloadTheTable")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func reloadTable(_ notification: NSNotification) {
        if let recNotification: NSDictionary = notification.userInfo as NSDictionary? {
            print(recNotification)
            
            let chatParameterStr = ChatStruct()
            let milliseconds = Double(recNotification.value(forKey: "messageTime") as! String)
            let dateTime = getDateAndTimeString(milliseconds!)
            
            chatParameterStr.messageVar = recNotification.value(forKey: "message") as? String ?? ""
            chatParameterStr.toUser = recNotification.value(forKey: "messageToID") as? Int ?? 0
            chatParameterStr.fromUser = recNotification.value(forKey: "messageFromID") as? Int ?? 0
            chatParameterStr.time = dateTime.timeString
            chatParameterStr.date = dateTime.dateString
            
            if listArray.count != 0 {
                let lastObj = listArray.lastObject as! ChatStruct
                //let milliseconds = lastObj.value(forKey: "messageTime") as? NSNumber ?? 0
               // let currentDateTime = la
                
                if dateTime.dateString != lastObj.date{
                    let chatParameterStr = ChatStruct()
                    chatParameterStr.time = dateTime.timeString
                    chatParameterStr.date = dateTime.dateString
                    chatParameterStr.type = "header"
                    listArray.add(chatParameterStr)
                    
                    chatParameterStr.messageVar = recNotification.value(forKey: "message") as? String ?? ""
                    chatParameterStr.toUser = recNotification.value(forKey: "messageToID") as? Int ?? 0
                    chatParameterStr.fromUser = recNotification.value(forKey: "messageFromID") as? Int ?? 0
                    chatParameterStr.time = dateTime.timeString
                    chatParameterStr.date = dateTime.dateString
                    chatParameterStr.type = "row"
                    listArray.add(chatParameterStr)
                }else{
                    chatParameterStr.type = "row"
                    listArray.add(chatParameterStr)
                }
            }
            else{
                
                let chatParameterStr = ChatStruct()
                chatParameterStr.time = dateTime.timeString
                chatParameterStr.date = dateTime.dateString
                chatParameterStr.type = "header"
                listArray.add(chatParameterStr)
                
                chatParameterStr.type = "row"
                listArray.add(chatParameterStr)
            }
            chatTable.reloadData()
            moveToLastComment()
        }
    }
    
    // MARK: Keyboard notifications methods
    @objc func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        viewBottomContraint.constant = keyBoardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        layoutSubViewBool = false
        viewBottomContraint.constant = 0
        chatTable.contentInset = UIEdgeInsets.zero
    }
    
    override func viewDidLayoutSubviews() {
        if layoutSubViewBool{
            let offset = CGPoint(x: 0, y: chatTable.contentSize.height - chatTable.frame.size.height)
            chatTable.contentOffset = offset
        }
    }
    
    //MARK: - get InboxMessage
    func getInboxMessage(){
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.startProgressView(view: self.view)
            AlamofireWrapper.sharedInstance.getMessageDelegate = self
            AlamofireWrapper.sharedInstance.getMessageLsit(toUserId: String(toUserId))
        }else{
            showAlert(self, message: noInternetConnection, title: appName)
        }
    }
    
    func getMessageResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            listArray.removeAllObjects()
            var dataArray = dictionaryContent.value(forKey: "result") as! NSArray
            dataArray = dataArray.reversed() as NSArray
            //            for item in dataArray  {
            //                var dict = NSMutableDictionary()
            //                dict = (item as! NSDictionary).mutableCopy() as! NSMutableDictionary
            //                listArray.add(dict)
            //            }
            ////////////////////
            var currentDate = ""
            if (dataArray.count != 0) {
                for i in 0...dataArray.count - 1 {
                    let resultDict = dataArray[i] as! NSDictionary
                    let chatParameterStr = ChatStruct()
                    let milliseconds = resultDict.value(forKey: "messageTime") as? NSNumber ?? 0
                    
                    let dateTime = getDateAndTimeString(milliseconds.doubleValue)
                    
                    chatParameterStr.messageVar = resultDict.value(forKey: "message") as? String ?? ""
                    chatParameterStr.toUser = resultDict.value(forKey: "messageToID") as? Int ?? 0
                    chatParameterStr.fromUser = resultDict.value(forKey: "messageFromID") as? Int ?? 0
                    chatParameterStr.time = dateTime.timeString
                    chatParameterStr.date = dateTime.dateString
                    
                    if dateTime.dateString != currentDate{
                        let chatParameterStr = ChatStruct()
                        chatParameterStr.time = dateTime.timeString
                        chatParameterStr.date = dateTime.dateString
                        chatParameterStr.type = "header"
                        listArray.add(chatParameterStr)
                    }
                    chatParameterStr.type = "row"
                    listArray.add(chatParameterStr)
                    currentDate = dateTime.dateString
                }
                ////////////////////
            }
            chatTable.reloadData()
            moveToLastComment()
        }
        else{
            //let error = dictionaryContent.value(forKey: "error") as! String
            //showAlert(self, message: error, title: appName)
        }
        if listArray.count == 0 {
            noMessage.isHidden = false
        }
        else{
            noMessage.isHidden = true
        }
    }
    
    func getDateAndTimeString(_ milliseconds: Double) -> (dateString: String, timeString: String) {
        let date = Date(timeIntervalSince1970: milliseconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm a"
        let timeString = dateFormatter.string(from: date)
        
        return (dateString, timeString)
    }
    
    func moveToLastComment() {
        DispatchQueue.main.async {
            if self.chatTable.contentSize.height > self.chatTable.frame.height {
                let lastSectionIndex = self.chatTable!.numberOfSections - 1
                let lastRowIndex = self.chatTable!.numberOfRows(inSection: lastSectionIndex) - 1
                let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                self.chatTable?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }
        }
    }
    
    func sendMessageResults(dictionaryContent: NSDictionary) {
        applicationDelegate.dismissProgressView(view: self.view)
        let success = dictionaryContent.value(forKey: "success") as AnyObject
        if success .isEqual(1) {
            getInboxMessage()
            messageText.text = ""
        }
        else{
            let error = dictionaryContent.value(forKey: "error") as! String
            showAlert(self, message: error, title: appName)
        }
        if listArray.count == 0 {
            noMessage.isHidden = false
        }
        else{
            noMessage.isHidden = true
        }
    }
    
    func serverError() {
        applicationDelegate.dismissProgressView(view: self.view)
        showAlert(self, message: serverErrorString, title: appName)
        
        if listArray.count == 0 {
            noMessage.isHidden = false
        }
        else{
            noMessage.isHidden = true
        }
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        var messageStr = messageText.text
        messageStr = messageStr?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(messageStr?.isEmpty)!{
            
        }else{
            let messageParameters: [String : Any]  =
                [
                    "userID": getUserID(),
                    "userIDTo": toUserId,
                    "message" : messageText.text as! String
            ]
            
            if applicationDelegate.isConnectedToNetwork {
                applicationDelegate.startProgressView(view: self.view)
                AlamofireWrapper.sharedInstance.sendMessageDelegate = self
                AlamofireWrapper.sharedInstance.sendMessage(messageParameters)
            }
            else {
                showAlert(self, message: noInternetConnection, title: appName)
            }
        }
    }
    
    func ServerError(){
        showAlert(self, message: serverErrorString, title: appName)
        applicationDelegate.dismissProgressView(view: self.view)
    }
    
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //var dict = NSDictionary()
        //        dict = listArray[indexPath.row] as! NSDictionary
        //        let toUserId = dict.value(forKey: "messageToID") as! Int
        //        if getUserID() == toUserId {
        //            let cellOne = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! ChatOneCell
        //            cellOne.resulDictList(resultdict:dict)
        //            return cellOne
        //        }
        //        else{
        //            let cellTwo = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath) as! ChatTwoCell
        //            cellTwo.resulDictList(resultdict:dict)
        //            return cellTwo
        //        }
        ///////////////
        let obj = listArray[indexPath.row] as! ChatStruct
        if obj.type == "header" {
            let dateCellVar = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! DateCell
            dateCellVar.dateLabel.text = obj.date
            return dateCellVar
        } else {
            if(obj.toUser == getUserID()) {
                let receiverCellVar = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath) as! ChatOneCell
                receiverCellVar.nameLabel.text = obj.messageVar
                receiverCellVar.timeLabel.text = obj.time
                return receiverCellVar
            } else {
                let senderCellVar = tableView.dequeueReusableCell(withIdentifier: "cellTwo", for: indexPath) as! ChatTwoCell
                senderCellVar.nameLabel.text = obj.messageVar
                senderCellVar.timeLabel.text = obj.time
                return senderCellVar
            }
        }
        ///////////////
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        if let vc = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(vc, animated: true)
        }
        
    }
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        messageLabel.text = ""
        return true
    }
}

class ChatStruct {
    var date = String()
    var time = String()
    var messageVar = String()
    var toUser = Int()
    var fromUser = Int()
    var type = String()
}

class DateCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

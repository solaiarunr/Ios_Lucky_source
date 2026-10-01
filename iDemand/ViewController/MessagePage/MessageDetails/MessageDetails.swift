//
//  MessageDetails.swift
//  iDemand
//
//  Created by Roby on 26/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
import IQKeyboardManagerSwift
import MLKitSmartReply
import GiphyUISDK
import GiphyCoreSDK
import iRecordView
import AVFoundation
import Photos

class MessageDetails: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource ,UINavigationControllerDelegate, UIImagePickerControllerDelegate,socketDelegate,GiphyDelegate,RecordViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate{
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var lastSeenLbl: UILabel!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var msgTV: GrowingTextView!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var cardView: MDCCard!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var statusView: UIView!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var contactBtn: UIButton!
    @IBOutlet var attachBtn: UIButton!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var smartReplyView: UIScrollView!
    @IBOutlet var recordView: RecordView!
    @IBOutlet var recordBtn: RecordButton!
    
    var isRequested = false
    var isMsgAvailable = true
    var viewType = String()
    var isKeyboardEnable = false
    var chatDict = NSDictionary()
    var profile:ProfileModel?
    var chatID = String()
    var receiverID = String()
    var messageArray = NSMutableArray()
    var tempArray = NSMutableArray()
    var picker = UIImagePickerController()
    var refreshChat: (() -> Void)?
    var isBlocked = false
    var blockedBy = String()
    var bookingType = String()
    var bookingID = String()
    var serviceDict = NSDictionary()
    var booking_status = String()
    var pageCount = 0
    var getBookingInfo = false
    var chatType = String()
    var messageIDsArray = NSMutableArray()
    var assignedTo = String()
    var viewFrom = String()
    var audioPlayer = AVAudioPlayer()
    
    var recordingSession: AVAudioSession!
    var duration = CGFloat()
    var VoiceRecordingSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Voice_record", ofType: ".wav")!)
    var audioPlayer_VoiceRecord: AVAudioPlayer!
    var counter = 0
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var ishold = false
    var isPlaying = false
    
    //modified-AR
    var declineClicked = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //qwerty
//        SocketClass.sharedInstance.connect()

        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.statusView.topRadius()
        self.navigationView.bottomRadius()
        self.userImgView.radius(value: 10.0)
        self.contactBtn.topRadius()
        self.smartReplyView.frame.origin.y = self.cardView.frame.origin.y - 40
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.isCurrentUser = ""
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        //qwerty
        self.viewFrom = ""
//        SocketClass.sharedInstance.disconnect()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("updated details")
        if chatType == "admin"{
            appDelegate.isCurrentUser = "admin"
        }else{
            appDelegate.isCurrentUser = self.chatID
        }
        self.updateTheme()
        SocketClass.sharedInstance.delegate = self
        if chatType != "admin"{
            SocketClass.sharedInstance.join(chat: chatID)
            self.bookingStatus()
            self.resetUnread()
        }
        self.checkRTL()
    }
    override func viewDidAppear(_ animated: Bool) {
        messageTableView.reloadData()
    }
    //initial set up
    func initialSetup()  {
        self.cardView.backgroundColor = BACKGROUND_COLOR
        self.smartReplyView.isHidden = true
        self.addLoader()
        self.statusView.backgroundColor = SECONDARY_COLOR
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.nameLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .left, text: "")
        self.lastSeenLbl.config(color: TEXT_WHITE_COLOR!, font: smallReg, align: .left, text: "")
        self.contactBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "contact_us")
        self.contactBtn.backgroundColor = PRIMARY_COLOR
        self.statusLbl.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, text: "")
        messageTableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        messageTableView.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        messageTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        messageTableView.register(UINib(nibName: "QuoteCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
        messageTableView.register(UINib(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: "StatusCell")
        messageTableView.register(UINib(nibName: "DateStickyCell", bundle: nil), forCellReuseIdentifier: "DateStickyCell")
        messageTableView.register(UINib(nibName: "AudioCell", bundle: nil), forCellReuseIdentifier: "AudioCell")
        
        self.statusView.isHidden = false
        let menuImg = #imageLiteral(resourceName: "menu_dot_icon").withRenderingMode(.alwaysTemplate)
        self.menuBtn.setImage(menuImg, for: .normal)
        self.menuBtn.tintColor = .white
        messageTableView.reloadData()
        //        self.msgTV.addTarget(self, action: #selector(textViewDidChange(_:)), forControlEvents: .EditingChanged)
        
        self.messageTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.configToolsView()
        do{
            let jsonDecoder = JSONDecoder()
            profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
        }catch{
        }
        self.cardView.isHidden = true
        
        self.startLoading()
        if chatType == "admin"{
            self.contactBtn.isHidden = false
            self.messageTableView.frame.size.height += self.cardView.frame.size.height
            self.menuBtn.isHidden = true
            self.lastSeenLbl.isHidden = true
            self.statusView.isHidden = true
            self.nameLbl.frame.origin.y += 10
            self.nameLbl.text = "\(APP_NAME) \(Utility.shared.Json().value(forKey: "team") ?? "")"
            self.userImgView.image = UIImage.init(named: "app_icon")
            appDelegate.isCurrentUser = "admin"
            
            self.getMessage(offset: "0")            
        }else{
            self.contactBtn.isHidden = true
            appDelegate.isCurrentUser = self.chatID
            let blockStatus = chatDict.value(forKey: "block") as! String
            self.nameLbl.text = chatDict.value(forKey: "name") as? String
            self.checkBlock(by: chatDict.value(forKey: "blocked_by") as! String, status: blockStatus,type:"start")
            self.lastSeenLbl.text = ""
            let userimgURL = URL.init(string: chatDict.value(forKey: "user_image") as! String)
            self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            self.onlineStatus()
        }
        if ADD_ON {
            self.recordBtn.radius(value: 17.5)
            self.recordBtn.backgroundColor = PRIMARY_COLOR
            self.recordView.isHidden = true
            self.recordView.delegate = self
            self.recordBtn.recordView = self.recordView
            self.recordView.isHidden = true
            self.sendBtn.isHidden = true
        }else{
            self.sendBtn.isHidden = false
            self.recordView.isHidden = true
            self.recordBtn.isHidden = true
        }
        
        
        self.checkRecordPermission()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    @objc func willResignActive() {
        if(isRecording){
            if(audioRecorder.isRecording){
                audioRecorder.stop()
                audioRecorder.deleteRecording()
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            // Print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        isRecording = false
    }
    // enable record based on the action
    func showRecord(status:Bool)  {
        if status {
            self.attachBtn.isHidden = true
            self.msgTV.isHidden = true
            self.recordView.isHidden = false
        }else{
            self.attachBtn.isHidden = false
            self.msgTV.isHidden = false
            self.recordView.isHidden = true
        }
        
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.lastSeenLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
            self.lastSeenLbl.textAlignment = .right
            self.sendBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.attachBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "write_something")
        }else{
            self.msgTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "write_something")
            
        }
    }
    
    //bottom tools view
    func configToolsView()  {
        //        self.cardView.topRadius()
        self.cardView.setShadowElevation(.modalActionSheet, for: .normal)
        self.cardView.setShadowColor(.lightGray, for: .normal)
        self.msgTV.delegate = self
        //        self.msgTV.placeholder = Utility.shared.Json().value(forKey: "write_something") as? String
        //        self.msgTV.placeColor = LINE_COLOR!
        //        self.msgTV.font = subReg
        self.msgTV.minHeight = 40.0
        self.msgTV.maxHeight = 150.0
        self.msgTV.backgroundColor = .clear
        
        self.sendBtn.config(color: TEXT_WHITE_COLOR!, font: smallBold, align: .center, title: "send")
        self.sendBtn.radius(value: 5.0)
        self.sendBtn.backgroundColor = PRIMARY_COLOR
        //keyboard manager
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.messageTableView.estimatedRowHeight = 80.0
        self.messageTableView.rowHeight = UITableView.automaticDimension
    }
    
    func checkBlock(by:String,status:String,type:String)  {
        if status == "true"{
            isBlocked = true
            self.statusView.isHidden = false
            self.cardView.isHidden = true
            self.blockedBy = by
            if by == LocalDefault.shared.userID(){
                self.statusLbl.text = "\(Utility.shared.Json().value(forKey: "chat_blocked") ?? "") \(Utility.shared.Json().value(forKey: "you") ?? "")"
            }else{
                self.statusLbl.text = "\(Utility.shared.Json().value(forKey: "chat_blocked") ?? "") \(self.nameLbl.text!)"
                self.lastSeenLbl.isHidden = true
            }
        }else{
            self.blockedBy = ""
            isBlocked = false
            let bookingType =  self.chatDict.value(forKey: "booking_type") as! String
            let due_status = chatDict.value(forKey: "due_status") as! String
            //check other status information
            if booking_status == "cancelled" || booking_status == "completed" || self.booking_status == "refunded"{
                self.statusLbl.text = "\(Utility.shared.Json().value(forKey: "service") ?? "") \(Utility.shared.get(status: booking_status) )"
                statusView.isHidden = false
                self.cardView.isHidden = true
            }else if bookingType == "userneeds"{
                let userID = self.chatDict.value(forKey: "user_id") as! String
                if (self.assignedTo != "" && self.assignedTo != LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo != userID && LocalDefault.shared.isUser()!){
                    self.statusLbl.text = "\(Utility.shared.Json().value(forKey: "service") ?? "") \(Utility.shared.get(status: "expired"))"
                    //qwerty
//                    statusView.isHidden = false
//                    self.cardView.isHidden = true
                    self.cardView.isHidden = false
                }else if (self.assignedTo != "" && self.assignedTo == LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo == userID && LocalDefault.shared.isUser()!){
                    statusView.isHidden = true
                    self.cardView.isHidden = false
                }else if  due_status == "pending" || due_status == "expired"{
                    if due_status == "pending"{
                        self.statusLbl.text = Utility.shared.Json().value(forKey: "admin_disabled") as? String
                    }else{
                        self.statusLbl.text = "\(Utility.shared.Json().value(forKey: "service") ?? "") \(Utility.shared.get(status: due_status))"
                    }
                    statusView.isHidden = false
                    self.cardView.isHidden = true
                }else{
                    statusView.isHidden = true
                    self.cardView.isHidden = false
                }
            }else{
                statusView.isHidden = true
                self.cardView.isHidden = false
            }
            
            if type == "start"{
                statusView.isHidden = true
                self.cardView.isHidden = true
            }
        }
        
    }
    //check online
    func onlineStatus()  {
        let dict = NSMutableDictionary()
        dict.setValue("onlineStatus", forKey: "type")
        dict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        dict.setValue(self.receiverID, forKey: "receiver_id")
        if receiverID != ""{
        SocketClass.sharedInstance.send(msg: dict)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.onlineStatus()
        }
    }
    //check booking status
    func bookingStatus()  {
        let dict = NSMutableDictionary()
        dict.setValue("bookingStatus", forKey: "type")
        dict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        dict.setValue(self.bookingID, forKey: "booking_id")
        //qwerty
        dict.setValue(self.receiverID, forKey: "receiver_id")
        SocketClass.sharedInstance.send(msg: dict)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Code you want to be delayed
            if !self.getBookingInfo{
                self.bookingStatus()
            }
        }
    }
    //check unread status
    func resetUnread()  {
        let dict = NSMutableDictionary()
        dict.setValue("resetUnread", forKey: "type")
        dict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        dict.setValue(self.chatID, forKey: "chat_id")
        SocketClass.sharedInstance.send(msg: dict)
        self.refreshChat!()
    }
    //send msg
    func sendMsg(type:String,dict:NSMutableDictionary) {
        let requestDict = NSMutableDictionary()
        requestDict.setValue("bookingchat", forKey: "type")
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(profile?.name, forKey: "user_name")
        requestDict.setValue(profile?.user_image, forKey: "user_image")
        requestDict.setValue(receiverID, forKey: "receiver_id")
        requestDict.setValue(chatID, forKey: "chat_id")
        requestDict.setValue(Utility.shared.UTC(), forKey: "date")
        requestDict.setValue(type, forKey: "message_type")
        requestDict.setValue(Utility.shared.messageID(), forKey: "message_id")
        requestDict.setValue(dict, forKey: "message")
        SocketClass.sharedInstance.send(msg: requestDict)
        self.messageArray.add(requestDict)
        self.tempArray.add(requestDict)
        
        self.messageTableView.reloadData()
        if self.messageArray.count != 0 {
            self.scrollToBottom()
            self.msgTV.text = ""
        }
        if viewType == "chat"{
            self.refreshChat!()
        }
    }
    //scroll to bottom
    func scrollToBottom(){
        UIView.animate(withDuration: 0.5, animations: {
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
                self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = self.messageTableView.contentOffset
        if currentOffset.y < 50{
            if self.isMsgAvailable{
                if !self.isRequested{
                    self.isRequested = true
                    let Obj = BaseAPI()
                    var subURL = String()
                    let offset = self.pageCount * 20
                    
                    if chatType == "admin"{
                        if LocalDefault.shared.isUser()!{
                            subURL = "\(USER_ADMIN_CHATS)/ios/\(offset)/20"
                        }else{
                            subURL = "\(TASKER_ADMIN_CHATS)/ios/\(offset)/20"
                        }
                    }else{
                        
                        if LocalDefault.shared.isUser()!{
                            subURL = "\(USER_MESSAGE_API)/\(self.chatID)/\(offset)/20"
                        }else{
                            subURL = "\(TASKER_MESSAGE_API)/\(self.chatID)/\(offset)/20"
                        }
                    }
                    Obj.getDetails(subURl: subURL, onSuccess: {response in
                        let dict = response.value as! NSDictionary
                        let status_code = dict.value(forKey: "status_code") as! Int
                        if status_code == 200{
                            let arrangeArray = NSMutableArray()
                            self.messageTableView.delegate = self
                            self.messageTableView.dataSource = self
                            let newArray = NSMutableArray()
                            newArray.addObjects(from: dict.value(forKey: "messages") as! [Any])
                            if newArray.count != 0{
                                self.pageCount += 1
                                arrangeArray.addObjects(from: newArray.reversed())
                                arrangeArray.addObjects(from: self.tempArray as! [Any])
                                self.messageArray.removeAllObjects()
                                self.messageArray.addObjects(from: arrangeArray as! [Any])
                                self.tempArray.removeAllObjects()
                                self.tempArray.addObjects(from: arrangeArray as! [Any])
                                self.messageTableView.reloadData()
                                let indexPath = IndexPath(row: newArray.count-1, section: 0)
                                self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }else{
                                self.isMsgAvailable = false
                            }
                            self.isRequested = false
                        }
                    })
                }
            }
        }
    }
    
    //get message
    func getMessage(offset:String)  {
        let Obj = BaseAPI()
        var subURL = String()
        if chatType == "admin"{
            if LocalDefault.shared.isUser()!{
                subURL = "\(USER_ADMIN_CHATS)/ios/\(offset)/20"
            }else{
                subURL = "\(TASKER_ADMIN_CHATS)/ios/\(offset)/20"
            }
        }else{
            if LocalDefault.shared.isUser()!{
                subURL = "\(USER_MESSAGE_API)/\(self.chatID)/\(offset)/20"
            }else{
                subURL = "\(TASKER_MESSAGE_API)/\(self.chatID)/\(offset)/20"
            }
        }
        Obj.getDetails(subURl: subURL, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.messageTableView.delegate = self
                self.messageTableView.dataSource = self
                self.pageCount += 1
                let newArray = NSMutableArray.init(array: dict.value(forKey: "messages") as! [Any])
                self.messageArray.addObjects(from: newArray.reversed())
                self.tempArray.addObjects(from: newArray.reversed())
                self.messageTableView.reloadData()
                if self.messageArray.count != 0 {
                    self.scrollToBottom()
                    
                }
            }else{
            }
            self.stopLoading()
        })
        
        
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        //modified-AR
        if self.viewFrom == "booking"{
//            let vc = clusterMapViewController()
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func contactBntapped(_ sender: Any) {
        let contactObj = ContactPage()
        self.navigationController?.pushViewController(contactObj, animated: true)
    }
    @IBAction func sendBtnTapped(_ sender: Any) {
        if self.msgTV.isEmptyValue(){
            Utility.shared.showToast(msg: "enter_msg")
        }else{
            self.smartReplyView.isHidden = true
            let msgDict = NSMutableDictionary()
            msgDict.setValue(self.msgTV.text, forKey: "message")
            msgDict.setValue("text", forKey: "type")
            msgDict.setValue("true", forKey: "isActive")
            self.sendMsg(type: "text", dict: msgDict)
            if ADD_ON {
                self.sendBtn.isHidden = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.recordBtn.isHidden = false
                })
            }
            
        }
    }
    @IBAction func menuBtnTapped(_ sender: Any) {
        if isBlocked{
            if self.blockedBy == LocalDefault.shared.userID(){
                self.showMenu()
            }
        }else{
            self.showMenu()
        }
    }
    
    @IBAction func chooseLanguageBtnTapped(_ sender: Any) {
        let languageObj = LanguagePage()
        languageObj.viewType = "translate"
        languageObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(languageObj, animated: true, completion: nil)
    }
    func showMenu()  {
        self.view.endEditing(true)
        
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style: .cancel) { action -> Void in
        }
        action.addAction(cancelAction)
        
        if !isBlocked{
            let block = UIAlertAction(title: (Utility.shared.Json().value(forKey: "block") as! String), style: .default) { action -> Void in
                self.isBlocked = true
                self.blockedBy = LocalDefault.shared.userID()!
                self.blockUser(status: "true")
            }
            action.addAction(block)
        }else{
            let unblock = UIAlertAction(title: (Utility.shared.Json().value(forKey: "unblock") as! String), style: .default) { action -> Void in
                self.isBlocked = false
                self.blockedBy = ""
                self.blockUser(status: "false")
            }
            action.addAction(unblock)
        }
        
        // Present the AlertController
        self.present(action, animated: true, completion: nil)
    }
    
    //block user
    func blockUser(status:String)  {
        let requestDict = NSMutableDictionary()
        requestDict.setValue("blockChat", forKey: "type")
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(self.chatID, forKey: "chat_id")
        requestDict.setValue(status, forKey: "blocked")
        SocketClass.sharedInstance.send(msg: requestDict)
    }
    
    
    @IBAction func attachmentBtnTapped(_ sender: Any) {
        self.msgTV.resignFirstResponder()
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style: .cancel) { action -> Void in
            // Just dismiss the action sheet
        }
        action.addAction(cancelAction)
        
        // Create and add first option action
        let camera = UIAlertAction(title: (Utility.shared.Json().value(forKey: "camera") as! String), style: .default) { action -> Void in
            self.picker.delegate = self
            self.picker.sourceType = .camera
            self.picker.allowsEditing = false
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }
        action.addAction(camera)
        
        // Create and add a second option action
        let gallery = UIAlertAction(title: (Utility.shared.Json().value(forKey: "gallery") as! String), style: .default) { action -> Void in
            self.picker.delegate = self
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = false
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }
        action.addAction(gallery)
        
        // Create and add a second option action
        let location = UIAlertAction(title: (Utility.shared.Json().value(forKey: "location") as! String), style: .default) { action -> Void in
            let locationObj = MapPage()
            locationObj.isFromChat = true
            locationObj.modalPresentationStyle = .fullScreen
            locationObj.currentLocation = { lat,lon,address in
                let msgDict = NSMutableDictionary()
                msgDict.setValue("Location", forKey: "message")
                msgDict.setValue("location", forKey: "type")
                msgDict.setValue(lat, forKey: "lat")
                msgDict.setValue(lon, forKey: "lon")
                msgDict.setValue("true", forKey: "isActive")
                self.sendMsg(type: "location", dict: msgDict)
            }
            self.navigationController?.present(locationObj, animated: true, completion: nil)
        }
        action.addAction(location)
        if ADD_ON {
            // Create and add a second option action
            let gif = UIAlertAction(title: (Utility.shared.Json().value(forKey: "gif") as! String), style: .default) { action -> Void in
                self.openGif()
            }
            action.addAction(gif)
        }
        // Present the AlertController
        self.present(action, animated: true, completion: nil)
    }
    
    
    //image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            Utility.shared.showAlert(msg: "image_not_valid")
            return
        }
        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageSize: Int = imageData!.count
        let size = Double(imageSize) / 1000.0
        if size <= 2000{
            self.startLoading()
            let api = BaseAPI()
            var subURL  = String()
            if LocalDefault().isUser()!{
                subURL = USER_CHAT_UPLOAD_API
            }else{
                subURL = TASKER_CHAT_UPLOAD_API
            }
            api.upload(sub_url: subURL, image: imageData!, type: "media", onSuccess: {response in
                self.stopLoading()
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                    let resDict = json! as NSDictionary
                    let status_code = resDict.value(forKey: "status_code") as! Int
                    if status_code == 200{
                        let msgDict = NSMutableDictionary()
                        msgDict.setValue("Image", forKey: "message")
                        msgDict.setValue("image", forKey: "type")
                        msgDict.setValue(resDict.value(forKey: "media_url"), forKey: "attachment")
                        msgDict.setValue("true", forKey: "isActive")
                        self.sendMsg(type: "image", dict: msgDict)
                    }
                }catch{
                }
            })
        }else{
            Utility.shared.showToast(msg: "maximum_limit")
        }
        
    }
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msgDict = self.messageArray.object(at: indexPath.row) as! NSDictionary
        let message_type = msgDict.value(forKey: "message_type") as! String

        switch message_type {
        case "text":
            return calculateTextCellHeight(for: msgDict)
        case "date":
            return 40
        case "request":
            return calculateQuoteCellHeight(for: msgDict)  + 20
        case "quote":
            return calculateQuoteCellHeight(for: msgDict) + 20
        case "accept":
            return 90
        case "cancel":
            return 100
        case "image":
            return 180
        case "location":
            return 180
        case "gif":
            return 180
        case "audio":
            return 100
        default:
            return 44 // Default height
        }
    }

    func calculateTextCellHeight(for msgDict: NSDictionary) -> CGFloat {
        let text = msgDict.value(forKeyPath: "message.message") as? String ?? ""
        let labelWidth = 170
        let labelHeight = text.height(withConstrainedWidth: CGFloat(labelWidth), font: normalReg!)
        print("Lab Height: ",labelHeight)
        return labelHeight + 40
    }

    func calculateQuoteCellHeight(for msgDict: NSDictionary) -> CGFloat {
        let description = msgDict.value(forKeyPath: "message.description") as? String ?? ""
        let labelWidth = 170
        let labelHeight = description.height(withConstrainedWidth: CGFloat(labelWidth), font: normalReg!)
        return labelHeight + 230
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var customCell = UITableViewCell()
        let msgDict = self.messageArray.object(at: indexPath.row) as! NSDictionary
        
        let message_type = msgDict.value(forKey: "message_type") as! String
        if message_type == "text"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.config(dict: msgDict, chatType: self.chatType)
            cell.translateBtn.tag = indexPath.row
            cell.translateBtn.addTarget(self,action:#selector(self.translateMsg),
                                        for:.touchUpInside)
//            tableView.rowHeight = cell.timeLbl.frame.origin.y + 17
            customCell = cell
        }else if message_type == "date"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateStickyCell", for: indexPath) as! DateStickyCell
            cell.dateLbl.text = Utility.shared.toLocal(dateStr: msgDict.value(forKey: "date") as! String, format: "dd.MM.yyyy")
//            tableView.rowHeight = 40
            customCell = cell
            
        }else if message_type == "request"{
            if LocalDefault.shared.isUser()!{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
                cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
                cell.config(dict:self.serviceDict, msgDict: msgDict)
//                tableView.rowHeight = UITableView.automaticDimension
                customCell = cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
                cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
                cell.config(dict:serviceDict,type:message_type,msgDict:msgDict)
                cell.quoteBtn.tag = indexPath.row
                //modified-AR
//                cell.quoteBtn.addTarget(self, action: #selector(self.quoteBtnTapped), for: .touchUpInside)
                cell.quoteBtn.addTarget(self, action: #selector(self.cancelBtnTapped), for: .touchUpInside)
                
                cell.acceptBtn.tag = indexPath.row
                cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnTapped), for: .touchUpInside)
                //modified-AR
                let msgActive = msgDict.value(forKeyPath: "message.isActive") as? String
                if !self.isActive(){
                    cell.actionView.isHidden = true
                    cell.requestView.frame.size.height -= 50
//                    tableView.rowHeight = cell.requestView.frame.size.height
                }
                //modified-AR
                //else if added change size 30 to 50
                else if msgActive == "false"{
                    cell.actionView.isHidden = true
                    cell.requestView.frame.size.height -= 50
//                    tableView.rowHeight = cell.requestView.frame.size.height
                }
                else{
                    cell.actionView.isHidden = false
//                    tableView.rowHeight = cell.requestView.frame.size.height + 50
                }
//                tableView.rowHeight = cell.requestView.frame.size.height + 50
                customCell = cell
            }
        } else if message_type == "quote"{
            if LocalDefault.shared.isUser()! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
                cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
                cell.config(dict:serviceDict,type:message_type,msgDict:msgDict)
                cell.quoteBtn.tag = indexPath.row
                cell.quoteBtn.addTarget(self, action: #selector(self.cancelBtnTapped), for: .touchUpInside)
                cell.acceptBtn.tag = indexPath.row
                cell.acceptBtn.addTarget(self, action: #selector(self.acceptBtnTapped), for: .touchUpInside)
                let msgActive = msgDict.value(forKeyPath: "message.isActive") as! String
                if isActive() && msgActive == "true"{
                    cell.actionView.isHidden = false
//                    tableView.rowHeight = cell.requestView.frame.size.height + 50
                }else{
                    cell.actionView.isHidden = true
                    cell.requestView.frame.size.height -= 50
//                    tableView.rowHeight = cell.requestView.frame.size.height
                }
//                tableView.rowHeight = cell.requestView.frame.size.height + 50
                customCell = cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
                cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
                cell.config(dict:self.serviceDict, msgDict: msgDict)
//                tableView.rowHeight = UITableView.automaticDimension
                customCell = cell
                
            }
        }else if message_type == "accept"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
            cell.config(dict:serviceDict,type:message_type,msgDict:msgDict)
            //qwerty
//            if booking_status == "paid" || booking_status == "completed" || booking_status == "started"{
//                cell.payBtn.setTitle(Utility.shared.Json().value(forKey: "paid") as? String, for: .normal)
//            }
            if booking_status == "paid"{
                cell.payBtn.setTitle(Utility.shared.Json().value(forKey: "paid") as? String, for: .normal)
            }
            if LocalDefault.shared.isUser()! {
                //qwerty
//                cell.payBtn.isHidden = false
//                if booking_status == "completed"{
//                    cell.payBtn.isHidden = false
//                    cell.payBtn.setTitle(Utility.shared.Json().value(forKey: "pay") as? String, for: .normal)
//                    tableView.rowHeight = 140
//                } else {
//                    cell.payBtn.isHidden = true
//                    tableView.rowHeight = 90
//                }
                cell.payBtn.isHidden = true
//                tableView.rowHeight = 90
                cell.payBtn.tag = indexPath.row
                cell.payBtn.addTarget(self, action: #selector(self.payBtnTapped), for: .touchUpInside)
            }else{
                //qwerty
//                if booking_status == "paid" || booking_status == "completed" || booking_status == "started"{
//                    cell.payBtn.isHidden = false
//                    cell.payBtn.setTitle(Utility.shared.Json().value(forKey: "paid") as? String, for: .normal)
//                    tableView.rowHeight = 140
//                }
//                if booking_status == "paid"{
//                    cell.payBtn.isHidden = false
//                    cell.payBtn.setTitle(Utility.shared.Json().value(forKey: "paid") as? String, for: .normal)
//                    tableView.rowHeight = 140
//                }
//                else{
//                    cell.payBtn.isHidden = true
//                    tableView.rowHeight = 90
//                }
                cell.payBtn.isHidden = true
//                tableView.rowHeight = 90
            }
            customCell = cell
        }else if message_type == "cancel"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            cell.imgBtn.addTarget(self, action: #selector(self.goToBookingPage(_:)), for: .touchUpInside)
            cell.config(dict:serviceDict,type:message_type,msgDict:msgDict)
            cell.payBtn.isHidden = true
//            tableView.rowHeight = 100
            customCell = cell
        }else if message_type == "image" ||  message_type == "location" ||  message_type == "gif"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.config(dict: msgDict,type:message_type)
//            tableView.rowHeight = 180
            customCell = cell
        }else if message_type == "audio"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as! AudioCell
            cell.config(dict: msgDict)
//            tableView.rowHeight = 100
            customCell = cell
        }
        
        return customCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgDict = self.messageArray.object(at: indexPath.row) as! NSDictionary
        let message_type = msgDict.value(forKey: "message_type") as! String
        if message_type == "image"{
            let attachment = msgDict.value(forKeyPath: "message.attachment") as! String
            let imgView = ImageViewer()
            imgView.modalPresentationStyle = .fullScreen
            imgView.viewType = "chat"
            imgView.imgUrl = attachment
            self.navigationController?.present(imgView, animated: true, completion: nil)
        }else if message_type == "location"{
            let lat = msgDict.value(forKeyPath: "message.lat") as? Double ?? Double(0)
            let lon = msgDict.value(forKeyPath: "message.lon") as? Double ?? Double(0)
            
            let mapObj = MapPage()
            mapObj.isFromChat = true
            mapObj.viewType = "view"
            mapObj.lat = lat
            mapObj.lon = lon
            mapObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(mapObj, animated: true, completion: nil)
        }
    }
    //translate msg here
    @objc func translateMsg(sender:UIButton){
        let dict = self.messageArray.object(at: sender.tag) as! NSDictionary
        let msgdict = NSMutableDictionary.init(dictionary: dict)
        let msgStr = dict.value(forKeyPath: "message.message") as! String
        
        Utility.shared.translate(msg: msgStr, callback: { translatedTxt in
            print("translated text \(translatedTxt)")
            DispatchQueue.main.async {
                let tempDict = NSMutableDictionary.init(dictionary:msgdict.value(forKey: "message") as! NSDictionary)
                tempDict.removeObject(forKey: "message")
                tempDict.setValue(translatedTxt, forKey: "message")
                msgdict.removeObject(forKey: "message")
                msgdict.setValue(tempDict, forKey: "message")
                self.messageArray.removeObject(at: sender.tag)
                self.messageArray.insert(msgdict, at: sender.tag)
                self.messageTableView.reloadData()
            }
        })
    }
    //active
    func isActive() -> Bool {
        let bookingType =  self.chatDict.value(forKey: "booking_type") as! String
        let due_status = chatDict.value(forKey: "due_status") as! String
        //modified-AT
        
        //modified-AR
        // add self.booking_status == "payment_pending" in this if condition
        if isBlocked || self.booking_status == "paid" || self.booking_status == "started" || self.booking_status == "cancelled" || self.booking_status == "completed" || self.booking_status == "accepted" || self.booking_status == "payment_pending"{
            return false
        }else if bookingType == "userneeds"{
            let userID = self.chatDict.value(forKey: "user_id") as! String
            if (self.assignedTo != "" && self.assignedTo != LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo != userID && LocalDefault.shared.isUser()!){
                //modified-AR
//                return false
                return true
            }else if (self.assignedTo != "" && self.assignedTo == LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo == userID && LocalDefault.shared.isUser()!){
                return true
            }else if due_status == "pending" || due_status == "expired"{
                return false
            }
            else{
                return true
            }
        } else{
            return true
        }
    }
    //check its expired or not
    func isExpired() -> Bool {
        let bookingType =  self.chatDict.value(forKey: "booking_type") as! String
        let due_status = chatDict.value(forKey: "due_status") as! String
        if isBlocked{
            return true
        }
        
        if bookingType == "userneeds"{
            let userID = self.chatDict.value(forKey: "user_id") as! String
            if (self.assignedTo != "" && self.assignedTo != LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo != userID && LocalDefault.shared.isUser()!){
                return true
            }else if (self.assignedTo != "" && self.assignedTo == LocalDefault.shared.userID() && !LocalDefault.shared.isUser()!) || (self.assignedTo != "" && self.assignedTo == userID && LocalDefault.shared.isUser()!){
                return false
            }else if due_status == "pending" || due_status == "expired"{
                return true
            }else{
                return false
            }
        } else{
            return false
        }
    }
    
    //dismiss view
    @objc func goToBookingPage(_ sender: UITapGestureRecognizer? = nil) {
        if viewFrom == "booking"{
            self.navigationController?.popViewController(animated: true)
        }else{
            if !isExpired(){
                if LocalDefault.shared.isUser()! {
                    let bookingType =  self.chatDict.value(forKey: "booking_type") as! String
                    if bookingType == "userneeds" && booking_status == "requested"{
                    }else{
                        let detailObj = BookingDetails()
                        detailObj.viewFrom = "chat"
                        detailObj.bookingID = self.bookingID
                        detailObj.refreshRequest = {
                            self.bookingStatus()
                        }
                        self.navigationController!.pushViewController(detailObj, animated: true)
                    }
                }else{
                    let detailObj = TaskerBookingDetails()
                    detailObj.viewFrom = "chat"
                    detailObj.bookingID = self.bookingID
                    detailObj.refreshRequest = {
                        self.bookingStatus()
                    }
                    self.navigationController!.pushViewController(detailObj, animated: true)
                }
            }
        }
    }
    //quote btn
    @objc func quoteBtnTapped(sender:UIButton)  {
        if isActive(){
            let dict = self.messageArray.object(at: sender.tag) as! NSDictionary
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = true
            let defaultDict = LocalDefault.shared.appDefaults()
            let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
            let quoteObj = QuotePage()
            quoteObj.modalPresentationStyle = .overCurrentContext
            quoteObj.serviceDict = self.serviceDict
            quoteObj.priceStr = dict.value(forKeyPath: "message.quote_price") as! String
            quoteObj.quoted = { price,des in
                IQKeyboardManager.shared.enable = false
                IQKeyboardManager.shared.enableAutoToolbar = false
                let msgDict = NSMutableDictionary()
                msgDict.setValue("\(Utility.shared.Json().value(forKey: "quoted_price") ?? "") \(currency_code)\(price) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))", forKey: "message")
                msgDict.setValue(des, forKey: "description")
                msgDict.setValue("quote", forKey: "type")
                msgDict.setValue(price, forKey: "quote_price")
                msgDict.setValue("\(currency_code)\(price)", forKey: "price")
                msgDict.setValue("true", forKey: "isActive")
                
                self.sendMsg(type: "quote", dict: msgDict)
            }
            self.navigationController?.present(quoteObj, animated: true, completion: nil)
        }else{
            Utility.shared.showToast(msg: "booking_status_changed")
            
        }
    }
    //accept btn
    @objc func acceptBtnTapped(sender:UIButton)  {
        if isActive(){
            let dict = self.messageArray.object(at: sender.tag) as! NSDictionary
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "accept_request"
            let defaultDict = LocalDefault.shared.appDefaults()
            let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
            alertObj.amtStr = "\(currency_code) \(dict.value(forKeyPath: "message.quote_price") as! String)"
            alertObj.deleteRequest = {
                self.updateMessage(msgDict: dict, index: sender.tag)
                let msgDict = NSMutableDictionary()
                msgDict.setValue("accept", forKey: "type")
                msgDict.setValue(dict.value(forKeyPath: "message.quote_price") as! String, forKey: "quote_price")
                msgDict.setValue(Utility.shared.Json().value(forKey: "service_accpted"), forKey: "message")
                msgDict.setValue("true", forKey: "isActive")
                self.sendMsg(type: "accept", dict: msgDict)
                self.quoteAccepted(price: dict.value(forKeyPath: "message.quote_price") as! String)
                self.bookingStatus()
                self.booking_status = "accepted"
                self.messageTableView.reloadData()
            }
            self.navigationController?.present(alertObj, animated: false, completion: nil)
        }else{
            Utility.shared.showToast(msg: "booking_status_changed")
        }
    }
    //cancel btn
    @objc func cancelBtnTapped(sender:UIButton)  {
        if isActive(){
            let dict = self.messageArray.object(at: sender.tag) as! NSDictionary
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "decline_request"
            alertObj.deleteRequest = {
                let msgDict = NSMutableDictionary()
                msgDict.setValue("cancel", forKey: "type")
                msgDict.setValue(dict.value(forKeyPath: "message.quote_price") as! String, forKey: "quote_price")
                msgDict.setValue(Utility.shared.Json().value(forKey: "service_declined"), forKey: "message")
                msgDict.setValue("true", forKey: "isActive")
//                modified-AR
                for (co,i) in self.messageArray.enumerated(){
                    let temp = i as! NSDictionary
                    let status = LocalDefault().isUser()! ? "quote" : "request"
//                    if temp.value(forKey: "message_type") as! String == "quote" || temp.value(forKey: "message_type") as! String == "request"{
                    if temp.value(forKey: "message_type") as! String == "quote" || temp.value(forKey: "message_type") as! String == "request" {
                        self.updateMessage(msgDict: temp, index: co)
                    }
                }
                self.sendMsg(type: "cancel", dict: msgDict)
//                self.updateMessage(msgDict: dict,index: sender.tag)
            }
            self.navigationController?.present(alertObj, animated: false, completion: nil)
        }else{
            Utility.shared.showToast(msg: "booking_status_changed")
            
        }
    }
    @objc func payBtnTapped(sender:UIButton)  {
        if isBlocked || self.booking_status == "paid" || self.booking_status == "started" || self.booking_status == "cancelled" || self.booking_status == "completed"  || self.booking_status == "refunded" {
        }else{
            let detailObj = BookingDetails()
            detailObj.bookingID = self.bookingID
            detailObj.refreshRequest = {
                self.bookingStatus()
            }
            self.navigationController!.pushViewController(detailObj, animated: true)
        }
    }
    
    //update particular message
    func updateMessage(msgDict:NSDictionary,index:Int)  {
        let requestDict = NSMutableDictionary.init(dictionary: msgDict)
        let newDict = NSMutableDictionary.init(dictionary: requestDict.value(forKey: "message") as! NSDictionary)
        newDict.removeObject(forKey: "isActive")
        requestDict.removeObject(forKey: "type")
        requestDict.removeObject(forKey: "message")
        newDict.setValue("false", forKeyPath: "isActive")
        requestDict.setValue(newDict, forKey: "message")
        requestDict.setValue("updateChat", forKey:"type")
        
        print("changed dict \(requestDict)")
        SocketClass.sharedInstance.send(msg: requestDict)
        self.messageArray.removeObject(at: index)
        self.tempArray.removeObject(at: index)
        self.messageArray.insert(requestDict, at: index)
        self.tempArray.insert(requestDict, at: index)
        self.messageTableView.reloadData()
        
    }
    
    
    //send stripe token to server for payment
    func payment(token:String,booking_id:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(booking_id, forKey: "booking_id")
        request.setValue(token, forKey: "payment_token")
//        request.setValue(String(format: "%.2f", totalAmt), forKey: "total_amount")
//        let appDefault = LocalDefault.shared.appDefaults()
//        let currency = appDefault?.value(forKey: "currency_code") as! String
//        if stripe_currency.contains(currency) {
//            request.setValue(String(format: "%.0f", totalAmt), forKey: "total_amount")
//        }
        Obj.baseService(subURl: PAY_BOOKING_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                Utility.shared.showToast(msg: "payment_done")
                self.bookingStatus()
            }
            self.stopLoading()
        })
    }
    //quote confirmed
    func quoteAccepted(price:String)  {
        let msgDict = NSMutableDictionary()
        msgDict.setValue(self.bookingID, forKey: "booking_id")
        msgDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        msgDict.setValue(price, forKey: "price")
        let bookingType =  self.chatDict.value(forKey: "booking_type") as! String
        if bookingType == "userneeds"{
            if !LocalDefault.shared.isUser()!{
                msgDict.setValue(LocalDefault.shared.userID(), forKey: "tasker_id")
            }else{
                msgDict.setValue(self.chatDict.value(forKey: "user_id"), forKey: "tasker_id")
            }
            msgDict.setValue("acceptNeed", forKey: "type")
        }else{
            msgDict.setValue("quoteConfirmed", forKey: "type")
        }
        
        SocketClass.sharedInstance.send(msg: msgDict)
    }
    
    //MARK: Keyboard hide/show
    @objc func keyboardWillShow(sender: NSNotification) {
        if !isKeyboardEnable {
            isKeyboardEnable = true
            let info = sender.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.messageTableView.frame.size.height -= keyboardFrame.height
            let topPadding = self.cardView.frame.origin.y - keyboardFrame.height
            
            self.cardView.frame = CGRect.init(x: 0, y: topPadding, width: FULL_WIDTH, height: self.cardView.frame.size.height)
            self.view.addSubview(self.cardView)
            if self.messageArray.count != 0 {
                self.scrollToBottom()
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.messageTableView.frame.size.height += keyboardFrame.height
        self.cardView.frame.origin.y = FULL_HEIGHT -  self.cardView.frame.size.height
        self.messageTableView.frame.size.height = self.cardView.frame.origin.y - self.navigationView.frame.size.height
        isKeyboardEnable = false
        
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.cardView.frame.origin.y += self.cardView.frame.size.height
        self.cardView.frame.size.height = height+20
        self.msgTV.frame.size.height = height
        self.cardView.frame.origin.y -= self.cardView.frame.size.height
        self.msgTV.frame.origin.y = 5
        self.messageTableView.frame.size.height -= 60
        self.messageTableView.frame.size.height = self.cardView.frame.origin.y - self.navigationView.frame.size.height
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.scrollToBottom()
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    //called textview did change
    func textViewDidChange(_ textView: UITextView) {
        if ADD_ON{
            print("called did change")
            if textView.text.isEmpty {
                self.sendBtn.isHidden = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.recordBtn.isHidden = false
                })
            }else{
                if self.sendBtn.isHidden{
                    self.recordBtn.isHidden = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.sendBtn.isHidden = false
                    })
                }
            }
        }
    }
    //MARK: SOCKET CLASS
    func gotSocket(msg: NSDictionary, type: String) {
        print("SOCKET MSG : \(msg)")
        if type == "admin"{
            if chatType == "admin"{
                let msgDict = NSMutableDictionary()
                msgDict.setValue("text", forKey: "message_type")
                msgDict.setValue(Utility.shared.UTC(), forKey: "date")
                msgDict.setValue("", forKey: "user_name")
                msgDict.setValue("", forKey: "message_id")
                msgDict.setValue("", forKey: "receiver_id")
                msgDict.setValue(msg, forKey: "message")
                self.messageArray.add(msgDict)
                self.tempArray.add(msgDict)
                self.messageTableView.reloadData()
            }
            
        }else  if type == "booking"{
            let bookingID = msg.value(forKeyPath: "message.booking_id") as! String
            if bookingID == self.bookingID{
                self.bookingStatus()
            }
        }else{
            let msg_type = msg.value(forKey: "type") as! String
            if msg_type == "onlineStatus"{ //ONLINE INFORMATION
                let user_id = msg.value(forKey: "user_id") as! String
                if user_id == self.receiverID{
                    let status = msg.value(forKey: "status") as! Int
                    if status == 1{
                        self.lastSeenLbl.text = Utility.shared.Json().value(forKey: "online") as? String
                    }else{
                        let time = msg.value(forKey: "last_seen") as! String
                        self.lastSeenLbl.text = Utility.shared.lastSeen(dateStr: time)
                    }
                }
            }else if msg_type == "bookingStatus"{ //ONLINE INFORMATION
                let booking_id = msg.value(forKey: "booking_id") as! String
                if booking_id == self.bookingID{
                    if self.booking_status != "accepted" {
                        self.booking_status = msg.value(forKey: "status") as! String
                    }
                    self.serviceDict = msg
                    self.messageTableView.reloadData()
                    self.assignedTo = msg.value(forKey: "assigned_to") as! String
                    if !isBlocked{
                        self.checkBlock(by: "", status: "false", type: "booking")
                    }
                    if !getBookingInfo{
                        getBookingInfo = true
                        self.getMessage(offset: "0")
                    }
                }
            }else if msg_type == "bookingchat"{ // CHAT MESSAGE
                print("bookingchat MSG : \(msg)")
                let chat_id = msg.value(forKey: "chat_id") as! String
                if chat_id == chatID{
                    let message_type = msg.value(forKey: "message_type") as! String
                    let message_id = msg.value(forKey: "message_id") as! String
                    if  !self.messageIDsArray.contains(message_id){
                        self.messageIDsArray.add(message_id)
                        if message_type == "accept"{
                            self.booking_status = "accepted"
                        }else if message_type == "text"{
                            if ADD_ON {
                                let msgStr = msg.value(forKeyPath: "message.message") as! String
                                self.showSmartReplies(msg: msgStr)
                                Utility.shared.translate(msg: msgStr, callback: { translatedTxt in
                                    print("translated text \(translatedTxt)")
                                    DispatchQueue.main.async { [self] in
                                        let msgDict = NSMutableDictionary.init(dictionary: msg)
                                        let tempDict = NSMutableDictionary.init(dictionary:msgDict.value(forKey: "message") as! NSDictionary)
                                        tempDict.removeObject(forKey: "message")
                                        tempDict.setValue(translatedTxt, forKey: "message")
                                        msgDict.removeObject(forKey: "message")
                                        msgDict.setValue(tempDict, forKey: "message")
                                        self.messageArray.add(msgDict)
                                        self.tempArray.add(msgDict)
                                        self.messageTableView.reloadData()
                                        
                                        return
                                    }
                                })
                            }
                        }
                        else if message_type == "cancel"{
//                            self.declineClicked = false
//                            self.messageArray.removeAllObjects()
//                            self.tempArray.removeAllObjects()
//                            self.getMessage(offset: "0")
                            for (co,i) in self.messageArray.enumerated(){
                                let temp = i as! NSDictionary
                                let status = LocalDefault().isUser()! ? "quote" : "request"
            //                    if temp.value(forKey: "message_type") as! String == "quote" || temp.value(forKey: "message_type") as! String == "request"{
                                if temp.value(forKey: "message_type") as! String == status{
                                    self.updateMessage(msgDict: temp, index: co)
                                }
                            }
                        }
                        if ADD_ON && message_type == "text"{
                            return
                        }
                        
                        self.messageArray.add(msg)
                        self.tempArray.add(msg)
                        
                        self.messageTableView.reloadData()
                        self.resetUnread()
                        if self.messageArray.count != 0 {
                            self.scrollToBottom()
                        }
                        if viewType == "chat"{
                            self.refreshChat!()
                        }
                    }
                }
            }else if msg_type == "blockChat"{ // BLOCK MESSAGE
                let chat_id = msg.value(forKey: "chat_id") as! String
                if chat_id == chatID{
                    let blocked = msg.value(forKey: "blocked") as! String
                    if blocked == "true"{
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.checkBlock(by: msg.value(forKey: "user_id") as! String, status: blocked, type: "block")
                    if viewType == "chat"{
                        self.refreshChat!()
                    }
                }
            }
            //qwerty
        else if msg_type == "cancel"{ // BLOCK MESSAGE
        
        }
        else if msg_type == "receiveMessage"{
            
        }
        else {
            
        }
        }
    }
    
    
}

//MARK: SMART REPLY
extension MessageDetails{
    
    func showSmartReplies(msg:String){
        
        var conversation: [TextMessage] = []
        // Then, for each message sent and received:
        let message = TextMessage(
            text: msg,
            timestamp: Date().timeIntervalSince1970,
            userID: "userId",
            isLocalUser: false)
        conversation.append(message)
        
        SmartReply.smartReply().suggestReplies(for: conversation) { result, error in
            let subViews = self.smartReplyView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            guard error == nil, let result = result else {
                return
            }
            if (result.status == .notSupportedLanguage) {
                // The conversation's language isn't supported, so
                // the result doesn't contain any suggestions.
            } else if (result.status == .success) {
                // Successfully suggested smart replies.
                
                var leftPadding = 5
                for suggestion in result.suggestions {
                    print("Suggested reply: \(suggestion.text)")
                    let suggestionBtn = UIButton()
                    suggestionBtn.config(color: TEXT_WHITE_COLOR!, font: subReg, align: .center, title: "")
                    suggestionBtn.setTitle(suggestion.text, for: .normal)
                    suggestionBtn.addTarget(self,action:#selector(self.smartMsgSend),
                                            for:.touchUpInside)
                    suggestionBtn.frame = CGRect.init(x: leftPadding, y: 5, width: Int(suggestionBtn.intrinsicContentSize.width)+30, height: 30)
                    suggestionBtn.radius(value: 5)
                    suggestionBtn.backgroundColor = PRIMARY_COLOR
                    suggestionBtn.addBorder(width: 1, color: PRIMARY_COLOR!)
                    self.smartReplyView.addSubview(suggestionBtn)
                    leftPadding = Int(suggestionBtn.frame.origin.x+suggestionBtn.frame.size.width+5)
                    self.smartReplyView.contentSize = CGSize.init(width: leftPadding+200, height: 50)
                    self.smartReplyView.isHidden = false
                }
            }
        }
    }
    
    @objc func smartMsgSend(sender:UIButton){
        print("msg btn tapp")
        
        self.smartReplyView.isHidden = true
        let msgDict = NSMutableDictionary()
        msgDict.setValue((sender.titleLabel?.text), forKey: "message")
        msgDict.setValue("text", forKey: "type")
        msgDict.setValue("true", forKey: "isActive")
        self.sendMsg(type: "text", dict: msgDict)
    }
}

//MARK: GIPHY
extension MessageDetails{
    func openGif()  {
        Giphy.configure(apiKey: GIPHY_API_KEY)
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.shouldLocalizeSearch = true
        if Utility.shared.getTheme() == "dark"{
            giphy.theme = GPHTheme.dark
        }else{
            giphy.theme = GPHTheme.light
        }
        
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.showCheckeredBackground = true
        giphy.modalPresentationStyle = .overCurrentContext
        present(giphy, animated: true, completion: nil)
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia)   {
        let gifURL : String = media.url(rendition: .fixedWidth, fileType: .gif)!
        print("gif url \(gifURL)")
        if Utility.shared.isConnectedToNetwork() {
            let msgDict = NSMutableDictionary()
            msgDict.setValue("Gif", forKey: "message")
            msgDict.setValue("gif", forKey: "type")
            msgDict.setValue(gifURL, forKey: "attachment")
            msgDict.setValue("true", forKey: "isActive")
            self.sendMsg(type: "gif", dict: msgDict)
        }
        // your user tapped a GIF!
        giphyViewController.dismiss(animated: true, completion: nil)
    }
    
    func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a GIF.
    }
}

//MARK: AUDIO RECORD
extension MessageDetails{
    //MARK: - Check Mic Permission ------------->
    func checkRecordPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    //set up record
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
                //setCategory(AVAudioSession.Category.playAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                //                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else{
            //            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    
    // MARK : record view delegate
    func onStart() {
        if self.counter != 0 {
            self.counter = 0
            //            self.stopAudioPlayer()
        }
        self.showRecord(status: true)
        if(isAudioRecordingGranted) {
            if(!isRecording)
            {
                do {
                    audioPlayer_VoiceRecord = try AVAudioPlayer(contentsOf: VoiceRecordingSound as URL)
                    audioPlayer_VoiceRecord.play()
                } catch {
                    // Print(error.localizedDescription)
                }
                
                setup_recorder()
                audioRecorder.record()
                isRecording = true
            }
        }
        else {
            //            self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "microphone_alert") as? String)
        }
    }
    func onCancel() {
        if(isRecording){
            if(audioRecorder.isRecording){
                audioRecorder.stop()
                audioRecorder.deleteRecording()
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            // Print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        isRecording = false
    }
    func onAnimationEnd() {
        self.showRecord(status: false)
    }
    func onFinished(duration: CGFloat) {
        self.showRecord(status: false)
        print("check \(duration)")
        self.duration = duration
        self.finishRecording(success: true)
        
        if(isRecording)
        {
            ishold = true
            isRecording = false
            
            if(duration > 0.0){
                do {
                    let audioData = try Data.init(contentsOf: getFileUrl() as URL)
                    self.startLoading()
                    let api = BaseAPI()
                    api.uploadAudio( audioData: audioData, onSuccess: {response in
                        self.stopLoading()
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                            let resDict = json! as NSDictionary
                            let status_code = resDict.value(forKey: "status_code") as! Int
                            if status_code == 200{
                                let msgDict = NSMutableDictionary()
                                msgDict.setValue("Audio", forKey: "message")
                                msgDict.setValue("audio", forKey: "type")
                                msgDict.setValue(self.duration, forKey: "duration")
                                msgDict.setValue(resDict.value(forKey: "audio"), forKey: "attachment")
                                msgDict.setValue("true", forKey: "isActive")
                                self.sendMsg(type: "audio", dict: msgDict)
                            }
                        }catch{
                        }
                    })
                }catch{
                    
                }
            }
            else {
                //                self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "hold_voice") as? String)
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            // Print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    
    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            // Print("recorded successfully.")
        }
        else
        {
            //            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    func playAudio(urlStr:String)  {
        let escapedString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let audioURL = URL(string:escapedString!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Speaker error : \(error)")
        }
        //
        print("play audio \(String(describing: audioURL))");
        do {
            let imageData = try Data(contentsOf: audioURL!)
            audioPlayer = try AVAudioPlayer.init(data: imageData)
        } catch {
            print("Unable to load data: \(error)")
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 10
        audioPlayer.play()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("done play")
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}

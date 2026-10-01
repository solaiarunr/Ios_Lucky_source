//
//  MessagePage.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MessagePage: UIViewController ,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate, socketDelegate,GADBannerViewDelegate{
    
    
    
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var bannerView: GADBannerView!

    var messageArray = NSMutableArray()
    var isFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        let height = (tabBarController?.tabBar.frame.size.height)!+40
        bannerView.frame.origin.y = FULL_HEIGHT - height
    }
    override func viewWillAppear(_ animated: Bool) {
        SocketClass.sharedInstance.delegate = self
        self.getChats()
        self.updateTheme()
    }
    override func viewDidAppear(_ animated: Bool) {
        messageTableView.reloadData()
    }
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.loader.color = PRIMARY_COLOR
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_message_yet")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "message")
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        messageTableView.reloadData()
        self.messageTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        
        self.addPullDownRefresh()
        self.loader.startAnimating()
        self.noView.isHidden = true
        
        //check rtl
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        self.configBanner()

    }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.messageTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getChats()
        }
    }
    
    // config banner
    func configBanner()  {
        if ADD_ON {
            self.messageTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
            bannerView.adUnitID = BANNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }else{
            bannerView.isHidden = true
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    }
    
    //get message
    func getChats()  {
        let Obj = BaseAPI()
        var subURL = String()
        if LocalDefault.shared.isUser()!{
            subURL = "\(USER_CHATS_API)/\(LocalDefault.shared.userID() ?? "")/ios"
        }else{
            subURL = "\(TASKER_CHATS_API)/\(LocalDefault.shared.userID() ?? "")/ios"
        }
        Obj.getDetails(subURl: subURL, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.messageArray.removeAllObjects()
                self.noView.isHidden = true
                self.messageTableView.delegate = self
                self.messageTableView.dataSource = self
                self.messageArray.addObjects(from: dict.value(forKey: "chats") as! [Any])
                self.messageTableView.reloadData()
            }else{
                self.noView.isHidden = false
            }
            self.messageTableView.fty.pullToRefresh.end()
            
            self.loader.stopAnimating()
            self.isFinished = true
        })
        
    }
    
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let model = self.messageArray.object(at: indexPath.row) as! NSDictionary
        cell.config(dict: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dict = self.messageArray.object(at: indexPath.row) as! NSDictionary
        let chatType =  dict.value(forKey: "chat_type") as! String
        if chatType == "admin"{
            return 80
        }else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.messageArray.object(at: indexPath.row) as! NSDictionary
        let chatType =  dict.value(forKey: "chat_type") as! String
        let detailObj = MessageDetails()
        detailObj.chatDict = dict
        if chatType != "admin"{
            detailObj.receiverID = dict.value(forKey: "user_id") as! String
            detailObj.chatID = dict.value(forKey: "chat_id") as! String
            detailObj.bookingID = dict.value(forKey: "booking_id") as! String
        }else{
            detailObj.chatType = "admin"
        }
        detailObj.viewType = "chat"
        detailObj.refreshChat = {
            self.getChats()
        }
        self.navigationController?.pushViewController(detailObj, animated: true)
    }
    
    //MARK: SOCKET RESPONSE
    func gotSocket(msg: NSDictionary, type: String) {
        print("SOCKET MSG : \(msg)")
        if type == "user" || type == "admin"{
            self.getChats()
        }else if type == "booking"{
        }else{
            let msg_type = msg.value(forKey: "type") as! String
            if msg_type == "bookingchat" || msg_type == "blockChat"{ // CHAT MESSAGE
                self.getChats()
            }
        }
    }
}



//
//  AccountSetting.swift
//  iDemand
//
//  Created by Roby on 05/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe
import SafariServices

class AccountSetting: UIViewController ,SFSafariViewControllerDelegate{
    
    let menuArray = NSMutableArray()
    let apiObj = BaseAPI()
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var notificationTitleLbl: UILabel!
    @IBOutlet var chatNotificationLbl: UILabel!
    @IBOutlet var chatNotificationSwitch: UISwitch!
    @IBOutlet var bookingNotificationLbl: UILabel!
    @IBOutlet var bookingNotificationSwitch: UISwitch!
    @IBOutlet var emailTitileLbl: UILabel!
    @IBOutlet var paymentEmailLbl: UILabel!
    @IBOutlet var paymentEmailSwitch: UISwitch!
    @IBOutlet var bookingEmailLbl: UILabel!
    @IBOutlet var bookingEmailSwitch: UISwitch!
    @IBOutlet var deactivateLbl: UILabel!
    @IBOutlet var deactivateHintLbl: UILabel!
    @IBOutlet var languageHintLbl: UILabel!
    @IBOutlet var languageLbl: UILabel!
    @IBOutlet var manageBtn: UIButton!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var paymentHintLbl: UILabel!
    @IBOutlet var switchSeparatorLbl: UILabel!
    @IBOutlet var paymentSepLbl: UILabel!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var workModeView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var settingView: UIView!
    @IBOutlet var availablityLbl: UILabel!
    @IBOutlet var workModeLbl: UILabel!
    @IBOutlet var workModeSwitch: UISwitch!
    @IBOutlet var chatNotificationInfoLbl: UILabel!
    @IBOutlet var bookingNotificationInfoLbl: UILabel!
    @IBOutlet var bookingEmailInfoLbl: UILabel!
    @IBOutlet var paymentEmailInfoLbl: UILabel!
    @IBOutlet var themeLbl: UILabel!
    @IBOutlet var themeHintLbl: UILabel!
    
    var stripeURL = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height+100)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.chatNotificationSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.notificationTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.chatNotificationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingNotificationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.bookingNotificationSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTitileLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.bookingNotificationSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.paymentEmailSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingEmailLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentEmailLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.deactivateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.deactivateHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.languageHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.languageLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.manageBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.workModeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.availablityLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.workModeSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.bookingEmailSwitch.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.chatNotificationInfoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.chatNotificationInfoLbl.textAlignment = .right
            self.bookingNotificationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingNotificationLbl.textAlignment = .right
            self.bookingEmailInfoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingEmailInfoLbl.textAlignment = .right
            self.paymentEmailInfoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentEmailInfoLbl.textAlignment = .right
            self.notificationTitleLbl.textAlignment = .right
            self.chatNotificationLbl.textAlignment = .right
            self.bookingNotificationLbl.textAlignment = .right
            self.emailTitileLbl.textAlignment = .right
            self.bookingEmailLbl.textAlignment = .right
            self.paymentEmailLbl.textAlignment = .right
            self.workModeLbl.textAlignment = .right
            self.availablityLbl.textAlignment = .right
            self.deactivateLbl.textAlignment = .right
            self.deactivateHintLbl.textAlignment = .right
            self.languageHintLbl.textAlignment = .right
            self.languageHintLbl.textAlignment = .right
            self.languageLbl.textAlignment = .right
            self.paymentLbl.textAlignment = .right
            self.manageBtn.contentHorizontalAlignment = .right
            self.paymentHintLbl.textAlignment = .right
            
        }
    }
    //initial set up
    func initialSetup()  {
        
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_account_setting")
        self.availablityLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "availability")
        //notification
        self.notificationTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "notification_settings")
        self.chatNotificationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "chat")
        self.bookingNotificationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "booking")
        self.chatNotificationInfoLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "hide_chat_notification")
        self.bookingNotificationInfoLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "hide_booking_notification")
        
        //email
        self.emailTitileLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "email_settings")
        self.bookingEmailLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "booking")
        self.paymentEmailLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "payment")
        self.bookingEmailInfoLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "hide_booking_email")
        self.paymentEmailInfoLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "hide_payment_email")
        
        self.workModeLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "make_me_avilable")
        self.languageLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "change_language")
        self.deactivateHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "deactivate_hint")
        self.languageHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "language_hint")
        self.deactivateLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "deactive_account")
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            if profile.payment_verified == "false"{
                
                self.paymentHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "add_stripe_hint")
            }else{
                self.paymentHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "modify_stripe_hint")
            }
            
        }catch{
            
        }
        self.paymentLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "manage_payment")
        self.workModeSwitch.onTintColor = PRIMARY_COLOR
        
        self.themeLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "change_theme")
        self.themeHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "theme_hint")
        
        self.bookingNotificationSwitch.onTintColor = PRIMARY_COLOR
        self.paymentEmailSwitch.onTintColor = PRIMARY_COLOR
        self.bookingEmailSwitch.onTintColor = PRIMARY_COLOR
        self.chatNotificationSwitch.onTintColor = PRIMARY_COLOR
        if LocalDefault.shared.isUser()!{
            self.workModeView.isHidden = true
            self.containerView.frame.origin.y = 0
            self.bottomView.frame.origin.y = self.switchSeparatorLbl.frame.origin.y+1
            self.paymentHintLbl.isHidden = true
            self.paymentLbl.isHidden = true
            self.manageBtn.isHidden = true
            self.paymentSepLbl.isHidden = true
        }else{
            self.getStripeInfo()
        }
        //set details from server
        self.setDetails()
        self.checkRTL()
    }
    
    
    //set details based on the profile
    func setDetails()  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            if profile.work_mode == "true"{
                self.workModeSwitch.setOn(true, animated: true)
            }else{
                self.workModeSwitch.setOn(false, animated: true)
            }
            
            if profile.chat_notification == "true"{
                self.chatNotificationSwitch.setOn(true, animated: true)
            }else{
                self.chatNotificationSwitch.setOn(false, animated: true)
            }
            if profile.booking_notification == "true"{
                self.bookingNotificationSwitch.setOn(true, animated: true)
            }else{
                self.bookingNotificationSwitch.setOn(false, animated: true)
            }
            if profile.payment_email == "true"{
                self.paymentEmailSwitch.setOn(true, animated: true)
            }else{
                self.paymentEmailSwitch.setOn(false, animated: true)
            }
            if profile.booking_email == "true"{
                self.bookingEmailSwitch.setOn(true, animated: true)
            }else{
                self.bookingEmailSwitch.setOn(false, animated: true)
            }
            
        }catch{
        }
    }
    
    @IBAction func switchBtnTapped(_ sender: UISwitch) {
        if sender.tag == 1{
            self.updateProfile(key: "chat_notification", value: chatNotificationSwitch.isOn)
        }else if sender.tag == 2{
            self.updateProfile(key: "booking_notification", value: bookingNotificationSwitch.isOn)
        }else if sender.tag == 3{
            self.updateProfile(key: "booking_email", value: bookingNotificationSwitch.isOn)
        }else if sender.tag == 4{
            self.updateProfile(key: "payment_email", value: paymentEmailSwitch.isOn)
        }else if sender.tag == 5{
            self.updateProfile(key: "work_mode", value: workModeSwitch.isOn)
        }
    }
    
    //update profile details
    func updateProfile(key:String,value:Bool)  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        if value{
            requestDict.setValue("true", forKey: key)
        }else{
            requestDict.setValue("false", forKey: key)
        }
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
            
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                LocalDefault.shared.setUser(data: response.data!)
                self.setDetails()
            }
        })
    }
    
    
    @IBAction func deactivateBtnTapped(_ sender: Any) {
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "deactivate"
        self.navigationController?.present(alertObj, animated: false, completion: nil)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeThemeBtnTapped(_ sender: Any) {
        let languageObj =  LanguagePage()
        languageObj.modalPresentationStyle = .fullScreen
        languageObj.viewType = "theme"
        languageObj.selectedLanguage = LocalDefault.shared.theme()! as String
        self.navigationController?.present(languageObj, animated: true, completion: nil)
    }
    
    @IBAction func languageBtnTapped(_ sender: Any) {
        let languageObj =  LanguagePage()
        languageObj.modalPresentationStyle = .fullScreen
        
        languageObj.selectedLanguage = Utility.shared.language()!
        self.navigationController?.present(languageObj, animated: true, completion: nil)
    }
    
    @IBAction func managePaymentBtnTapped(_ sender: Any) {
        //        self.stripeConnect()
        let webObj = WebPage()
        webObj.viewType = "stripe"
        self.navigationController?.pushViewController(webObj, animated: true)
    }
    
    //get stripe information
    func getStripeInfo()  {
        self.stripeURL = STRIPE_URL
//        let Obj = BaseAPI()
//        Obj.getDetails(subURl: "\(PAYMENT_DETAILS_API)/\(LocalDefault.shared.userID() ?? "")", onSuccess: {response in
//            let dict = response.value as! NSDictionary
//            let status_code = dict.value(forKey: "status_code") as! Int
//            self.scrollView.isHidden = false
//            if status_code == 200{
//                self.stripeURL = dict.value(forKey: "stripe_url") as! String
//            }
//
//        })
    }
    func stripeConnect()  {
        let safariViewController = SFSafariViewController(url: URL.init(string: self.stripeURL)!)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("SAFARI COMPLETED")
        // the user may have closed the SFSafariViewController instance before a redirect
        // occurred. Sync with your backend to confirm the correct state
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("url load \(URL)")
    }
    
    
    
}

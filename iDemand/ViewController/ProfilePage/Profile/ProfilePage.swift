//
//  ProfilePage.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MGStarRatingView
import StoreKit
import GoogleMobileAds

class ProfilePage: UIViewController,UITableViewDelegate,UITableViewDataSource,StarRatingDelegate,GADBannerViewDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var menuTableview: UITableView!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var alertPopup: UIView!
    @IBOutlet var alertView: UIView!
    @IBOutlet var alertTitleLbl: UILabel!
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var alertDesLbl: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var ratingView: StarRatingView!
    @IBOutlet var bannerView: GADBannerView!
    let menuArray = NSMutableArray()
    let apiObj = BaseAPI()
    
    var profile:ProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setProfileDetails()
        self.getProfile()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.checkRTL()
        let height = (tabBarController?.tabBar.frame.size.height)!+40
        bannerView.frame.origin.y = FULL_HEIGHT - height
    }
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.profileImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.textAlignment = .right
            self.nameLbl.textAlignment = .right
            self.locationLbl.textAlignment = .right
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
    }
    
    //initial set up
    func initialSetup()  {
        
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //        self.menuTableview.contentInset = UIEdgeInsets.init(top: 40, left: 0, bottom: 0, right: 0)
        menuTableview.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.menuTableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.nameLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .left, text: "")
        self.locationLbl.config(color: TEXT_WHITE_COLOR!, font: subReg, align: .left, text: "")
        self.profileImgView.radius(value: 10)
        self.ratingLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        if !LocalDefault().isUser()! {
            ratingView.isUserInteractionEnabled = false
            ratingView.delegate = self
        }else{
            self.ratingView.isHidden = true
            self.ratingLbl.isHidden = true
        }
        //alert
        self.alertPopup.radius(value: 10)
        self.alertTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        self.alertDesLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.resetBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "yes")
        self.resetBtn.radius(value: 5)
        self.resetBtn.backgroundColor = PRIMARY_COLOR
        self.cancelBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "cancel")
        self.alertView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.alertView)
        
        //menu
        self.addMenu(name: "edit_profile", icon: #imageLiteral(resourceName: "edit_profile"),hint:"hint_edit")
        self.addMenu(name: "my_account_setting", icon: #imageLiteral(resourceName: "tab_profile"),hint:"hint_setting")
        if LocalDefault().isUser()! {
            self.addMenu(name: "my_bookings", icon: #imageLiteral(resourceName: "my_booking"),hint:"hint_bookings")
            self.addMenu(name: "my_needs", icon: #imageLiteral(resourceName: "my_task"),hint:"hint_tasks")
        }else{
            self.addMenu(name: "my_tasks", icon: #imageLiteral(resourceName: "my_booking"),hint:"tasks_hint")
            self.addMenu(name: "my_services", icon: #imageLiteral(resourceName: "my_task"),hint:"hint_services")
            self.addMenu(name: "my_portfolio", icon: #imageLiteral(resourceName: "my_portfolio"),hint:"hint_portfolio")
            self.addMenu(name: "my_certificate", icon: #imageLiteral(resourceName: "my_certificate"),hint:"hint_certificate")
            
        }
        self.addMenu(name: "help", icon: #imageLiteral(resourceName: "help"),hint:"hint_help")
        self.addMenu(name: "invite", icon: #imageLiteral(resourceName: "invite"),hint:"hint_invite")
        self.addMenu(name: "rate_us", icon: #imageLiteral(resourceName: "rate"),hint:"hint_rate")
        self.addMenu(name: "logout", icon: #imageLiteral(resourceName: "logout"),hint:"hint_logout")
        
        //set details
        self.configBanner()

    }
    
    // config banner
    func configBanner()  {
        if ADD_ON {
            self.menuTableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
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
    //menu
    func addMenu(name:String,icon:UIImage,hint:String)  {
        let dict = NSMutableDictionary()
        dict.setValue(name, forKey: "name")
        dict.setValue(icon, forKey: "icon")
        dict.setValue(hint, forKey: "hint")
        
        self.menuArray.add(dict)
        self.menuTableview.reloadData()
    }
    
    @IBAction func imgViewBtnTapped(_ sender: Any) {
        let imgView = ImageViewer()
        imgView.modalPresentationStyle = .fullScreen
        imgView.viewType = "profile"
        imgView.imgUrl = "\(profile.user_image!)"
        self.navigationController?.present(imgView, animated: true, completion: nil)
    }
    //review list
    @IBAction func reviewBtnTapped(_ sender: Any) {
        let reviewObj = ReviewsList()
        reviewObj.viewType = "tasker"
        reviewObj.reviwer_id = LocalDefault.shared.userID()!
        self.navigationController?.pushViewController(reviewObj, animated: true)
    }
    //get profile details
    func getProfile()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            LocalDefault.shared.setUser(data: response.data!)
            self.stopLoading()
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.setProfileDetails()
            }
        })
    }
    //set profile information
    func setProfileDetails()  {
        do{
            let jsonDecoder = JSONDecoder()
            profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            self.nameLbl.text = profile.name
            self.locationLbl.text = profile.email
            let userimgURL = URL.init(string: profile.user_image ?? "")
            self.profileImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            self.locationLbl.adjustsFontSizeToFitWidth = true
            if !LocalDefault().isUser()! {
                self.ratingLbl.text = profile.rating
                let attribute = StarRatingAttribute(type: .half,
                                                    point: 18,
                                                    spacing: 0.5,
                                                    emptyColor: SENDER_INNER_BG!,
                                                    fillColor: PRIMARY_COLOR!,
                                                    emptyImage: nil,
                                                    fillImage: nil)
                if profile.rating != nil {
                    ratingView.configure(attribute, current: CGFloat((profile.rating! as NSString).floatValue), max: 5)
                }
                
            }
        }catch{
        }
    }
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat) {
        print("rating value \(value)")
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.alertView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
        },  completion: {(_ completed: Bool) -> Void in
            self.alertView.isHidden = true
        })
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        var api_name = String()
        if alertView.tag == 1{
            if LocalDefault().isUser()!{
                api_name = USER_LOGOUT_API
            }else{
                api_name = TASKER_LOGOUT_API
            }
        }else{
            if LocalDefault().isUser()!{
                api_name = USER_DEACTIVATE_API
            }else{
                api_name = TASKER_DEACTIVATE_API
            }
        }
        apiObj.baseService(subURl: api_name, params: requestDict as? Parameters, onSuccess: {response in
            let responseDict = response.value as! NSDictionary
            let status_code = responseDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                LocalDefault.shared.logOut()
            }
        })
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let menuDict = self.menuArray.object(at: indexPath.row) as! NSDictionary
        let menu_name = Utility.shared.Json().value(forKey: menuDict.value(forKey: "name") as! String) as! String
        cell.menuNameLbl.text = menu_name
        cell.menuIcon.image = (menuDict.value(forKey:"icon") as! UIImage)
        cell.hintLbl.text = (Utility.shared.Json().value(forKey: menuDict.value(forKey: "hint") as! String) as! String)
        let logout = Utility.shared.Json().value(forKey: "logout") as! String
        if logout == menu_name{
            cell.menuNameLbl.textColor = PRIMARY_COLOR
        }else{
            cell.menuNameLbl.textColor = TEXT_BLACK_COLOR
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuDict = self.menuArray.object(at: indexPath.row) as! NSDictionary
        let menu_name = menuDict.value(forKey: "name") as! String
        
        if menu_name == "edit_profile" {
            let editObj = EditProfile()
            editObj.informationUpdated = {
                self.getProfile()
            }
            self.navigationController?.pushViewController(editObj, animated: true)
        }else if menu_name == "my_bookings" || menu_name == "my_tasks" {
            let bookingObj = TabPager()
            bookingObj.viewType = "my_bookings"
            self.navigationController?.pushViewController(bookingObj, animated: true)
        }else if menu_name == "my_needs" {
            let needObj = MyNeeds()
            self.navigationController?.pushViewController(needObj, animated: true)
        }else if menu_name == "my_services" {
            let serviceObj = MyServicesCategory()
            self.navigationController?.pushViewController(serviceObj, animated: true)
        }else if menu_name == "my_portfolio"{
            let portfolioObj = PortfolioPage()
            portfolioObj.viewType = "profile"
            self.navigationController?.pushViewController(portfolioObj, animated: true)
        }else if menu_name == "my_certificate"{
            let certObj = CertificatePage()
            certObj.viewType = "profile"
            //            certObj.viewType = "profile"
            self.navigationController?.pushViewController(certObj, animated: true)
        } else if menu_name == "help" {
            let helpObj = HelpPage()
            self.navigationController?.pushViewController(helpObj, animated: true)
        }else if menu_name == "my_account_setting" {
            let settingObj = AccountSetting()
            self.navigationController?.pushViewController(settingObj, animated: true)
        }else if menu_name == "invite" {
            self.inviteFriends()
        }else if menu_name == "rate_us" {
            self.rateApp()
        }else if menu_name == "logout" {
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "logout"
            self.navigationController?.present(alertObj, animated: false, completion: nil)
        }
    }
    
    //rate us
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "http://onelink.to/t6fpv9") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //share link to friends
    func inviteFriends()  {
        let appDefault = LocalDefault.shared.appDefaults()

        let invite_link = NSURL(string: appDefault?.value(forKey: "invite_link") as! String)
        let inviteContent = Utility.shared.Json().value(forKey: "invite_description")
        guard let url = invite_link else {
            print("nothing found")
            return
        }
        let shareItems:Array = [inviteContent,url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems as [Any], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

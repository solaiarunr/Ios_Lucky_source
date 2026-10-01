//
//  TaskerDashboard.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
import GoogleMobileAds
import CoreLocation

class TaskerDashboard: UIViewController,GADBannerViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var scrollIcon: UIImageView!
    @IBOutlet var navigationview: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var topScrollView: UIScrollView!
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var earnsLbl: UILabel!
    @IBOutlet var taskScrollView: UIScrollView!
    @IBOutlet var upcomingLbl: UILabel!
    @IBOutlet var viewAllBtn: UIButton!
    @IBOutlet var chartView: LineChart!
    @IBOutlet var waitTitleLbl: UILabel!
    @IBOutlet var waitingView: UIView!
    @IBOutlet var waitingDesLbl: UILabel!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var notficationBtn: UIButton!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var sortBtn: UIButton!
    @IBOutlet var noView: UIView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet var paymentBtn: UIButton!
    let locationManager = CLLocationManager()
    var taskPadding = 15
    var dataModel:TaskModel?
    var upcomings:[Upcoming]?
    var isUpdate = true
    let UPDATE_INTERVAL = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
        if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
            self.chartView.backgroundColor = UIColor.clear
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.basicInfoUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,name: UIApplication.didBecomeActiveNotification,object: nil)
    }
    //basic information update
    func basicInfoUpdate() {
        self.notificationRedirection()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        Utility.shared.updateProfile()
        if LocalDefault.shared.userInfo() != nil{
            self.checkApprovedStatus()
        }else{
            self.waitingView.isHidden = true
            self.containerScrollView.isScrollEnabled = true
        }
        self.updateTheme()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.logo.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.notficationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.earnsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.upcomingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.viewAllBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.upcomingLbl.textAlignment = .right
            self.viewAllBtn.contentHorizontalAlignment = .left
            self.earnsLbl.textAlignment = .right
            self.titleLbl.textAlignment = .right
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationview.bottomRadius()
        let height = (tabBarController?.tabBar.frame.size.height)!+50
        bannerView.frame.origin.y = FULL_HEIGHT - height
    }
    //initial set up
    func initialSetup()  {
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.paymentBtn.isHidden = true
        self.loader.color = PRIMARY_COLOR
        self.navigationview.backgroundColor = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .left, text: "dashboard")
        self.earnsLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "earns")
        self.upcomingLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "upcoming_task")
        self.viewAllBtn.config(color: PRIMARY_COLOR!, font: smallReg, align: .right, title:"view_all")
        self.paymentBtn.config(color: PRIMARY_COLOR!, font: smallReg, align: .center, title:"click_here")
        
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .center, text: "no_statistics_found")
        
        self.scrollIcon.image = #imageLiteral(resourceName: "arrow")
        self.noView.isHidden = true
        self.containerScrollView.isHidden = true
        self.loader.startAnimating()
        self.getDetails()
        self.containerScrollView.contentInsetAdjustmentBehavior = .never
        self.addPullDownRefresh()
        self.checkRTL()
        Utility.shared.updateDeviceToken()
        if LocalDefault.shared.hint() != nil{
            if LocalDefault.shared.hint() == "true"{
                DispatchQueue.main.async {
                    let alertObj = AlertPage()
                    alertObj.modalPresentationStyle = .overCurrentContext
                    alertObj.viewType = "admin"
                    alertObj.deleteRequest = {
                    }
                    self.navigationController?.present(alertObj, animated: false, completion: nil)
                }
            }
        }
        self.configBanner()
        self.basicInfoUpdate()
    }
    //add pull down
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.containerScrollView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getDetails()
        }
    }
    
    // config banner
    func configBanner()  {
        if ADD_ON {
            self.containerScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
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
    //check tasker is verified user
    func checkApprovedStatus()  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            self.paymentBtn.isHidden = true
            
            if profile.payment_verified == "false"{
                self.paymentBtn.isHidden = false
                self.waitTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .center, text: "payment_details")
                self.waitingDesLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "add_payment_hint")
                self.waitingView.isHidden = false
                self.containerScrollView.isScrollEnabled = false
            }
//            else if profile.profile_verified == "false"{
//                self.waitTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .center, text: "waiting_for_admin_approval")
//                self.waitingDesLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "waiting_des")
//                self.waitingView.isHidden = false
//                self.containerScrollView.isScrollEnabled = false
//            }
            else{
                self.waitingView.isHidden = true
                self.containerScrollView.isScrollEnabled = true
            }
        }catch{
        }
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        let notifyObj = NotificationPage()
        self.navigationController?.pushViewController(notifyObj, animated: true)
    }
    
    @IBAction func paymentBtnTapped(_ sender: Any) {
        let webObj = WebPage()
        webObj.viewType = "stripe"
        self.navigationController?.pushViewController(webObj, animated: true)
    }
    
    @IBAction func sortBtnTapped(_ sender: Any) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style: .cancel) { action -> Void in
        }
        action.addAction(cancelAction)
        
        // Create and add first option action
        let weekly = UIAlertAction(title: (Utility.shared.Json().value(forKey: "weekly") as! String), style: .default) { action -> Void in
            self.configGraphView(datas:(self.dataModel?.earn?.week)!)
            
        }
        action.addAction(weekly)
        
        // Create and add a second option action
        let monthly = UIAlertAction(title: (Utility.shared.Json().value(forKey: "monthly") as! String), style: .default) { action -> Void in
            self.configGraphView(datas:(self.dataModel?.earn?.month)!)
            
        }
        action.addAction(monthly)
        
        // Present the AlertController
        self.present(action, animated: true, completion: nil)
    }
    
    
    //get details
    func getDetails()  {
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            Obj.getDetails(subURl: "\(TASKER_DASHBOARD_API)/\(LocalDefault.shared.userID()!)", onSuccess: {response in
                do{
                    let jsonDecoder = JSONDecoder()
                    self.dataModel = try jsonDecoder.decode(TaskModel.self, from: response.data!)
                    if self.dataModel?.status_code == 200{
                        self.taskPadding = 15
                        self.configTaskInfo(model: self.dataModel!)
                        if self.dataModel?.total_completed == "0"{
                            self.noView.isHidden = false
//                            modified-AR
                            self.noView.backgroundColor = BACKGROUND_COLOR
                            self.sortBtn.isHidden = true
                            self.earnsLbl.isHidden = true
                        }else{
                            self.configGraphView(datas:(self.dataModel?.earn?.week)!)
                            self.noView.isHidden = true
                            self.sortBtn.isHidden = false
                            self.earnsLbl.isHidden = false
                        }
                        if self.dataModel?.upcoming?.count == 0{
                            self.upcomingLbl.isHidden = true
                            self.viewAllBtn.isHidden = true
                        }else{
                            self.upcomingLbl.isHidden = false
                            self.viewAllBtn.isHidden = false
                            self.upcomings = self.dataModel?.upcoming
                            self.config(tasks: (self.dataModel?.upcoming)!)
                        }
                        
                    }
                    self.containerScrollView.isHidden = false
                    self.loader.stopAnimating()
                    self.containerScrollView.fty.pullToRefresh.end()
                }catch{
                    self.loader.stopAnimating()
                }
            })
        }
    }
    //dashboard item
    func configTaskInfo(model:TaskModel)  {
        let subviews = self.topScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        let appDefault = LocalDefault.shared.appDefaults()
        let currency_symbol = appDefault?.value(forKey: "currency_symbol") as! String
        self.addTask(name: "total_task", count: model.total_task!, color:#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        self.addTask(name: "accepted_task", count: model.upcoming_task!, color:#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        self.addTask(name: "total_earnings", count: "\(currency_symbol) \(model.total_earnings!)", color:#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        self.addTask(name: "total_completed", count: model.total_completed!, color:#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        
    }
    func addTask(name:String,count:String,color:UIColor)  {
        let width = 170
        print("width \(width)")
        let cardView = MDCCard()
        cardView.frame = CGRect.init(x: Int(taskPadding), y: 10, width: width, height: 90)
        cardView.elevation(radius: 15.0)
        cardView.backgroundColor = BACKGROUND_COLOR
        self.topScrollView.addSubview(cardView)
        
        let dotLbl = UILabel()
        dotLbl.frame = CGRect.init(x: 15, y: 17.5, width: 15, height: 15)
        dotLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "•")
        dotLbl.font = subBold
        dotLbl.radius(value: 7.5)
        dotLbl.backgroundColor = color
        cardView.addSubview(dotLbl)
        
        let taskLbl = UILabel()
        taskLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: name)
        taskLbl.frame = CGRect.init(x: 40, y: 0, width: width-60, height: 50)
        taskLbl.numberOfLines = 2
        cardView.addSubview(taskLbl)
        
        let priceLbl = UILabel()
        priceLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        priceLbl.text = count
        priceLbl.frame = CGRect.init(x: 15, y: 50, width: width-60, height: 30)
        priceLbl.adjustsFontSizeToFitWidth = true
        cardView.addSubview(priceLbl)
        
        if Utility.shared.isRTL(){
            taskLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            priceLbl.textAlignment = .right
            taskLbl.textAlignment = .right
        }
        
        taskPadding += (Int(width)+10)
//        let top = (self.navigationview.frame.size.height - 60)
//        self.topScrollView.frame = CGRect.init(x: 0, y: Int(top), width: Int(FULL_WIDTH), height: 120)
        self.topScrollView.contentSize = CGSize.init(width: taskPadding, height: 50)
        
    }
    //config graph view
    func configGraphView(datas:[chart_data])  {
        var result: [PointEntry] = []
        for model in datas {
            let earns = model.earns! as NSString
            result.append(PointEntry(value: earns.integerValue, label: model.duration!))
        }
        chartView.backgroundColor = BACKGROUND_COLOR
        chartView.showDots = false
        chartView.dataEntries = result
        chartView.isCurved = true
        
    }
    
    
    //recent task
    func config(tasks:[Upcoming])  {
        var leftPadding = 20
        let item_width = 270
        var index = 0
        
        self.clearAllViews()
        for recent in tasks {
            let containerView = MDCCard()
            containerView.frame = CGRect.init(x: leftPadding, y: 5, width: item_width, height: 150)
            containerView.elevation(radius: 15.0)
            containerView.backgroundColor = BACKGROUND_COLOR
            
            self.taskScrollView.addSubview(containerView)
            
            let serviceView = MDCCard()
            serviceView.frame = CGRect.init(x: 0, y: 0, width: item_width, height: 100)
            serviceView.elevation(radius: 15.0)
            serviceView.setShadowElevation(.lite, for: .normal)
            serviceView.backgroundColor = POPUP_COLOR
            
            containerView.addSubview(serviceView)
            
            let serviceNameLbl = UILabel()
            serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
            serviceNameLbl.frame = CGRect.init(x: 15, y: 20, width:160 , height: 30)
            serviceNameLbl.text = recent.item_name
            serviceView.addSubview(serviceNameLbl)
            
            let priceNameLbl = UILabel()
            priceNameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
            priceNameLbl.frame = CGRect.init(x: 15, y: 50, width:160 , height: 30)
            let appDefault = LocalDefault.shared.appDefaults()
            let currency_symbol = appDefault?.value(forKey: "currency_symbol") as! String
            
            priceNameLbl.text = "\(currency_symbol) \(recent.price!)"
            serviceView.addSubview(priceNameLbl)
            
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: item_width-80, y: 27, width:65 , height: 45)
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            imgView.backgroundColor = LINE_COLOR
            let userimgURL = URL.init(string: recent.item_image!)
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            serviceView.addSubview(imgView)
            
            let desLbl = UILabel()
            desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            desLbl.frame = CGRect.init(x: 15, y: 100, width:item_width-15 , height: 50)
            desLbl.numberOfLines = 2
            desLbl.text = recent.description
            containerView.addSubview(desLbl)
            leftPadding += Int(item_width+20)
            
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: 0, y: 0, width: item_width, height: 150)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.bookingDetailsTapped(_:)), for: .touchUpInside)
            containerView.addSubview(imageBtn)
            
            if Utility.shared.isRTL(){
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                priceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                
                priceNameLbl.textAlignment = .right
                serviceNameLbl.textAlignment = .right
                desLbl.textAlignment = .right
                
            }
            index += 1
            
            self.taskScrollView.contentSize = CGSize.init(width: leftPadding, height: 160)
            if !UIDevice.current.hasNotch {
                self.containerScrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.taskScrollView.frame.origin.y+400)
            }
        }
    }
    
    //go to bookingDetails
    @objc func bookingDetailsTapped(_ sender: UIButton){
        let model = self.upcomings![sender.tag]
        let detailObj = TaskerBookingDetails()
        detailObj.bookingID = model.item_id!
        detailObj.refreshRequest = {
        }
        self.navigationController!.pushViewController(detailObj, animated: true)
    }
    func clearAllViews()  {
        let subviews = self.taskScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func viewAllBtnTapped(_ sender: Any) {
        let bookingObj = TabPager()
        bookingObj.viewType = "my_bookings"
        self.navigationController?.pushViewController(bookingObj, animated: true)
    }
    
    //notfication redirection
    func notificationRedirection()  {
        print("redirection type 1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            
            if LocalDefault.shared.notifcationType() != nil{
                print("redirection type 2 \(LocalDefault.shared.notifcationType() ?? "")")
                if LocalDefault.shared.notifcationType() == "chat"{
                    let Obj = BaseAPI()
                    let request = NSMutableDictionary()
                    request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
                    request.setValue(LocalDefault.shared.notificationID(), forKey: "chat_id")
                    Obj.baseService(subURl: TASKER_CHAT_INFO, params: request as? Parameters, onSuccess: {response in
                        let responseDict = response.value as! NSDictionary
                        let status_code = responseDict.value(forKey: "status_code") as! Int
                        if status_code == 200{
                            let detailObj = MessageDetails()
                            detailObj.chatDict =  responseDict
                            detailObj.receiverID =  responseDict.value(forKey: "user_id") as! String
                            detailObj.chatID =  responseDict.value(forKey: "chat_id") as! String
                            detailObj.viewType = "chat"
                            detailObj.bookingID =  responseDict.value(forKey: "booking_id") as! String
                            detailObj.refreshChat = {
                            }
                            self.navigationController?.pushViewController(detailObj, animated: true)
                            LocalDefault.shared.clearNotification()
                        }
                    })
                }
                else if LocalDefault.shared.notifcationType() == "text"{
                    let detailObj = NotificationPage()
                    self.navigationController?.pushViewController(detailObj, animated: true)
                    LocalDefault.shared.clearNotification()
                    
                }
                else if LocalDefault.shared.notifcationType() == "admin"{
                    let detailObj = MessageDetails()
                    detailObj.chatType = "admin"
                    detailObj.viewType = "chat"
                    detailObj.refreshChat = {
                    }
                    self.navigationController?.pushViewController(detailObj, animated: true)
                    LocalDefault.shared.clearNotification()
                    
                }else if LocalDefault.shared.notifcationType() == "booking"{
                    
                    let detailObj = TaskerBookingDetails()
                    detailObj.bookingID = LocalDefault.shared.notificationID()!
                    detailObj.refreshRequest = {
                    }
                    self.navigationController!.pushViewController(detailObj, animated: true)
                    LocalDefault.shared.clearNotification()
                    
                }else if LocalDefault.shared.notifcationType() == "review"{
                    let reviewObj = ReviewsList()
                    reviewObj.viewType = "tasker"
                    reviewObj.reviwer_id = LocalDefault.shared.userID()!
                    self.navigationController?.pushViewController(reviewObj, animated: true)
                    LocalDefault.shared.clearNotification()
                    
                }
            }
        }
    }
    
    
    //MARK: LOCATION
    @objc func applicationDidBecomeActive() {
        if LocalDefault.shared.isLiveTrack()! {
            //modified-AR
            self.getLocationPermission()
        }
    }
    //location permission
    func getLocationPermission()  {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        var isLocationActive = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                isLocationActive = true
                break
            case .restricted:
                isLocationActive = false
                break
            case .denied:
                isLocationActive = false
                break
            case .authorizedAlways:
                isLocationActive = true
                break
            case .authorizedWhenInUse:
                isLocationActive = true
                break
            @unknown default:
                break
            }
        }
        if isLocationActive {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = true
        }else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Utility.shared.Json().value(forKey: "alert") as? String, message: Utility.shared.Json().value(forKey: "location_permission_denied") as? String, preferredStyle: UIAlertController.Style.alert)
                //settings
                alert.addAction(UIAlertAction(title: Utility.shared.Json().value(forKey: "settings") as? String, style: .default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    //location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //        if isUpdate{
        //            isUpdate = false
        DispatchQueue.main.asyncAfter(deadline: .now() + UPDATE_INTERVAL) {
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            self.getAddress(lat: locValue.latitude, lon:locValue.longitude)
        }
        //        }
    }
    //get full address
    func getAddress(lat: Double,lon: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail")
                                        }
                                        if placemarks != nil{
                                            let pm = placemarks! as [CLPlacemark]
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                var addressString : String = ""
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }
                                                //                                                Utility.shared.customToast(msg: addressString)
                                                print(addressString)
                                                let locationDict = NSMutableDictionary()
                                                locationDict.setValue("postLocation", forKey: "type")
                                                locationDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
                                                locationDict.setValue(addressString, forKey: "location")
                                                locationDict.setValue(lat, forKey: "lat")
                                                locationDict.setValue(lon, forKey: "lon")
                                                SocketClass.sharedInstance.send(msg: locationDict)
                                                self.isUpdate = true
                                            }
                                        }
                                    })
    }
}

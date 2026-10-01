//
//  HomePage.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
import GoogleMobileAds
import GoogleMaps

class HomePage: UIViewController,UITableViewDelegate,UITableViewDataSource,bannerDelegate,serviceDelegate,featureCatDelegate,GADBannerViewDelegate,recentDelegate, CLLocationManagerDelegate {
    
    var homeArray = NSMutableArray()
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var homeTableView: UITableView!
    @IBOutlet var floatingView: MDCCard!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var notificationBtn: UIButton!
    @IBOutlet var noView: UIView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var bannerView: GADBannerView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loader.startAnimating()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.initialSetup()
        self.checkRTL()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.notificationRedirection()
        self.updateTheme()
        if self.homeArray.count != 0 {
            homeTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        if !UIDevice.current.hasNotch{
            self.floatingView.frame.origin.y = FULL_HEIGHT - 125
        }
        let height = (tabBarController?.tabBar.frame.size.height)!+40
        bannerView.frame.origin.y = FULL_HEIGHT - height
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.notificationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.logo.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    //config initial information
    func initialSetup()  {
        self.configLocationManager()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.homeTableView.register(UINib(nibName: "HomeBannerCell", bundle: nil), forCellReuseIdentifier: "HomeBannerCell")
        self.homeTableView.register(UINib(nibName: "recentTaskCell", bundle: nil), forCellReuseIdentifier: "recentCell")
        self.homeTableView.register(UINib(nibName: "HomeServiceCell", bundle: nil), forCellReuseIdentifier: "HomeServiceCell")
        self.homeTableView.register(UINib(nibName: "HomeRecentCell", bundle: nil), forCellReuseIdentifier: "HomeRecentCell")
        self.homeTableView.register(UINib(nibName: "FeaturedCategoryCell", bundle: nil), forCellReuseIdentifier: "FeaturedCategoryCell")
        self.homeTableView.register(UINib(nibName: "mapViewTableViewCell", bundle: nil), forCellReuseIdentifier: "mapVIewCell")
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_information_found")
        self.noView.isHidden = true
        self.loader.color = PRIMARY_COLOR
        self.getDetails(offset: "0")
        self.addPullDownRefresh()
        self.floatingView.backgroundColor = PRIMARY_COLOR
        self.floatingView.elevation(radius: 30)
        Utility.shared.updateDeviceToken()
        self.configBanner()
    }
    //config location manager
    func configLocationManager(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.appDelegate?.current_lat = locationManager.location?.coordinate.latitude ?? 0
        self.appDelegate?.current_lon = locationManager.location?.coordinate.longitude ?? 0
    }
    // config banner
    func configBanner(){
        if ADD_ON {
            self.homeTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
            bannerView.adUnitID = BANNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }else{
            bannerView.isHidden = true
        }
    }
    //    / Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.view.bringSubviewToFront(self.floatingView)
    }
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.homeTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getDetails(offset: "0")
        }
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        let notifyObj = NotificationPage()
        self.navigationController?.pushViewController(notifyObj, animated: true)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        let searchObj = CategorySearch()
        self.navigationController?.pushViewController(searchObj, animated: true)
    }
    
    //get details
    func getDetails(offset:String)  {
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            Obj.baseService(subURl: USER_HOME_API, params: request as? Parameters, onSuccess: {response in
                var responseDict = NSDictionary()
                responseDict = response.value  as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.homeArray.removeAllObjects()
                    self.homeTableView.reloadData()
                    let bannerArray = responseDict.value(forKey: "banner_items") as! NSArray
                    let categoryArray = responseDict.value(forKey: "category_items") as! NSArray
                    let recentArray = responseDict.value(forKey: "recent_items") as! NSArray
                    let featureCategoryArray = responseDict.value(forKey: "feature_items") as! NSArray
                    if bannerArray.count != 0 {
                        let dict = NSMutableDictionary()
                        dict.setValue("banner", forKey: "type")
                        dict.setValue(bannerArray, forKey: "items")
                        self.homeArray.add(dict)
                 
                    }
                    if categoryArray.count != 0 {
                        let dict = NSMutableDictionary()
                        dict.setValue("category", forKey: "type")
                        dict.setValue(categoryArray, forKey: "items")
                        self.homeArray.add(dict)
                    }
                    if recentArray.count != 0 {
                        let dict = NSMutableDictionary()
                        dict.setValue("task", forKey: "type")
                        dict.setValue(recentArray, forKey: "items")
                        self.homeArray.add(dict)
                    }
                    if featureCategoryArray.count != 0 {
                        for feature in featureCategoryArray {
                            let featureDict = feature as! NSDictionary
                            let array = featureDict.value(forKey: "items") as! NSArray
                            let dict = NSMutableDictionary.init(dictionary: featureDict)
                            dict.setValue("feature_category", forKey: "type")
                            if array.count != 0{
                                self.homeArray.add(dict)
                            }
                        }
                    }
                    
                    if bannerArray.count == 0 && categoryArray.count == 0 && recentArray.count == 0 && featureCategoryArray.count == 0{
                        self.noView.isHidden = false
                    }else{
                        self.noView.isHidden = true
                    }
                    
                    self.homeTableView.reloadData()
                    self.homeTableView.fty.pullToRefresh.end()
                    
                }
                self.loader.stopAnimating()
            })
        }
        
    }
    
    //mark: tableview deleagate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return homeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0{
            let map_cell = tableView.dequeueReusableCell(withIdentifier: "mapVIewCell") as! mapViewTableViewCell
            map_cell.selectionStyle = .none
            if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
                do {
                    // Set the map style by passing the URL of the local file.
                    if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                        map_cell.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            } else{
                map_cell.mapView.mapStyle = nil
            }
            map_cell.mapViewBtn.addTarget(self, action: #selector(mapBtnTapped(sender:)), for: .touchUpInside)
            if appDelegate?.current_lat != 0{
                map_cell.mapView.camera = GMSCameraPosition(latitude: appDelegate?.current_lat ?? 0 , longitude: appDelegate?.current_lon ?? 0 , zoom: 15)
            }

            cell = map_cell
        }
        else{
            let homeDict = self.homeArray.object(at: indexPath.row) as! NSDictionary
            let type = homeDict.value(forKey: "type") as! String
            if type == "banner" {
//                let bannerCell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerCell") as! HomeBannerCell
//                bannerCell.delegate = self
//                let bannerArray = homeDict.value(forKey: "items") as! NSArray
//                bannerCell.config(banners: bannerArray)
//                cell = bannerCell
            }
            else if type == "task" {
                let recentCell = tableView.dequeueReusableCell(withIdentifier: "HomeRecentCell") as! HomeRecentCell
                let recent = homeDict.value(forKey: "items") as! NSArray
                recentCell.config(recents: recent)
                recentCell.viewAllBtn.addTarget(self, action: #selector(self.viewAllRecents), for: .touchUpInside)
                recentCell.delegate = self
                cell = recentCell
            }
            else if type == "category" {
                let categoryCell = tableView.dequeueReusableCell(withIdentifier: "HomeServiceCell") as! HomeServiceCell
                let categories = homeDict.value(forKey: "items") as! NSArray
                categoryCell.config(services:categories)
                categoryCell.viewAllBtn.tag = indexPath.row
                categoryCell.viewAllBtn.addTarget(self, action: #selector(self.viewAllCategory), for: .touchUpInside)
                
                categoryCell.delegate = self
                cell = categoryCell
                
            } else if type == "feature_category"{
                let serviceCell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCategoryCell") as! FeaturedCategoryCell
                serviceCell.config(featureCategory: homeDict)
                serviceCell.viewAllBtn.tag = indexPath.row
                serviceCell.viewAllBtn.addTarget(self, action: #selector(self.viewAllSubCategory), for: .touchUpInside)
                serviceCell.delegate = self
                cell = serviceCell
            }
        }
        return cell
        }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if indexPath.section == 0{
            if IS_IPHONE_678 {
                height = 300//215
            }else{
                height = (self.view.frame.size.height - 450)
            }
            
        }
        else{
            let homeDict = self.homeArray.object(at: indexPath.row) as! NSDictionary
            let type = homeDict.value(forKey: "type") as! String
            if type == "banner" {
//                height = 215
                height = 0
            }else if type == "task" {
//                height = 225
                height = 0
            }else if type == "category" {
                let item_width = (FULL_WIDTH/3)-10
                let item_height = ((item_width/3)*2)-15
                height = item_height+100
            }else {
                let item_width = ((FULL_WIDTH/3))-20
                height = item_width+80
            }
        }
        return height
    }
    //redirect to cluster map tabbar
    @objc func mapBtnTapped(sender:UIButton){
        self.appDelegate?.tabbarSelectedIndex = 1
        self.appDelegate?.setInitialViewController()
    }
    //view all recent tasks
    @objc func viewAllRecents()  {
        print("view all recent")
        let bookingObj = TabPager()
        bookingObj.viewType = "my_bookings"
        self.navigationController?.pushViewController(bookingObj, animated: true)
    }
    //view all service
    @objc func viewAllSubCategory(sender:UIButton)  {
        let homeDict = self.homeArray.object(at: sender.tag) as! NSDictionary
        
        let subCatObj = subCategoryPage()
        subCatObj.parent_cat_id = homeDict.value(forKey: "item_id") as! String
        subCatObj.parent_cat_name = homeDict.value(forKey: "item_name") as! String
        subCatObj.parent_cat_type = homeDict.value(forKey: "item_type") as! String
        subCatObj.location_type = homeDict.value(forKey: "location_type") as! String
        
        self.navigationController?.pushViewController(subCatObj, animated: true)
        
    }
    //view all cateogry
    @objc func viewAllCategory(sender:UIButton)  {
        //qwerty
        //  self.tabBarController?.selectedIndex = 1
        let CategoryObj = CategoryPage()
        self.navigationController?.pushViewController(CategoryObj, animated: true)
        
    }
    //banner tap delegate
    func bannerTapped(cell: HomeBannerCell, index: Int) {
        
        let indexPath = self.homeTableView.indexPath(for: cell)
        let homeDict = self.homeArray.object(at: indexPath!.row) as! NSDictionary
        let itemsArray = homeDict.value(forKey: "items") as! NSArray
        let bannerDict = itemsArray.object(at: index) as! NSDictionary
        
        print("view all service \(homeDict) banner \(bannerDict)")
        
        
        guard let url = URL(string: bannerDict.value(forKey: "item_link") as! String) else { return }
        UIApplication.shared.open(url)
    }
    
    //service tap delegate
    
    func featureCategoryTapped(cell: FeaturedCategoryCell, index: Int) {
        let indexPath = self.homeTableView.indexPath(for: cell)
        let homeDict = self.homeArray.object(at: indexPath!.row) as! NSDictionary
        let itemsArray = homeDict.value(forKey: "items") as! NSArray
        let serviceDict = itemsArray.object(at: index) as! NSDictionary
//qwerty
//        let serviceObj = ServiceListPage()
//        serviceObj.parent_cat_id = homeDict.value(forKey: "item_id") as! String
//        serviceObj.parent_cat_name = homeDict.value(forKey: "item_name") as! String
//        serviceObj.parent_cat_type = homeDict.value(forKey: "item_type") as! String
//        serviceObj.sub_cat_id = serviceDict.value(forKey: "item_id") as! String
//        serviceObj.sub_cat_name = serviceDict.value(forKey: "item_name") as! String
//        serviceObj.location_type = homeDict.value(forKey: "location_type") as! String
//
//        self.navigationController?.pushViewController(serviceObj, animated: true)
        
        let needObj = PostNeeds()
        needObj.parent_cat_id = homeDict.value(forKey: "item_id") as! String
        needObj.parent_cat_name = homeDict.value(forKey: "item_name") as! String
        needObj.parent_cat_type = homeDict.value(forKey: "item_type") as! String
        needObj.sub_cat_id = serviceDict.value(forKey: "item_id") as! String
        needObj.sub_cat_name = serviceDict.value(forKey: "item_name") as! String
        needObj.location_type = homeDict.value(forKey: "location_type") as! String
        self.navigationController?.pushViewController(needObj, animated: true)

    }
    
    //category tap delegate
    func categoryTapped(cell: HomeServiceCell, index: Int) {
        
        let indexPath = self.homeTableView.indexPath(for: cell)
        let homeDict = self.homeArray.object(at: indexPath!.row) as! NSDictionary
        let itemsArray = homeDict.value(forKey: "items") as! NSArray
        let serviceDict = itemsArray.object(at: index) as! NSDictionary
        let subCatObj = subCategoryPage()
        subCatObj.parent_cat_id = serviceDict.value(forKey: "item_id") as! String
        subCatObj.parent_cat_name = serviceDict.value(forKey: "item_name") as! String
        subCatObj.parent_cat_type = serviceDict.value(forKey: "item_type") as! String
        subCatObj.location_type = serviceDict.value(forKey: "location_type") as! String
        
        self.navigationController?.pushViewController(subCatObj, animated: true)
        print(homeDict)
    }
    
    @IBAction func addNeedBtnTapped(_ sender: Any) {
        LocalDefault.shared.removeCategory()
        let needObj = PostNeeds()
        needObj.viewFrom = "home"
        self.navigationController?.pushViewController(needObj, animated: true)
    }
    func recentTaskAct(cell: HomeRecentCell, index: Int) {
        let indexPath = self.homeTableView.indexPath(for: cell)
        let homeDict = self.homeArray.object(at: (indexPath?.row ?? 0)) as! NSDictionary
        let itemsArray = homeDict.value(forKey: "items") as! NSArray
        let serviceDict = itemsArray.object(at: index) as! NSDictionary
        
        let detailObj = BookingDetails()
        detailObj.bookingID = serviceDict.value(forKey: "item_id") as! String
        detailObj.refreshRequest = {
        }
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navigationController!.pushViewController(detailObj, animated: true)
    }
    //notfication redirection
    func notificationRedirection()  {
        if LocalDefault.shared.notifcationType() != nil{
            if LocalDefault.shared.notifcationType() == "chat"{
                let Obj = BaseAPI()
                let request = NSMutableDictionary()
                request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
                request.setValue(LocalDefault.shared.notificationID(), forKey: "chat_id")
                Obj.baseService(subURl: USER_CHAT_INFO, params: request as? Parameters, onSuccess: {response in
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
                let detailObj = BookingDetails()
                detailObj.bookingID = LocalDefault.shared.notificationID()!
                detailObj.refreshRequest = {
                }
                self.navigationController!.pushViewController(detailObj, animated: true)
                LocalDefault.shared.clearNotification()
            }
        }
    }
}

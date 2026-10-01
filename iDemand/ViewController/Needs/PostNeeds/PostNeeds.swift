//
//  PostNeeds.swift
//  iDemand
//
//  Created by Roby on 23/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleMobileAds
import CoreLocation

class PostNeeds: UIViewController,UITextFieldDelegate,UITextViewDelegate,FUIAuthDelegate,GADBannerViewDelegate {
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var categoriesBtn: UIButton!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var desLbl: UILabel!
    @IBOutlet var desTV: UITextView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var pickupView: UIView!
    @IBOutlet var dropView: UIView!
    @IBOutlet var priceView: UIView!
    @IBOutlet var dateSepLbl: UILabel!
    @IBOutlet var destinationLbl: UILabel!
    @IBOutlet var destinationBtn: UIButton!
    
    var locationType = String()
    var datePicker :UIDatePicker!
    var currency_symbol = String()
    var refreshRequest: (() -> Void)?
    var viewType = String()
    var need:Needs?
    var viewFrom = String()
    var isDateChoosed = false
    var sourceLat = Double()
    var sourceLon = Double()
    var dropLat = Double()
    var dropLon = Double()
    var distance = Double()
    var source_location = String()
    
    // Phase 1
    var parent_cat_id = String()
    var parent_cat_name = String()
    var location_type = String()
    var parent_cat_type = String()
    var sub_cat_id = String()
    var sub_cat_name = String()
    
    //qwerty
    var already_active = String()
    
    @IBOutlet var categoryArrowBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            if Utility.shared.isRTL(){
                self.saveBtn.corner(position: .topLeft)
                self.cancelBtn.corner(position: .topRight)
            }else{
                self.cancelBtn.corner(position: .topLeft)
                self.saveBtn.corner(position: .topRight)
            }
            self.navigationView.bottomRadius()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if (LocalDefault.shared.selectedCategory() == nil) && (self.sub_cat_name != ""){
            let dict = NSMutableDictionary()
                dict.setValue("", forKey: "service_id")
                dict.setValue("", forKey: "service_name")
                dict.setValue(self.sub_cat_id, forKey: "sub_cat_id")
                dict.setValue(self.sub_cat_name, forKey: "sub_cat_name")
                dict.setValue(self.parent_cat_id, forKey: "parent_cat_id")
                dict.setValue(self.parent_cat_name, forKey: "parent_cat_name")
                dict.setValue(self.location_type, forKey: "location_type")
                LocalDefault.shared.selectCat(data: dict)
        }
        
        if (LocalDefault.shared.selectedCategory() != nil){
            let dict = LocalDefault.shared.selectedCategory()
            self.categoryLbl.text = dict?.value(forKey: "sub_cat_name") as? String
            locationType = dict?.value(forKey: "location_type") as! String
            self.pickupView.isHidden  = true
            self.dropView.isHidden  = true
            
            if locationType == "home"{
                self.pickupView.isHidden  = false
                self.priceView.frame.origin.y = self.pickupView.frame.origin.y + 56
            }else if locationType == "transport"{
                self.pickupView.isHidden  = false
                self.dropView.isHidden  = false
                self.priceView.frame.origin.y = self.dropView.frame.origin.y + 56
                if Utility.shared.isRTL() {
                    self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, title: "pickup")
                }else{
                    self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "pickup")
                }
            }else{
                self.priceView.frame.origin.y = self.dateSepLbl.frame.origin.y + 1
            }
            
        }
        
        self.addLoader()
        self.updateTheme()
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoriesBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.textAlignment = .right

            self.categoryLbl.textAlignment = .left
            self.categoriesBtn.contentHorizontalAlignment = .right
            self.dateTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateTF.textAlignment = .right
            self.dateLbl.textAlignment = .left
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationBtn.contentHorizontalAlignment = .right
            self.destinationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationLbl.textAlignment = .left
            self.locationLbl.textAlignment = .left
            self.locationBtn.contentHorizontalAlignment = .right            
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.textAlignment = .left
            self.priceTF.textAlignment = .left
            self.priceLbl.textAlignment = .right
            self.nameLbl.textAlignment = .right
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.textAlignment = .right
            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "enter_details_task")
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)

        }else{

            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_details_task")
        }
    }
    
    //config initial setup
    func initialSetup()  {
        LocalDefault.shared.removeCategory()
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "post_yout_needs")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        currency_symbol = appDefault?.value(forKey: "currency_symbol") as! String
        let currency_code = appDefault?.value(forKey: "currency_code") as! String
        
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "task_name")
        if self.viewType == "edit"{
            self.categoriesBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "category")
        }else{
            self.categoriesBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "select_category")
        }
        self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "location")
        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "description")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "price")
        self.destinationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "drop")
        self.nameTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_task_name")
        let payment_minimum_price = appDefault?.value(forKey: "minimum_payment_price") as? Double
        self.priceTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "")
        self.priceTF.placeholder = "\(Utility.shared.Json().value(forKey: "minimum") ?? "") (\(currency_symbol)\(payment_minimum_price!))"
        self.priceTF.adjustsFontSizeToFitWidth = true
        self.currencyLbl.config(color: PRIMARY_COLOR!, font: subReg, align: .right, text: "")
        self.currencyLbl.text = "\(currency_code) - \(currency_symbol)"
        self.currencyLbl.adjustsFontSizeToFitWidth = true
        self.categoryLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.configDatePicker()
        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.locationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.destinationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.cancelBtn.backgroundColor = SECONDARY_COLOR
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        if self.viewType == "edit"{
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "update")
        }
        else{
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "post")
        }
        
        
        self.cancelBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "cancel")
        if viewType == "edit"{
            self.cancelBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "delete")
            self.categoryArrowBtn.isHidden = true
            self.setDetails()
        }

        self.checkRTL()
        self.configBanner()
        self.priceView.frame.origin.y = self.dateSepLbl.frame.origin.y + 1
        self.pickupView.isHidden = true
        self.dropView.isHidden = true
        
        //qwerty
        if already_active == "true"{
            self.saveBtn.isHidden = true
            self.cancelBtn.isHidden = false
        } else {
            self.saveBtn.isHidden = false
            self.cancelBtn.isHidden = false
        }
        
    }
    
    // config banner
    func configBanner(){
        if ADD_ON {
            self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
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
    //set information
    func setDetails()  {
        self.nameTF.text = need?.name
        self.categoryLbl.text = need?.subcategory_name
//        self.dateLbl.text = Utility.shared.toLocal(dateStr: (need?.date)!, format: "dd.MMM.yyyy")
        self.priceTF.text = need?.booking_price
        self.desTV.text = need?.description
        self.dateLbl.text = Utility.shared.toLocal(dateStr: (need?.date)!, format: "dd.MMM.yyyy") ?? ""
        if need?.location_type == "transport"{
            self.locationLbl.text = need?.source_location
            self.destinationLbl.text = need?.dest_location
            if LocalDefault.shared.isLiveTrack()!{
                self.sourceLat = Double("\(need?.source_lat ?? "")")!
                self.sourceLon = Double("\(need?.source_lon ?? "")")!
                self.dropLat = Double("\(need?.dest_lat ?? "")")!
                self.dropLon = Double("\(need?.dest_lon ?? "")")!
            }
        }else if need?.location_type == "home"{
            self.locationLbl.text = self.need?.source_location
            if LocalDefault.shared.isLiveTrack()!{
                self.sourceLat = Double("\(need?.source_lat ?? "")")!
                self.sourceLon = Double("\(need?.source_lon ?? "")")!
            }
        }
        //qwerty
        let dict = NSMutableDictionary()
        dict.setValue("", forKey: "service_id")
        dict.setValue("", forKey: "service_name")
        dict.setValue(need?.subcategory_id, forKey: "sub_cat_id")
        dict.setValue(need?.subcategory_name, forKey: "sub_cat_name")
        dict.setValue(need?.parent_category_id, forKey: "parent_cat_id")
        dict.setValue(need?.parent_category_name, forKey: "parent_cat_name")
        dict.setValue(need?.location_type, forKey: "location_type")
        LocalDefault.shared.selectCat(data: dict)
    }
    
    //config date pick
    func configDatePicker()  {
        self.dateTF.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, place: "")
        self.dateTF.text = (Utility.shared.Json().value(forKey: "date") as! String)
        self.dateTF.tintColor = .clear
        let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        let aftMonth = Calendar.current.date(byAdding: .month, value: 1, to: tomorrow!)
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = tomorrow
        datePicker.maximumDate = aftMonth
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.dateTF.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: (Utility.shared.Json().value(forKey: "done") as! String), style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        self.dateTF.inputAccessoryView = toolBar
    }
    //done
    @objc func datePickerDone() {
        if !isDateChoosed{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MMM.yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            self.dateLbl.text = dateString
        }
        self.dateTF.resignFirstResponder()
    }
    //change action
    @objc func dateChanged() {
        isDateChoosed = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMM.yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        self.dateLbl.text = dateString
    }
    
    //calculate percent
    public func get(value:Double,percent:Double)->Double{
        let val = value * percent
        return val / 100.00
    }
    
    @IBAction func categoryBtnTapped(_ sender: Any) {
        print("called ")

        if self.viewType != "edit"{
            LocalDefault.shared.setView(from: "choose")
            let categoryObj = CategoryPage()
            self.navigationController?.pushViewController(categoryObj, animated: true)
        }
    }
    //go back
    @IBAction func backBtnTapped(_ sender: Any) {
        LocalDefault.shared.setView(from: "")
        //qwerty
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    //choose location
    @IBAction func locationBtnTapped(_ sender: Any) {
        if LocalDefault.shared.isLiveTrack()!{
            let locationObj = MapPage()
            locationObj.modalPresentationStyle = .fullScreen
            //modified-AR
            locationObj.viewType = self.viewType
            //modified-AR
            if viewType == "edit"{
                locationObj.lat = self.sourceLat
                locationObj.lon = self.sourceLon
            }
            locationObj.currentLocation = { lat,lon,address in
                self.locationLbl.text = address
                self.sourceLat = lat
                self.sourceLon = lon
                if !(self.destinationLbl.text?.isEmptyVal())! {
                    self.getDistance()
                }
            }
            self.navigationController?.present(locationObj, animated: true, completion: nil)
        }else{
            let locationObj = LocationPage()
            locationObj.selectedLocation = self.locationLbl.text!
            locationObj.modalPresentationStyle = .fullScreen
            locationObj.didSelectedLocation = { location in
                self.locationLbl.text = location
            }
            self.navigationController?.present(locationObj, animated: true, completion: nil)
        }
    }
    //drop location
    @IBAction func destinationBtnTapped(_ sender: Any) {
        if locationLbl.text!.isEmptyVal(){
            Utility.shared.showToast(msg: "choose_pickup")
        }else{
            if LocalDefault.shared.isLiveTrack()!{
                let locationObj = MapPage()
                locationObj.modalPresentationStyle = .fullScreen
                locationObj.currentLocation = { lat,lon,address in
                    self.destinationLbl.text = address
                    self.dropLat = lat
                    self.dropLon = lon
                    self.getDistance()
                }
                self.navigationController?.present(locationObj, animated: true, completion: nil)
            }else{
                let locationObj = LocationPage()
                locationObj.selectedLocation = self.destinationLbl.text!
                locationObj.modalPresentationStyle = .fullScreen
                locationObj.didSelectedLocation = { location in
                    self.destinationLbl.text = location
                }
                self.navigationController?.present(locationObj, animated: true, completion: nil)
            }
        }
       
    }
    
    //get location details from google api
    func getDistance(){
        let apiObj = BaseAPI()
        let drop = CLLocationCoordinate2D.init(latitude: self.dropLat, longitude: self.dropLon)
        let pickup = CLLocationCoordinate2D.init(latitude: self.sourceLat, longitude: self.sourceLon)

        apiObj.getDistance(pickup: pickup, drop: drop, onSuccess: {response in
            let responseDict = response.value as! NSDictionary
            let status:String = responseDict.value(forKey: "status") as! String
            if status == "OVER_QUERY_LIMIT"{
            }else  if status == "ZERO_RESULTS"{
                
            }else{
                let responseArray:NSArray =  responseDict.value(forKey: "rows") as! NSArray
                let detailsDict:NSDictionary = responseArray.object(at: 0) as! NSDictionary
                let elementsArray:NSArray = detailsDict.value(forKey: "elements") as! NSArray
                let distanceDict:NSDictionary = elementsArray.object(at: 0) as! NSDictionary
                let finalStatus:String = distanceDict.value(forKey: "status") as! String
                print("api distance response \(distanceDict)")
                if finalStatus == "ZERO_RESULTS" {
                    self.dropLat = Double()
                    self.dropLon = Double()
                    self.distance = -1
                }else{
                   let meter = distanceDict.value(forKeyPath: "distance.value") as! Int
                    self.distance = Double(meter / 1000)
                    print("get distance \(self.distance)")
                }
            }
        }, onProgress: {errorResponse in
        })
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        if viewType == "edit"{
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "cancel_request"
            alertObj.deleteRequest = {
                self.startLoading()
                self.changeBooking(status: "cancelled")
            }
            self.navigationController?.present(alertObj, animated: false, completion: nil)
        }else{
            LocalDefault.shared.setView(from: "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        let defaultDict = LocalDefault.shared.appDefaults()
        let price = Double("\(self.priceTF.text!)") ?? .nan
        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double ?? .nan
        let maxDistance = defaultDict?.value(forKey: "max_ride_distance") as? Double ?? .nan
        if nameTF.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_title")
        }else if categoryLbl.text!.isEmptyVal() {
            Utility.shared.showToast(msg: "choose_category")
        }else if dateLbl.text!.isEmptyVal() {
            Utility.shared.showToast(msg: "choose_date")
        }else if !self.locationInput().isEmptyVal() {
            Utility.shared.showToast(msg: self.locationInput())
        }else if locationType == "transport" && LocalDefault.shared.isLiveTrack()! && distance > maxDistance{
            Utility.shared.showToast(msg: "distance_alert")
        }else if LocalDefault.shared.isLiveTrack()! && distance == 0.0 && locationType == "transport"{
            Utility.shared.showToast(msg: "same_location")
        }else if LocalDefault.shared.isLiveTrack()! && distance == -1 && locationType == "transport"{
            Utility.shared.showToast(msg: "distance_limit_exceeds")
        }else if priceTF.isEmptyValue() || price < payment_minimum_price{
            let msgStr = "\(Utility.shared.Json().value(forKey: "enter_valid_amount") ?? "") \(currency_symbol)\(payment_minimum_price)"
            Utility.shared.customToast(msg: msgStr)
        }else if self.desTV.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_details_task")
        }else{
            do{
                let jsonDecoder = JSONDecoder()
                let  profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
                //qwerty
//                if profile.mobile == ""{
//                    let alertObj = AlertPage()
//                    alertObj.modalPresentationStyle = .overCurrentContext
//                    alertObj.viewType = "mobile_no_validation"
//                    alertObj.deleteRequest = {
//                        self.dismiss(animated: true, completion: nil)
//                        self.addPhoneNumber()
//                    }
//                    self.navigationController?.present(alertObj, animated: false, completion: nil)
//                }else{
                    self.startLoading()
                    self.postNeed()
//                }
            }catch{
            }
        }
    }
    
    //check location process
    func locationInput() -> String {
        if locationType == "transport"{
            if locationLbl.text!.isEmptyVal(){
                return "choose_pickup"
            }else if destinationLbl.text!.isEmptyVal(){
                return "choose_drop"
            }
        }else if locationType == "home"{
            if locationLbl.text!.isEmptyVal(){
                return "choose_location"
            }
        }
        return ""
        
    }
    //add phone number
    func addPhoneNumber()  {
        FUIAuth.defaultAuthUI()?.delegate = self
        let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
        FUIAuth.defaultAuthUI()?.providers = [phoneProvider]
        let phoneProviderNew = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProviderNew.signIn(withPresenting: self, phoneNumber: nil)
    }
    //phone number delegate
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if authDataResult?.user != nil{
            
            let Obj = BaseAPI()
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            requestDict.setValue(authDataResult?.user.phoneNumber, forKey: "mobile")
            Obj.baseService(subURl: USER_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
                let resDict = response.value as! NSDictionary
                let status_code = resDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    LocalDefault.shared.setUser(data: response.data!)
                    self.startLoading()
                    self.postNeed()
                }
            })
        }
    }
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
    }
    
    
    //change status
    func changeBooking(status:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(status, forKey: "status")
        request.setValue(need?.item_id, forKey: "booking_id")
        
        Obj.baseService(subURl: USER_BOOKING_STATUS_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.refreshRequest!()
                LocalDefault.shared.setView(from: "")
                self.navigationController?.popViewController(animated: true)
            }
            self.stopLoading()
        })
    }
    //book service
    func postNeed(){
        let dict = LocalDefault.shared.selectedCategory()
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(dict?.value(forKey: "parent_cat_id") as! String, forKey: "parent_category_id")
        request.setValue(dict?.value(forKey: "sub_cat_id") as! String, forKey: "subcategory_id")
        request.setValue(dict?.value(forKey: "sub_cat_name") as! String, forKey: "sub_cat_name")
        request.setValue("", forKey: "service_id")
        request.setValue(Utility.shared.toUTC(local: datePicker.date), forKey: "date")
        request.setValue(self.nameTF.text, forKey: "name")
        request.setValue(self.priceTF.text, forKey: "price")
        request.setValue(self.desTV.text, forKey: "description")
        if viewType == "edit"{
            request.setValue(need?.item_id, forKey: "need_id")
        }
        if locationType == "home" {
            request.setValue(self.locationLbl.text, forKey: "source_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }else if locationType == "transport"{
            request.setValue(self.locationLbl.text, forKey: "source_location")
            request.setValue(self.destinationLbl.text, forKey: "dest_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
                request.setValue(self.sourceLat, forKey: "dest_lat")
                request.setValue(self.sourceLon, forKey: "dest_lon")
            }
        }
        Obj.baseService(subURl: ADD_NEED_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                if self.viewType == "edit"{
                    self.refreshRequest!()
                }
                LocalDefault.shared.setView(from: "")
                if self.viewType == "edit"{
                    Utility.shared.showToast(msg: "need_updated")
                } else{
                    Utility.shared.showToast(msg: "need_posted")
                }
                if self.viewFrom == "home"{
                    self.navigationController?.viewControllers.removeAll()
                    let bookingObj = MyNeeds()
                    bookingObj.viewFrom = "home"
                    let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                    navigationController!.pushViewController(bookingObj, animated: false)
                }
                else if self.viewType == "Tasker_Page"{
                    self.refreshRequest!()
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.navigationController?.popViewController(animated: true)
                }
                LocalDefault.shared.setView(from: "")
            }
            // qwerty
           else  if status_code == 400{
               let message = dict.value(forKey: "message") as!  String
               let alertObj = AlertPage()
               alertObj.modalPresentationStyle = .overCurrentContext
               alertObj.viewType = "user_need_post_alert"
               alertObj.deleteRequest = {
               }
               self.navigationController?.present(alertObj, animated: false, completion: nil)

           }
            self.stopLoading()
        })
    }
    
    //MARK: textView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let msg = textView.text! + text
        if msg.containsEmoji(){
            return false
        }else{
            if textView.text!.count > 499{
                if text.isEmpty{
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
    }
    
    //textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{
            if textField.tag == 1{ // check name label
                if textField.text!.count > 59{
                    if string.isEmpty{
                        return true
                    }else{
                        return false
                    }
                }else{
                    return true
                }
            }else{ // check price
                var maxLimit = 5
                if msg.contains(".") {
                    maxLimit = 8
                }
                if textField.text!.count > maxLimit{
                    if string.isEmpty{
                        return true
                    }else{
                        return false
                    }
                }else{
                    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                        return true
                    }
                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }
                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
                }
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.last == "." {
            self.priceTF.text?.removeLast()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

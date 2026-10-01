//
//  DescribeTask.swift
//  iDemand
//
//  Created by Roby on 20/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import CoreLocation
import SwiftyJSON
import Stripe

class DescribeTask: UIViewController ,UITextViewDelegate,FUIAuthDelegate{
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var categoriesBtn: UIButton!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var servicesLbl: UILabel!
    @IBOutlet var servicesScrollView: UIScrollView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var desLbl: UILabel!
    @IBOutlet var desTV: UITextView!
    @IBOutlet var summaryLbl: UILabel!
    @IBOutlet var bookingLbl: UILabel!
    @IBOutlet var bookingPriceLbl: UILabel!
    @IBOutlet var taxLbl: UILabel!
    @IBOutlet var taxPriceLbl: UILabel!
    @IBOutlet var commissionLbl: UILabel!
    @IBOutlet var commissionPriceLbl: UILabel!
    @IBOutlet var totalLbl: UILabel!
    @IBOutlet var totalPriceLbl: UILabel!
    @IBOutlet var paymentView: UIView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var loaderView: UIView!
    @IBOutlet var loader: DotsLoader!
    @IBOutlet var quantityView: UIView!
    @IBOutlet var hoursLbl: UILabel!
    @IBOutlet var marketplaceQuantityLbl: UILabel!
    @IBOutlet var increaseBtn: UIButton!
    @IBOutlet var decreaseBtn: UIButton!
    @IBOutlet var sourceView: UIView!
    @IBOutlet var destinationView: UIView!
    @IBOutlet var destinationBtn: UIButton!
    @IBOutlet var destinationLbl: UILabel!
    @IBOutlet var datepicketSeparatorLbl: UILabel!
    
    
    var isDateChoosed = false
    var datePicker :UIDatePicker!
    var currency_code = String()
    var parent_cat_id = String()
    var parent_cat_name = String()
    var parent_cat_type = String()
    var locationType = String()
    
    var sub_cat_id = String()
    var sub_cat_name = String()
    var service_name = String()
    var bookingArray = NSMutableArray()
    var viewType = String()
    var booking_amt = String()
    var totalAmt = Double()
    var unAvailableServices = NSMutableArray()
    var sourceLat = Double()
    var sourceLon = Double()
    var dropLat = Double()
    var dropLon = Double()
    var distance = Double()
    
    var stripeModel = StripeDataModel()
    var stripe_currency = ["BIF","CLP","DJF","GNF","JPY","KMF","KRW","MGA","PYG","RWF","UGX","VND","VUV","XAF","XOF", "XOF","XPF"];


    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        
        self.navigationView.bottomRadius()
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height + 50)
        self.checkRTL()
        
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoriesBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoriesBtn.contentHorizontalAlignment = .right
            self.categoryLbl.textAlignment = .right
            self.dateTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateTF.textAlignment = .right
            self.dateLbl.textAlignment = .left
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationLbl.textAlignment = .left
            self.locationBtn.contentHorizontalAlignment = .right
            self.destinationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationLbl.textAlignment = .left
            self.destinationBtn.contentHorizontalAlignment = .right
            
            self.marketplaceQuantityLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.hoursLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.hoursLbl.textAlignment = .right
            
            
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.textAlignment = .right
            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "enter_details_task")
            
            self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.saveBtn.removeRadius()
            self.cancelBtn.removeRadius()
            self.cancelBtn.corner(position: .topRight)
            self.saveBtn.corner(position: .topLeft)
            self.summaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.commissionPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.commissionLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.summaryLbl.textAlignment = .right
            self.totalPriceLbl.textAlignment = .left
            self.bookingPriceLbl.textAlignment = .left
            self.taxPriceLbl.textAlignment = .left
            self.commissionPriceLbl.textAlignment = .left
            self.totalLbl.textAlignment = .right
            self.bookingLbl.textAlignment = .right
            self.taxLbl.textAlignment = .right
            self.commissionLbl.textAlignment = .right
        }else{
            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_details_task")
            self.cancelBtn.corner(position: .topLeft)
            self.saveBtn.corner(position: .topRight)
        }
    }
    //config initial setup
    func initialSetup()  {
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "describe_your_task")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        StripeAPI.defaultPublishableKey = appDefault?.value(forKey: "stripe_public_key") as? String ?? ""
        currency_code = appDefault?.value(forKey: "currency_symbol") as! String
        self.categoryLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "categories")
        self.configDatePicker()
        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "description")
        self.summaryLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "payment_summary")
        self.categoriesBtn.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, title: "")
        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.locationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.bookingLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "booking_amount")
        self.taxLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "tax")
        self.commissionLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "commission")
        self.totalLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "total_amount")
        self.commissionPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.taxPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.bookingPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.totalPriceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
        
        self.sourceView.isHidden = true
        self.destinationView.isHidden = true
        self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "location")
        if parent_cat_type == "professional"{
            if locationType == "transport"{
                self.sourceView.isHidden = false
                self.destinationView.isHidden = false
                self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "pickup")
                self.destinationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "drop")
                self.servicesLbl.frame.origin.y = self.destinationView.frame.origin.y + 70
            }else if locationType == "home"{
                self.sourceView.isHidden = false
                self.servicesLbl.frame.origin.y = self.sourceView.frame.origin.y + 70
            }else{
                self.servicesLbl.frame.origin.y = self.datepicketSeparatorLbl.frame.origin.y + 15
            }
        }else{
            if locationType == "transport"{
                self.sourceView.isHidden = false
                self.destinationView.isHidden = false
                self.locationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "pickup")
                self.destinationBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "drop")
                self.quantityView.frame.origin.y = self.destinationView.frame.origin.y + 70
            }else if locationType == "home"{
                self.sourceView.isHidden = false
                self.quantityView.frame.origin.y = self.sourceView.frame.origin.y + 70
            }else{
                self.quantityView.frame.origin.y = self.datepicketSeparatorLbl.frame.origin.y + 15
            }
        }
        
        if parent_cat_type == "professional"{
            self.quantityView.isHidden = true
            self.configServices()
            self.servicesLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "services")
            self.configPayment()
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "book_now")
            self.categoriesBtn.setTitle("\(self.parent_cat_name) - \(self.sub_cat_name)", for: .normal)
        }else{
            //set details
            self.categoriesBtn.setTitle("\(self.parent_cat_name) - \(self.sub_cat_name) - \(self.service_name)", for: .normal)
            self.servicesLbl.isHidden = true
            self.paymentView.isHidden = true
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "hire")
            self.servicesScrollView.isHidden = true
            self.hoursLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "hours")
            self.marketplaceQuantityLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .center, text: "add")
            self.bottomView.frame.origin.y = self.quantityView.frame.origin.y+60
            
        }
        
        
        
        
        let increaseImg = #imageLiteral(resourceName: "increase_icon").withRenderingMode(.alwaysTemplate)
        let decreaseImg = #imageLiteral(resourceName: "decrease_icon").withRenderingMode(.alwaysTemplate)
        self.increaseBtn.setImage(increaseImg, for: .normal)
        self.decreaseBtn.setImage(decreaseImg, for: .normal)
        self.increaseBtn.tintColor = TEXT_BLACK_COLOR
        self.decreaseBtn.tintColor = LINE_COLOR
        self.cancelBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "cancel")
        self.cancelBtn.backgroundColor = SECONDARY_COLOR
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        self.loaderView.isHidden = true
        self.loader.dotsCount = 5
        self.loader.dotsRadius = 5
        self.loader.tintColor = PRIMARY_COLOR!
        
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
    //payment information
    func configPayment()  {
        let appDefault = LocalDefault.shared.appDefaults()
        let commissionPercent = Double(appDefault?.value(forKey: "site_commission") as! String)
        let taxPercent = Double(appDefault?.value(forKey: "site_tax") as! String)
        
        let bookingAmt = Double(self.booking_amt)
        let taxAmt = self.get(value: bookingAmt!, percent: taxPercent!)
        let commissionAmt = self.get(value: bookingAmt!, percent: commissionPercent!)
        if Utility.shared.isRTL(){
            self.bookingPriceLbl.text = "\(String(format: "%.2f", bookingAmt!)) \(currency_code)"
            self.taxPriceLbl.text = "\(String(format: "%.2f", taxAmt)) \(currency_code)"
            self.commissionPriceLbl.text = "\(String(format: "%.2f", commissionAmt)) \(currency_code)"
            totalAmt = bookingAmt! + taxAmt + commissionAmt
            self.totalPriceLbl.text = "\(String(format: "%.2f", totalAmt)) \(currency_code)"
        }else{
            self.bookingPriceLbl.text = "\(currency_code) \(String(format: "%.2f", bookingAmt!))"
            self.taxPriceLbl.text = "\(currency_code) \(String(format: "%.2f", taxAmt))"
            self.commissionPriceLbl.text = "\(currency_code) \(String(format: "%.2f", commissionAmt))"
            totalAmt = bookingAmt! + taxAmt + commissionAmt
            self.totalPriceLbl.text = "\(currency_code) \(String(format: "%.2f", totalAmt))"
        }
    }
    //calculate percent
    public func get(value:Double,percent:Double)->Double{
        let val = value * percent
        return val / 100.00
    }
    //MARK : services
    func configServices()  {
        var topPadding = 0
        var index = 0
        
        self.clearAllViews()
        for booking in self.bookingArray {
            let bookingDict = booking as! NSDictionary
            let serviceView = UIView.init(frame: CGRect.init(x: 20, y: topPadding, width:Int(FULL_WIDTH)-40 , height: 80))
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: 0, y: 15, width:70 , height: 50)
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            let userimgURL = URL.init(string:bookingDict.value(forKey: "service_image") as! String )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.backgroundColor = LINE_COLOR
            serviceView.addSubview(imgView)
            
            let nameLbl = UILabel()
            nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            nameLbl.frame = CGRect.init(x: 80, y: 15, width:Int(FULL_WIDTH)-100 , height: 25)
            nameLbl.text = (bookingDict.value(forKey: "service_name") as! String)
            serviceView.addSubview(nameLbl)
            let service_id = bookingDict.value(forKey: "service_id") as! String
            let quantityLbl = UILabel()
            let unavailableAlert = UILabel()
            
            //btn action
            let closeBtn = UIButton()
            closeBtn.frame = CGRect.init(x: Int(FULL_WIDTH)-55, y: 10, width:15 , height: 15)
            closeBtn.tag = index
            closeBtn.setImage(#imageLiteral(resourceName: "cancel_file"), for: .normal)
            closeBtn.addTarget(self, action: #selector(self.removeService(_:)), for: .touchUpInside)
            
            if self.unAvailableServices.contains(service_id){
                quantityLbl.frame = CGRect.init(x: 80, y: 35, width:Int(FULL_WIDTH)-100 , height: 20)
                unavailableAlert.frame = CGRect.init(x: 80, y: 50, width:Int(FULL_WIDTH)-100 , height: 20)
                unavailableAlert.config(color: PRIMARY_COLOR!, font: liteReg, align: .left, text: "service_not_available")
                serviceView.addSubview(unavailableAlert)
                serviceView.addSubview(closeBtn)
            }else{
                quantityLbl.frame = CGRect.init(x: 80, y: 40, width:Int(FULL_WIDTH)-100 , height: 40)
            }
            
            quantityLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
            var quantityType = bookingDict.value(forKey: "service_pricing") as! String
            if quantityType  == "hour"{
                quantityType = Utility.shared.Json().value(forKey: "hr") as! String
            }else{
                quantityType = Utility.shared.Json().value(forKey: "unit") as! String
            }
            
            if Utility.shared.isRTL() {
                quantityLbl.text = "\(bookingDict.value(forKey: "service_quantity") ?? "") x \(quantityType) \u{200E}/\(bookingDict.value(forKey: "service_price") as! String) \(currency_code)"

            }else{
                quantityLbl.text = "\(currency_code) \(bookingDict.value(forKey: "service_price") as! String)/\(quantityType) x \(bookingDict.value(forKey: "service_quantity") ?? "")"
            }
            quantityLbl.numberOfLines = 0
            serviceView.addSubview(quantityLbl)
            let totalAmtLbl = UILabel()
            totalAmtLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
            totalAmtLbl.frame = CGRect.init(x: Int(FULL_WIDTH)-200, y: 20, width:160 , height: 40)
            let amt = Double(bookingDict.value(forKey: "service_total_price") as! String)
            if Utility.shared.isRTL() {
                totalAmtLbl.text = "\(amt!) \(currency_code)"
            }else{
                totalAmtLbl.text = "\(currency_code) \(amt!)"
            }
            totalAmtLbl.numberOfLines = 0
            serviceView.addSubview(totalAmtLbl)
            
            if Utility.shared.isRTL(){
                totalAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                quantityLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                nameLbl.textAlignment = .right
                quantityLbl.textAlignment = .right
                totalAmtLbl.textAlignment = .left
            }
            
            topPadding += 80
            index += 1
            self.servicesScrollView.addSubview(serviceView)
            self.servicesScrollView.frame = CGRect.init(x: 0, y: Int(self.servicesLbl.frame.origin.y)+20, width: Int(FULL_WIDTH), height:topPadding)
            self.bottomView.frame.origin.y = self.servicesScrollView.frame.origin.y + CGFloat(topPadding)
        }
    }
    @objc func removeService(_ sender: UIButton){
        self.bookingArray.removeObject(at: sender.tag)
        self.configServices()
    }
    
    func clearAllViews()  {
        let subviews = self.servicesScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
    
    //go back
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //choose location
    @IBAction func locationBtnTapped(_ sender: Any) {
        if LocalDefault.shared.isLiveTrack()!{
            let locationObj = MapPage()
            locationObj.modalPresentationStyle = .fullScreen
            locationObj.currentLocation = { lat,lon,address in
                self.locationLbl.text = address
                self.sourceLat = lat
                self.sourceLon = lon
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
    
    @IBAction func destinationLocationBtnTapped(_ sender: Any) {
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
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.setInitialViewController()
        }
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        let defaultDict = LocalDefault.shared.appDefaults()
        let maxDistance = defaultDict?.value(forKey: "max_ride_distance") as? Double ?? .nan
        if dateLbl.text!.isEmptyVal() {
            Utility.shared.showToast(msg: "choose_date")
        }else if locationInput() != "" {
            Utility.shared.showToast(msg: self.locationInput())
        }else if locationType == "transport" && LocalDefault.shared.isLiveTrack()! && distance > maxDistance{
            Utility.shared.showToast(msg: "distance_alert")
        }else if LocalDefault.shared.isLiveTrack()! && distance == 0.0 && locationType == "transport"{
            Utility.shared.showToast(msg: "same_location")
        }else if LocalDefault.shared.isLiveTrack()! && distance == -1 && locationType == "transport"{
            Utility.shared.showToast(msg: "distance_limit_exceeds")
        }else if self.desTV.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_details_task")
        }else{
            do{
                let jsonDecoder = JSONDecoder()
                let  profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
                if profile.mobile == ""{
                    let alertObj = AlertPage()
                    alertObj.modalPresentationStyle = .overCurrentContext
                    alertObj.viewType = "mobile_no_validation"
                    alertObj.deleteRequest = {
                        self.dismiss(animated: true, completion: nil)
                        self.addPhoneNumber()
                    }
                    self.navigationController?.present(alertObj, animated: false, completion: nil)
                }else{
                    self.startBookingProcess()
                }
            }catch{
                
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
    
    func startBookingProcess()  {
        if parent_cat_type == "professional"{
            self.bookService()
        }else{
            let addStr = Utility.shared.Json().value(forKey: "add") as! String
            if self.marketplaceQuantityLbl.text ==  addStr{
                Utility.shared.showToast(msg: "add_hour_information")
            }else{
                let dict = self.bookingArray.object(at: 0) as! NSDictionary
                let bookingDict = NSMutableDictionary.init(dictionary:dict)
                bookingDict.setValue(self.marketplaceQuantityLbl.text, forKey: "service_quantity")
                let newArray = NSMutableArray()
                newArray.add(bookingDict)
                let hireObj = HirePage()
                hireObj.location = self.locationLbl.text!
                hireObj.bookingArray = newArray
                hireObj.parent_cat_id  = self.parent_cat_id
                hireObj.sub_cat_id = self.sub_cat_id
                hireObj.dateStr = Utility.shared.toUTC(local: datePicker.date)!
                hireObj.aboutTask = self.desTV.text
                hireObj.locationType = self.locationType
                hireObj.dropLon = self.dropLon
                hireObj.dropLat = self.dropLat
                hireObj.sourceLon = self.sourceLon
                hireObj.sourceLat = self.sourceLat
                hireObj.dropLocation = self.destinationLbl.text!
                hireObj.sourceLocation = self.locationLbl.text!
                self.navigationController?.pushViewController(hireObj, animated: true)
            }
        }
    }
    //add new number
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
                    self.startBookingProcess()
                }
            })
        }
    }
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
    }
    
    @IBAction func decreaeBtnTapped(_ sender: Any) {
        var count = Int()
        if self.marketplaceQuantityLbl.text == (Utility.shared.Json().value(forKey: "add") as! String) || self.marketplaceQuantityLbl.text == "1"{
            self.marketplaceQuantityLbl.text = (Utility.shared.Json().value(forKey: "add") as! String)
            self.increaseBtn.tintColor = TEXT_BLACK_COLOR
            self.decreaseBtn.tintColor = LINE_COLOR
            self.decreaseBtn.isUserInteractionEnabled = false
            count = 0
        }else{
            self.increaseBtn.tintColor = TEXT_BLACK_COLOR
            self.decreaseBtn.tintColor = PRIMARY_COLOR
            self.decreaseBtn.isUserInteractionEnabled = true
            let currentVal:Int? = Int(self.marketplaceQuantityLbl.text!) // firstText is UITextField
            count = currentVal!
            count -= 1
            self.marketplaceQuantityLbl.text = "\(count)"
        }
    }
    
    @IBAction func increaseBtnTapped(_ sender: Any) {
        self.decreaseBtn.isUserInteractionEnabled = true
        self.increaseBtn.tintColor = PRIMARY_COLOR
        self.decreaseBtn.tintColor = TEXT_BLACK_COLOR
        
        var count = Int()
        if self.marketplaceQuantityLbl.text == (Utility.shared.Json().value(forKey: "add") as! String) {
            count += 1
        }else{
            let currentVal:Int? = Int(self.marketplaceQuantityLbl.text!) // firstText is UITextField
            if currentVal == 10 {
                Utility.shared.showToast(msg: "maximum_limit_exceeds")
                return
            }else{
                count = currentVal!
                count += 1
            }
        }
        self.marketplaceQuantityLbl.text = "\(count)"
    }
    
    //book service
    func bookService(){
        self.loaderView.isHidden = false
        self.loader.startAnimating()
        let bookingAmt = Double(self.booking_amt)
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(parent_cat_id, forKey: "parent_category_id")
        request.setValue(sub_cat_id, forKey: "subcategory_id")
        request.setValue(Utility.shared.toUTC(local: datePicker.date), forKey: "date")
        request.setValue(bookingAmt, forKey: "price")
        request.setValue(String(format: "%.2f", totalAmt), forKey: "total")
        request.setValue(self.desTV.text, forKey: "description")
        request.setValue(Utility.shared.json(from: self.bookingArray), forKey: "services")
        
        if locationType == "transport"{
            request.setValue(self.locationLbl.text, forKey: "source_location")
            request.setValue(self.destinationLbl.text, forKey: "dest_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
                request.setValue(self.dropLat, forKey: "dest_lat")
                request.setValue(self.dropLon, forKey: "dest_lon")
            }
        }else if locationType == "home"{
            request.setValue(self.locationLbl.text, forKey: "source_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }
        
        Obj.baseService(subURl: BOOK_SERVICE_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                let availability = dict.value(forKey: "availability") as! String
                if availability == "true"{
                    let booking_id = dict.value(forKey: "booking_id") as! String
                    self.paymentProcess(booking_id)
//                    let paymentObj = PaymentPage()
//                    paymentObj.amtStr = self.totalPriceLbl.text!
//                    paymentObj.viewType = "professional"
//                    paymentObj.paymentDone = { token in
//                        self.loaderView.isHidden = false
//                        self.loader.startAnimating()
//                        self.navigationController!.dismiss(animated: false, completion: nil)
//                        if token != ""{
//                            self.payment(token: token, booking_id: booking_id)
//                        }else{
//                            let bookingObj = TabPager()
//                            bookingObj.viewType = "my_bookings"
//                            bookingObj.viewFrom = "payment"
//                            self.navigationController?.pushViewController(bookingObj, animated: true)
//                        }
//                    }
//                    paymentObj.modalPresentationStyle = .fullScreen
//                    self.navigationController?.present(paymentObj, animated: true, completion: nil)
                }
            }else if status_code == 400{
                if dict.value(forKey: "unavailable_services") != nil{
                    self.unAvailableServices.removeAllObjects()
                    self.unAvailableServices.addObjects(from: dict.value(forKey: "unavailable_services") as! [Any])
                    self.configServices()
                }
                Utility.shared.serverAlert(msg: dict.value(forKey: "message") as! String)
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
            }
        })
    }
    func paymentProcess(_ bookingID: String)  {
        var paymentSheet: PaymentSheet?
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        request.setValue(currency, forKey: "currency")
        request.setValue(String(format: "%.2f", totalAmt), forKey: "amount")
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "amount")
        }
        self.loaderView.isHidden = false
        self.loader.startAnimating()

        Obj.baseService(subURl: BALLENCE_SHEET_URL, params: request as? Parameters, onSuccess: {response in
            do {
                let jsonResponse = try JSON.init(data: response.data!)
                print("RESPONSE : \(jsonResponse)")
                self.stripeModel = StripeDataModel.init(fromJson: jsonResponse)
                if self.stripeModel.status == 200{
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "Example, Inc."
                    configuration.customer = .init(id: self.stripeModel.customer, ephemeralKeySecret: self.stripeModel.ephemeralKey)
//                    paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration, cancelString: (Utility.shared.Json().value(forKey: "payment_pending_alert") as? String ?? ""), okButton: (Utility.shared.Json().value(forKey: "ok") as? String ?? ""), cancelButton: (Utility.shared.Json().value(forKey: "cancel") as? String ?? ""), viewType: "professional", titleString: (Utility.shared.Json().value(forKey: "alert") as? String ?? ""))
                    paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration)

                    DispatchQueue.main.async {
                        paymentSheet?.present(from: self) { paymentResult in
                            // MARK: Handle the payment result
                            switch paymentResult {
                            case .completed:
                                print("Your order is confirmed")
                                let token = self.stripeModel.paymentIntent.components(separatedBy: "_secret_")
    //                            self.navigationController!.dismiss(animated: false, completion: nil)
                                if (token.first ?? "") != "" {
                                    self.payment(token: (token.first ?? ""), booking_id: bookingID)
                                }else{
                                    let bookingObj = TabPager()
                                    bookingObj.viewType = "my_bookings"
                                    bookingObj.viewFrom = "payment"
                                    self.navigationController?.pushViewController(bookingObj, animated: true)
                                }
                                self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                            case .canceled:
                                
                                let bookingObj = TabPager()
                                bookingObj.viewType = "my_bookings"
                                bookingObj.viewFrom = "payment"
                                self.navigationController?.pushViewController(bookingObj, animated: true)

//                                self.view.window?.rootViewController?.present(alertObj, animated: false, completion: nil)
                                print("Canceled!")
                                self.loaderView.isHidden = true
                                self.loader.stopAnimating()
                            case .failed(let error):
                                self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                                self.loaderView.isHidden = true
                                self.loader.stopAnimating()
                                print("Payment failed: \n\(error.localizedDescription)")
                            }
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: Utility.shared.Json().value(forKey: "alert") as? String, message: Utility.shared.Json().value(forKey: "amount_too_small") as? String, preferredStyle: UIAlertController.Style.alert)
                    //settings
                    alert.addAction(UIAlertAction(title: Utility.shared.Json().value(forKey: "ok") as? String, style: .default, handler: { action in
                        self.loaderView.isHidden = true
                        self.loader.stopAnimating()
                    }))
                    self.navigationController?.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        })
    }
    //send stripe token to server for payment
    func payment(token:String,booking_id:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(booking_id, forKey: "booking_id")
        request.setValue(token, forKey: "payment_token")
        request.setValue(String(format: "%.2f", totalAmt), forKey: "total_amount")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "total_amount")
        }
        Obj.baseService(subURl: PAY_BOOKING_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                Utility.shared.showToast(msg: "payment_done")
                let bookingObj = BookingDetails()
                bookingObj.viewType = "booking"
                bookingObj.bookingID = booking_id
                bookingObj.refreshRequest = {
                    
                }
                self.navigationController?.pushViewController(bookingObj, animated: true)
            }
            self.loader.stopAnimating()
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
    
}

//
//  BookingDetails.swift
//  iDemand
//
//  Created by Roby on 22/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe
import CoreLocation
import SwiftyJSON

class BookingDetails: UIViewController,socketDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var categoryTitleLbl: UILabel!
    @IBOutlet var categoriesLbl: UILabel!
    @IBOutlet var locationTitleLbl: UILabel!
    @IBOutlet var servicesLbl: UILabel!
    @IBOutlet var servicesScrollView: UIScrollView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var desTitleLbl: UILabel!
    @IBOutlet var desLbl: UILabel!
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
    @IBOutlet var dateTitleLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ratingCountLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var completedJobsLbl: UILabel!
    @IBOutlet var otpLbl: UILabel!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var otpTitleLbl: UILabel!
    @IBOutlet var phoneNoLbl: UIButton!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var bookingStatusLbl: UILabel!
    @IBOutlet var rewardView: UIView!
    @IBOutlet var rewardLbl: UILabel!
    @IBOutlet var tipsLbl: UILabel!
    @IBOutlet var totalSeparatorLbl: UILabel!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var bookingIDLbl: UILabel!
    @IBOutlet var otpHintLbl: UILabel!
    @IBOutlet var pickupView: UIView!
    @IBOutlet var dropView: UIView!
    @IBOutlet var dropLocationLbl: UILabel!
    @IBOutlet var dropTitleLbl: UILabel!
    @IBOutlet var dateSeparatorLbl: UILabel!
    @IBOutlet var otpView: UIView!
    @IBOutlet var liveTrackingBtn: UIButton!
    //modified-AR
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var chatDict = NSDictionary()
    var currency_code = String()
    var bookingArray = NSMutableArray()
    var viewType = String()
    var viewFrom = String()
    var bookingID = String()
    var bookingDict = NSDictionary()
    var parent_cat_type = String()
    var booking_status = String()
    var refreshRequest: (() -> Void)?
    var booking_type = String()
    var locationType = String()
    
    var stripeModel = StripeDataModel()
    var stripe_currency = ["BIF","CLP","DJF","GNF","JPY","KMF","KRW","MGA","PYG","RWF","UGX","VND","VUV","XAF","XOF","XPF"];
    //qwerty
    var subcat_img = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
//        self.paymentView.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        if Utility.shared.isRTL(){
            self.desLbl.frame.origin.x = 20
            self.desLbl.frame.origin.y = self.desTitleLbl.frame.origin.y + 30
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        SocketClass.sharedInstance.delegate = self
        self.updateTheme()
        //get data from server
        self.getBookingDetails()
        
    }
    
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.otpHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoriesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.servicesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.summaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.commissionLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.commissionPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingCountLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.completedJobsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingStatusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rewardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.tipsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rewardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingIDLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropLocationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.textAlignment = .left
            self.bookingIDLbl.textAlignment = .right
            self.totalPriceLbl.textAlignment = .left
            self.categoryTitleLbl.textAlignment = .right
            self.categoriesLbl.textAlignment = .right
            self.locationTitleLbl.textAlignment = .right
            self.dropTitleLbl.textAlignment = .right
            self.locationLbl.textAlignment = .left
            self.servicesLbl.textAlignment = .right
            self.desTitleLbl.textAlignment = .right
            self.desLbl.textAlignment = .right
            self.summaryLbl.textAlignment = .right
            self.bookingLbl.textAlignment = .right
            self.bookingPriceLbl.textAlignment = .left
            self.taxLbl.textAlignment = .right
            self.taxPriceLbl.textAlignment = .left
            self.commissionLbl.textAlignment = .right
            self.commissionPriceLbl.textAlignment = .left
            self.dropLocationLbl.textAlignment = .left
            self.locationLbl.textAlignment = .left
            self.dateTitleLbl.textAlignment = .right
            self.dateLbl.textAlignment = .left
            self.nameLbl.textAlignment = .right
            self.ratingCountLbl.textAlignment = .right
            self.priceLbl.textAlignment = .right
            self.completedJobsLbl.textAlignment = .right
            self.otpLbl.textAlignment = .left
            self.otpTitleLbl.textAlignment = .right
            self.phoneNoLbl.contentHorizontalAlignment = .right
            self.statusLbl.textAlignment = .left
            self.bookingStatusLbl.textAlignment = .right
            self.rewardLbl.textAlignment = .right
            self.tipsLbl.textAlignment = .left
            self.otpHintLbl.textAlignment = .right

        }
    }
    
    //config initial setup
    func initialSetup()  {
//        modified-AR
        self.totalSeparatorLbl.isHidden = true
        self.loader.color = PRIMARY_COLOR
        self.loader.hidesWhenStopped = true
        // qwerty
        self.phoneNoLbl.isHidden = true
        self.liveTrackingBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.saveBtn.isHidden = true
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "details")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        StripeAPI.defaultPublishableKey = appDefault?.value(forKey: "stripe_public_key") as? String ?? ""

        currency_code = appDefault?.value(forKey: "currency_symbol") as! String
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.phoneNoLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, title: "")
        self.ratingCountLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.completedJobsLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        //qwerty
        self.servicesLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "category")
        self.categoryTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "category")
        self.dateTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "date")
        //qwerty
//        self.bookingIDLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "id")
        self.bookingIDLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "booking_id")
        self.bookingStatusLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "status")
        self.otpTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "otp")
        
        self.desTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "description")
        self.summaryLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "payment_summary")
        self.rewardLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "tips")
        self.otpHintLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "share_otp_tasker")
        self.categoriesLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.idLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.otpLbl.config(color: RATING_GREEN!, font: subBold, align: .right, text: "")
        self.locationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.bookingLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "booking_amount")
        self.taxLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "tax")
        self.commissionLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "commission")
        self.totalLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "total_amount")
        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.commissionPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.taxPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.bookingPriceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.totalPriceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
        self.statusLbl.config(color: RATING_GREEN!, font: subBold, align: .right, text: "")
        self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "")
        self.cancelBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "cancel")
        self.tipsLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.cancelBtn.backgroundColor = SECONDARY_COLOR
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        self.saveBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.addLoader()
        self.scrollView.isHidden = true
        self.startLoading()
        
    }    
    //set values to all
    func setDetails()  {
        let appDefault = LocalDefault.shared.appDefaults()
        let currency_code = appDefault?.value(forKey: "currency_symbol") as! String
        self.bookingArray.removeAllObjects()
        self.bookingArray.addObjects(from: self.bookingDict.value(forKey: "services") as! [Any])
        //qwerty
        self.subcat_img = bookingDict.value(forKey: "subcategory_image") as! String
        self.booking_type = self.bookingDict.value(forKey: "booking_type") as! String
        self.locationType = (self.bookingDict.value(forKey: "location_type") as! String)
        
        if !LocalDefault.shared.isLiveTrack()! || locationType == "remote"{
            self.liveTrackingBtn.isHidden = true
        }else{
            self.liveTrackingBtn.isHidden = false
        }
        self.locationTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "location")
        //based on the location
        self.pickupView.isHidden = true
        self.dropView.isHidden = true
        if locationType == "transport"{
            self.pickupView.isHidden = false
            self.dropView.isHidden = false
            self.locationTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "pickup")
            self.dropTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "drop")
            self.otpView.frame.origin.y = self.dropView.frame.origin.y + 70
        }else if locationType == "home"{
            self.pickupView.isHidden = false
            self.otpView.frame.origin.y = self.pickupView.frame.origin.y + 70
        }else{
            self.otpView.frame.origin.y = self.dateSeparatorLbl.frame.origin.y + 15
        }
        self.servicesLbl.frame.origin.y = self.otpView.frame.origin.y + 88
        
        
        self.configServices()
        if self.bookingDict.value(forKeyPath: "tasker.image") != nil {
            let userimgURL = URL.init(string: self.bookingDict.value(forKeyPath: "tasker.image") as! String)
            self.userImgView.radius(value: 5.0)
            self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            self.priceLbl.text = "\(currency_code) \(self.bookingDict.value(forKey: "price") as! String)"
            self.priceLbl.adjustsFontSizeToFitWidth = true
            self.nameLbl.text = self.bookingDict.value(forKeyPath: "tasker.name") as? String
            let ratingTxt = "★ \(self.bookingDict.value(forKeyPath: "tasker.rating") as! String) (\(self.bookingDict.value(forKeyPath: "tasker.reviews") as! String) \(Utility.shared.Json().value(forKey: "reviews") as! String))"
            let actTxt = "★ \(self.bookingDict.value(forKeyPath: "tasker.rating") as! String)"
            self.ratingCountLbl.setCustom(fullTxt: ratingTxt, activeTxt: actTxt, color: RATING_GREEN!)
            let jobs = Utility.shared.Json().value(forKey: "jobs") as! String
            self.completedJobsLbl.text = "\(self.bookingDict.value(forKeyPath: "tasker.completed_tasks") as! String) \(jobs)"
//            self.phoneNoLbl.setTitle("\(self.bookingDict.value(forKeyPath: "tasker.phone") as! String)", for: .normal)
        }
        self.dateLbl.text = Utility.shared.toLocal(dateStr: self.bookingDict.value(forKey: "date") as! String,format: "dd.MMM.yyy")
        if locationType != "remote" {
            self.locationLbl.text = (self.bookingDict.value(forKey: "source_location") as! String)
            if locationType == "transport"  {
                self.dropLocationLbl.text = (self.bookingDict.value(forKey: "dest_location") as! String)
            }
        }
        self.desLbl.text = (self.bookingDict.value(forKey: "description") as! String)
        self.idLbl.text = (self.bookingDict.value(forKey: "reference_id") as! String).uppercased()
        
        self.desLbl.numberOfLines = 0
        self.desLbl.sizeToFit()
        self.desLbl.frame.origin.x = 20
        self.desLbl.frame.origin.y = self.desTitleLbl.frame.origin.y + 30
        self.paymentView.frame.origin.y = self.desLbl.frame.origin.y + self.desLbl.frame.size.height + 15
        self.bottomView.frame.size.height = self.paymentView.frame.origin.y + self.paymentView.frame.size.height + 15
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height+50)
        self.categoriesLbl.text = "\(self.bookingDict.value(forKey: "parent_category_name") as! String) - \(self.bookingDict.value(forKey: "subcategory_name") as! String)"
        
        
        
        if Utility.shared.isRTL(){
            self.bookingPriceLbl.text = "\(self.bookingDict.value(forKey: "price") as! String) \(currency_code)"
            self.taxPriceLbl.text = "\(self.bookingDict.value(forKey: "tax") as! String) \(currency_code)"
            self.commissionPriceLbl.text = "\(self.bookingDict.value(forKey: "commission") as! String) \(currency_code)"
            self.totalPriceLbl.text = "\(self.bookingDict.value(forKey: "total") as! String) \(currency_code)"
        }else{
            self.bookingPriceLbl.text = "\(currency_code) \(self.bookingDict.value(forKey: "price") as! String)"
            self.taxPriceLbl.text = "\(currency_code) \(self.bookingDict.value(forKey: "tax") as! String)"
            self.commissionPriceLbl.text = "\(currency_code) \(self.bookingDict.value(forKey: "commission") as! String)"
            self.totalPriceLbl.text = "\(currency_code) \(self.bookingDict.value(forKey: "total") as! String)"
        }
        self.otpLbl.text = (self.bookingDict.value(forKey: "otp") as! String)
        let rewardStatus =  self.bookingDict.value(forKeyPath: "reward.status") as! String
        if rewardStatus == "true"{
            self.rewardView.isHidden = false
            if Utility.shared.isRTL(){
                
                self.tipsLbl.text = "\(self.bookingDict.value(forKeyPath: "reward.amount") as! String) \(currency_code)"
            }else{
                self.tipsLbl.text = "\(currency_code) \(self.bookingDict.value(forKeyPath: "reward.amount") as! String)"
                
            }
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height)
        }else{
            self.rewardView.isHidden = true
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height-60)
        }
        //qwerty
//        parent_cat_type =  self.bookingDict.value(forKey: "parent_category_type") as! String
        booking_status =  self.bookingDict.value(forKey: "booking_status") as! String
        if booking_type == "userneeds"{
            self.checkStatus(type:"marketplace") // needs should perform as marketplace
        }else{
            self.titleLbl.text = Utility.shared.Json().value(forKey: "details") as? String
            self.checkStatus(type:parent_cat_type)
        }
        self.checkRTL()
    }
    //calculate percent
    public func get(value:Double,percent:Double)->Double{
        let val = value * percent
        return val / 100.00
    }
    
    //booking information
    func getBookingDetails(){
        let Obj = BaseAPI()
        Obj.getDetails(subURl: "\(BOOKING_DETAILS_API)/\(bookingID)", onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            self.scrollView.isHidden = false
            if status_code == 200{
                self.bookingDict = dict
                self.setDetails()
                self.getChatInfo(type: "book",chat_id:self.bookingDict.value(forKey: "chat_id") as! String)
                if self.booking_status == "completed"{
                    self.refreshRequest!()
                }
            }else{
                self.stopLoading()
            }
        })
    }
    //chat information
    func getChatInfo(type:String,chat_id:String){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(chat_id, forKey: "chat_id")
            Obj.baseService(subURl: USER_CHAT_INFO, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.chatDict = responseDict
                    if type == "create"{
                        self.goToChat()
                    }
                }
                self.stopLoading()
            })
        }
    }
    
    //MARK : services
    func configServices()  {
        var topPadding = 0
        self.clearAllViews()
        for booking in self.bookingArray {
            let bookingDict = booking as! NSDictionary
            
            let serviceView = UIView.init(frame: CGRect.init(x: 20, y: topPadding, width:Int(FULL_WIDTH)-40 , height: 80))
            
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: 0, y: 15, width:70 , height: 50)
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            //qwerty
//            let userimgURL = URL.init(string:bookingDict.value(forKey: "service_image") as! String )
            let userimgURL = URL.init(string: self.subcat_img )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.backgroundColor = LINE_COLOR
            serviceView.addSubview(imgView)
            
            let nameLbl = UILabel()
            nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            nameLbl.frame = CGRect.init(x: 80, y: 10, width:Int(FULL_WIDTH)-100 , height: 25)
            nameLbl.text = (bookingDict.value(forKey: "service_name") as! String)
            serviceView.addSubview(nameLbl)
            
            let quantityLbl = UILabel()
            quantityLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
            quantityLbl.frame = CGRect.init(x: 80, y: 40, width:Int(FULL_WIDTH)-100 , height: 25)
            //qwerty
//            var quantityType = bookingDict.value(forKey: "service_pricing") as! String
//            if quantityType  == "hour"{
//                quantityType = Utility.shared.Json().value(forKey: "hr") as! String
//            }else{
//                quantityType = Utility.shared.Json().value(forKey: "unit") as! String
//            }
//
//            if Utility.shared.isRTL() {
////                quantityLbl.text = "\(bookingDict.value(forKey: "service_quantity") ?? "") x \(quantityType)/\(bookingDict.value(forKey: "service_price") as! String) \(currency_code)"
//                let previous = "\(bookingDict.value(forKey: "service_quantity") ?? "") x \(quantityType) "
//                let end = "/\u{200E}\(bookingDict.value(forKey: "service_price") as! String)  \(currency_code)"
//                quantityLbl.text = "\(previous)\(end)"
//
//            }else{
//                quantityLbl.text = "\(currency_code) \(bookingDict.value(forKey: "service_price") as! String)/\(quantityType) x \(bookingDict.value(forKey: "service_quantity") ?? "")"
//            }
            serviceView.addSubview(quantityLbl)
            
            let totalAmtLbl = UILabel()
            totalAmtLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
            totalAmtLbl.frame = CGRect.init(x: Int(FULL_WIDTH)-200, y: 20, width:160 , height: 40)
            let amt = Double(bookingDict.value(forKey: "service_total_price") as! String)
            if Utility.shared.isRTL() {
                if self.booking_type == "userneeds"{
                    quantityLbl.isHidden = true
                    nameLbl.frame = CGRect.init(x: 80, y: 25, width:Int(FULL_WIDTH)-100 , height: 25)
                    totalAmtLbl.text = "\(bookingDict.value(forKey: "service_price") as! String) \(currency_code)"
                }else{
                    totalAmtLbl.text = "\(amt!) \(currency_code)"
                }
            }else{
                if self.booking_type == "userneeds"{
                    quantityLbl.isHidden = true
                    nameLbl.frame = CGRect.init(x: 80, y: 25, width:Int(FULL_WIDTH)-100 , height: 25)
                    totalAmtLbl.text = "\(currency_code) \(bookingDict.value(forKey: "service_price") as! String)"
                }else{
                    totalAmtLbl.text = "\(currency_code) \(amt!)"
                }
            }
            
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
            topPadding += 85
            self.servicesScrollView.addSubview(serviceView)
            self.servicesScrollView.frame = CGRect.init(x: 0, y: Int(self.servicesLbl.frame.origin.y)+20, width: Int(FULL_WIDTH), height:topPadding)
            self.bottomView.frame.origin.y = self.servicesScrollView.frame.origin.y + CGFloat(topPadding)
        }
    }
    func clearAllViews()  {
        let subviews = self.servicesScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
    
    //check status
    func checkStatus(type:String){
        self.saveBtn.isHidden = true
        self.cancelBtn.isHidden = true
        if type == "professional"{
            if booking_status == "requested"{
                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
            }else  if booking_status == "accepted"{
                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
            }else if booking_status == "paid"{
                self.statusLbl.text = Utility().Json().value(forKey: "paid") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "chat") as! String))
            }else if booking_status == "started"{
                self.statusLbl.text = Utility().Json().value(forKey: "started") as? String
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "chat") as! String))
            }else if booking_status == "completed"{
                
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "reward") as! String))
                self.statusLbl.text = Utility().Json().value(forKey: "completed") as? String
            }else if booking_status == "cancelled"{
                self.statusLbl.text = Utility().Json().value(forKey: "cancelled") as? String
            }else if booking_status == "refunded"{
                self.statusLbl.text = "\(Utility().Json().value(forKey: "cancelled") as? String ?? "") - \(Utility().Json().value(forKey: "amount_refunded") as? String ?? "")"
            }
        }else{
            if booking_status == "requested"{
                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "chat") as! String))
            }else  if booking_status == "accepted"{
                //qwerty
//                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
                self.statusLbl.text = Utility().Json().value(forKey: booking_status) as? String
//                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "chat") as! String))
            }
            else if booking_status == "paid"{
                self.statusLbl.text = Utility().Json().value(forKey: "paid") as? String
                //qwerty
//                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "chat") as! String))
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "review") as! String))
            }else if booking_status == "started"{
                self.statusLbl.text = Utility().Json().value(forKey: "started") as? String
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "chat") as! String))
            }
            //modified-AR
            else if booking_status == "completed"{
                //qwerty
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "review") as! String))
//                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
                self.statusLbl.text = Utility().Json().value(forKey: "completed") as? String
            }
            //modified-AR
            else if booking_status == "payment_pending"{
                //qwerty
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
//                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "pay") as! String))
                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
            }
            else if booking_status == "cancelled"{
                self.statusLbl.text = Utility().Json().value(forKey: "cancelled") as? String
            }else if booking_status == "refunded"{
                self.statusLbl.text = "\(Utility().Json().value(forKey: "cancelled") as? String ?? "") - \(Utility().Json().value(forKey: "amount_refunded") as? String ?? "")"
            }
        }
        self.statusLbl.textColor = Utility.shared.color(status:booking_status)
        self.statusLbl.adjustsFontSizeToFitWidth = true
        
        if !LocalDefault.shared.isLiveTrack()! || locationType == "remote"{
            self.liveTrackingBtn.isHidden = true
        }
        // qwerty
//        else if booking_status == "started"{
        else if booking_status == "accepted" ||  booking_status == "started"{
            self.liveTrackingBtn.isHidden = false
        }else{
            self.liveTrackingBtn.isHidden = true
        }
        //        self.liveTrackingBtn.isHidden = false
        
        
    }
    func showAct(isSingle:Bool,title:String)  {
        self.cancelBtn.removeRadius()
        self.saveBtn.removeRadius()
        if isSingle {
            self.saveBtn.frame.origin.x = 0
            self.saveBtn.frame.size.width = FULL_WIDTH
            self.saveBtn.isHidden = false
            self.saveBtn.topRadius()
        }else{
            let width = FULL_WIDTH/2
            self.cancelBtn.frame.origin.x = 0
            self.cancelBtn.frame.size.width = width
            
            self.saveBtn.frame.origin.x = width
            self.saveBtn.frame.size.width = width
            
            if Utility.shared.isRTL() {
                self.cancelBtn.corner(position: .topRight)
                self.saveBtn.corner(position: .topLeft)
            }else{
                self.cancelBtn.corner(position: .topLeft)
                self.saveBtn.corner(position: .topRight)
            }
            self.saveBtn.isHidden = false
            self.cancelBtn.isHidden = false
        }
        self.saveBtn.setTitle(title, for: .normal)
        if booking_status == "completed"{
            let reviewStatus =  self.bookingDict.value(forKeyPath: "review.status") as! String
            if reviewStatus == "true"{

                self.saveBtn.setTitle((Utility().Json().value(forKey: "edit_review") as! String), for: .normal)
//                self.cancelBtn.setTitle((Utility().Json().value(forKey: "edit_review") as! String), for: .normal)
            }else{
                //qwerty
                self.saveBtn.setTitle((Utility().Json().value(forKey: "review") as! String), for: .normal)
            }
            let rewardStatus =  self.bookingDict.value(forKeyPath: "reward.status") as! String
            let settlemetStatus = self.bookingDict.value(forKeyPath: "settlement") as? String ?? ""
            if rewardStatus == "true" || settlemetStatus == "true"{
                //qwerty
//                self.saveBtn.isHidden = true
                self.cancelBtn.frame.origin.x = 0
                self.cancelBtn.frame.size.width = FULL_WIDTH
                self.cancelBtn.topRadius()
            }
        }else if booking_status == "accepted" && parent_cat_type == "marketplace"{
            self.cancelBtn.setTitle((Utility().Json().value(forKey: "chat") as! String), for: .normal)
        }else if booking_status == "accepted" && booking_type == "userneeds"{
            // qwerty
            cancelBtn.isHidden = true
            saveBtn.isHidden = false
            self.saveBtn.setTitle((Utility().Json().value(forKey: "chat") as! String), for: .normal)
        }
        //modified-AR
        else if booking_status == "payment_pending"{
            // qwerty
            cancelBtn.isHidden = false
            saveBtn.isHidden = false
            let reviewStatus =  self.bookingDict.value(forKeyPath: "review.status") as! String
            if reviewStatus == "true"{
                self.cancelBtn.setTitle((Utility().Json().value(forKey: "edit_review") as! String), for: .normal)
            }else{
                self.cancelBtn.setTitle((Utility().Json().value(forKey: "review") as! String), for: .normal)
            }
            self.saveBtn.setTitle((Utility().Json().value(forKey: "pay") as! String), for: .normal)
            
        }
        else{
            self.cancelBtn.setTitle((Utility().Json().value(forKey: "cancel") as! String), for: .normal)
        }
    }
    
    //go back
    @IBAction func backBtnTapped(_ sender: Any) {
        if viewType == "booking"{
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //cancel btn tapped
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        
        if booking_status == "completed"{
            self.postReview()
        }
        else if booking_status == "accepted" && booking_type == "userneeds"{
            self.makeChat()
        }
        else if booking_status == "payment_pending"{
            self.postReview()
        }
        else{
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "cancel_request"
            alertObj.deleteRequest = {
                self.startLoading()
                self.changeBooking(status: "cancelled")
            }
            self.navigationController?.present(alertObj, animated: false, completion: nil)
        }
        
        //qwerty
//        if booking_status == "completed"{
//            self.postReview()
//        }else if booking_status == "accepted" && parent_cat_type == "marketplace"{
//            self.makeChat()
//        }else if booking_status == "accepted" && booking_type == "userneeds"{
//            self.makeChat()
//        }else{
//            let alertObj = AlertPage()
//            alertObj.modalPresentationStyle = .overCurrentContext
//            alertObj.viewType = "cancel_request"
//            alertObj.deleteRequest = {
//                self.startLoading()
//                self.changeBooking(status: "cancelled")
//            }
//            self.navigationController?.present(alertObj, animated: false, completion: nil)
//        }
        
    }
    
    @IBAction func trackingBtnTapped(_ sender: Any) {
        if self.bookingDict.value(forKey: "source_lat") != nil{
        let pickupLat = self.bookingDict.value(forKey: "source_lat") as! NSString
        let pickupLon = self.bookingDict.value(forKey: "source_lon") as! NSString
        
        let locationObj = MapPage()
        locationObj.viewType = "tracking"
        locationObj.taskerID = self.bookingDict.value(forKeyPath: "tasker.id") as! String
        locationObj.modalPresentationStyle = .fullScreen
        locationObj.pickUpCoordination =  CLLocationCoordinate2D.init(latitude: pickupLat.doubleValue, longitude: pickupLon.doubleValue)
        locationObj.locationType = self.locationType
            //qwerty
//        if locationType == "transport"{
            let sourceLat = self.bookingDict.value(forKey: "dest_lat") ?? "0.0"
            let sourceLon = self.bookingDict.value(forKey: "dest_lon") ?? "0.0"
            locationObj.dropCoordination =  CLLocationCoordinate2D.init(latitude: (sourceLat as AnyObject).doubleValue, longitude: (sourceLon as AnyObject).doubleValue)
            
//        }
        locationObj.currentLocation = { lat,lon,address in
            
        }
        self.navigationController?.present(locationObj, animated: true, completion: nil)
        }else{
            Utility.shared.showToast(msg: "tracking_unavailable")
        }
    }
    //save btn tapped
    @IBAction func saveBtnTapped(_ sender: Any) {
        if parent_cat_type == "professional"{
            if booking_status == "requested"{
                //pay
                self.paymentProcess()
            }else if booking_status == "paid" || booking_status == "started"{
                //chat
                self.makeChat()
            }else if booking_status == "completed"{
                //reward
                payTips()
            }else  if booking_status == "accepted"{
                //pay
                self.paymentProcess()
            }
        }else{
            if booking_status == "requested"{
                //chat
                self.goToChat()
            }else  if booking_status == "accepted"{
                //qwerty
                //pay
//                self.paymentProcess()
                self.goToChat()
            }else if booking_status == "paid" ||  booking_status == "started"{
                //chat
                //qwerty
                self.goToChat()
//                self.postReview()
            }else if booking_status == "started"{
                self.statusLbl.text = Utility().Json().value(forKey: "started") as? String

            }
            else if booking_status == "payment_pending"{
                self.paymentProcess()
            }
            else if booking_status == "completed"{
                //reward
//                payTips()
//                self.paymentProcess()
                self.postReview()
            }
            else if booking_status == "completed"{
                self.postReview()
            }
        }
    }
    //create new or make chat
    func makeChat()  {
        let chatid = self.bookingDict.value(forKey: "chat_id") as! String
        if chatid == ""{
            self.startLoading()
            self.createChatID()
        }else{
            self.goToChat()
        }
    }
    @IBAction func taskerProfileBtnTapped(_ sender: Any) {
        let profileObj = TaskerDetails()
        profileObj.tasker_id = self.bookingDict.value(forKeyPath: "tasker.id") as! String
        self.navigationController?.pushViewController(profileObj, animated: true)
    }
    
    //create chat id
    func createChatID(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.bookingID, forKey: "booking_id")
            Obj.baseService(subURl: USER_CREATE_CHAT_ID, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    let chatID = responseDict.value(forKey: "chat_id") as! String
                    self.getChatInfo(type: "create",chat_id:chatID)
                }
            })
        }
    }
    //change status
    func changeBooking(status:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(status, forKey: "status")
        request.setValue(self.bookingID, forKey: "booking_id")
        Obj.baseService(subURl: USER_BOOKING_STATUS_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.getBookingDetails()
                self.refreshRequest!()
            }else if status_code == 400{
                self.booking_status = dict.value(forKey: "booking_status") as! String
                self.getBookingDetails()
                self.refreshRequest!()
                Utility.shared.serverAlert(msg: dict.value(forKey: "message") as! String)
            }
            self.stopLoading()
        })
    }
    //payment details
    func paymentProcess()  {
        
        var paymentSheet: PaymentSheet?
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        let totalAmt = Double(self.bookingDict.value(forKey: "total") as! String) ?? Double(0)
        request.setValue(String(format: "%.2f", totalAmt), forKey: "amount")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        request.setValue(currency, forKey: "currency")
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "amount")
        }

        //modified-AR
//        self.startLoading()
        self.loader.startAnimating()
        Obj.baseService(subURl: BALLENCE_SHEET_URL, params: request as? Parameters, onSuccess: {response in
            do {
                let jsonResponse = try JSON.init(data: response.data!)
                print("RESPONSE : \(jsonResponse)")
                self.stripeModel = StripeDataModel.init(fromJson: jsonResponse)
                if self.stripeModel.status == 200 {
                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "Example, Inc."
                    configuration.customer = .init(id: self.stripeModel.customer, ephemeralKeySecret: self.stripeModel.ephemeralKey)
//                    paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration, cancelString: "", okButton: "", cancelButton: "", viewType: "", titleString: "")
                    paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration)
                    DispatchQueue.main.async {
                        paymentSheet?.present(from: self) { paymentResult in
                            // MARK: Handle the payment result
                            switch paymentResult {
                            case .completed:
                                print("Your order is confirmed")
                                let token = self.stripeModel.paymentIntent.components(separatedBy: "_secret_")
                                self.payment(token: (token.first ?? ""), booking_id: self.bookingID)
                            case .canceled:
                                print("Canceled!")
//                                self.stopLoading()
                                self.loader.stopAnimating()
                            case .failed(let error):
                                print("Payment failed: \n\(error.localizedDescription)")
                                self.loader.stopAnimating()
                            }
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: Utility.shared.Json().value(forKey: "alert") as? String, message: Utility.shared.Json().value(forKey: "amount_too_small") as? String, preferredStyle: UIAlertController.Style.alert)
                    //settings
                    alert.addAction(UIAlertAction(title: Utility.shared.Json().value(forKey: "ok") as? String, style: .default, handler: { action in
                        self.stopLoading()
                    }))
                    self.navigationController?.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        })
    }
    //post review
    func postReview()  {
        let reviewObj = MakeReview()
        reviewObj.userDict = self.bookingDict.value(forKey: "tasker") as! NSDictionary
        reviewObj.reviewDict = self.bookingDict.value(forKey: "review") as! NSDictionary
        reviewObj.bookingID = self.bookingID
        reviewObj.modalPresentationStyle = .fullScreen
        reviewObj.refresh = {
            self.getBookingDetails()
            self.navigationController!.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.present(reviewObj, animated: true, completion: nil)
    }
    //pay tips
    func payTips()  {
        let rewardObj = PayReward()
        rewardObj.userDict = self.bookingDict.value(forKey: "tasker") as! NSDictionary
        rewardObj.bookingID = self.bookingID
        rewardObj.refresh = {
            self.getBookingDetails()
            self.navigationController!.dismiss(animated: true, completion: nil)
        }
        rewardObj.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(rewardObj, animated: true, completion: nil)
        
    }
    //go to chat
    func goToChat()  {
        if self.chatDict.value(forKey: "chat_id") != nil{
            let detailObj = MessageDetails()
            detailObj.chatDict =  self.chatDict
            detailObj.viewFrom = "booking"
            detailObj.receiverID =  self.chatDict.value(forKey: "user_id") as! String
            detailObj.chatID =  self.chatDict.value(forKey: "chat_id") as! String
            detailObj.viewType = "chat"
            detailObj.bookingID =  self.chatDict.value(forKey: "booking_id") as! String
            detailObj.refreshChat = {
            }
            self.navigationController?.pushViewController(detailObj, animated: true)
        }
    }
    
    @IBAction func phoneNoBtnTapped(_ sender: Any) {
        let phoneNo = self.phoneNoLbl.titleLabel?.text
        if let url = URL(string: "tel://\(phoneNo!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //send stripe token to server for payment
    func payment(token:String,booking_id:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(booking_id, forKey: "booking_id")
        request.setValue(token, forKey: "payment_token")
        let totalAmt = Double(self.bookingDict.value(forKey: "total") as! String) ?? Double(0)
        request.setValue(String(format: "%.2f", totalAmt), forKey: "total_amount")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        request.setValue(currency, forKey: "currency")
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "total_amount")
        }
        Obj.baseService(subURl: PAY_BOOKING_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                //modified-AR
//                self.booking_status = "paid"
                self.booking_status = "completed"
//                //qwerty
//                self.changeBooking(status: "completed")
                if self.booking_type == "userneeds"{
                    self.checkStatus(type:"marketplace") // needs should perform as marketplace
                }else{
                    self.checkStatus(type:self.parent_cat_type)
                }
                Utility.shared.showToast(msg: "payment_done")
                self.getBookingDetails()
            }
            
            self.stopLoading()
            self.loader.stopAnimating()
        })
    }
    
    //socket delegate
    func gotSocket(msg: NSDictionary, type: String) {
        if type == "booking"{
            if let bookingID = msg.value(forKeyPath: "message.booking_id") as? String {
                if bookingID == self.bookingID{
                    self.getBookingDetails()
                }
            }
            else {
                self.getBookingDetails()
            }
        }else if type == "user"{ // CHAT MESSAGE
            print("bookingchat MSG : \(msg)")
            if let message_type = msg.value(forKey: "message_type") as? String {
                if message_type == "accept"{
                    self.getBookingDetails()
                }
            }
            else {
                self.getBookingDetails()
            }
        }
    }
}

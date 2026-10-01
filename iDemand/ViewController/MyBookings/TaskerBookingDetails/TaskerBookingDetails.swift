//
//  TaskerBookingDetails.swift
//  iDemand
//
//  Created by Roby on 23/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class TaskerBookingDetails: UIViewController,UITextFieldDelegate,socketDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var categoryTitleLbl: UILabel!
    @IBOutlet var categoriesLbl: UILabel!
    @IBOutlet var locationTitleLbl: UILabel!
    @IBOutlet var servicesLbl: UILabel!
    @IBOutlet var servicesScrollView: UIScrollView!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var dateTitleLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var phoneNoLbl: UIButton!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var OtpView: UIView!
    @IBOutlet var OtpContainerView: UIView!
    @IBOutlet var otpTitleLbl: UILabel!
    @IBOutlet var otpHintLbl: UILabel!
    @IBOutlet var otpTF: UITextField!
    @IBOutlet var otpTFView: UIView!
    @IBOutlet var otpSaveBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var paymentView: UIView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var bookingIDLbl: UILabel!
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
    @IBOutlet var rewardView: UIView!
    @IBOutlet var rewardLbl: UILabel!
    @IBOutlet var tipsLbl: UILabel!
    @IBOutlet var totalSeparatorLbl: UILabel!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var bookingStatusLbl: UILabel!
    @IBOutlet var needTitleLbl: UILabel!
    @IBOutlet var needTitleInfoLbl: UILabel!
    @IBOutlet var needTitleView: UIView!
    @IBOutlet var generalView: UIView!
    @IBOutlet var userSeparatorLbl: UILabel!
    @IBOutlet var needTitleSeparator: UILabel!
    //modified-AR
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    @IBOutlet var pickupView: UIView!
    @IBOutlet var dropView: UIView!
    @IBOutlet var dropLocationLbl: UILabel!
    @IBOutlet var dropTitleLbl: UILabel!
    @IBOutlet var dateSeparatorLbl: UILabel!
    
    var currency_code = String()
    var bookingArray = NSMutableArray()
    var viewFrom = String()
    var viewType = String()
    var bookingID = String()
    var bookingDict = NSDictionary()
    var parent_cat_type = String()
    var booking_status = String()
    var refreshRequest: (() -> Void)?
    var chatDict = NSDictionary()
    var chatID = String()
    var booking_type = String()
    var titleStr = String()
    var locationType = String()
    //modified-AR
    var quoteDes = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        SocketClass.sharedInstance.delegate = self
        //get data from server
        self.getBookingDetails()
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.OtpView.topRadius()
        self.otpSaveBtn.topRadius()
        self.generalView.frame.size.height = self.servicesLbl.frame.origin.y + 40
        
        self.navigationView.bottomRadius()
        if booking_status == "cancelled" || booking_status == "refunded" || booking_status == "completed" {
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height-50-265)
        }else{
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height-265)
        }
    }
    
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.categoryTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoriesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.needTitleInfoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.needTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
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
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rewardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rewardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.tipsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpSaveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.otpTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingIDLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropLocationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingStatusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.dropTitleLbl.textAlignment = .right
            self.dropLocationLbl.textAlignment = .left
            
            self.idLbl.textAlignment = .left
            self.bookingIDLbl.textAlignment = .right
            self.otpTF.textAlignment = .right
            self.otpHintLbl.textAlignment = .right
            self.otpTitleLbl.textAlignment = .right
            self.totalPriceLbl.textAlignment = .left
            self.categoryTitleLbl.textAlignment = .right
            self.categoriesLbl.textAlignment = .right
            self.locationTitleLbl.textAlignment = .right
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
            self.locationTitleLbl.textAlignment = .right
            self.locationLbl.textAlignment = .left
            self.dateTitleLbl.textAlignment = .right
            self.dateLbl.textAlignment = .left
            self.nameLbl.textAlignment = .right
            self.otpTitleLbl.textAlignment = .right
            self.phoneNoLbl.contentHorizontalAlignment = .right
            self.statusLbl.textAlignment = .left
            self.bookingStatusLbl.textAlignment = .right
            self.rewardLbl.textAlignment = .right
            self.tipsLbl.textAlignment = .left
            self.desLbl.frame.origin.x = 20
            self.desLbl.frame.origin.y = self.desTitleLbl.frame.origin.y + 30
            self.needTitleInfoLbl.textAlignment = .right
            self.needTitleLbl.textAlignment = .right
        }
    }
    //config initial setup
    func initialSetup()  {
        //modified-AR
        self.loader.color = PRIMARY_COLOR
        self.loader.hidesWhenStopped = true
        self.totalSeparatorLbl.isHidden = true
        self.bookingStatusLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "status")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "task_details")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        self.paymentView.isHidden = true
        currency_code = appDefault?.value(forKey: "currency_symbol") as! String
        //modified-AR
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        //modified-AR
        self.phoneNoLbl.isHidden = true
        self.phoneNoLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, title: "")
//        modified-AR
        self.servicesLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "category")
        self.categoryTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "categories")
        self.needTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "name")
        self.needTitleInfoLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        
        self.dateTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "date")
        //modified-AR
        self.bookingIDLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "booking_id")
        self.otpTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "otp")
        self.locationTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "location")
        self.desTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "description")
        self.summaryLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "payment_summary")
        self.rewardLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "tips")
        self.categoriesLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
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
        self.idLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, text: "")
        self.otpTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "otp")
        self.otpTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_otp")
        self.otpHintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "enter_otp")
        self.otpSaveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "done")
        self.otpSaveBtn.backgroundColor = PRIMARY_COLOR
        self.OtpContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
        self.otpTFView.addBorder(width: 1.0, color: LINE_COLOR!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.OtpContainerView.addGestureRecognizer(tap)
        self.OtpContainerView.isHidden = true
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

        //modified-AR
        //qwerty
//        self.bookingArray.addObjects(from: self.bookingDict.value(forKey: "services") as! [Any])
        
        self.bookingArray = [self.bookingDict]
        
        self.booking_type = self.bookingDict.value(forKey: "booking_type") as! String
        self.locationType = self.bookingDict.value(forKey: "location_type") as! String
        
        let userimgURL = URL.init(string: self.bookingDict.value(forKeyPath: "user.image") as! String)
        self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        self.nameLbl.text = self.bookingDict.value(forKeyPath: "user.name") as? String
        self.userImgView.radius(value: 5.0)
        
//        self.phoneNoLbl.setTitle("\(self.bookingDict.value(forKeyPath: "user.phone") as! String)", for: .normal)
        self.dateLbl.text = Utility.shared.toLocal(dateStr: self.bookingDict.value(forKey: "date") as! String,format:"dd.MMM.yyy")
        
        if locationType != "remote" {
            self.locationLbl.text = (self.bookingDict.value(forKey: "source_location") as! String)
            if locationType == "transport"  {
                self.dropLocationLbl.text = (self.bookingDict.value(forKey: "dest_location") as! String)
            }

        }
        if self.bookingDict.value(forKey: "description") !=  nil{
            self.desLbl.text = (self.bookingDict.value(forKey: "description") as! String)
        }
        self.idLbl.text = (self.bookingDict.value(forKey: "reference_id") as! String).uppercased()
        self.desLbl.numberOfLines = 0
        self.desLbl.sizeToFit()
        self.desLbl.frame.origin.x = 20
        self.desLbl.frame.origin.y = self.desTitleLbl.frame.origin.y + 30
        if viewFrom == "browse"{
            self.needTitleInfoLbl.text = self.titleStr
            self.needTitleInfoLbl.numberOfLines = 0
            self.needTitleInfoLbl.sizeToFit()
            self.needTitleView.isHidden = false
            self.needTitleSeparator.frame.origin.y = self.needTitleInfoLbl.frame.origin.y + self.needTitleInfoLbl.frame.size.height + 14
            
            self.needTitleView.frame.size.height = self.needTitleInfoLbl.frame.origin.y + self.needTitleInfoLbl.frame.size.height + 15
            self.generalView.frame.origin.y = self.needTitleView.frame.origin.y + self.needTitleView.frame.size.height
        }else{
            self.needTitleView.isHidden = true
            self.generalView.frame.origin.y = self.userSeparatorLbl.frame.origin.y + self.userSeparatorLbl.frame.size.height
        }
        
        
        //based on the live location
            self.pickupView.isHidden = true
            self.dropView.isHidden = true
            if locationType == "transport"{
                self.pickupView.isHidden = false
                self.dropView.isHidden = false
                self.locationTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "pickup")
                self.dropTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "drop")
                self.servicesLbl.frame.origin.y = self.dropView.frame.origin.y + 70
            }else if locationType == "home"{
                self.pickupView.isHidden = false
                self.servicesLbl.frame.origin.y = self.pickupView.frame.origin.y + 70
            }else{
                self.servicesLbl.frame.origin.y = self.dateSeparatorLbl.frame.origin.y + 15
            }
            self.generalView.frame.size.height = self.servicesLbl.frame.origin.y + 40
        
        self.configServices()
        
        self.paymentView.frame.origin.y = self.desLbl.frame.origin.y + self.desLbl.frame.size.height + 15
        self.bottomView.frame.size.height = self.paymentView.frame.origin.y + self.paymentView.frame.size.height + 15
        self.categoriesLbl.text = "\(self.bookingDict.value(forKey: "parent_category_name") as! String) - \(self.bookingDict.value(forKey: "subcategory_name") as! String)"
        booking_status =  self.bookingDict.value(forKey: "booking_status") as! String
        if booking_status == "requested"{
            self.statusLbl.text = Utility.shared.Json().value(forKey: "requested") as? String
        }
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
        
        
        let rewardStatus =  self.bookingDict.value(forKeyPath: "reward.status") as! String
        if rewardStatus == "true"{
            self.rewardView.isHidden = false
            if Utility.shared.isRTL(){
                self.tipsLbl.text = "\(self.bookingDict.value(forKeyPath: "reward.amount") as! String) \(currency_code)"
            }else{
                self.tipsLbl.text = "\(currency_code) \(self.bookingDict.value(forKeyPath: "reward.amount") as! String)"
            }
        }else{
            self.rewardView.isHidden = true
        }
        if booking_status == "cancelled" || booking_status == "refunded" || booking_status == "completed"{
            if rewardStatus == "true"{
                self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height-50)
            }else{
                self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height-100)
            }
        }else{
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height+50)
        }
        
        self.cancelBtn.backgroundColor = SECONDARY_COLOR
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        parent_cat_type =  self.bookingDict.value(forKey: "parent_category_type") as! String
        booking_status =  self.bookingDict.value(forKey: "booking_status") as! String
        
        if booking_type == "userneeds"{
            self.cancelBtn.removeRadius()
            self.saveBtn.removeRadius()
            self.saveBtn.frame.origin.x = 0
            self.saveBtn.frame.size.width = FULL_WIDTH
            self.saveBtn.topRadius()
            self.cancelBtn.isHidden = true
            //            self.titleLbl.text = titleStr
            
            self.titleLbl.adjustsFontSizeToFitWidth = true
            //modifed-AR
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "request")
            let  due_status =  self.bookingDict.value(forKey: "due_status") as! String
            if  (due_status == "expired" && !self.isBookingActive()) ||  (due_status == "pending" && !self.isBookingActive()) {
                self.saveBtn.isHidden = true
                self.statusLbl.text = Utility.shared.get(status: due_status)
            }else{
                self.saveBtn.isHidden = false
                if booking_status != "requested"{
                    self.checkStatus(type:"marketplace") // needs should perform as marketplace
                }
            }
        }else{
            self.checkStatus(type:parent_cat_type)
        }
        self.checkRTL()
    }
    //check current booking is crossed
    func isBookingActive() ->Bool {
        if self.booking_status == "paid" || self.booking_status == "started" || self.booking_status == "completed" || self.booking_status == "accepted"{
            return true
        }else{
            return false
        }
    }
    //check status
    func checkStatus(type:String){
        self.saveBtn.isHidden = true
        self.cancelBtn.isHidden = true
        
        if type == "professional"{
            if booking_status == "requested"{
                self.saveBtn.backgroundColor = SECONDARY_COLOR
                self.statusLbl.text = Utility.shared.Json().value(forKey: "requested") as? String
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "cancel") as! String))
            }else  if booking_status == "accepted"{
                self.statusLbl.text = Utility().Json().value(forKey: "accepted") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "chat") as! String))
            }else if booking_status == "paid"{
                self.statusLbl.text = Utility().Json().value(forKey: "paid") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "start") as! String))
            }else if booking_status == "started"{
                self.statusLbl.text = Utility().Json().value(forKey: "started") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "complete") as! String))
            }else if booking_status == "completed"{
                self.statusLbl.text = Utility().Json().value(forKey: "completed") as? String
            }else if booking_status == "cancelled" ||  booking_status == "refunded"{
                self.statusLbl.text = Utility().Json().value(forKey: "cancelled") as? String
            }
        }else{
            if booking_status == "requested"{
                self.statusLbl.text = Utility().Json().value(forKey: "requested") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "chat") as! String))
            }else  if booking_status == "accepted"{
                self.statusLbl.text = Utility().Json().value(forKey: "accepted") as? String
                //modified-AR
//                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "chat") as! String))
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "start") as! String))
            }else if booking_status == "paid"{
                self.statusLbl.text = Utility().Json().value(forKey: "paid") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "start") as! String))
            }else if booking_status == "started"{
                self.statusLbl.text = Utility().Json().value(forKey: "started") as? String
                self.showAct(isSingle: false, title:(Utility().Json().value(forKey: "complete") as! String))
            }
            //modified-AR
            else if booking_status == "payment_pending"{
                self.statusLbl.text = Utility().Json().value(forKey: "payment_pending") as? String
                //qwerty
                self.showAct(isSingle: true, title:(Utility().Json().value(forKey: "chat") as! String))
            }
            else if booking_status == "completed"{
                self.statusLbl.text = Utility().Json().value(forKey: "completed") as? String
            }else if booking_status == "cancelled" ||  booking_status == "refunded"{
                self.statusLbl.text = Utility().Json().value(forKey: "cancelled") as? String
            }
        }
        self.statusLbl.textColor = Utility.shared.color(status:booking_status)
        
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
            //modified-AR
//            self.saveBtn.isHidden = false
//            self.cancelBtn.isHidden = false
            self.saveBtn.isHidden = false
            self.cancelBtn.isHidden = false
        }
        self.saveBtn.setTitle(title, for: .normal)
        if booking_status == "paid" || booking_status == "started"{
            self.cancelBtn.setTitle((Utility().Json().value(forKey: "chat") as! String), for: .normal)
        }
        //modified-AR
//        else if added
        else if booking_status == "accepted"{
            self.cancelBtn.setTitle((Utility().Json().value(forKey: "chat") as! String), for: .normal)
        }
        else{
            self.cancelBtn.setTitle((Utility().Json().value(forKey: "cancel") as! String), for: .normal)
        }
    }
    
    //booking information
    func getBookingDetails(){
        self.startLoading()
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(bookingID, forKey: "booking_id")
        Obj.baseService(subURl: TASKER_BOOKING_DETAILS_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            self.scrollView.isHidden = false
            if status_code == 200{
                self.bookingDict = dict
                self.setDetails()
                self.getChatInfo(type: "", chat_id: self.bookingDict.value(forKey: "chat_id") as! String)
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
            Obj.baseService(subURl: TASKER_CHAT_INFO, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.chatID = responseDict.value(forKey: "chat_id") as! String
                    self.chatDict = responseDict
                    if type != ""{
                        if type == "professional"{
                            self.goToChat()
                        }else if type == "quote"{
                            //modified-AR
                            self.setChat()
//                            self.showQoutePopup()
                        }
                    }
                }
//                modified-AR
//                need to remove whole else condition
                
                self.stopLoading()
            })
        }
    }
    
    //create chat id
    func createChatID(type:String){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.bookingID, forKey: "booking_id")
            Obj.baseService(subURl: TASKER_CREATE_CHAT_ID, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.chatID = responseDict.value(forKey: "chat_id") as! String
                    self.getBookingDetails()
                    self.getChatInfo(type: type, chat_id: self.chatID)
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
            //modified-AR
            let userimgURL = URL.init(string:bookingDict.value(forKey: "subcategory_image") as! String )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "app_icon"))
            imgView.backgroundColor = LINE_COLOR
            serviceView.addSubview(imgView)
            
            //modified-AR
            let nameLbl = UILabel()
            nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            nameLbl.frame = CGRect.init(x: 80, y: 10, width:Int(FULL_WIDTH)-100 , height: 25)
//            modified-AR
            nameLbl.text = (bookingDict.value(forKey: "subcategory_name") as! String)
            serviceView.addSubview(nameLbl)
            
            //modified-AR
            let quantityLbl = UILabel()
            quantityLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
            quantityLbl.frame = CGRect.init(x: 80, y: 40, width:Int(FULL_WIDTH)-100 , height: 25)
            //            modified-AR
            var quantityType = bookingDict.value(forKey: "price") as! String
            if quantityType  == "hour"{
                quantityType = Utility.shared.Json().value(forKey: "hr") as! String
            }else{
                //            modified-AR
//                quantityType = Utility.shared.Json().value(forKey: "unit") as! String
            }
            
            //modified-AR
            if Utility.shared.isRTL() {
//                quantityLbl.text = "\(bookingDict.value(forKey: "service_quantity") ?? "") x \(quantityType) \u{200E}/\(bookingDict.value(forKey: "service_price") as! String) \(currency_code)"
            }else{
                
//                quantityLbl.text = "\(currency_code) \(bookingDict.value(forKey: "service_price") as! String)/\(quantityType) x \(bookingDict.value(forKey: "service_quantity") ?? "")"
            }
            
            serviceView.addSubview(quantityLbl)
            
            let totalAmtLbl = UILabel()
            totalAmtLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
            totalAmtLbl.frame = CGRect.init(x: Int(FULL_WIDTH)-200, y: 20, width:160 , height: 40)
            //modified-AR
            let amt = Double(bookingDict.value(forKey: "price") as! String)
            if Utility.shared.isRTL() {
                if self.booking_type == "userneeds"{
                    quantityLbl.isHidden = true
                    nameLbl.frame = CGRect.init(x: 80, y: 25, width:Int(FULL_WIDTH)-100 , height: 25)
                    //modified-AR
                    totalAmtLbl.text = "\(bookingDict.value(forKey: "price") as! String) \(currency_code)"
                }else{
                    totalAmtLbl.text = "\(amt!) \(currency_code)"
                }
            }else{
                if self.booking_type == "userneeds"{
                    quantityLbl.isHidden = true
                    nameLbl.frame = CGRect.init(x: 80, y: 25, width:Int(FULL_WIDTH)-100 , height: 25)
                    //modified-AR
                    totalAmtLbl.text = "\(currency_code) \(bookingDict.value(forKey: "price") as! String)"
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
            self.servicesScrollView.frame = CGRect.init(x: 0, y: Int(self.generalView.frame.origin.y+self.generalView.frame.size.height)-5, width: Int(FULL_WIDTH), height:topPadding)
            self.bottomView.frame.origin.y = self.servicesScrollView.frame.origin.y + CGFloat(topPadding)
        }
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
        self.refreshRequest?()
    }
    //dismiss view
    @objc func dismissView(_ sender: UITapGestureRecognizer? = nil) {
        self.otpTF.text = ""
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.OtpContainerView.isHidden = true
                        self.OtpContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
                       }, completion: nil)
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
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if self.booking_type == "userneeds" && booking_status == "requested"{
            self.checkChatAvailablity(type: "quote")
        }else{
            if parent_cat_type == "professional"{ //PROFESSIONAL
                if booking_status == "paid"{
                    //start
                    self.changeBooking(status: "started")
                }else if booking_status == "requested"{
                    //cancel
                    self.cancelRequest()
                }else  if booking_status == "accepted"{
                    //chat
                    self.checkChatAvailablity(type: "professional")
                }
                
                
                
                
                
                else if booking_status == "started"{
                    //complete
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                                   animations: {
                                    self.OtpContainerView.isHidden = false
                                    self.OtpContainerView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT)
                                   }, completion: nil)
                }
            }
            else{ //MARKETPLACE & NEEDS.
                if booking_status == "requested" || booking_status == "accepted"{
                    //chat
                    //modified-AR
//                    self.goToChat()
                    self.changeBooking(status: "started")
                }else if booking_status == "paid"{
                    //start
                    self.changeBooking(status: "started")
                }else if booking_status == "started"{
                    //complete
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                                   animations: {
                                    self.OtpContainerView.isHidden = false
                                    self.OtpContainerView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT)
                                   }, completion: nil)
                }
                // qwerty
                else if booking_status == "payment_pending"{
                    self.goToChat()
                }
            }
        }
    }
    
    //go to chat
    func goToChat()  {
        if self.chatDict.value(forKey: "chat_id") != nil{
            if viewFrom == "chat"{
                self.navigationController?.popViewController(animated: true)
            }else{
                let detailObj = MessageDetails()
                detailObj.viewFrom = "booking"
                detailObj.chatDict =  self.chatDict
                detailObj.receiverID =  self.chatDict.value(forKey: "user_id") as! String
                detailObj.chatID =  self.chatDict.value(forKey: "chat_id") as! String
                detailObj.viewType = "chat"
                detailObj.bookingID =  self.chatDict.value(forKey: "booking_id") as! String
                detailObj.refreshChat = {
                }
                self.loader.stopAnimating()
                self.navigationController?.pushViewController(detailObj, animated: true)
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        if self.booking_type == "userneeds" && booking_status == "requested"{
            self.checkChatAvailablity(type: "quote")
        }else if booking_status == "paid" || booking_status == "started"{
            self.checkChatAvailablity(type: "professional")
        }
        //modified-AR
//        else if added
        else if booking_status == "accepted"{
            self.checkChatAvailablity(type: "professional")
        }
        else{
            self.cancelRequest()
        }
    }
    func cancelRequest(){
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "cancel_request"
        alertObj.deleteRequest = {
            self.startLoading()
            self.changeBooking(status: "cancelled")
            self.refreshRequest!()
        }
        self.navigationController?.present(alertObj, animated: false, completion: nil)
    }
    //check if there chat is available
    func checkChatAvailablity(type:String)  {
        self.chatID = self.bookingDict.value(forKey: "chat_id") as! String
        if self.chatID == ""{
            //modified-AR
            //add if
            if type == "quote"{
//                self.startLoading()
                self.showQoutePopup()
            }
            
//            self.startLoading()
//            self.createChatID(type: type)
        }else{
            if type == "quote"{
                self.showQoutePopup()
            }else if type == "professional"{
                self.goToChat()
            }
        }
    }
    
    
    //quote menu
    func showQoutePopup()  {
        //modified-AR
//        let bookingArray = self.bookingDict.value(forKey: "services") as! NSArray
//        let serviceDict = bookingArray.object(at: 0) as! NSDictionary
        let serviceDict = bookingDict
        let quoteObj = QuotePage()
        quoteObj.modalPresentationStyle = .overCurrentContext
        quoteObj.serviceDict = serviceDict
        if self.booking_type == "userneeds"{
            quoteObj.priceStr = serviceDict.value(forKey: "price") as! String
        }else{
            quoteObj.priceStr = serviceDict.value(forKey: "service_total_price") as! String
        }
        quoteObj.quoted = { [self] price,des in
            //modified-AR
            self.quoteDes = des
            if self.chatID == ""{
                self.loader.startAnimating()
                self.createChatID(type: "quote")
            }
            
//            let msgDict = NSMutableDictionary()
//            msgDict.setValue("\(Utility.shared.Json().value(forKey: "quoted_price") ?? "") \(self.currency_code)\(price) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))", forKey: "message")
//            msgDict.setValue(des, forKey: "description")
//            msgDict.setValue("quote", forKey: "type")
//            msgDict.setValue(price, forKey: "quote_price")
//            msgDict.setValue("true", forKey: "isActive")
//            msgDict.setValue("\(self.currency_code)\(price)", forKey: "price")
//
//            //modified-AR
//            self.initiateServiceChat(msgDict: msgDict, type: "quote")
        }
        self.navigationController?.present(quoteObj, animated: true, completion: nil)
    }
    
    
    func setChat(){
        let msgDict = NSMutableDictionary()
        msgDict.setValue("\(Utility.shared.Json().value(forKey: "price") ?? "") \(self.currency_code)\(self.bookingDict.value(forKey: "price")) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))", forKey: "message")
        msgDict.setValue(self.quoteDes, forKey: "description")
        msgDict.setValue("quote", forKey: "type")
        msgDict.setValue(self.bookingDict.value(forKey: "price"), forKey: "quote_price")
        msgDict.setValue("true", forKey: "isActive")
        msgDict.setValue("\(self.currency_code)\(self.bookingDict.value(forKey: "price") as? String ?? "")", forKey: "price")
        
        //modified-AR
        self.initiateServiceChat(msgDict: msgDict, type: "quote")
    }
    
    //initiate first msg
    func initiateServiceChat(msgDict:NSDictionary,type:String)  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            //send msg
            let requestDict = NSMutableDictionary()
            requestDict.setValue("bookingchat", forKey: "type")
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            requestDict.setValue(profile.name, forKey: "user_name")
            requestDict.setValue(profile.user_image, forKey: "user_image")
            requestDict.setValue(self.bookingDict.value(forKeyPath: "user.id") as? String, forKey: "receiver_id")
            requestDict.setValue(self.chatID, forKey: "chat_id")
            requestDict.setValue(Utility.shared.UTC(), forKey: "date")
            requestDict.setValue(Utility.shared.messageID(), forKey: "message_id")
            requestDict.setValue(type, forKey: "message_type")
            requestDict.setValue(msgDict, forKey: "message")
            SocketClass.sharedInstance.send(msg: requestDict)
            self.goToChat()
        }catch{
        }
        
    }
    
    
    @IBAction func otpSaveBtnTapped(_ sender: Any) {
        let otp = self.bookingDict.value(forKey: "otp") as! String
        if self.otpTF.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_otp")
        }else if self.otpTF.text != otp{
            Utility.shared.showToast(msg: "otp_not_valid")
        }else{
            self.startLoading()
            //modified-AR
//            self.changeBooking(status: "completed")
            self.changeBooking(status: "payment_pending")
            self.refreshRequest!()
        }
    }
    
    //change status
    func changeBooking(status:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(status, forKey: "status")
        request.setValue(self.bookingID, forKey: "booking_id")
        //modified-AR
        if status == "payment_pending"{
//        if status == "completed"{
            request.setValue(otpTF.text, forKey: "otp")
        }
        Obj.baseService(subURl: TASKER_BOOKING_STATUS_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.getBookingDetails()
                if status == "payment_pending"{
                    self.refreshRequest!()
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                                   animations: {
                                    self.OtpContainerView.isHidden = true
                                    self.OtpContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
                                   }, completion: nil)
                }
            }else if status_code == 400{
                self.booking_status = dict.value(forKey: "booking_status") as! String
                self.getBookingDetails()
                self.refreshRequest!()
                Utility.shared.serverAlert(msg: dict.value(forKey: "message") as! String)
            }
            self.stopLoading()
        })
    }
    
    
    //textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{
            if textField.text!.count > 3{
                if string.isEmpty{
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

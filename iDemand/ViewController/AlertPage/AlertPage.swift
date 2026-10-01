//
//  AlertPage.swift
//  iDemand
//
//  Created by Roby on 03/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class AlertPage: UIViewController,UITextFieldDelegate {
    @IBOutlet var alertView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var okayBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var msgLbl: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var amtTF: UITextField!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var amtView: UIView!
    @IBOutlet var adminView: UIView!
    @IBOutlet var adminTitleLbl: UILabel!
    @IBOutlet var adminMsgLbl: UILabel!
    @IBOutlet var adminBtn: UIButton!
    
    var service:Services?
    var amtStr = String()
    let apiObj = BaseAPI()
    var viewType = String()
    var deleteRequest: (() -> Void)?
    var addPrice: ((_ price:String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.alertView.backgroundColor = BACKGROUND_COLOR
        self.adminView.backgroundColor = BACKGROUND_COLOR
        self.alertView.backgroundColor = BACKGROUND_COLOR

    }
    override func viewDidLayoutSubviews() {
        self.alertView.topRadius()
        self.adminBtn.topRadius()
        self.adminView.topRadius()

        if Utility.shared.isRTL() {
            self.saveBtn.removeRadius()
            self.cancelBtn.removeRadius()
            self.saveBtn.topRadius()
            self.cancelBtn.corner(position: .topRight)
            self.okayBtn.corner(position: .topLeft)
        }else{
            self.saveBtn.topRadius()
            self.cancelBtn.corner(position: .topLeft)
            self.okayBtn.corner(position: .topRight)
        }
        
        self.priceView.topRadius()
    }
    
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.okayBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.adminBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amtTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.adminTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.adminMsgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.textAlignment = .right
            self.priceLbl.textAlignment = .right
            self.amtTF.textAlignment = .right
            self.titleLbl.textAlignment = .right
            self.msgLbl.textAlignment = .right
            self.adminTitleLbl.textAlignment = .right
            self.adminMsgLbl.textAlignment = .right
            
        }
    }
    //initial setup
    func initialSetup()  {
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as? String
        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double
        self.adminBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "ok")

        self.adminBtn.backgroundColor = PRIMARY_COLOR

        self.okayBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "yes")
        self.cancelBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "no")
        self.cancelBtn.backgroundColor = SECONDARY_COLOR
        self.okayBtn.backgroundColor = PRIMARY_COLOR
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        
        if viewType == "logout"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "logout")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "confirm_logout")
        }else if viewType == "delete"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "delete")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "want_to_delete")
        }else if viewType == "deactivate"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "deactive_account")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "confirm_deactivate")
        }else if viewType == "tasker_info"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "profile_information")
        }else if viewType == "cancel_request"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "cancel_booking")
        }else if viewType == "hire_confirm"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "hire_confirm")
        }else if viewType == "decline_request"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "decline_alert")
        }else if viewType == "accept_request"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "accept_alert")
            self.msgLbl.text = "\(Utility.shared.Json().value(forKey: "accept_alert") ?? "") \(self.amtStr)"
        }else if viewType == "payment_pending_alert"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "payment_pending_alert")
        }else if viewType == "post_job_alert"{
            self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
            self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "post_job_alert")
            self.okayBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "ok")
        }else if viewType == "admin"{
                self.adminTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
                self.adminMsgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "admin_contact_soon")
        }else if viewType == "mobile_no_validation"{
                self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
                self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "mobile_no_validation")
        }
        // qwerty
        else if viewType == "please_delete_existing_service"{
                self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
                self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "please_delete_existing_service")
        }
        // qwerty
        else if viewType == "user_need_post_alert"{
                self.adminTitleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "alert")
                self.adminMsgLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "user_need_post_alert")
        }
                
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.containerView.addGestureRecognizer(tap)
        
        if viewType == "addservice"{
            let userimgURL = URL.init(string: (service?.service_image)!)
            self.serviceImgView.radius(value: 5.0)
            self.serviceImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "save")
            self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "task_price")
            self.currencyLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "")
            self.currencyLbl.backgroundColor = LINE_COLOR
            self.amtTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "")
            self.amtTF.placeholder = "\(Utility.shared.Json().value(forKey: "enter_amount") ?? "") (\(currency_code!)\(payment_minimum_price!))"
            self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
            self.serviceNameLbl.text = service?.service_name
            self.amtTF.leftPadding()
            self.amtView.radius(value: 5.0)
            self.amtView.layer.borderColor = LINE_COLOR?.cgColor
            self.amtView.layer.borderWidth = 1
            self.saveBtn.backgroundColor = PRIMARY_COLOR
            self.amtTF.text =  amtStr
            self.currencyLbl.text = currency_code
            self.alertView.isHidden = true
            self.priceView.isHidden = false
            self.adminView.isHidden = true
        }else if viewType == "admin"{
          self.alertView.isHidden = true
            self.priceView.isHidden = true
            self.adminView.isHidden = false
        }
        //qwerty
        else if viewType == "user_need_post_alert"{
          self.alertView.isHidden = true
            self.priceView.isHidden = true
            self.adminView.isHidden = false
        }
        else{
            self.alertView.isHidden = false
            self.priceView.isHidden = true
            self.adminView.isHidden = true
        }
        self.checkRTL()
        
    }
    
    //dismiss view
    @objc func dismissView(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func adminBtnTapped(_ sender: Any) {
        LocalDefault.shared.setHint(status: "false")
        self.deleteRequest!()
        self.dismiss(animated: false, completion: nil)

    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if viewType == "logout" || viewType == "deactivate"{
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            var api_name = String()
            if  viewType == "logout"{
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
        //qwerty
        else if viewType == "delete" || viewType == "tasker_info" || viewType == "cancel_request" || viewType == "accept_request" || viewType == "decline_request" || viewType == "payment_pending_alert" || viewType == "post_job_alert" || viewType == "admin" || viewType == "hire_confirm" || viewType == "mobile_no_validation" || viewType == "please_delete_existing_service" || viewType == "user_need_post_alert"{
            self.deleteRequest!()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let defaultDict = LocalDefault.shared.appDefaults()
        let price = Double("\(self.amtTF.text!)") ?? .nan
        let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String
        
        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double ?? .nan
        if self.amtTF.isEmptyValue() || price < payment_minimum_price {
            let msgStr = "\(Utility.shared.Json().value(forKey: "enter_valid_amount") ?? "") \(currency_symbol)\(payment_minimum_price)"
            Utility.shared.customToast(msg: msgStr)
        }else{
            self.addPrice!(self.amtTF.text!)
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    //textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{            
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.last == "." {
            self.amtTF.text?.removeLast()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

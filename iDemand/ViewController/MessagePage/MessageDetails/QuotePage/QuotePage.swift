//
//  QuotePage.swift
//  iDemand
//
//  Created by Roby on 29/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class QuotePage: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var quoteView: UIView!
    @IBOutlet var quoteLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var amtLbl: UILabel!
    @IBOutlet var amtView: UIView!
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var desTV: UITextView!
    var quoted: ((_ price:String,_ des:String) -> Void)?
    var priceStr = String()
    
    var bookingID = String()
    var serviceDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewDidLayoutSubviews() {
        self.quoteView.topRadius()
        self.payBtn.topRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
        //qwerty
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.backgroundColor = .clear

    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.quoteLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.payBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.quoteLbl.textAlignment = .right
            self.amtLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
            self.priceLbl.textAlignment = .right
            self.priceTF.textAlignment = .right
            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "share_your_message")
        }else{
            self.desTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "share_your_message")
        }
    }
    //initial setup
    func initialSetup()  {
        //modified-AR
        self.amtView.isHidden = true
        self.amtLbl.isHidden = true
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        self.addLoader()
        self.serviceImgView.radius(value: 5.0)
        //modified-AR
//        self.quoteLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "quote_your_price")
        self.quoteLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "request")
        self.amtLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "amount")
        self.currencyLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "")
        self.currencyLbl.backgroundColor = LINE_COLOR

        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double
        self.priceTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "")
        self.priceTF.placeholder = "\(Utility.shared.Json().value(forKey: "enter_amount") ?? "") (\(currency_code)\(payment_minimum_price!))"
        
        self.priceTF.leftPadding()
        self.amtView.radius(value: 5.0)
        self.amtView.addBorder(width: 1.0, color: LINE_COLOR!)
        self.desTV.radius(value: 5.0)
        self.desTV.addBorder(width: 1.0, color: LINE_COLOR!)
        //modified-AR
//        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        self.priceLbl.config(color: PRIMARY_COLOR!, font: headBold, align: .left, text: "")
        self.desTV.textContainerInset = UIEdgeInsets.init(top: 10, left: 5, bottom: 5, right: 5)
        self.payBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "send")
        self.payBtn.backgroundColor = PRIMARY_COLOR
        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
//        modified-AR
//        let userimgURL = URL.init(string: (self.serviceDict.value(forKey: "service_image") as? String)!)
//        self.serviceImgView.sd_setImage(with: userimgURL,  placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
//        self.serviceNameLbl.text = self.serviceDict.value(forKey: "service_name") as? String
        //modified-AR
        let userimgURL = URL.init(string: (self.serviceDict.value(forKey: "subcategory_image") as? String) ?? "")
        self.serviceImgView.sd_setImage(with: userimgURL,  placeholderImage: #imageLiteral(resourceName: "app_icon"))
        //modifiedAR
//        self.serviceNameLbl.text = self.serviceDict.value(forKey: "subcategory_name") as? String
        self.serviceNameLbl.text = "\(self.serviceDict.value(forKey: "parent_category_name") ?? "") - \(self.serviceDict.value(forKey: "subcategory_name") as? String ?? "")"
        self.serviceNameLbl.numberOfLines  = 2
        
    
        self.currencyLbl.text = currency_code
        //modified-AR
//        self.priceLbl.text = "\(Utility.shared.Json().value(forKey: "ask_price") ?? "") \(currency_code) \(priceStr)"
        self.priceLbl.text = "\(currency_code)\(priceStr)"
        
        self.priceTF.text = priceStr
        self.priceLbl.adjustsFontSizeToFitWidth = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopup(_:)))
        containerView.addGestureRecognizer(tap)
        self.checkRTL()
    }
    
    @IBAction func quoteBtnTapped(_ sender: Any) {
        
        let defaultDict = LocalDefault.shared.appDefaults()
        let price = Double("\(self.priceTF.text!)") ?? .nan
        //modified-AR
        
//        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double ?? .nan
//        let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String
        
//        if self.priceTF.isEmptyValue() || price < payment_minimum_price  {
//            let msgStr = "\(Utility.shared.Json().value(forKey: "enter_valid_amount") ?? "") \(currency_symbol)\(payment_minimum_price)"
//            Utility.shared.customToast(msg: msgStr)
//        }else if self.desTV.isEmptyValue() {
//            Utility.shared.showToast(msg: "enter_description")
//        }else{
//            self.quoted!(self.priceTF.text!, self.desTV.text)
//            self.dismiss(animated: true, completion: nil)
//
//        }
        
        if self.desTV.isEmptyValue(){
            Utility.shared.showToast(msg: "enter_description")
        }
        else{
//            modified-AR
            if LocalDefault().isUser()!{
                let vc = TaskerDetails()
                
            }
            else{
                let vc = TaskerBookingDetails()
            }
            self.quoted!(String(price), self.desTV.text)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dismissPopup(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if sender?.view == self.quoteView{
            print("quote view")
        }
        if sender?.view == self.containerView{
            print("container view")

            self.dismiss(animated: true, completion: nil)
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
             self.priceTF.text?.removeLast()
         }
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  PayReward.swift
//  iDemand
//
//  Created by Roby on 18/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MGStarRatingView
import Stripe
import SwiftyJSON

class PayReward: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var reviewView: UIView!
    @IBOutlet var rewardLbl: UILabel!
    @IBOutlet var taskerImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ratingView: StarRatingView!
    @IBOutlet var amtLbl: UILabel!
    @IBOutlet var amtView: UIView!
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var currencyTF: UITextField!
    @IBOutlet var currencyLbl: UILabel!
    var refresh: (() -> Void)?
    
    var bookingID = String()
    var userDict = NSDictionary()
    
    var stripeModel = StripeDataModel()
    var stripe_currency = ["BIF","CLP","DJF","GNF","JPY","KMF","KRW","MGA","PYG","RWF","UGX","VND","VUV","XAF","XOF","XPF"];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.reviewView.topRadius()
        self.payBtn.topRadius()
    }
    //initial set up
    func initialSetup()  {
        self.addLoader()
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String
        StripeAPI.defaultPublishableKey = defaultDict?.value(forKey: "stripe_public_key") as? String ?? ""

        self.taskerImgView.radius(value: 5.0)
        self.rewardLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "reward_to_tasker")
        self.amtLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "amount")
        self.currencyLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "")
        self.currencyLbl.backgroundColor = LINE_COLOR
        
        
        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double
        self.currencyTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "")
        self.currencyTF.placeholder = "\(Utility.shared.Json().value(forKey: "enter_amount") ?? "") (\(currency_symbol)\(payment_minimum_price!))"
        
        self.currencyTF.leftPadding()
        self.amtView.radius(value: 5.0)
        self.amtView.layer.borderColor = LINE_COLOR?.cgColor
        self.amtView.layer.borderWidth = 1
        self.payBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "pay")
        self.payBtn.backgroundColor = PRIMARY_COLOR
        self.payBtn.radius(value: 5.0)
        let attribute = StarRatingAttribute(type: .half,
                                            point: 18,
                                            spacing: 0.5,
                                            emptyColor: .lightGray,
                                            fillColor: SENDER_INNER_BG!,
                                            emptyImage: nil,
                                            fillImage: nil)
        
        let rating = self.userDict.value(forKey: "rating") as! NSString
        ratingView.configure(attribute, current:CGFloat(rating.floatValue), max: 5)
        ratingView.isUserInteractionEnabled = false
        
        let userimgURL = URL.init(string: (self.userDict.value(forKey: "image") as? String)!)
        self.taskerImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        self.nameLbl.text = self.userDict.value(forKey: "name") as? String
      
        self.currencyLbl.text = currency_symbol
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopup(_:)))
        containerView.addGestureRecognizer(tap)
        self.checkRTL()
    }
    //check rtl layout
      func checkRTL()  {
          if Utility.shared.isRTL(){
              self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.rewardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.amtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.currencyTF.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.payBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.rewardLbl.textAlignment = .right
              self.amtLbl.textAlignment = .right
              self.nameLbl.textAlignment = .right
              self.currencyTF.textAlignment = .right
          }
      }
    @IBAction func payBtnTapped(_ sender: Any) {
        let defaultDict = LocalDefault.shared.appDefaults()
            let price = Double("\(self.currencyTF.text!)") ?? .nan
            let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double ?? .nan
        let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String

        if self.currencyTF.isEmptyValue() || price < payment_minimum_price{
            let msgStr = "\(Utility.shared.Json().value(forKey: "enter_valid_amount") ?? "") \(currency_symbol)\(payment_minimum_price)"
            Utility.shared.customToast(msg: msgStr)
        }else{
//            let defaultDict = LocalDefault.shared.appDefaults()
//            let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String
            self.paymentProcess()
//            let paymentObj = PaymentPage()
//            paymentObj.amtStr = "\(currency_symbol) \(self.currencyTF.text!)"
//            paymentObj.paymentDone = { token in
//                self.addLoader()
//                self.startLoading()
//                self.payReward(token: token)
//                self.dismiss(animated: true, completion: nil)
//            }
//            paymentObj.modalPresentationStyle = .fullScreen
//            self.present(paymentObj, animated: true, completion: nil)
        }
    }
    //payment details
    func paymentProcess()  {
        
        var paymentSheet: PaymentSheet?
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        let totalAmt = Double(self.currencyTF.text!) ?? .nan
        request.setValue(String(format: "%.2f", totalAmt), forKey: "amount")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        request.setValue(currency, forKey: "currency")
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "amount")
        }
        self.addLoader()
        self.startLoading()
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
                                self.payReward(token: (token.first ?? ""))
                            case .canceled:
                                print("Canceled!")
                                self.stopLoading()
                            case .failed(let error):
                                print("Payment failed: \n\(error.localizedDescription)")
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
    //send stripe token to server for payment
    func payReward(token:String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.bookingID, forKey: "booking_id")
        request.setValue(token, forKey: "payment_token")
//        request.setValue(self.currencyTF.text, forKey: "amount")
        let totalAmt = Double(self.currencyTF.text!) ?? .nan
        request.setValue(String(format: "%.2f", totalAmt), forKey: "amount")
        let appDefault = LocalDefault.shared.appDefaults()
        let currency = (appDefault?.value(forKey: "currency_code") as! String).trimmingCharacters(in: .whitespaces)
        request.setValue(currency, forKey: "currency")
        if stripe_currency.contains(currency) {
            request.setValue(String(format: "%.0f", totalAmt), forKey: "amount")
        }
//        (self.currencyTF.text!)
        Obj.baseService(subURl: PAY_REWARD_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                Utility.shared.showToast(msg: "payment_done")
                self.refresh!()
            }
            self.stopLoading()
        })
    }
    
    
    @objc func dismissPopup(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismiss(animated: true, completion: nil)
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
            self.currencyTF.text?.removeLast()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        textField.resignFirstResponder()
        return true
    }
}

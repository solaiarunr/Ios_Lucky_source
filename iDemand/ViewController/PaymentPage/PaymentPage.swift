//
//  PaymentPage.swift
//  iDemand
//
//  Created by Roby on 21/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe

class PaymentPage: UIViewController {
    
    @IBOutlet var paymentView: STPPaymentCardTextField!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var payBtn: UIButton!
    var amtStr = String()
    var paymentDone: ((_ token:String) -> Void)?
    var viewType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.payBtn.topRadius()
        self.navigationView.bottomRadius()
    }
    
    //config initial setup
    func initialSetup()  {
        self.addLoader()
        let appDefault = LocalDefault.shared.appDefaults()
        let publishKey = appDefault?.value(forKey: "stripe_public_key") as! String
        Stripe.setDefaultPublishableKey(publishKey)
        StripeAPI.defaultPublishableKey = appDefault?.value(forKey: "stripe_public_key") as! String

        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.payBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "pay")
        self.payBtn.backgroundColor = PRIMARY_COLOR
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.paymentView.font = subReg ?? UIFont.systemFont(ofSize: 15)
        self.paymentView.postalCodeEntryEnabled = false
        self.titleLbl.text = "\(Utility.shared.Json().value(forKey: "pay") ?? "") - \(self.amtStr)"
        self.paymentView.becomeFirstResponder()
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if viewType == "professional"{
            let alertObj = AlertPage()
            alertObj.modalPresentationStyle = .overCurrentContext
            alertObj.viewType = "payment_pending_alert"
            alertObj.deleteRequest = {
                self.paymentDone!("")
            }
            self.present(alertObj, animated: false, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func payBtnTapped(_ sender: Any) {
        if self.paymentView.isValid{
            self.startLoading()
            let cardParams = STPCardParams()
            cardParams.number = self.paymentView.cardNumber
            cardParams.expYear = UInt(self.paymentView.expirationYear)
            cardParams.expMonth = UInt(self.paymentView.expirationMonth)
            cardParams.cvc = self.paymentView.cvc
            STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
                self.stopLoading()
                if token?.stripeID != nil{
                    self.paymentDone!(token!.stripeID)
                }
            }
        }else{
            self.stopLoading()
            Utility.shared.showToast(msg: "enter_valid_card")
        }
    }
    
}

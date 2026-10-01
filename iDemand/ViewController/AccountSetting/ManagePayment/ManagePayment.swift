//
//  ManagePayment.swift
//  iDemand
//
//  Created by Roby on 23/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Stripe
import SafariServices

class ManagePayment: UIViewController ,SFSafariViewControllerDelegate{
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var publicKeyTF: UITextField!
    @IBOutlet var privateKeyTF: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var publicKeyLbl: UILabel!
    @IBOutlet var privateKeyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.submitBtn.topRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        let publishKey = appDefault?.value(forKey: "stripe_public_key") as! String
        Stripe.setDefaultPublishableKey(publishKey)
        self.checkConnection()
        
        self.addLoader()
        self.publicKeyLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "public_key")
        self.privateKeyLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "private_key")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "stripe")
        self.publicKeyTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "enter_public_key")
        self.privateKeyTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "enter_private_key")
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "save")
        
        do{
            let jsonDecoder = JSONDecoder()
            let  profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            self.privateKeyTF.text = profile.stripe_private_key
            self.publicKeyTF.text = profile.stripe_public_key
        }catch{
        }
        self.checkRTL()
    }
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.publicKeyTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.privateKeyTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.publicKeyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.privateKeyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.publicKeyTF.textAlignment = .right
            self.privateKeyTF.textAlignment = .right
            self.publicKeyLbl.textAlignment = .right
            self.privateKeyLbl.textAlignment = .right
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.publicKeyTF.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_public_key")
        }else if self.privateKeyTF.isEmptyValue() {
            Utility.shared.showToast(msg: "enter_private_key")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.startLoading()
                self.updateStripeInfo()
            }
        }
    }
    
    //update stripe details
    func updateStripeInfo()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(self.publicKeyTF.text, forKey: "stripe_public_key")
        requestDict.setValue(self.privateKeyTF.text, forKey: "stripe_private_key")
        Obj.baseService(subURl: TASKER_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey:"status_code") as! Int
            self.stopLoading()
            if status_code == 200{
                LocalDefault.shared.setUser(data: response.data!)
                Utility.shared.showToast(msg: "stripe_details_updated")
                self.navigationController?.popViewController(animated: true)
            }else{
                let message = resDict.value(forKey:"message") as! String
                Utility.shared.serverAlert(msg: message)
            }
        })
    }
    
    
    //MARK: textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{
            if string.isEmpty{
                return true
            }else{
                return false
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func createStripeAccount()  {
        
        let appDefault = LocalDefault.shared.appDefaults()
        let publishKey = appDefault?.value(forKey: "stripe_public_key") as! String
        let url : String = "https://api.stripe.com/v1/accounts"
        let parameters = ["type": "express"]
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer sk_test_51HaL45Lm1VO21YvJNHxlnTAvWVhjLyT4RPKC3pIrm78irfAAXfldr8GwNs5vMuNJ36vzVzelwptTwvLu59TLvP7q00fd9lxrnh", forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func checkConnection()  {
        
        
        
        let safariViewController = SFSafariViewController(url:URL.init(string: "https://connect.stripe.com/setup/s/0OhXNwX1wwbg")!)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)


        /*
        let baseURLStr = "https://api.stripe.com/v1/accounts/onboard-user"
        if let url = URL(string: baseURLStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer sk_test_51HaL45Lm1VO21YvJNHxlnTAvWVhjLyT4RPKC3pIrm78irfAAXfldr8GwNs5vMuNJ36vzVzelwptTwvLu59TLvP7q00fd9lxrnh", forHTTPHeaderField: "Authorization")
            
            
            let session = URLSession.shared
            _ = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
                print(response!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    let accountURLString = json["url"] as? String
                    _ = URL(string: accountURLString!)
                    let safariViewController = SFSafariViewController(url: url)
                    safariViewController.delegate = self
                    
                    DispatchQueue.main.async {
                        self.present(safariViewController, animated: true, completion: nil)
                    }
                } catch {
                    print("error")
                }
            })
        } */
    }
    
}

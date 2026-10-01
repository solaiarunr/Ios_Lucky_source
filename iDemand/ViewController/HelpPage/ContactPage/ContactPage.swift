//
//  ContactPage.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class ContactPage: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var mobileLbl: UILabel!
    @IBOutlet var mobileTF: UITextField!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var msgLbl: UILabel!
    @IBOutlet var msgTV: UITextView!
    @IBOutlet var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.submitBtn.topRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initialSetup()  {
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "contact_us")
        
        self.nameLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "your_name")
        self.mobileLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "your_mobile")
        self.emailLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "your_mail")
        self.msgLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "message")
        
        self.nameTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_your_name")
        self.mobileTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_your_mobile")
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "enter_your_mail")
        
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "send")
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.setDetails()
        self.checkRTL()
    }
    //check rtl layout
       func checkRTL()  {
           if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.textAlignment = .right
            self.nameLbl.textAlignment = .right
            
            self.mobileTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mobileLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mobileTF.textAlignment = .right
            self.mobileLbl.textAlignment = .right
            
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.emailLbl.textAlignment = .right
            
            self.msgTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgLbl.textAlignment = .right
            self.msgTV.textAlignment = .right

            self.msgTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "type_your_msg")
           }else{
            self.msgTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "type_your_msg")
        }
       }
    
    
    //set profile information
    func setDetails()  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            self.nameTF.text = profile.name
            self.mobileTF.text = profile.mobile
            self.emailTF.text = profile.email
            
            self.emailTF.isUserInteractionEnabled = false
            self.emailTF.textColor = LINE_COLOR

        }catch{
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //signup button action
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.nameTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_name")
        }else if self.nameTF.text!.count < 3 {
            Utility.shared.showAlert(msg: "enter_valid_name")
        }else if self.mobileTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_phone")
        }else if self.emailTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_email")
        }else if !(self.emailTF.text?.isValidEmail())!{
            Utility.shared.showAlert(msg: "enter_valid_email")
        }else if self.mobileTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "choose_location")
        }else if self.msgTV.isEmptyValue() {
            Utility.shared.showAlert(msg: "type_your_msg")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.sendApiService()
            }
        }
    }
    
    //MARK: submit api service
    func sendApiService()  {
        if Utility.shared.isConnectedToNetwork(){

        self.startLoading()
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.nameTF.text, forKey: "name")
        requestDict.setValue(self.mobileTF.text, forKey: "mobile")
        requestDict.setValue(self.msgTV.text, forKey: "description")
        requestDict.setValue(self.emailTF.text, forKey: "email")
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")

        Obj.baseService(subURl: CONTACT_US_API, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                Utility.shared.showToast(msg: "mail_sent")
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        }
    }
    //MARK: textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if textField.tag == 3{
             if string == " "{
                 return false
             }
         }
        if msg.containsEmoji(){
            return false
        }else{
            if textField.tag == 1{
                if textField.text!.count > 30{
                    if string.isEmpty{
                        return true
                    }else{
                        return false
                    }
                }else{
                    var restrict = String()
                    restrict = USERNAME_CHARACTERS
                    if !string.isEmpty{
                        let set = CharacterSet(charactersIn: restrict)
                        let inverted = set.inverted
                        let filtered = string.components(separatedBy: inverted).joined(separator: "")
                        return filtered != string
                    }else{
                        return true
                    }
                }
            }
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
}

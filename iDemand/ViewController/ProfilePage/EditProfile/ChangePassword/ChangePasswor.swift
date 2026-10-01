//
//  ChangePasswor.swift
//  iDemand
//
//  Created by Roby on 07/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ChangePasswor: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var currentPasswordTF: UITextField!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var currentPwdTitleLbl: UILabel!
    @IBOutlet var newPwdTitleLbl: UILabel!
    @IBOutlet var confirmPwdTitleLbl: UILabel!

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
        self.checkRTL()
    }
    //check rtl
       func checkRTL()  {
           if Utility.shared.isRTL(){
               self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.newPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.confirmPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.currentPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.currentPwdTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.newPwdTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.currentPwdTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.newPasswordTF.textAlignment = .right
               self.confirmPasswordTF.textAlignment = .right
               self.currentPasswordTF.textAlignment = .right
               self.currentPwdTitleLbl.textAlignment = .right
               self.newPwdTitleLbl.textAlignment = .right
               self.currentPwdTitleLbl.textAlignment = .right            
           }
       }
    
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.addLoader()
        self.currentPwdTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "current_password")
        self.newPwdTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "new_password")
        self.confirmPwdTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "confirm_password")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "change_password")
        self.currentPasswordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "")
        self.newPasswordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "")
        self.confirmPasswordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "")
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "save")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.currentPasswordTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_current_password")
        }else if self.currentPasswordTF.text!.count < 6 {
            Utility.shared.showAlert(msg: "password_validation")
        }else if self.newPasswordTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_new_password")
        }else if self.newPasswordTF.text!.count < 6 {
            Utility.shared.showAlert(msg: "password_validation")
        }else if self.newPasswordTF.text != self.confirmPasswordTF.text{
            Utility.shared.showAlert(msg: "password_mismatch")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.startLoading()
                self.updatePassword()
            }
        }
    }
    
    //update profile details
    func updatePassword()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(self.currentPasswordTF.text, forKey: "current_password")
        requestDict.setValue(self.newPasswordTF.text, forKey: "new_password")
        
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_CHANGE_PASSWORD
        }else{
            subURL = TASKER_CHANGE_PASSWORD
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey:"status_code") as! Int
            self.stopLoading()
            if status_code == 200{
               Utility.shared.showToast(msg: "profile_updated")
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
            if textField.text!.count > 14{
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
    
    
}

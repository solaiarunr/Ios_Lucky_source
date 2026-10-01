//
//  ForgotPage.swift
//  iDemand
//
//  Created by Roby on 26/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ForgotPage: UIViewController {
    
    @IBOutlet var forgotTitle: UILabel!
    @IBOutlet var forgotInfoLbl: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    
    //initial set up
    func initialSetup()  {
        self.addLoader()
        self.forgotTitle.config(color: TEXT_BLACK_COLOR!, font: highBold, align: .left, text: "forgot_password")
        self.forgotInfoLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .left, text: "send_link_to_mail")
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "enter_email")
        self.resetBtn.config(color: .white, font: subBold, align: .center, title: "reset")
        self.resetBtn.radius(value: 5)
        self.resetBtn.backgroundColor = PRIMARY_COLOR
        let backArrow = #imageLiteral(resourceName: "back_icon").withRenderingMode(.alwaysTemplate)
        self.backBtn.setImage(backArrow, for: .normal)
        self.backBtn.tintColor = TEXT_BLACK_COLOR!
        self.checkRTL()
    }
    //check rtl
    func checkRTL()  {
           if Utility.shared.isRTL(){
               self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.forgotInfoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.resetBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.forgotTitle.frame.origin.x = 20
               self.forgotTitle.textAlignment = .left
               self.emailTF.textAlignment = .right
               self.forgotInfoLbl.textAlignment = .right
       
              }
       }
    //back btn tapped
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.emailTF.isEmptyValue() {
            self.showAlert(msg: (Utility.shared.Json().value(forKey: "enter_email") as! String))
        }else if !(self.emailTF.text?.isValidEmail())!{
            self.showAlert(msg: (Utility.shared.Json().value(forKey: "enter_valid_email") as! String))
        }else{
            self.resetPasswordAPIService()
        }
    }
    //reset password
    func resetPasswordAPIService()  {
        self.startLoading()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.emailTF.text, forKey: "email")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_FORGOT_API
        }else{
            subURL = TASKER_FORGOT_API
        }
        let apiObj = BaseAPI()
        apiObj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: login.message!, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else if login.status_code == 400{
                    self.showAlert(msg: login.message!)
                }
            }catch{
            }
        })
    }
    
    //MARK: textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{
            return true
        }
    }
    //show alert
    func showAlert(msg:String)  {
        let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

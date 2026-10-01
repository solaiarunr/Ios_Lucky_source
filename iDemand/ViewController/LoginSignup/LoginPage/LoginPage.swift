//
//  LoginPage.swift
//  iDemand
//
//  Created by Roby on 26/08/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseUI
import AuthenticationServices
import IQKeyboardManagerSwift
import GoogleSignIn
import MaterialComponents
import CoreLocation

class LoginPage: UIViewController ,UITextFieldDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding,GIDSignInDelegate {
    
    @IBOutlet weak var mobileNumberButton: UIButton!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var loginLbl: UILabel!
    @IBOutlet var signupLbl: UILabel!
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var forgotBtn: UIButton!
    @IBOutlet var appleBtn: UIButton!
    @IBOutlet var socialInfoView: UIView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var loginSwitchBtn: UIButton!
    @IBOutlet var fbBtn: UIButton!
    
    @IBOutlet var arrowIcon: UIImageView!
    @IBOutlet var googleBtn: UIButton!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var socialType = String()
    var login_type = String()
    var login_id = String()
    var isAgree = false
    let apiObj = BaseAPI()
    var profile_url:URL?
    let locationManager = CLLocationManager()
    var lat = Double()
    var lon = Double()
    var location = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewDidLayoutSubviews() {
        
        self.socialInfoView.frame.origin.y = (self.loginView.frame.origin.y+self.loginView.frame.height-10)
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.signupLbl.frame.origin.y+50)
        self.navigationView.bottomRadius()
        self.checkRTL()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.loginLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signupLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.forgotBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.appleBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fbBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.googleBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.loginSwitchBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.orLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.navigationView.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.loginSwitchBtn.frame.origin.x = FULL_WIDTH - 190
            self.loginLbl.frame.origin.x = 20
            self.loginLbl.textAlignment = .right
            self.emailTF.textAlignment = .right
            self.passwordTF.textAlignment = .right
            self.loginSwitchBtn.contentHorizontalAlignment = .left
            self.forgotBtn.contentHorizontalAlignment = .left
            
        }
    }
    //initial setup
    func initialSetup() {
        self.scrollView.contentInsetAdjustmentBehavior = .never        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let arrowImg = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        self.arrowIcon.image = arrowImg
        self.arrowIcon.tintColor =  PRIMARY_COLOR
        self.addLoader()
        self.login_type = "email"
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "email")
        self.passwordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "password")
        self.orLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .center, text: "or")
        self.submitBtn.config(color: .white, font: headBold, align: .center, title: "login")
        self.forgotBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, title: "forgot_password")
        self.mobileNumberButton.config(color: PRIMARY_COLOR!, font: subBold, align: .center, title: "login_with_mobile_number")
        // MARK: MOBILE LOGIN WITH OTP
        self.mobileNumberButton.isHidden = true
        
        self.submitBtn.radius(value: 10)
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        //signup lbl
        self.signupLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .center, text: "")
        let loginText = "\(Utility.shared.Json().value(forKey: "dont_account_already") as! String) \(Utility.shared.Json().value(forKey: "signup") as! String)"
        self.signupLbl.setCustom(fullTxt: loginText, activeTxt: (Utility.shared.Json().value(forKey: "signup") as! String), color: PRIMARY_COLOR!)
        signupLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapSignup(gesture:))))
        
        if #available(iOS 13.0, *) {
        }else{
            self.appleBtn.isHidden = true
        }
        //config goole
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        
        self.checkIsUser()
        self.checkRTL()
    }
    
    func checkIsUser()  {
        if !LocalDefault().isUser()!{
            LocalDefault().setRole(type: "tasker")
            self.socialInfoView.isHidden = false
            self.loginSwitchBtn.config(color: PRIMARY_COLOR!, font: subBold, align: .right, title: "user_login")
            // Mobile Number Addon change layout
            //            self.signupLbl.frame.origin.y = self.loginView.frame.origin.y + self.loginView.frame.size.height + 13
            self.signupLbl.frame.origin.y = self.socialInfoView.frame.origin.y + 125
            self.loginLbl.config(color: TEXT_BLACK_COLOR!, font: highBold, align: .left, text: "login_with_tasker")
        }else{
            LocalDefault().setRole(type: "user")
            self.socialInfoView.isHidden = false
            self.loginSwitchBtn.config(color: PRIMARY_COLOR!, font: subBold, align: .right, title: "tasker_login")
            self.signupLbl.frame.origin.y = self.socialInfoView.frame.origin.y + 125
            self.loginLbl.config(color: TEXT_BLACK_COLOR!, font: highBold, align: .left, text: "login_with_user")
            
        }
    }
    
    
    //go to signup page
    @objc func tapSignup(gesture: UITapGestureRecognizer) {
        let text = "\(Utility.shared.Json().value(forKey: "dont_account_already") as! String) \(Utility.shared.Json().value(forKey: "signup") as! String)"
        let termsRange = (text as NSString).range(of: (Utility.shared.Json().value(forKey: "signup") as! String))
        // comment for now
        if gesture.didTapAttributedTextInLabel(label: self.signupLbl, inRange: termsRange) {
            if LocalDefault().isUser()!{
                let loginObj = SignupPage()
                self.navigationController?.pushViewController(loginObj, animated: true)
            }else{
                let loginObj = TaskerSignup()
                self.navigationController?.pushViewController(loginObj, animated: true)
            }
        }
    }
    
    @IBAction func mobileLoginBtnTapped(_ sender: UIButton) {
        FUIAuth.defaultAuthUI()?.delegate = self
        let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
        FUIAuth.defaultAuthUI()?.providers = [phoneProvider]
        let phoneProviderNew = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProviderNew.signIn(withPresenting: self, phoneNumber: nil)
    }
    
    @IBAction func switchLoginBtnTapped(_ sender: Any) {
        self.emailTF.text = ""
        self.passwordTF.text = ""
        
        let btnTxt = self.loginSwitchBtn.titleLabel?.text
        let taskerLogin = Utility.shared.Json().value(forKey: "tasker_login") as! String
        
        if btnTxt == taskerLogin{
            LocalDefault().setRole(type: "tasker")
        }else{
            LocalDefault().setRole(type: "user")
        }
        self.checkIsUser()
        //        self.viewDidLayoutSubviews()
    }
    
    
    
    //login button action
    @IBAction func loginBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
        if self.emailTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_email")
        }else if !(self.emailTF.text?.isValidEmail())!{
            Utility.shared.showAlert(msg: "enter_valid_email")
        }else if self.passwordTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_password")
        }else{
            self.login_type = "email"
            self.login_id = self.emailTF.text!
            self.signInApiService()
        }
        
    }
    
    //MARK: facebook sign in
    @IBAction func fbBtnTapped(_ sender: Any) {
        if Utility.shared.isConnectedToNetwork(){
            if LocalDefault.shared.isUser()!{
                if AccessToken.current != nil {
                    // User is logged in, do work such as go to next view controller.
                    self.getFBUserData()
                }else{
                    let login = LoginManager()
                    login.logIn(permissions: ["public_profile","email"], from: self, handler: { result, error in
                        
                        if error != nil {
                            print("Process error ")
                        } else if (result?.isCancelled)! {
                            print("Cancelled")
                        } else {
                            self.startLoading()
                            self.getFBUserData()
                        }
                    })
                }
            }
            else{
                self.socialType = "facebook"
                self.checklocationAccess()
            }
        }
    }
    // Get facebook user details based on accesstoken
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id,email,name,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let responseDict = result as! NSDictionary
                    let fb_id = responseDict.value(forKey: "id") as! String
                    self.login_id = fb_id
                    self.login_type = "facebook"
                    self.profile_url = URL.init(string: responseDict.value(forKeyPath: "picture.data.url") as! String)
                    if (responseDict.value(forKey: "email") != nil){
                        let mail = responseDict.value(forKey: "email") as! String
                        self.checkLogin(id: mail,name:(responseDict.value(forKey: "name") as! String))
                    }else{
                        Utility.shared.showAlert(msg: "fb_mail_permission_disabled")
                    }
                }
            })
        }
    }
    
    //MARK: google sign in
    @IBAction func googleBtnTapped(_ sender: Any) {
        if LocalDefault().isUser()!{
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
        else{
            self.socialType = "google"
            self.checklocationAccess()
        }
        
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        if user.profile.hasImage{
            let url = user.profile.imageURL(withDimension: 200)
            profile_url = url
        }
        let userId = user.userID
        self.login_id = userId!
        self.login_type = "google"
        self.checkLogin(id: user.profile.email,name:user.profile.name)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK: apple sign in
    @IBAction func appleBtnTapped(_ sender: Any) {
        if LocalDefault.shared.isUser()!{
            if #available(iOS 13.0, *) {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
        }
        else{
            self.socialType = "apple"
            self.checklocationAccess()
        }
        
    }
    @available(iOS 13.0, *)
    /*  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
     if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
     login_type = "apple"
     login_id = appleIDCredential.user
     self.startLoading()
     if appleIDCredential.fullName?.familyName != nil{
     let firstName = appleIDCredential.fullName?.givenName
     let secondName = appleIDCredential.fullName?.familyName
     let email = appleIDCredential.email
     self.checkLogin(id: email!, name: "\(firstName!) \(secondName!)")
     }else{
     print("already signin \(appleIDCredential.user)")
     self.checkLogin(id: appleIDCredential.user, name: nil)
     }
     }
     }*/
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            login_type = "apple"
            login_id = appleIDCredential.user
            self.startLoading()
            if appleIDCredential.fullName?.familyName != nil{
                let firstName = appleIDCredential.fullName?.givenName
                let secondName = appleIDCredential.fullName?.familyName
                let email = appleIDCredential.email
                self.checkLogin(id: email!, name: "\(firstName!) \(secondName!)")
            }else{
                print("already signin \(appleIDCredential.user)")
                self.checkLogin(id: appleIDCredential.user, name: nil)
            }
            
        case let passwordCredential as ASPasswordCredential:
            print("password signin \(passwordCredential.user)")
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        // For the purpose of this demo app, show the password credential as an alert.
        //            DispatchQueue.main.async {
        //                self.showPasswordCredentialAlert(username: username, password: password)
        //            }
        
        default:
            break
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("APPLE SIGN IN ERROR \(error.localizedDescription)")
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    //check login api service
    func checkLogin(id:String,name:String?)  {
        DispatchQueue.main.async {
            self.startLoading()
        }
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.login_id, forKey: "login_id")
        requestDict.setValue(self.login_type, forKey: "login_type")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue("iOS", forKey: "device_platform")
        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
        requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")
        
        if self.login_type == "apple" && name == nil{
            requestDict.setValue("", forKey: "email")
            requestDict.setValue("", forKey: "name")
        }else{
            requestDict.setValue(id, forKey: "email")
            requestDict.setValue(name, forKey: "name")
        }
        var sub_URL = String()
        if LocalDefault().isUser()!{
            sub_URL = USER_SOCIAL_SIGNIN_API
        }else{
            requestDict.setValue("\(self.lat)", forKey: "lat")
            requestDict.setValue("\(self.lon)", forKey: "lon")
            requestDict.setValue("\(self.location)", forKey: "location")
            sub_URL = TASKER_SOCIAL_SIGNIN_API
        }
        
        Obj.baseService(subURl: sub_URL, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    LocalDefault.shared.setUser(data: response.data!)
                    LocalDefault.shared.setUser(id: login.user_id!)
                    LocalDefault.shared.setAccess(token: login.access_token!)
                    Utility.shared.updateProfile()
                    if login.new_account == "true"{
                        self.uploadProfileImg()
                    }
                    SocketClass.sharedInstance.connect()
                    
                    if !(LocalDefault.shared.isUser()!){
                        let resDict = response.value as! NSDictionary
                        if resDict.value(forKey: "payment_verified") as? String ?? "" == "true"{
                            LocalDefault.shared.set_paymentAdded(status: true)
                        }
                        else{
                            LocalDefault.shared.set_paymentAdded(status: false)
                        }
                        if resDict.value(forKey: "new_account") as? String ?? "true" == "true"{
                            LocalDefault.shared.setView(from: "signup")
                            let categoryObj =  CategoryPage()
                            categoryObj.viewType = "signup"
                            self.navigationController?.pushViewController(categoryObj, animated: true)
                        }
                        else{
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.setInitialViewController()
                            }
                        }
                    }
                    else{
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.setInitialViewController()
                        }
                    }
                }else if login.status_code == 400{
                    
                    if login.account_exists == "1"{
                        Utility.shared.customToast(msg: login.message!)
                    }else{
                        if name != nil{
                            //                        self.nameTF.text = name
                            //                        self.emailTF.text = id
                            //                        self.nameTF.isUserInteractionEnabled = false
                            //                        self.emailTF.isUserInteractionEnabled = false
                        }else{
                            Utility.shared.showToast(msg: "cannot_fetch_email")
                        }
                    }
                }
            }catch{
            }
        })
    }
    
    //sign in api call
    func signInApiService()  {
        self.startLoading()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.login_type, forKey: "login_type")
        requestDict.setValue(self.emailTF.text, forKey: "login_id")
        requestDict.setValue(self.emailTF.text, forKey: "email")
        requestDict.setValue(self.passwordTF.text, forKey: "password")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue("iOS", forKey: "device_platform")
        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
        var sub_api = String()
        if LocalDefault().isUser()!{
            sub_api = USER_SIGNIN_API
        }else{
            sub_api = TASKER_SIGNIN_API
        }
        apiObj.baseService(subURl: sub_api, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    if !(LocalDefault.shared.isUser()!){
                        let resDict = response.value as! NSDictionary
                        if resDict.value(forKey: "payment_verified") as? String ?? "" == "true"{
                            LocalDefault.shared.set_paymentAdded(status: true)
                        }
                        else{
                            LocalDefault.shared.set_paymentAdded(status: false)
                        }
                        
                    }
                    LocalDefault.shared.setUser(data: response.data!)
                    LocalDefault.shared.setUser(id: login.user_id!)
                    LocalDefault.shared.setAccess(token: login.access_token!)
                    Utility.shared.updateProfile()
                    SocketClass.sharedInstance.connect()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.setInitialViewController()
                    }
                }else if login.status_code == 400{
                    Utility.shared.serverAlert(msg: login.message!)
                }
            }catch{
            }
        })
    }
    
    //upload social profile image
    func uploadProfileImg() {
        if profile_url != nil{
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: self.profile_url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                let image = UIImage(data: data!)
                let imageData: Data = image!.jpegData(compressionQuality: 0.5)!
                let imageSize: Int = imageData.count
                let size = Double(imageSize) / 1000.0
                print("image size \(size)")
                let api = BaseAPI()
                var sub_api = String()
                if LocalDefault().isUser()!{
                    sub_api = USER_PICTURE_UPLOAD
                }else{
                    sub_api = TASKER_PICTURE_UPLOAD
                }
                api.upload(sub_url: sub_api, image: imageData, type: "image", onSuccess: {response in
                })
            }
        }
    }
    
    //MARK: textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if textField.tag == 1{
            if string == " "{
                return false
            }
        }
        
        if msg.containsEmoji(){
            return false
        }else{
            return true
        }
    }
    
    @IBAction func forgotBtnTapped(_ sender: Any) {
        let forgotObj = ForgotPage()
        forgotObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(forgotObj, animated: true, completion: nil)
    }
    
    
}
extension LoginPage: FUIAuthDelegate {
    //phone number delegate
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if authDataResult?.user != nil{
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue((authDataResult?.user.phoneNumber ?? ""), forKey: "mobile")
            requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
            requestDict.setValue("iOS", forKey: "device_platform")
            requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
            requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")
            var sub_api = String()
            if LocalDefault().isUser()!{
                requestDict.setValue("user", forKey: "type")
                sub_api = MOBILE_LOGIN_URL
            }else{
                requestDict.setValue("tasker", forKey: "type")
                sub_api = TASKER_MOBILE_LOGIN_URL
            }
            apiObj.baseService(subURl: sub_api, params: requestDict as? Parameters, onSuccess: {response in
                self.stopLoading()
                do{
                    let jsonDecoder = JSONDecoder()
                    let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                    if login.status_code == 200{
                        if LocalDefault().isUser()! && (login.type ?? "") == "user"{
                            LocalDefault.shared.setUser(data: response.data!)
                            LocalDefault.shared.setUser(id: login.user_id!)
                            LocalDefault.shared.setAccess(token: login.access_token!)
                            Utility.shared.updateProfile()
                            SocketClass.sharedInstance.connect()
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.setInitialViewController()
                            }
                        }else if !LocalDefault().isUser()! && (login.type ?? "") == "tasker"{
                            LocalDefault.shared.setUser(data: response.data!)
                            LocalDefault.shared.setUser(id: login.user_id!)
                            LocalDefault.shared.setAccess(token: login.access_token!)
                            Utility.shared.updateProfile()
                            SocketClass.sharedInstance.connect()
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.setInitialViewController()
                            }
                        }
                        else {
                            var message = (Utility.shared.Json().value(forKey: "account not exist") as! String)
                            if LocalDefault().isUser()! && (login.type ?? "") != "user" {
                                message = (Utility.shared.Json().value(forKey: "Phone number exist with another tasker") as! String)
                            }
                            else if !LocalDefault().isUser()! && (login.type ?? "") != "tasker" {
                                message = (Utility.shared.Json().value(forKey: "Phone number exist with another user") as! String)
                            }
                            let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }else if login.status_code == 400{
                        let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: login.message!, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
                            if login.account_exists ?? "" == "0" {
                                if LocalDefault().isUser()!{
                                    let loginObj = SignupPage()
                                    loginObj.mobileNumber = (authDataResult?.user.phoneNumber ?? "")
                                    self.navigationController?.pushViewController(loginObj, animated: true)
                                }else{
                                    let loginObj = TaskerSignup()
                                    loginObj.mobileNumber = (authDataResult?.user.phoneNumber ?? "")
                                    self.navigationController?.pushViewController(loginObj, animated: true)
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                        //                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            })
        }
    }
    
}

extension LoginPage: CLLocationManagerDelegate{
    //check location lat & lon
    func checklocationAccess(){
        if self.lat != 0 && self.lon != 0{
            if self.location != ""{
                startTaskerSocialLogin()
            }
            else{
                self.getAddress()
            }
        }
        else if self.appDelegate?.current_lat != 0{
            self.lat = self.appDelegate?.current_lat ?? 0
            self.lon = self.appDelegate?.current_lon ?? 0
            self.getAddress()
        }
        else{
            self.getLocationPermission()
        }
    }
    func startTaskerSocialLogin(){
        if self.lat != 0 && self.lon != 0 && self.location != ""{
            switch self.socialType {
            case "google":
                GIDSignIn.sharedInstance()?.presentingViewController = self
                GIDSignIn.sharedInstance()?.signIn()
                break
            case "facebook":
                if AccessToken.current != nil {
                    // User is logged in, do work such as go to next view controller.
                    self.getFBUserData()
                }else{
                    let login = LoginManager()
                    login.logIn(permissions: ["public_profile","email"], from: self, handler: { result, error in
                        
                        if error != nil {
                            print("Process error ")
                        } else if (result?.isCancelled)! {
                            print("Cancelled")
                        } else {
                            self.startLoading()
                            self.getFBUserData()
                        }
                    })
                }
                break
            case "apple":
                if #available(iOS 13.0, *) {
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    authorizationController.delegate = self
                    authorizationController.presentationContextProvider = self
                    authorizationController.performRequests()
                }
                break
            default:
                break
            }
            
        }
        else{
            print("check_location_access_again_called_anyone_missing= self.lat\(self.lat),self.lan\(self.lon),self.location\(self.location)")
            checklocationAccess()
        }
        
    }
    //location permission
    func getLocationPermission()  {
        self.startLoading()
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        var isLocationActive = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                isLocationActive = true
                break
            case .restricted:
                isLocationActive = false
                break
            case .denied:
                isLocationActive = false
                self.stopLoading()
                break
            case .authorizedAlways:
                isLocationActive = true
                break
            case .authorizedWhenInUse:
                isLocationActive = true
                break
            @unknown default:
                break
            }
        }
        if isLocationActive {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }else{
            self.stopLoading()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Utility.shared.Json().value(forKey: "alert") as? String, message: Utility.shared.Json().value(forKey: "location_permission_denied") as? String, preferredStyle: UIAlertController.Style.alert)
                //settings
                alert.addAction(UIAlertAction(title: Utility.shared.Json().value(forKey: "settings") as? String, style: .default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }))
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lat = locValue.latitude
        self.lon = locValue.longitude
        self.getAddress()
        self.locationManager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways:
                self.locationManager.requestAlwaysAuthorization()
            case .authorizedWhenInUse:
                self.locationManager.requestWhenInUseAuthorization()
            case .denied:
                self.checklocationAccess()
//                checkLocationAccess()
            case.restricted:
                locationManager.requestWhenInUseAuthorization()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
        
    }
    //get full address
    func getAddress() {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail")
                                        }
                                        if let pm = placemarks {
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                var addressString : String = ""
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }
                                                print(addressString)
                                                self.location = addressString
                                                if self.lat != 0 && self.lon != 0 && self.location != ""{
                                                    self.stopLoading()
                                                    self.startTaskerSocialLogin()
                                                }
                                            }
                                        }
                                    })
    }
}

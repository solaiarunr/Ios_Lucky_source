//
//  SignupPage.swift
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

class SignupPage: UIViewController,UITextFieldDelegate,FUIAuthDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding,GIDSignInDelegate {
    
    @IBOutlet var nameTF: FloatLabelTextField!
    @IBOutlet var emailTF: FloatLabelTextField!    
    @IBOutlet var phoneTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var confirmPasswordTF: FloatLabelTextField!
    @IBOutlet var termsCheckBox: VKCheckbox!
    @IBOutlet var termsLbl: UILabel!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var loginLbl: UILabel!
    @IBOutlet var signupLbl: UILabel!
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var appleBtn: UIButton!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var taskerLoginBtn: UIButton!
    @IBOutlet var arrowIcon: UIImageView!
    @IBOutlet var fbBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    
    var login_type = String()
    var login_id = String()
    var isAgree = false
    var isLoginData = Bool()
    var name = String()
    var email = String()
    var profile_url:URL?
    var mobileNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.loginLbl.frame.origin.y+50)
        self.checkRTL()
        self.navigationView.bottomRadius()
        let leftPadding = FULL_WIDTH - self.termsLbl.intrinsicContentSize.width
        self.termsLbl.frame.origin.x = (leftPadding/2)+15
        self.termsCheckBox.frame.origin.x = self.termsLbl.frame.origin.x - 30
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //check is language support rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.confirmPasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.loginLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signupLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.appleBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fbBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.googleBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taskerLoginBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.termsCheckBox.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.orLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.navigationView.transform = CGAffineTransform(scaleX: -1, y: 1)
//            self.taskerLoginBtn.frame.origin.x = FULL_WIDTH - 190
            self.signupLbl.frame.origin.x = 20
            self.emailTF.textAlignment = .right
            self.passwordTF.textAlignment = .right
            self.nameTF.textAlignment = .right
            self.phoneTF.textAlignment = .right
            self.confirmPasswordTF.textAlignment = .right
            self.taskerLoginBtn.contentHorizontalAlignment = .left
        }
    }
    func initialSetup() {
        self.scrollView.contentInsetAdjustmentBehavior = .never
        let arrowImg = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
        self.arrowIcon.image = arrowImg
        self.arrowIcon.tintColor =  PRIMARY_COLOR
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.navigationController?.navigationBar.isHidden = true
        self.nameTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "name")
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "email")
        self.phoneTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "mobile_number")
        self.passwordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "password")
        self.confirmPasswordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "confirm_password")
        self.orLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .center, text: "or")
        self.signupLbl.config(color: TEXT_BLACK_COLOR!, font: highBold, align: .left, text: "signup_as_user")
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        self.submitBtn.config(color: .white, font: headBold, align: .center, title: "signup")
        self.submitBtn.radius(value: 10)
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        
        //terms lbl
        self.termsLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        let termText = "\(Utility.shared.Json().value(forKey: "agree_all") as! String) \(Utility.shared.Json().value(forKey: "terms") as! String) \(Utility.shared.Json().value(forKey: "stated") as! String)"
        
        
        self.termsLbl.setCustom(fullTxt: termText, activeTxt: (Utility.shared.Json().value(forKey: "terms") as! String), color: PRIMARY_COLOR!)
        termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapTerms(gesture:))))
        termsLbl.adjustsFontSizeToFitWidth = true
        //login lbl
        self.loginLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .center, text: "")
        let loginText = "\(Utility.shared.Json().value(forKey: "have_account_already") as! String) \(Utility.shared.Json().value(forKey: "login") as! String)"
        self.loginLbl.setCustom(fullTxt: loginText, activeTxt: (Utility.shared.Json().value(forKey: "login") as! String), color: PRIMARY_COLOR!)
        loginLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLogin(gesture:))))
        
        self.taskerLoginBtn.config(color: PRIMARY_COLOR!, font: subBold, align: .right, title: "tasker_login")
        
        //terms check
        termsCheckBox.line             = .thin
        termsCheckBox.bgColorSelected  = PRIMARY_COLOR!
        termsCheckBox.bgColor          = .clear
        termsCheckBox.color            = TEXT_WHITE_COLOR!
        termsCheckBox.borderColor      = LINE_COLOR
        termsCheckBox.borderWidth      = 1
        termsCheckBox.cornerRadius     = 5
        // Handle state update
        termsCheckBox.checkboxValueChangedBlock = { isOn in
            if isOn{
                self.termsCheckBox.borderColor = .clear
            }else{
                self.termsCheckBox.borderColor = LINE_COLOR
            }
            self.isAgree = isOn
        }
        
        if #available(iOS 13.0, *) {
        }else{
            self.appleBtn.isHidden = true
        }
        //config goole
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance().delegate = self
        
        if isLoginData{
            self.nameTF.text = self.name
            self.emailTF.text = self.email
        }else{
            self.login_type = "email"
        }
        self.phoneTF.text = mobileNumber
    }
    
    //go to terms page
    @objc func tapTerms(gesture: UITapGestureRecognizer) {
        let text = "\(Utility.shared.Json().value(forKey: "agree_all") as! String) \(Utility.shared.Json().value(forKey: "terms") as! String)"
        let termsRange = (text as NSString).range(of: (Utility.shared.Json().value(forKey: "terms") as! String))
        // comment for now
        if gesture.didTapAttributedTextInLabel(label: self.termsLbl, inRange: termsRange) {
//            let webObj = WebPage()
//            webObj.modalPresentationStyle = .fullScreen
//            webObj.viewType = "terms"
//            self.navigationController?.present(webObj, animated: true, completion: nil)
        }
        else {
            let webObj = WebPage()
            webObj.modalPresentationStyle = .fullScreen
            webObj.viewType = "terms"
            self.navigationController?.present(webObj, animated: true, completion: nil)
        }
    }
    
    @IBAction func userLoginBtnTapped(_ sender: Any) {
        LocalDefault().setRole(type: "tasker")
        let loginObj = LoginPage()
        self.navigationController?.pushViewController(loginObj, animated: true)
    }
    
    
    //go to login page
    @objc func tapLogin(gesture: UITapGestureRecognizer) {
        let text = "\(Utility.shared.Json().value(forKey: "have_account_already") as! String) \(Utility.shared.Json().value(forKey: "login") as! String)"
        let termsRange = (text as NSString).range(of: (Utility.shared.Json().value(forKey: "login") as! String))
        // comment for now
        if gesture.didTapAttributedTextInLabel(label: self.loginLbl, inRange: termsRange) {
            print("Tapped login")
            let loginObj = LoginPage()
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    //phone number verfication
    @IBAction func phoneBtnTapped(_ sender: Any) {
        FUIAuth.defaultAuthUI()?.delegate = self
        let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
        FUIAuth.defaultAuthUI()?.providers = [phoneProvider]
        let phoneProviderNew = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProviderNew.signIn(withPresenting: self, phoneNumber: nil)
    }
    
    //phone number delegate
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if authDataResult?.user != nil{
            self.phoneTF.text = authDataResult?.user.phoneNumber
        }
    }
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, url: URL?, error: Error?) {
    }
    
    //signup button action
    @IBAction func signupBtnTapped(_ sender: Any) {
        if self.nameTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_name")
        }else if self.nameTF.text!.count < 3 {
            Utility.shared.showAlert(msg: "enter_valid_name")
        }else if self.emailTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_email")
        }else if !(self.emailTF.text?.isValidEmail())!{
            Utility.shared.showAlert(msg: "enter_valid_email")
        }else if self.phoneTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_phone")
        }else if self.passwordTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_password")
        }else if self.passwordTF.text!.count < 6 {
            Utility.shared.showAlert(msg: "password_validation")
        }else if self.confirmPasswordTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_confirm_password")
        }else if self.passwordTF.text != self.confirmPasswordTF.text{
            Utility.shared.showAlert(msg: "password_mismatch")
        }else if !isAgree{
            Utility.shared.showAlert(msg: "agree_terms_to_continue")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.signUpApiService()
            }
        }
    }
    
    //MARK: facebook sign in
    @IBAction func fbBtnTapped(_ sender: Any) {
        if Utility.shared.isConnectedToNetwork(){
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
    }
    // Get facebook user details based on accesstoken
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id,email,name,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let responseDict = result as! NSDictionary
                    print("fb response \(responseDict)")
                    let fb_id = responseDict.value(forKey: "id") as! String
                    self.login_id = fb_id
                    self.login_type = "facebook"
                    self.profile_url = URL.init(string: responseDict.value(forKeyPath: "picture.data.url") as! String)
                    if (responseDict.value(forKey: "email") != nil){
                        let mail = responseDict.value(forKey: "email") as! String
                        self.checkExist(id: mail,name:responseDict.value(forKey: "name") as? String)
                    }else{
                        self.stopLoading()
                        Utility.shared.showAlert(msg: "fb_mail_permission_disabled")
                    }
                }
            })
        }
    }
    
    //MARK: google sign in
    @IBAction func googleBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.signIn()
        
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
            let url = user.profile.imageURL(withDimension: 500)
            profile_url = url
            print("google url \(url)")
        }
        
        let userId = user.userID
        self.login_id = userId!
        self.login_type = "google"
        self.checkExist(id: user.profile.email,name:user.profile.name)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK: apple sign in
    @IBAction func appleBtnTapped(_ sender: Any) {
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
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            login_type = "apple"
            login_id = appleIDCredential.user
            self.startLoading()
            if appleIDCredential.fullName?.familyName != nil{
                print("new signin")
                let firstName = appleIDCredential.fullName?.givenName
                let secondName = appleIDCredential.fullName?.familyName
                let email = appleIDCredential.email
                self.checkExist(id: email!, name: "\(firstName!) \(secondName!)")
            }else{
                print("already signin \(appleIDCredential.user)")
                self.checkExist(id: appleIDCredential.user, name: nil)
            }
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
//    func verifyMobileNumber() {
//        self.startLoading()
//        let Obj = BaseAPI()
//        let requestDict = NSMutableDictionary.init()
//        requestDict.setValue(self.phoneTF.text!, forKey: "mobile")
//        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
//        requestDict.setValue("iOS", forKey: "device_platform")
//        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
//        requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")
//        var sub_api = String()
//        if LocalDefault().isUser()!{
//            requestDict.setValue("user", forKey: "type")
//            sub_api = MOBILE_LOGIN_URL
//        }else{
//            requestDict.setValue("tasker", forKey: "type")
//            sub_api = TASKER_MOBILE_LOGIN_URL
//        }
//        Obj.baseService(subURl: sub_api, params: requestDict as? Parameters, onSuccess: {response in
//            self.stopLoading()
//            do{
//                let jsonDecoder = JSONDecoder()
//                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
//                if login.status_code == 200{
//                    Utility.shared.showToast(msg: "mobile_number_already_exist")
//                }else if login.status_code == 400{
//                    self.signUpApiService()
//                }
//            }catch{
//            }
//        })
//    }
    //MARK: Signup api service
    func signUpApiService()  {
//        self.startLoading()
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.login_type, forKey: "login_type")
        if self.login_type == "email"{
            requestDict.setValue(self.emailTF.text, forKey: "login_id")
        }else{
            requestDict.setValue(self.login_id, forKey: "login_id")
        }
        requestDict.setValue(self.nameTF.text, forKey: "name")
        requestDict.setValue(self.phoneTF.text, forKey: "mobile")
        requestDict.setValue(self.emailTF.text, forKey: "email")
        requestDict.setValue(self.passwordTF.text, forKey: "password")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue("iOS", forKey: "device_platform")
        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
        requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")

        Obj.baseService(subURl: USER_SIGNUP_API, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    LocalDefault.shared.setUser(id: login.user_id!)
                    LocalDefault.shared.setAccess(token: login.access_token!)
                    Utility.shared.updateProfile()
                    SocketClass.sharedInstance.connect()
                    
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.setInitialViewController()
                    }
                    if self.login_type == "facebook" || self.login_type == "google" {
                        self.uploadProfileImg()
                    }
                }else if login.status_code == 400{
                    if login.type == "tasker" {
                        
                    }
                    else {
                        
                    }
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
                api.upload(sub_url: USER_PICTURE_UPLOAD, image: imageData, type: "image", onSuccess: {response in
                })
            }
        }
    }
    
    //check login api service
    func checkExist(id:String,name:String?){
        self.startLoading()
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
        
        Obj.baseService(subURl: USER_SOCIAL_SIGNIN_API, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    LocalDefault.shared.setUser(id: login.user_id!)
                    LocalDefault.shared.setAccess(token: login.access_token!)
                    Utility.shared.updateProfile()
                    SocketClass.sharedInstance.connect()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.setInitialViewController()
                    }
                    if login.new_account == "true"{
                            self.uploadProfileImg()
                    }
                }else if login.status_code == 400{
                    if name != nil{
                     
                    }else{
                        Utility.shared.showToast(msg: "cannot_fetch_email")
                    }
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
        if textField.tag == 2{
            if string == " "{
                return false
            }
        }
        if msg.containsEmoji(){
            return false
        }else{
            if textField.tag == 1{
                if textField.text!.count > 29{
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
            if textField.tag == 4{
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
            return true
        }
    }
}

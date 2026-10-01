//
//  TaskerSignup.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import IQKeyboardManagerSwift
import MaterialComponents
import CoreLocation

class TaskerSignup: UIViewController,UITextFieldDelegate,FUIAuthDelegate,CLLocationManagerDelegate{
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var locationTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet var termsCheckBox: VKCheckbox!
    @IBOutlet var termsLbl: UILabel!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var signupLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var loginLbl: UILabel!
    @IBOutlet var userLoginBtn: UIButton!
    @IBOutlet var arrowIcon: UIImageView!
    

    var isAgree = false
    let locationManager = CLLocationManager()
    var lat = Double()
    var lon = Double()
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
        self.navigationView.bottomRadius()
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.loginLbl.frame.origin.y+50)
        let leftPadding = FULL_WIDTH - self.termsLbl.intrinsicContentSize.width
        self.termsLbl.frame.origin.x = (leftPadding/2)+15
        self.termsCheckBox.frame.origin.x = self.termsLbl.frame.origin.x - 30
        self.checkRTL()
        
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
            self.locationTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.loginLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signupLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.termsCheckBox.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userLoginBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.navigationView.transform = CGAffineTransform(scaleX: -1, y: 1)
//            self.userLoginBtn.frame.origin.x = FULL_WIDTH - 190
            self.signupLbl.frame.origin.x = 20
            self.emailTF.textAlignment = .right
            self.passwordTF.textAlignment = .right
            self.nameTF.textAlignment = .right
            self.phoneTF.textAlignment = .right
            self.confirmPasswordTF.textAlignment = .right
            self.locationTF.textAlignment = .right
            self.userLoginBtn.contentHorizontalAlignment = .left
        }
    }
    
    func initialSetup() {
        let arrowImg = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
        self.arrowIcon.image = arrowImg
        self.arrowIcon.tintColor =  PRIMARY_COLOR
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.navigationController?.navigationBar.isHidden = true
        self.nameTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "name")
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "email")
        self.phoneTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "mobile_number")
        self.locationTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "location")
        self.passwordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "password")
        self.confirmPasswordTF.config(color: TEXT_BLACK_COLOR!, font: headReg, align: .left, place: "confirm_password")
        self.signupLbl.config(color: TEXT_BLACK_COLOR!, font: highBold, align: .left, text: "signup_as_tasker")
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        self.submitBtn.config(color: .white, font: headBold, align: .center, title: "signup")
        self.submitBtn.radius(value: 10)
        
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        if !UIDevice.current.hasNotch{
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: FULL_HEIGHT+200)
        }
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
        
        self.userLoginBtn.config(color: PRIMARY_COLOR!, font: subBold, align: .right, title: "user_login")
        
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
        LocalDefault().setRole(type: "user")
        let loginObj = LoginPage()
        self.navigationController?.pushViewController(loginObj, animated: true)
        
    }
    
    
    //go to login page
    @objc func tapLogin(gesture: UITapGestureRecognizer) {
        let text = "\(Utility.shared.Json().value(forKey: "have_account_already") as! String) \(Utility.shared.Json().value(forKey: "login") as! String)"
        let termsRange = (text as NSString).range(of: (Utility.shared.Json().value(forKey: "login") as! String))
        // comment for now
        if gesture.didTapAttributedTextInLabel(label: self.loginLbl, inRange: termsRange) {
            let loginObj = LoginPage()
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    //phone number verfication
    @IBAction func phoneBtnTapped(_ sender: Any) {
        print("phone nunber")
        DispatchQueue.main.async{
            FUIAuth.defaultAuthUI()?.delegate = self
            let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
            FUIAuth.defaultAuthUI()?.providers = [phoneProvider]
            let phoneProviderNew = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
            phoneProviderNew.signIn(withPresenting: self, phoneNumber: nil)
        }
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
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        if LocalDefault.shared.isLiveTrack() ?? false {
            if LocalDefault.shared.isLiveTrack()! {
                self.getLocationPermission()
            }
        }else{
            let locationObj = LocationPage()
            locationObj.selectedLocation = self.locationTF.text!
            locationObj.modalPresentationStyle = .fullScreen
            locationObj.didSelectedLocation = { location in
                self.locationTF.text = location
            }
            self.navigationController?.present(locationObj, animated: true, completion: nil)
        }
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
        }else if self.locationTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "choose_location")
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
    
    //MARK: Signup api service
    func signUpApiService()  {
        self.startLoading()
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(self.nameTF.text, forKey: "name")
        requestDict.setValue(self.phoneTF.text, forKey: "mobile")
        requestDict.setValue(self.locationTF.text, forKey: "location")
        requestDict.setValue(self.emailTF.text, forKey: "email")
        requestDict.setValue(self.passwordTF.text, forKey: "password")
        requestDict.setValue(DEVICE_MODE, forKey: "device_mode")
        requestDict.setValue("iOS", forKey: "device_platform")
        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
        requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")

        if LocalDefault.shared.isLiveTrack()!{
            requestDict.setValue(self.lat, forKey: "lat")
            requestDict.setValue(self.lon, forKey: "lon")
        }
        Obj.baseService(subURl: TASKER_SIGNUP_API, params: requestDict as? Parameters, onSuccess: {response in
            self.stopLoading()
            do{
                let jsonDecoder = JSONDecoder()
                let login = try jsonDecoder.decode(LoginModel.self, from: response.data!)
                if login.status_code == 200{
                    LocalDefault.shared.setUser(data: response.data!)
                    LocalDefault.shared.set_paymentAdded(status: false)
                    LocalDefault().setRole(type: "tasker")
                    LocalDefault.shared.setUser(id: login.user_id!)
                    LocalDefault.shared.setAccess(token: login.access_token!)
                    Utility.shared.updateProfile()
                    LocalDefault.shared.setView(from: "signup")
                    let categoryObj =  CategoryPage()
                    categoryObj.viewType = "signup"
                    self.navigationController?.pushViewController(categoryObj, animated: true)
                }else if login.status_code == 400{
                    Utility.shared.serverAlert(msg: login.message!)
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
//MARK: LOCATION MANAGEMENT
extension TaskerSignup{
    
 
    //location permission
    func getLocationPermission()  {
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
    //location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.lat = locValue.latitude
        self.lon = locValue.longitude
        self.getAddress()
        self.locationManager.stopUpdatingLocation()
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
                                                self.locationTF.text = addressString
                                            }
                                        }
                                    })
    }
}

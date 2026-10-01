//
//  EditProfile.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
import IQKeyboardManagerSwift
import Firebase
import FirebaseUI
import CoreLocation

class EditProfile: UIViewController ,UITextFieldDelegate,FUIAuthDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var infoView: UIView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var locationTF: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailSeparatorLbl: UILabel!
    @IBOutlet var phoneSeparatorLbl: UILabel!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var locationArrow: UIImageView!
    @IBOutlet var aboutTV: UITextView!
    @IBOutlet var phoneBtn: UIButton!
    @IBOutlet var bottomView: UIView!    
    @IBOutlet var nameTitleLbl: UILabel!
    @IBOutlet var passwordTitleLbl: UILabel!
    @IBOutlet var emailTitleLbl: UILabel!
    @IBOutlet var phoneTitleLbl: UILabel!
    @IBOutlet var locationTitleLbl: UILabel!
    @IBOutlet var aboutTitleLbl: UILabel!
    @IBOutlet var editIcon: UIButton!
    @IBOutlet var aboutSeparatorLbl: UILabel!
    @IBOutlet var passwordBtn: UIButton!
    @IBOutlet var passwordArrow: UIImageView!
        
    var picker = UIImagePickerController()
    var profile:ProfileModel!
    let locationManager = CLLocationManager()
    var lat = Double()
    var lon = Double()
    var informationUpdated: (() -> Void)?

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
        self.navigationView.bottomRadius()
        self.submitBtn.topRadius()
        self.aboutTV.frame.size.height = self.aboutTV.contentSize.height
        self.bottomView.frame.size.height = self.aboutTV.contentSize.height + self.aboutTV.frame.origin.y + 10
        self.infoView.frame.size.height = self.bottomView.frame.size.height + self.bottomView.frame.origin.y + 10
        self.aboutSeparatorLbl.frame.origin.y = (self.bottomView.frame.size.height - 1)
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height+250)
        self.checkRTL()
        let jsonDecoder = JSONDecoder()
        let profile = try? jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
        if profile?.password_less_login == "true" && !(LocalDefault.shared.isUser()!){
            self.bottomView.frame = CGRect(x: self.bottomView.frame.origin.x, y: self.phoneSeparatorLbl.frame.origin.y + 10, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
        }
    }
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.nameTitleLbl.textAlignment = .right
            self.nameTF.textAlignment = .right
            self.passwordTitleLbl.textAlignment = .right
            self.passwordTF.textAlignment = .right
            self.locationTitleLbl.textAlignment = .right
            self.locationTF.textAlignment = .right
            self.emailTitleLbl.textAlignment = .right
            self.emailTF.textAlignment = .right
            self.phoneTitleLbl.textAlignment = .right
            self.phoneTF.textAlignment = .right
            self.aboutTitleLbl.textAlignment = .right
            self.aboutTV.textAlignment = .right
            
        }
    }
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.userImgView.radius(value: 10)
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        self.addLoader()
        self.nameTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "name")
        self.passwordTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "password")
        self.emailTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "email")
        self.phoneTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "mobile_number")
        self.locationTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "location")
        self.aboutTitleLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "about")
        
        self.emailTF.isUserInteractionEnabled = false
        self.phoneTF.isUserInteractionEnabled = false
        self.locationTF.isUserInteractionEnabled = false
        self.aboutTV.delegate = self
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "edit_profile")
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .center, text: "")
        self.locationLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .center, text: "")
        self.nameTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "name")
        self.passwordTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "change_password")
        self.emailTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "email")
        self.phoneTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "mobile_number")
        if LocalDefault().isUser()!{
            self.bottomView.isHidden = true
        }else{
            self.bottomView.isHidden = false
            self.locationTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "location")
            self.aboutTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "about_placeholder")
        }
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "save")
        self.setDetails()
    }
    
    //set values
    func setDetails()  {
        do{
            let jsonDecoder = JSONDecoder()
            profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            self.nameLbl.text = profile.name
            self.nameTF.text =  profile.name
            self.passwordTF.text = "******"
            self.emailTF.text = profile.email
            self.phoneTF.text = profile.mobile
            let userimgURL = URL.init(string: (profile.user_image ?? ""))
            self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            
            if LocalDefault().isUser()!{
                self.locationLbl.text = profile.email
                if profile.password_less_login == "true"{
                    self.passwordTF.isHidden = true
                    self.passwordTitleLbl.isHidden = true
                    self.passwordBtn.isHidden = true
                    self.passwordArrow.isHidden = true
                }else{
                    self.passwordTF.isHidden = false
                    self.passwordTitleLbl.isHidden = false
                    self.passwordBtn.isHidden = false
                    self.passwordArrow.isHidden = true
                }
            }else{
                if profile.password_less_login == "true"{
                    self.passwordTF.isHidden = true
                    self.passwordTitleLbl.isHidden = true
                    self.passwordBtn.isHidden = true
                    self.passwordArrow.isHidden = true
                }else{
                    self.passwordTF.isHidden = false
                    self.passwordTitleLbl.isHidden = false
                    self.passwordBtn.isHidden = false
                    self.passwordArrow.isHidden = true
                }
                if LocalDefault.shared.isLiveTrack()!{
                    self.lat = Double("\(profile.lat ?? "")") ?? Double(0)
                    self.lon = Double("\(profile.lon ?? "")") ?? Double(0)
                }
                self.locationLbl.text = profile.location
                self.locationTF.text = profile.location
                self.aboutTV.text = profile.about
            }
        }catch{
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewImgBtnTapped(_ sender: Any) {
        let imgView = ImageViewer()
        imgView.modalPresentationStyle = .fullScreen
        imgView.viewType = "profile"
        imgView.imgUrl = "\(profile.user_image!)"
        self.navigationController?.present(imgView, animated: true, completion: nil)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
    if LocalDefault.shared.isLiveTrack()! {
            self.getLocationPermission()
    }else{
        let locationObj = LocationPage()
        locationObj.selectedLocation = self.locationTF.text!
        locationObj.modalPresentationStyle = .fullScreen
        locationObj.didSelectedLocation = { location in
            self.locationTF.text = location
            self.locationLbl.text = location
        }
        self.navigationController?.present(locationObj, animated: true, completion: nil)
    }
    }
    
    @IBAction func changePhoneBtnTapped(_ sender: Any) {
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
    
    @IBAction func changePassword(_ sender: Any) {
        let change = ChangePasswor()
        self.navigationController?.pushViewController(change, animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.nameTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_name")
        }else if self.nameTF.text!.count < 3 {
            Utility.shared.showAlert(msg: "enter_valid_name")
        }else if self.emailTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_email")
        }else if !(self.emailTF.text?.isValidEmail())!{
            Utility.shared.showAlert(msg: "enter_valid_email")
        }else if self.locationTF.isEmptyValue() && !LocalDefault().isUser()! {
            Utility.shared.showAlert(msg: "choose_location")
        }else if self.phoneTF.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_phone")
        }else if self.aboutTV.isEmptyValue() && !LocalDefault().isUser()!{
            Utility.shared.showAlert(msg: "enter_about")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.startLoading()
                self.updateProfile()
            }
        }
    }
    
    @IBAction func choosePic(_ sender: Any) {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style: .cancel) { action -> Void in
            // Just dismiss the action sheet
        }
        action.addAction(cancelAction)
        
        // Create and add first option action
        let camera = UIAlertAction(title: (Utility.shared.Json().value(forKey: "camera") as! String), style: .default) { action -> Void in
            self.picker.delegate = self
            self.picker.sourceType = .camera
            self.picker.allowsEditing = false
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }
        action.addAction(camera)
        
        // Create and add a second option action
        let gallery = UIAlertAction(title: (Utility.shared.Json().value(forKey: "gallery") as! String), style: .default) { action -> Void in
            self.picker.delegate = self
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = false
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }
        action.addAction(gallery)
        // Present the AlertController
        self.present(action, animated: true, completion: nil)
    }
    
    //image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            Utility.shared.showAlert(msg: "image_not_valid")
            return
        }
        var config = ImageCropperConfiguration.init(with: image, and: .rect2x1)
        config.maskFillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        config.borderColor = PRIMARY_COLOR
        config.showGrid = false
        config.gridColor = UIColor.white
        config.doneTitle = (Utility.shared.Json().value(forKey: "crop") as! String)
        config.cancelTitle = (Utility.shared.Json().value(forKey: "cancel") as! String)
        
        let cropper = ImageCropperViewController.initialize(with: config) { croppedImage in
            self.userImgView.image = croppedImage
            self.dismiss(animated: true, completion: nil)
            let imageData: Data = croppedImage!.jpegData(compressionQuality: 0.5)!
            
            self.startLoading()
            let api = BaseAPI()
            var subURL  = String()
            if LocalDefault().isUser()!{
                subURL = USER_PICTURE_UPLOAD
            }else{
                subURL = TASKER_PICTURE_UPLOAD
            }
            api.upload(sub_url: subURL, image: imageData, type: "image", onSuccess: {response in
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                    let resDict = json! as NSDictionary
                    let status_code = resDict.value(forKey: "status_code") as! Int
                    if status_code == 200{
                        self.informationUpdated!()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.stopLoading()
                            Utility.shared.showToast(msg: "profile_updated")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }catch{
                }
               
            })
        }
        
        cropper.modalPresentationStyle = .fullScreen
        self.navigationController?.present(cropper, animated: true, completion: nil)
        
    }
    
    //update profile details
    func updateProfile()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(self.nameTF.text, forKey: "name")
        requestDict.setValue(self.emailTF.text, forKey: "email")
        requestDict.setValue(self.phoneTF.text, forKey: "mobile")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
            if LocalDefault.shared.isLiveTrack()!{
                requestDict.setValue(self.lat, forKey: "lat")
                requestDict.setValue(self.lon, forKey: "lon")
            }
//            else {
//                requestDict.setValue("", forKey: "lat")
//                requestDict.setValue("", forKey: "lon")
//            }
            requestDict.setValue(self.locationTF.text, forKey: "location")
            requestDict.setValue(self.aboutTV.text, forKey: "about")
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                LocalDefault.shared.setUser(data: response.data!)
                self.informationUpdated!()
                self.stopLoading()
                self.setDetails()
                Utility.shared.showToast(msg: "profile_updated")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let message = resDict.value(forKey: "message") as? String ?? ""
                self.stopLoading()
                Utility.shared.showToast(msg: message)
            }
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
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
            return true
        }
    }
    //MARK: textView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let msg = textView.text! + text
        if msg.containsEmoji(){
            return false
        }else{
            if textView.text!.count > 499{
                if text.isEmpty{
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
    }
    
}
//MARK: LOCATION MANAGEMENT
extension EditProfile{
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
                                        if placemarks != nil {
                                            let pm = placemarks! as [CLPlacemark]
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

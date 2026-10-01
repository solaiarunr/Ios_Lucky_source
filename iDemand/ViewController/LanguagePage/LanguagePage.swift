//
//  LanguagePage.swift
//  iDemand
//
//  Created by Roby on 05/11/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class LanguagePage:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var languageTableView: UITableView!
    var languageArray = NSMutableArray()
    var selectedLanguage = String()
    var viewType = String()
    var translateArray:[SwiftGoogleTranslate.Language]?
   var bundle: Bundle!

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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //config initial setup
    func initialSetup()  {
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "change_language")
        languageTableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        if viewType == "translate"{
            if LocalDefault.shared.translation() != nil{
                selectedLanguage = LocalDefault.shared.translation()!
            }
            self.getSupportedLanguages()
        }else if viewType == "theme"{
//            self.languageArray.addObjects(from: [Utility.shared.Json().value(forKey: "light")!,Utility.shared.Json().value(forKey: "dark")!,Utility.shared.Json().value(forKey: "system_default")!])
            self.languageArray.addObjects(from:["Dark","Light","System Default"] )

            self.refresh()
        } else{
            //modified-AR
//            self.languageArray.addObjects(from: ["English","Française","عربى"])
            //qwerty
            self.languageArray.addObjects(from: ["English","Française"])

            self.refresh()
        }
        
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //get supported languages
    func getSupportedLanguages(){
        SwiftGoogleTranslate.shared.start(with: GOOGLE_API_KEY)
        SwiftGoogleTranslate.shared.languages { (languages, error) in
            if let languages = languages {
                DispatchQueue.main.async {
                    self.translateArray = languages
                    self.refresh()
                }
                
            }else{
                print("GOT ERROR \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func refresh()  {
        self.languageTableView.delegate = self
        self.languageTableView.dataSource = self
        self.languageTableView.reloadData()
    }
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewType == "translate"{
            return self.translateArray!.count
        }else{
            return self.languageArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        if viewType != "translate"{
            let language : String? = self.languageArray[indexPath.row] as? String
            if language != nil{
                cell.locationLbl.text = language
            }else{
                cell.locationLbl.text = ""
            }
            if selectedLanguage == language{
                cell.tickIcon.isHidden = false
                cell.tickIcon.image = #imageLiteral(resourceName: "tick_icon")
            }else{
                cell.tickIcon.isHidden = true
            }
        }else{
            let modal = self.translateArray![indexPath.row]
            if selectedLanguage == modal.language{
                cell.tickIcon.isHidden = false
                cell.tickIcon.image = #imageLiteral(resourceName: "tick_icon")
            }else{
                cell.tickIcon.isHidden = true
            }
            cell.locationLbl.text = modal.name
        }
        
        if Utility.shared.isRTL(){
            cell.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            cell.tickIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewType == "theme"{
            let theme : String? = self.languageArray[indexPath.row] as? String
            
            LocalDefault.shared.set(theme:theme! as NSString)
            self.dismiss(animated: true, completion: nil)
        }else if viewType != "translate"{
            let language : String? = self.languageArray[indexPath.row] as? String
            self.selectedLanguage = language!
            self.languageTableView.reloadData()
            Utility.shared.setApp(language: language!)
            self.updateProfile()
            if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                myDelegate.initialSetup()
//                myDelegate.setInitialViewController()
            }
        }else{
            let modal = self.translateArray![indexPath.row]
            self.setLanguage(lang: "ar")
            LocalDefault.shared.setTranslation(language: modal.language)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //update profile details
    func updateProfile()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(Utility.shared.languageCode(), forKey: "language_type")
        print("Language Code \(Utility.shared.languageCode())")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey: "status_code") as! Int
            if status_code == 200{
            }
        })
    }
    
     func setLanguage(lang: String) {
            UserDefaults.standard.set(lang, forKey: "app_lang")
            let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        self.bundle = Bundle(path: path!)
        }
}


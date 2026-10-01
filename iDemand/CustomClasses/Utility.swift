//
//  Utility.swift
//  iDemand
//
//  Created by Roby on 27/08/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AwaitToast

class Utility: NSObject {
    
    static let shared = Utility()
    
    //MARK:set App language
    func Json() -> NSDictionary {
        return UserDefaults.standard.value(forKey: "language_json") as! NSDictionary
    }
    func setApp(language: String){
        if let path = Bundle.main.path(forResource:language, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                UserDefaults.standard.set(jsonResult as! NSDictionary, forKey: "language_json")
            } catch {
                // handle error
            }
        }
        UserDefaults.standard.set(language, forKey: "language")
    }
    func language() -> String? {
        return UserDefaults.standard.value(forKey: "language") as? String
    }
    func isRTL() -> Bool {
        if language() == "عربى"{
            return  true
        }
        return false
    }

    //update own user profile
    func updateProfile()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            LocalDefault.shared.setUser(data: response.data!)
        })
    }
    //update own user profile
    func updateDeviceToken()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(LocalDefault.shared.FCM(), forKey: "device_token")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_PROFILE_API
        }else{
            subURL = TASKER_PROFILE_API
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            LocalDefault.shared.setUser(data: response.data!)
        })
    }
    
    func networkAlert()  {
        if !self.isConnectedToNetwork(){
            let msg = Utility.shared.Json().value(forKey: "network_error") as! String
            
            let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
                exit(0)
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Network rechability
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
    //random id generation
    func messageID() -> String  {
        let timestamp = NSDate().timeIntervalSince1970
        return "\(LocalDefault.shared.userID()!)\(timestamp)"
    }
    //local time to UTC time
    func toUTC(local: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: local)
    }
    //getUTC time
    func UTC() -> String? {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //modified-AR
        formatter.timeZone = TimeZone.current
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let utcTimeZoneStr = formatter.string(from: date)
        return utcTimeZoneStr
    }
    //utc to local date
    func toLocal(dateStr: String,format:String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)// create   date from string
        // change to a readable time format and change to local time zone
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date!)
        
    }
    //get status 
    func get(status:String) -> String {
        if status == "requested"{
            return (Utility.shared.Json().value(forKey: "requested") as? String)!
        }else  if status == "accepted"{
            return (Utility.shared.Json().value(forKey: "accepted") as? String)!
        }else if status == "paid"{
            return (Utility.shared.Json().value(forKey: "paid") as? String)!
        }else if status == "started"{
            return (Utility.shared.Json().value(forKey: "started") as? String)!
        }else if status == "completed"{
            return (Utility.shared.Json().value(forKey: "completed") as? String)!
        }else if status == "cancelled"{
            return (Utility.shared.Json().value(forKey: "cancelled") as? String)!
        }else if status == "refunded"{
            if LocalDefault.shared.isUser()!{
                return (Utility.shared.Json().value(forKey: "refunded") as? String)!
            }else{
                return (Utility.shared.Json().value(forKey: "cancelled") as? String)!
            }
        }else if status == "expired"{
            return (Utility.shared.Json().value(forKey: "expired") as? String)!
        }else if status == "active"{
            return (Utility.shared.Json().value(forKey: "active") as? String)!
        }else if status == "pending"{
            return (Utility.shared.Json().value(forKey: "pending") as? String)!
        }
        //modified-AR
        else if status == "payment_pending"{
            return (Utility.shared.Json().value(forKey: "payment_pending") as? String)!
        }
        
        return status
    }
    //get status
    func color(status:String) -> UIColor {
        if status == "requested" || status == "paid" || status == "started" || status == "pending" || status == "payment_pending" {
            if status == "requested" {
                if LocalDefault.shared.isUser()!{
                    return .red
                }
            }
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }else  if status == "accepted" || status == "completed" || status == "active"{
            if status == "accepted" {
                if LocalDefault.shared.isUser()!{
                    //qwerty
//                    return .red
                    return RATING_GREEN!
                }
            }
            return RATING_GREEN!
        }
        //modified-AT
        else if status == "cancelled"  || status == "refunded" || status == "expired"{
            return .red
        }
        return .lightGray
    }
    
    //utc to local date
    func lastSeen(dateStr:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)// create   date from string
        
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a"
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date!) {
            return "Today, \(dateFormatter.string(from: date!))"
        }else if calendar.isDateInYesterday(date!){
            return "Yesterday, \(dateFormatter.string(from: date!))"
        }else{
            return toLocal(dateStr: dateStr, format: "dd/MM/yyyy hh:mm a")!
        }
    }
    
    
    //utc to local date
    func msg(Time:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: Time)// create date from string
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "hh:mm a"
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date!) {
            return dateFormatter.string(from: date!)
        }else{
            return toLocal(dateStr: Time, format: "dd.MMM.yyyy")!
            
        }
    }
    
    //    //show alert
    func showAlert(msg:String) {
        // create the alert
        let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: (Utility.shared.Json().value(forKey: msg) as! String), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func languageCode() -> String {
        let languageStr = Utility().language()
        var language_code = String()
        if languageStr == "عربى"{
            language_code = "ar"
        }else if languageStr == "Française"{
            language_code = "fr"
        }else if languageStr == "English"{
            language_code = "en"
        }
        return language_code
    }
    
    func serverAlert(msg:String) {
        // create the alert
        let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showToast(msg:String)  {
        let defaultAppearance = ToastAppearanceManager.default
        defaultAppearance.height = 60
        defaultAppearance.backgroundColor = .black
        defaultAppearance.numberOfLines = 2
        defaultAppearance.textAlignment = .left
        defaultAppearance.textFont = subReg!
        defaultAppearance.textColor = .white
        let toast: Toast = Toast.default(text: Utility.shared.Json().value(forKey: msg) as! String)
        toast.show()
    }
    
    func customToast(msg:String)  {
        let defaultAppearance = ToastAppearanceManager.default
        defaultAppearance.height = 60
        defaultAppearance.backgroundColor = .black
        defaultAppearance.numberOfLines = 2
        defaultAppearance.textAlignment = .left
        defaultAppearance.textFont = subReg!
        defaultAppearance.textColor = .white
        let toast: Toast = Toast.default(text:msg)
        toast.show()
    }
    //check app update
    func checkAppUpdate()  {
        let appDefault = LocalDefault.shared.appDefaults()
        let status = appDefault?.value(forKeyPath: "app_update.status") as! String
        if status == "true"{
            let store_version = appDefault?.value(forKeyPath: "app_update.ios_version") as! NSString
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? NSString
            let invite_link = URL(string: appDefault?.value(forKey: "invite_link") as? String ?? "")
            if appVersion!.floatValue < store_version.floatValue{
                let forceUpdate = appDefault?.value(forKeyPath: "app_update.ios_force_update") as! NSString
                let alert = UIAlertController(title: Utility.shared.Json().value(forKey: "alert") as? String, message: Utility.shared.Json().value(forKey: "app_update_info") as? String, preferredStyle: UIAlertController.Style.alert)
                if forceUpdate == "false"{
                    alert.addAction(UIAlertAction(title: Utility.shared.Json().value(forKey: "cancel") as? String, style: UIAlertAction.Style.default, handler: nil))
                }
                alert.addAction(UIAlertAction(title:Utility.shared.Json().value(forKey: "ok") as? String , style: .default, handler: { action in

                    if let url = invite_link, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //get theme
    func getTheme()-> String{
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark{
                return "dark"
            }else{
                return "light"
            }
        } else {
            return "dark"
        }
    }
    //get formatted json from array
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //MARK: Check string is empty
    func checkEmpty(str:String) -> Bool {
        if  (str == "") || (str == "NULL") || (str == "(null)") || (str == "<null>") || (str == "Json Error") || (str.isEmpty) ||  str.trimmingCharacters(in: .whitespaces).isEmpty || str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty  {
            return true
        }
        return false
    }
    
    func translate(msg: String, callback:@escaping (_ translatedText:String) -> ()) {
        var request = URLRequest(url: URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(GOOGLE_API_KEY)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        let targetLanguage = LocalDefault.shared.translation()
        let jsonRequest = [
            "q": msg,
            "target": targetLanguage as Any,
        ] as [String : Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted) {
            request.httpBody = jsonData
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Something went wrong: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if let data = data {
                        print("Response [\(httpResponse.statusCode)] - \(data)")
                    }
                    do {
                        if let data = data {
                            if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let jsonData = json["data"] as? [String : Any] {
                                    if let translations = jsonData["translations"] as? [NSDictionary] {
                                        if let translation = translations.first as? [String : Any] {
                                            if let translatedText = translation["translatedText"] as? String {
                                                callback(translatedText)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Serialization failed: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
        }
    }
}

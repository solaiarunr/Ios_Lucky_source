//
//  LocalDefault.swift
//  iDemand
//
//  Created by Roby on 27/08/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class LocalDefault: NSObject {
    
    static let shared = LocalDefault()
    //User id
    func setUser(id: String){
        UserDefaults.standard.set(id, forKey: "current_user_id")
    }
    func userID() -> String? {
        return UserDefaults.standard.value(forKey: "current_user_id") as? String
    }
    
    //FCM Token
    func setRole(type: String){
        UserDefaults.standard.set(type, forKey: "user_role")
    }
    func isUser() -> Bool? {
        let type = UserDefaults.standard.value(forKey: "user_role") as? String
        if type == "user"{
            return true
        }else{
            return false
        }
    }
    //viewFrom
    func setView(from: String){
        UserDefaults.standard.set(from, forKey: "view_from")
    }
    func viewFrom() -> String? {
        return UserDefaults.standard.value(forKey: "view_from") as? String
    }
    //selected category
    func selectCat(data: NSDictionary){
        do {
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            UserDefaults.standard.set(encoded, forKey: "select_category")
        } catch  {
        }
    }
    func selectedCategory() -> NSDictionary? {
        if UserDefaults.standard.object(forKey: "select_category") != nil{
            do {
                let decoded  = UserDefaults.standard.object(forKey: "select_category") as! Data
                let encoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
                return encoded as? NSDictionary
            } catch  {
            }
        }
        return nil
    }
    func removeCategory()  {
        UserDefaults.standard.removeObject(forKey: "select_category")
    }
    
    //FCM Token
    func setFCM(token: String){
        UserDefaults.standard.set(token, forKey: "fcm_token")
    }
    func FCM() -> String? {
        return UserDefaults.standard.value(forKey: "fcm_token") as? String
    }
    //accessToken
    func setAccess(token: String){
        UserDefaults.standard.set(token, forKey: "access_token")
    }
    func accessToken() -> String? {
        return UserDefaults.standard.value(forKey: "access_token") as? String
    }
    //location
    func setLocation(current: Bool){
        UserDefaults.standard.set(current, forKey: "instant_location")
    }
    func isLiveTrack() -> Bool? {
        return UserDefaults.standard.value(forKey: "instant_location") as? Bool
    }
    //qwerty
    //distance
    func setDistance(current: String){
        UserDefaults.standard.set(current, forKey: "distance")
    }
    func Distance() -> String? {
        return UserDefaults.standard.value(forKey: "distance") as? String
    }
    //distance_type
    func setDistanceType(current: String){
        UserDefaults.standard.set(current, forKey: "distance_type")
    }
    func DistanceType() -> String? {
        return UserDefaults.standard.value(forKey: "distance_type") as? String
    }
    //NOTIFICATION TOKEN
    func setNotification(redirection_id: String,type:String){
        UserDefaults.standard.set(redirection_id, forKey: "redirection_id")
        UserDefaults.standard.set(type, forKey: "notification_type")
    }
    func notifcationType() -> String? {
        return UserDefaults.standard.value(forKey: "notification_type") as? String
    }
    func notificationID() -> String? {
        return UserDefaults.standard.value(forKey: "redirection_id") as? String
    }
    func clearNotification() {
        UserDefaults.standard.removeObject(forKey: "redirection_id")
        UserDefaults.standard.removeObject(forKey: "notification_type")
    }
    //set app default
    func setApp(data: NSDictionary){
        do {
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            UserDefaults.standard.set(encoded, forKey: "app_defaults_info")
        } catch  {
        }
    }
    func appDefaults() -> NSDictionary? {
        do {
            if let decoded  = UserDefaults.standard.object(forKey: "app_defaults_info") as? Data {
                let encoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
                return encoded as? NSDictionary
            }
        } catch  {
        }
        return nil
    }
    //MARK: set theme
    func set(theme: NSString){
        UserDefaults.standard.set(theme, forKey: "app_theme")
    }
    func theme()-> NSString? {
        return UserDefaults.standard.value(forKey: "app_theme") as! NSString?
    }
    //show Hint
    func setHint(status: String){
        UserDefaults.standard.set(status, forKey: "show_hint")
    }
    func hint() -> String? {
        return UserDefaults.standard.value(forKey: "show_hint") as? String
    }
    //tranlsation language
    func setTranslation(language: String){
        UserDefaults.standard.set(language, forKey: "translation_language")
    }
    func translation() -> String? {
        return UserDefaults.standard.value(forKey: "translation_language") as? String
    }
    
    //set user info
    func setUser(data: Data){
        do {
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            UserDefaults.standard.set(encoded, forKey: "current_user_info")
        } catch  {
        }
    }
    func userInfo() -> Data? {
        do {
            let decoded  = UserDefaults.standard.object(forKey: "current_user_info") as! Data
            let encoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
            return encoded as? Data
        } catch  {
        }
        return nil
    }
    func set_paymentAdded(status: Bool){
        UserDefaults.standard.setValue(status, forKey: "payment_added")
    }
    func get_paymentAdded() -> Bool{
        return UserDefaults.standard.value(forKey: "payment_added") as? Bool ?? true
    }
    //MARK: set & get filter Array
    func setFilterArray(filter: NSMutableArray){
        UserDefaults.standard.removeObject(forKey: "filterArray")
        UserDefaults.standard.setValue(filter, forKey: "filterArray")
    }
    func getFilterArray() -> NSMutableArray{
        if UserDefaults.standard.value(forKey: "filterArray") != nil {
            return UserDefaults.standard.value(forKey: "filterArray") as! NSMutableArray
        }
        return NSMutableArray()
    }
    func clearFilterArray(){
        UserDefaults.standard.removeObject(forKey: "filterArray")
    }
    //MARK: Logout
    func logOut()  {
        UserDefaults.standard.removeObject(forKey: "filterArray")
        UserDefaults.standard.removeObject(forKey: "user_role")
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        UserDefaults.standard.removeObject(forKey: "user_role")
        UserDefaults.standard.removeObject(forKey: "current_user_info")
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.setInitialViewController()
        }
    }
}

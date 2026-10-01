//
//  BaseAPI.swift
//  iDemand
//
//  Created by Roby on 28/08/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import CoreLocation

public typealias Parameters = [String: Any]

class BaseAPI: NSObject {
    
    
    //POST METHOD
    public func baseService(subURl: String, params: Parameters!, onSuccess success: @escaping (AFDataResponse<Any>) -> Void) {
        let BaseUrl = URL(string: API_BASE_URL+subURl)
        print("API URL : \(API_BASE_URL+subURl)")
        print("PARAMETER : \(params!)")
        if Utility.shared.isConnectedToNetwork(){
            var header:HTTPHeaders? =  nil
            if(LocalDefault.shared.accessToken() != nil) {
                header = self.getHeaders()
                print("ACCESS TOKEN : \(LocalDefault.shared.accessToken()!)")
            }
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 15
            AF.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
            //webservice call
            AF.request(BaseUrl!, method:.post, parameters: params!, headers: header).responseJSON { response in
                //sucesss block
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse) URL : \(BaseUrl) Params \(params)")
                        let success_code = jsonResponse["status_code"].int
                        if success_code == 401{
                            LocalDefault.shared.logOut()
                        }
                    } catch {
                        print("JSONSerialization error:", error)
                        
                    }
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    print("FAILURE CODE: \(error._code)")
                    
                    loaderView.isHidden = true
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showToast(msg: "something_went_wrong")
                    }else if error._code == NSURLErrorNotConnectedToInternet{
                    }else if error._code == NSURLErrorNetworkConnectionLost{
                        self.baseService(subURl: subURl, params: params, onSuccess:{response in
                        })
                    }
                    //qwerty
                    else if error._code == 13{
                    self.baseService(subURl: subURl, params: params, onSuccess:{response in
                    })
                }
                else{
                    }
                }
            }
        }
    }   
    public func getDataCall(subURl: String, params: Parameters, onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = subURl
        var parameters = params
            AF.request(BaseUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    if json["status"].stringValue == "error" {
                      //  self.adminDisableAlert()
                    }
                    else {
                        success(json)
                    }
                case .failure(let error):
                    print(error)
                    failure(error)
                }
            }
    }
    // GET METHOD
    public func getDetails(subURl: String,onSuccess success: @escaping (AFDataResponse<Any>) -> Void) {
        let BaseUrl = URL(string: API_BASE_URL+subURl)
        print("API URL : \(API_BASE_URL+subURl)")
        
        if Utility().isConnectedToNetwork(){
            var header:HTTPHeaders? =  nil
            if(LocalDefault.shared.accessToken() != nil) {
                header = self.getHeaders()
                print("ACCESS TOKEN : \(LocalDefault.shared.accessToken()!)")
            }
            AF.sessionConfiguration.timeoutIntervalForRequest = 15
            AF.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
            //webservice call
            AF.request(BaseUrl!, method:.get, parameters: nil, headers: header).responseJSON { response in
                //sucesss block
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse) URL: \(BaseUrl) PRAMS : GET_METHOD)")
                        let success_code = jsonResponse["status_code"].int
                        if success_code == 401{
                            LocalDefault.shared.logOut()
                        }
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                    
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    loaderView.isHidden = true
                    if error._code == NSURLErrorNetworkConnectionLost{
                        self.getDetails(subURl: subURl, onSuccess:{response in
                        })
                    }
                    //qwerty
                    else if error._code == 13{
                        self.getDetails(subURl: subURl, onSuccess:{response in
                        })
                    }
                }
            }
        }
    }
    
    
    //MARK: UPLOAD IMAGE
    public func upload(sub_url:String,image:Data,type:String, onSuccess success: @escaping (AFDataResponse<Data?>) -> Void) {
        
        if Utility.shared.isConnectedToNetwork(){
            let BaseUrl = URL(string: UPLOAD_BASE_URL+sub_url)
            print("API URL : \(UPLOAD_BASE_URL+sub_url)")
            let parameters = ["user_id": "\(LocalDefault.shared.userID() ?? "")"]
            print("PARAMS : \(parameters)")
            
            var header:HTTPHeaders? =  nil
            if(LocalDefault.shared.accessToken() != nil) {
                header = self.getHeaders()
                print("ACCESS TOKEN : \(LocalDefault.shared.accessToken()!)")
            }
            AF.sessionConfiguration.timeoutIntervalForRequest = 15
            AF.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(image, withName: type, fileName: "profile.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
                }
            },to: BaseUrl!, usingThreshold: UInt64.init(),
              method: .post,
              headers: header).response{ response in
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse)")
                        let success_code = jsonResponse["status_code"].int
                        if success_code == 401{
                            LocalDefault.shared.logOut()
                        }
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    loaderView.isHidden = true
                }
            }
        }
    }
    //MARK: UPLOAD audio
    public func uploadAudio(audioData:Data, onSuccess success: @escaping (AFDataResponse<Data?>) -> Void) {
        
        if Utility.shared.isConnectedToNetwork(){
            var subURL = String()
            if LocalDefault().isUser()!{
                subURL = USER_AUDIO_UPLOAD_API
            }else{
                subURL = TASKER_AUDIO_UPLOAD_API
                
            }
            let BaseUrl = URL(string: UPLOAD_BASE_URL+subURL)
            print("API URL : \(UPLOAD_BASE_URL+subURL)")
            let parameters = ["user_id": "\(LocalDefault.shared.userID() ?? "")"]
            print("PARAMS : \(parameters)")
           
            var header:HTTPHeaders? =  nil
            if(LocalDefault.shared.accessToken() != nil) {
                header = self.getHeaders()
                print("ACCESS TOKEN : \(LocalDefault.shared.accessToken()!)")
            }
            AF.sessionConfiguration.timeoutIntervalForRequest = 15
            AF.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(audioData, withName: "audio", fileName: "audio.wav", mimeType: "audio/wav")
                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
                }
            },to: BaseUrl!, usingThreshold: UInt64.init(),
              method: .post,
              headers: header).response{ response in
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse)")
                        let success_code = jsonResponse["status_code"].int
                        if success_code == 401{
                            LocalDefault.shared.logOut()
                        }
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    loaderView.isHidden = true
                }
            }
        }
    }
    public func uploadFile(image:Data,fileType:String,name:String,type:String, onSuccess success: @escaping (AFDataResponse<Any>) -> Void , onProgress progress: @escaping (_ value: Progress?) -> Void) {
        let BaseUrl = URL(string: UPLOAD_BASE_URL+MEDIA_UPLOAD_API)
        print("API URL : \(UPLOAD_BASE_URL+MEDIA_UPLOAD_API)")
        let parameters = ["user_id": "\(LocalDefault.shared.userID() ?? "")","type": "\(type)","name": "\(name)"+".\(fileType)"]
     //    let parameters = ["user_id": "\(LocalDefault.shared.userID() ?? "")","type": "\(type)","image": "\(name)"]
        
        print("PARAMS : \(parameters)")
        var request = URLRequest(url:BaseUrl!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
        if(LocalDefault.shared.accessToken() != nil) {
            request.setValue(LocalDefault.shared.accessToken()! as String, forHTTPHeaderField: "Authorization")
            print("ACCESS TOKEN : \(LocalDefault.shared.accessToken()!)")
        }
        print("type : \(fileType)")
        
        var mime_type = String()
        if fileType == ".jpg" {
            mime_type = "image/jpg"
        }else if fileType == ".png"{
            mime_type = "image/png"
        }
        else if fileType == ".jpeg"
        {
            mime_type = "image/jpeg"
        }
        else if fileType == ".pdf"{
            mime_type = "application/pdf"
        }
        AF.sessionConfiguration.timeoutIntervalForRequest = 15
        AF.sessionConfiguration.requestCachePolicy = .reloadIgnoringCacheData
        AF.upload(multipartFormData: { multiPart in
            multiPart.append(image, withName: "image", fileName: "\(name)"+".\(fileType)", mimeType: mime_type)
            for (key, value) in parameters {
                multiPart.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
            }
        }, with: request)
            .uploadProgress(queue: .main, closure: { progressValue in
                //Current upload progress of file
                print("Upload Progress: \(progressValue.fractionCompleted)")
                progress(progressValue)
                
            })
            .responseJSON(completionHandler: { response in
                //Do what ever you want to do with response
                print("RESPONSE : \(response)")
                
                do {
                    let jsonResponse = try JSON.init(data: response.data!)
                    print("RESPONSE : \(jsonResponse)")
                    let success_code = jsonResponse["status_code"].int
                    if success_code == 401{
                        LocalDefault.shared.logOut()
                    }
                    success(response)
                } catch {
                    print("JSONSerialization error:", error)
                }
                
            })
    }
    
    
    //MARK: http headers
    func getHeaders() -> HTTPHeaders {
       
        let headers: HTTPHeaders = [
            "Authorization": LocalDefault.shared.accessToken()! as String,
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept-Language":Utility.shared.languageCode()
        ]
//        print("language code \(Utility.shared.languageCode())")
        return headers
    }
    
    public func getLocation(destinationCoordination:CLLocationCoordinate2D,pickupCoordination:CLLocationCoordinate2D,  onSuccess success: @escaping (AFDataResponse<Any>) -> Void , onProgress progress: @escaping (_ value: Progress?) -> Void) {
        
        let GetBaseUrl = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(pickupCoordination.latitude),\(pickupCoordination.longitude)&destination=\(destinationCoordination.latitude),\(destinationCoordination.longitude)&sensor=false&key=\(GOOGLE_API_KEY)&mode=driving")!
        print("BASE URL : \(String(describing: GetBaseUrl))")
        if Utility().isConnectedToNetwork(){
            //webservice call
            AF.request(GetBaseUrl, method:.get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                //sucesss block
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse)")
                     
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    print("FAILURE CODE: \(error._code)")
                    
                    loaderView.isHidden = true
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showToast(msg: "something_went_wrong")
                    }
                }
            }
        }
    }
    
    //get distance from pickup and drop
    public func getDistance(pickup:CLLocationCoordinate2D,drop:CLLocationCoordinate2D,  onSuccess success: @escaping (AFDataResponse<Any>) -> Void , onProgress progress: @escaping (_ value: Progress?) -> Void) {
        let GetBaseUrl = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(pickup.latitude),\(pickup.longitude)&destinations=\(drop.latitude),\(drop.longitude)&sensor=false&key=\(GOOGLE_API_KEY)&mode=driving")!
        print("BASE URL : \(String(describing: GetBaseUrl))")
        if Utility().isConnectedToNetwork(){
            //webservice call
            AF.request(GetBaseUrl, method:.get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                //sucesss block
                switch response.result {
                case .success:
                    do {
                        let jsonResponse = try JSON.init(data: response.data!)
                        print("RESPONSE : \(jsonResponse)")
                     
                    } catch {
                        print("JSONSerialization error:", error)
                    }
                    success(response)
                    break
                case .failure(let error):
                    print("FAILURE RESPONSE: \(error.localizedDescription)")
                    print("FAILURE CODE: \(error._code)")
                    
                    loaderView.isHidden = true
                    if error._code == NSURLErrorTimedOut{
                        Utility.shared.showToast(msg: "something_went_wrong")
                    }
                }
            }
        }
        
    }
}

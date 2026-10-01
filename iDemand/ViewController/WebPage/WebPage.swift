//
//  WebPage.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import WebKit

class WebPage: UIViewController,WKNavigationDelegate {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var contentView: WKWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet var noView: UIView!
    
    @IBOutlet var noLbl: UILabel!
    var viewType = String()
    var helpDict = NSDictionary()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
        self.checkRTL()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
        contentView.isOpaque = false
        self.contentView.backgroundColor = BACKGROUND_COLOR
        self.contentView.scrollView.backgroundColor = BACKGROUND_COLOR
    }    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contentView.frame.origin.x = 0
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if viewType == "terms"{
            self.dismiss(animated: true, completion: nil)
        }else if viewType == "stripe"{
            let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: (Utility.shared.Json().value(forKey: "payment_details_not_added") as! String), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style:.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style:.cancel, handler: { action in
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        } else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        if viewType == "stripe"{
            let topPadding = self.navigationView.frame.size.height
            self.contentView.frame = CGRect.init(x: 0, y:topPadding , width: FULL_WIDTH, height: FULL_HEIGHT-topPadding)
        }
    }
    //config initial setup
    func initialSetup()  {
        loader.startAnimating()
        loader.color = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_information_found")
        self.noView.isHidden = true
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.contentView.navigationDelegate = self
        
        if viewType == "stripe"{
            self.titleLbl.text = (Utility.shared.Json().value(forKey: "payment_details") as! String)
            
            //            let Obj = BaseAPI()
            //            Obj.getDetails(subURl: "\(STRIPE_URL)/\(LocalDefault.shared.userID() ?? "")", onSuccess: {response in
            //                let dict = response.value as! NSDictionary
            //                let status_code = dict.value(forKey: "status_code") as! Int
            //                if status_code == 200{
            //                    let link = dict.value(forKey: "stripe_url") as! String
            //                    let request = URLRequest(url: URL.init(string: link)!)
            //                    self.contentView.load(request)
            //                }
            //            })
            // qwerty
            let appDefault = LocalDefault.shared.appDefaults()
            let Client_id = appDefault?.value(forKey: "stripe_client_id") as? String
            if Client_id != nil {
                let request = URLRequest(url: URL.init(string: STRIPE_URL + Client_id!)!)
                self.contentView.load(request)
            }
            //    let request = URLRequest(url: URL.init(string: STRIPE_URL)!)
            //            self.contentView.load(request)
            
        }else{
            self.loadHTMLContent()
        }
        
    }
    
    //load content
    func loadHTMLContent()  {
        let appDefault = LocalDefault.shared.appDefaults()
        var contentString = String()
        if viewType == "terms"{
            if LocalDefault().isUser()!{
                if appDefault!.value(forKey: "user_terms") != nil{
                    if appDefault?.value(forKeyPath: "user_terms.description") != nil{
                        contentString = appDefault?.value(forKeyPath: "user_terms.description") as! String
                        self.titleLbl.text = (Utility.shared.Json().value(forKey: (appDefault?.value(forKeyPath: "user_terms.name") as? String ?? "")) as? String ?? appDefault?.value(forKeyPath: "user_terms.name") as? String)
                    }
                }
            }else{
                if appDefault!.value(forKey: "tasker_terms") != nil{
                    if appDefault?.value(forKeyPath: "tasker_terms.description") != nil{
                        contentString = appDefault?.value(forKeyPath: "tasker_terms.description") as! String
                        self.titleLbl.text =
                        (Utility.shared.Json().value(forKey: (appDefault?.value(forKeyPath: "tasker_terms.name") as? String ?? "")) as? String ?? appDefault?.value(forKeyPath: "tasker_terms.name") as? String)
                    }
                }
            }
        }else{
            contentString = self.helpDict.value(forKey: "description") as! String
            print("test \(contentString)")
            self.titleLbl.text = (Utility.shared.Json().value(forKey: (helpDict.value(forKey: "name") as? String ?? "")) as? String ?? helpDict.value(forKey: "name") as? String) //self.helpDict.value(forKey: "name") as? String
            if contentString == ""{
                self.noView.isHidden = false
            }
        }
        var alignment = String()
        if Utility.shared.isRTL(){
            alignment = "right"
        }else{
            alignment = "left"
        }
        var htmlString:String = "<font face=\(APP_FONT_REGULAR) size='6' align='\(alignment)'color='black'>\(contentString)"
        if #available(iOS 13.0, *) {
            if LocalDefault.shared.theme() == "Dark" || UITraitCollection.current.userInterfaceStyle == .dark{
                htmlString = "<font face=\(APP_FONT_REGULAR) size='6' align='\(alignment)' color='white'>\(contentString)"
            }  //overrideUserInterfaceStyle = .dark
        }
        self.contentView.loadHTMLString(htmlString, baseURL: nil)
    }
    //MARK: WebKit navigation delegate
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ERROR LOADING \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.stopAnimating()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("detect url \(webView.url)")
        let urlStr = webView.url?.absoluteString ?? ""
        if (urlStr.contains("code=")) {
            self.loader.startAnimating()
            let Obj = BaseAPI()
            do{
                let jsonDecoder = JSONDecoder()
                let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
                let codeval = urlStr.components(separatedBy: "code=").last
                let dispatchGroup = DispatchGroup()
                if profile.payment_verified == "false"{
                    dispatchGroup.enter()
                    Obj.getDetails(subURl: "\(PAYMENT_DETAILS_API)/\(LocalDefault.shared.userID() ?? "")/\(codeval ?? "")") { (response) in
                        print(response.value as! NSDictionary)
                        dispatchGroup.leave()
                    }
                }else{
                    dispatchGroup.enter()
                    Obj.getDetails(subURl: "\(MAP_CONNECT_ACCOUNT_API)/\(LocalDefault.shared.userID() ?? "")/\(codeval ?? "")") { (response) in
                        dispatchGroup.leave()
                        print(response.value as! NSDictionary)
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    Obj.getDetails(subURl: "\(STRIPE_STATUS_API)/\(LocalDefault.shared.userID() ?? "")", onSuccess: {response in
                        let dict = response.value as! NSDictionary
                        let status_code = dict.value(forKey: "status_code") as! Int
                        let msgStr = dict.value(forKey: "message") as! String
                        if status_code == 200 || status_code == 400{
                            if status_code == 200{
                                LocalDefault.shared.set_paymentAdded(status: true)
                            }
                            let alert = UIAlertController(title: (Utility.shared.Json().value(forKey: "alert") as! String), message: msgStr, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: (Utility.shared.Json().value(forKey: "ok") as! String), style: UIAlertAction.Style.cancel, handler: { action in
//                                self.navigationController?.popViewController(animated: true)
                                self.appDelegate?.setInitialViewController()
                            }))
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }catch{
                
            }
            
        }
    }
}

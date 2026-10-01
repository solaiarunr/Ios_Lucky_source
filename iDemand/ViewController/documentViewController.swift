//
//  documentViewController.swift
//  iDemand
//
//  Created by MAC pro 2.9Ghz on 10/08/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import UIKit
import WebKit
class documentViewController: UIViewController,WKUIDelegate {
    var webView:WKWebView!
    var selectedDict=NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL.init(string: selectedDict.value(forKey: "item_url") as! String)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        // Do any additional setup after loading the view.
    }

    override func loadView() {
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          webView.uiDelegate = self
          view = webView
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

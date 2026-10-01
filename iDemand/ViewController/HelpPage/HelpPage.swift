//
//  HelpPage.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class HelpPage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var helpTableView: UITableView!
    var helpArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Utility.shared.updateProfile()
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
        self.checkRTL()
    }
    //check rtl layout
       func checkRTL()  {
           if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
           }
       }
    
    //config initial setup
    func initialSetup()  {
        self.addLoader()
        self.navigationView.backgroundColor =  PRIMARY_COLOR
        self.helpTableView.radius(value: 10)
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "help")
        helpTableView.register(UINib(nibName: "HelpCell", bundle: nil), forCellReuseIdentifier: "HelpCell")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.getHelpContent()
    }
    
    //get help content
    func getHelpContent(){
        self.startLoading()
        let Obj = BaseAPI()
        var sub_api = String()
        if LocalDefault().isUser()!{
            sub_api = USER_HELP_API
        }else{
            sub_api = TASKER_HELP_API
        }
        Obj.getDetails(subURl: sub_api, onSuccess: {response in
            let helpDict = response.value as! NSDictionary
            let status_code = helpDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                self.stopLoading()
                let contactDict = NSMutableDictionary()
                contactDict.setValue("user", forKey: "type")
                contactDict.setValue("Contact us", forKey: "name")
                contactDict.setValue("Reach us using this", forKey: "description")
                self.helpArray.removeAllObjects()
                self.helpArray.add(contactDict)
                self.helpArray.addObjects(from: helpDict.value(forKey: "items") as! [Any])
                self.helpTableView.reloadData()
            }
        })
    }
    //back btn tapped
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.helpArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell
        let helpDict = helpArray.object(at: indexPath.row) as! NSDictionary
        let text = (Utility.shared.Json().value(forKey: (helpDict.value(forKey: "name") as? String ?? "")) as? String ?? helpDict.value(forKey: "name") as? String)
        cell.titleLbl.text = text
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let helpDict = helpArray.object(at: indexPath.row) as! NSDictionary
        let title = helpDict.value(forKey: "name") as? String
        
        if (title?.contains("Contact"))!{
            let contactObj = ContactPage()
            self.navigationController?.pushViewController(contactObj, animated: true)
        }else{
            let contentObj = WebPage()
            contentObj.viewType = "help"
            contentObj.helpDict = helpDict
            self.navigationController?.pushViewController(contentObj, animated: true)
        }
    }
}

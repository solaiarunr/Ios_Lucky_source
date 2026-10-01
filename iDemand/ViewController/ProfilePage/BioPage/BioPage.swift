//
//  BioPage.swift
//  iDemand
//
//  Created by Roby on 03/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class BioPage: UIViewController,UITextViewDelegate{
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var aboutTV: UITextView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var bioLbl: UILabel!
    
    
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
        self.submitBtn.topRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.addLoader()
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_bio")
        self.bioLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "my_bio")

        self.aboutTV.delegate = self
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "next")
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bioLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "about_placeholder")
            self.bioLbl.textAlignment = .right
        }else{
            self.aboutTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "about_placeholder")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.aboutTV.isEmptyValue() {
            Utility.shared.showAlert(msg: "enter_about")
        }else{
            if Utility.shared.isConnectedToNetwork(){
                self.startLoading()
                self.updateProfile()
            }
        }
    }
    
    //update profile details
    func updateProfile()  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue(self.aboutTV.text, forKey: "about")
        Obj.baseService(subURl: TASKER_PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            let resDict = response.value as! NSDictionary
            let status_code = resDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                LocalDefault.shared.setUser(data: response.data!)
                self.stopLoading()
                let certObj = CertificatePage()
                self.navigationController?.pushViewController(certObj, animated: true)
            }
        })
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

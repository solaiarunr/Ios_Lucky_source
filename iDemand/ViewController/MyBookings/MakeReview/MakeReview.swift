//
//  MakeReview.swift
//  iDemand
//
//  Created by Roby on 16/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MGStarRatingView
import MaterialComponents
import IQKeyboardManagerSwift
import SwiftUI

class MakeReview: UIViewController,StarRatingDelegate,UITextViewDelegate {
    
    @IBOutlet var titleLb: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var reviewHintLbl: UILabel!
    @IBOutlet var rateLbl: UILabel!
    @IBOutlet var ratingView: StarRatingView!
    @IBOutlet var ratingValueLbl: UILabel!
    @IBOutlet var reviewLbl: UILabel!
    @IBOutlet var reviewTV: UITextView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var reviewView: UIView!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    var refresh: (() -> Void)?
    var bookingID = String()
    var userDict = NSDictionary()
    var rating = CGFloat()
    var reviewDict = NSDictionary()
    var isKeyboardEnable = false
    var height = 140.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
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
        let reviewStatus = self.reviewDict.value(forKey: "status") as! String
        
        if reviewStatus == "true"{
            if self.reviewTV.contentSize.height < 140{
                self.reviewTV.frame.size.height = 140
                
                self.height = 140.0
            }else{
                self.reviewTV.frame.size.height = self.reviewTV.contentSize.height
                self.height = Double(self.reviewTV.contentSize.height)
            }
            self.reviewView.frame.size.height = self.reviewTV.frame.origin.y+self.reviewTV.frame.size.height
            self.containerView.frame.size.height = self.reviewView.frame.origin.y+self.reviewView.frame.size.height
            
            self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.containerView.frame.size.height+100)
        }
        
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLb.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.reviewHintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.reviewLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingValueLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingValueLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
//            self.ratingView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.reviewTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rateLbl.textAlignment = .right
            self.ratingValueLbl.textAlignment = .right
            self.reviewLbl.textAlignment = .right
            self.reviewTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .right, place: "review_des")
        }else{
            self.reviewTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "review_des")

        }
    }
    
    //initial set up
    func initialSetup()  {
        
        //keyboard manager
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        self.rating = 0.0
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.titleLb.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "rate_and_review")
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "")
        self.reviewHintLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "review_hint")
        self.reviewHintLbl.adjustsFontSizeToFitWidth = true
        self.rateLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "rate")
        self.ratingValueLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "rate")
        self.reviewLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "review")
        self.submitBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "post")
        self.addLoader()
        self.userImgView.radius(value: 5.0)
        let userimgURL = URL.init(string: (self.userDict.value(forKey: "image") as? String)!)
        self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        self.nameLbl.text = self.userDict.value(forKey: "name") as? String
        self.reviewTV.addBorder(width: 0.5, color: LINE_COLOR!)
        
        let attribute = StarRatingAttribute(type: .half,
                                            point: 30,
                                            spacing: 2,
                                            emptyColor: .lightGray,
                                            fillColor: PRIMARY_COLOR!,
                                            emptyImage: nil,
                                            fillImage: nil)
        self.ratingView.delegate = self
        
        let reviewStatus = self.reviewDict.value(forKey: "status") as! String
        
        if reviewStatus == "true"{
            let rating = self.reviewDict.value(forKey: "rating") as! String
            if NumberFormatter().number(from: rating) != nil {
                self.ratingView.configure(attribute, current: CGFloat(truncating: NumberFormatter().number(from: rating)!), max: 5)
                
            }
            self.ratingValueLbl.text = "\(Utility.shared.Json().value(forKey: "rate") as! String) \(self.reviewDict.value(forKey: "rating") as! String) / 5.0"
            self.reviewTV.text = self.reviewDict.value(forKey: "review_description") as? String
        }else{
            self.ratingValueLbl.text = "\(Utility.shared.Json().value(forKey: "rate") as! String) 0.0 / 5.0"
            self.ratingView.configure(attribute, current: 0, max: 5)
        }
        self.checkRTL()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat) {
        self.rating = value
        self.ratingValueLbl.text = "\(Utility.shared.Json().value(forKey: "rate") as! String) \(value) / 5.0"
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.reviewTV.isEmptyValue(){
            Utility.shared.showToast(msg: "leave_your_comments")
        }else{
            self.postReview()
        }
    }
    
    //post review
    func postReview(){
        self.startLoading()
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.bookingID, forKey: "booking_id")
        request.setValue(rating, forKey: "rating")
        request.setValue(self.reviewTV.text, forKey: "description")
        let reviewStatus = self.reviewDict.value(forKey: "status") as! String
        if reviewStatus == "true"{
            request.setValue(self.reviewDict.value(forKey: "review_id") as! String, forKey: "review_id")
        }
        Obj.baseService(subURl: POST_REVIEW_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                Utility.shared.showToast(msg: "review_posted")
                self.refresh!()
            }
            self.stopLoading()
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
    
    
    
    //MARK: Keyboard hide/show
    @objc func keyboardWillShow(sender: NSNotification) {
        if !isKeyboardEnable {
            isKeyboardEnable = true
            if UIDevice.current.hasNotch {
                self.containerView.frame.origin.y -= CGFloat(self.height+100)
            }else{
                self.containerView.frame.origin.y -= CGFloat(self.height+150)
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if UIDevice.current.hasNotch {
            self.containerView.frame.origin.y += CGFloat(self.height+100)
        }else{
            self.containerView.frame.origin.y += CGFloat(self.height+150)
        }
        isKeyboardEnable = false
    }
    @objc func doneTapped(){
        
    }
}

//
//  ServiceDetails.swift
//  iDemand
//
//  Created by Roby on 07/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ServiceDetails: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var saveBtn: UIButton!
    
    var works:MyWorks?
    var parent_cat_id = String()
    var parent_cat_type = String()
    var isLast = false
    var refreshRequest: (() -> Void)?

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
        self.saveBtn.topRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl layout
        func checkRTL()  {
            if Utility.shared.isRTL(){
                self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.priceTF.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.priceLbl.textAlignment = .right
                self.currencyLbl.textAlignment = .right
                self.priceTF.textAlignment = .left
                self.serviceNameLbl.textAlignment = .right
            }
        }
    
    //initial set up
    func initialSetup()   {
        self.addLoader()
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String

        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.serviceImgView.radius(value: 5)
        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.currencyLbl.config(color: PRIMARY_COLOR!, font: subReg, align: .left, text: "")
        let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double
        self.priceTF.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, place: "")
        self.priceTF.placeholder = "\(Utility.shared.Json().value(forKey: "enter_amount") ?? "") (\(currency_code)\(payment_minimum_price!))"
        self.priceTF.delegate = self
        self.titleLbl.text = works?.subcategory_name
        self.serviceNameLbl.text = works?.service_name
        self.priceTF.text = works?.service_price
        self.priceLbl.text = "\(Utility.shared.Json().value(forKey: "price") as! String) /\(works?.service_pricing! ?? "")"
        self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "save")
        let item_img = URL.init(string: (works?.service_image!)!)
        self.serviceImgView.sd_setImage(with: item_img, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        self.serviceImgView.backgroundColor = LINE_COLOR

        self.currencyLbl.text = "\((defaultDict?.value(forKey: "currency_code") as! String)) - \(defaultDict?.value(forKey: "currency_symbol") as! String)"
        if parent_cat_type == "professional"{
            self.priceTF.isUserInteractionEnabled = false
            self.saveBtn.isHidden = true
        }
        self.checkRTL()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Delete btn tapped
    @IBAction func deleteBtnTapped(_ sender: Any) {
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "delete"
        alertObj.deleteRequest = {
            self.deleteService()
        }
        self.navigationController?.present(alertObj, animated: false, completion: nil)
    }
    //save btn tapped
    @IBAction func saveBtnTapped(_ sender: Any) {
        let defaultDict = LocalDefault.shared.appDefaults()
            let price = Double("\(self.priceTF.text!)") ?? .nan
            let payment_minimum_price = defaultDict?.value(forKey: "minimum_payment_price") as? Double ?? .nan
        let currency_symbol = defaultDict?.value(forKey: "currency_symbol") as! String

        if self.priceTF.isEmptyValue() || price < payment_minimum_price {
            let msgStr = "\(Utility.shared.Json().value(forKey: "enter_valid_amount") ?? "") \(currency_symbol)\(payment_minimum_price)"
            Utility.shared.customToast(msg: msgStr)
        }else{
            if Utility.shared.isConnectedToNetwork(){
                let Obj = BaseAPI()
                let request = NSMutableDictionary()
                request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
                request.setValue(self.parent_cat_id, forKey: "parent_category_id")
                request.setValue(works?.subcategory_id, forKey: "subcategory_id")
                request.setValue("edit", forKey: "type")
                let servicesArray = NSMutableArray()
                let dict = NSMutableDictionary()
                dict.setValue(works?.service_id, forKey: "service_id")
                dict.setValue(self.priceTF.text, forKey: "service_price")
                servicesArray.add(dict)
                request.setValue(Utility.shared.json(from: servicesArray), forKey: "services")
                Obj.baseService(subURl: ADD_SERVICES_API, params: request as? Parameters, onSuccess: {response in
                    let dict = response.value as! NSDictionary
                    let status_code = dict.value(forKey: "status_code") as! Int
                    if status_code == 200{
                        self.refreshRequest!()
                        Utility.shared.showToast(msg: "service_added")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    //Delete services
    func deleteService(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.parent_cat_id, forKey: "parent_category_id")
            request.setValue(works?.subcategory_id, forKey: "subcategory_id")
            request.setValue(works?.service_id, forKey: "service_id")
            Obj.baseService(subURl: DELETE_SERVICE_API, params: request as? Parameters, onSuccess: {response in
                let dict = response.value as! NSDictionary
                let status_code = dict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.refreshRequest!()
                    Utility.shared.showToast(msg: "service_deleted")
                    if self.isLast{
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    //textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let msg = textField.text! + string
        if msg.containsEmoji(){
            return false
        }else{
            var maxLimit = 5
                if msg.contains(".") {
                        maxLimit = 8
            }            
            if textField.text!.count > maxLimit{
                if string.isEmpty{
                    return true
                }else{
                    return false
                }
            }else{
                
                guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                    return true
                }
                let newText = oldText.replacingCharacters(in: r, with: string)
                let isNumeric = newText.isEmpty || (Double(newText) != nil)
                let numberOfDots = newText.components(separatedBy: ".").count - 1
                
                let numberOfDecimalDigits: Int
                if let dotIndex = newText.firstIndex(of: ".") {
                    numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                } else {
                    numberOfDecimalDigits = 0
                }
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
            }
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         if textField.text?.last == "." {
             self.priceTF.text?.removeLast()
         }
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }
}

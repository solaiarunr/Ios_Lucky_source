//
//  ServiceListPage.swift
//  iDemand
//
//  Created by Roby on 12/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ServiceListPage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var noItemLbl: UILabel!
    @IBOutlet var serviceTableView: UITableView!
    @IBOutlet var noItemView: UIView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var amtLbl: UILabel!
    @IBOutlet var paymentView: UIView!
    @IBOutlet var nextBtn: UIButton!
    
    var services:[Services]?
    var parent_cat_id = String()
    var parent_cat_name = String()
    var location_type = String()
    var parent_cat_type = String()
    var sub_cat_id = String()
    var sub_cat_name = String()
    
    var selected_id = String()
    var servicesArray = NSMutableArray()
    var servicesIDs = NSMutableArray()
    var viewType = String()
    var currency_code = String()
    var isEdit = false
    var total_amt = Double()
    var bookingArray = NSMutableArray()
    var isDataAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initalSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.saveBtn.topRadius()
        self.paymentView.topRadius()
        self.checkRTL()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noItemView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noItemLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.saveBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nextBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nextBtn.contentHorizontalAlignment = .left
            self.amtLbl.textAlignment = .right

        }
    }
    
    func initalSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.addLoader()
        serviceTableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        serviceTableView.register(UINib(nibName: "ProfessionalServiceCell", bundle: nil), forCellReuseIdentifier: "ProfessionalServiceCell")
        serviceTableView.register(UINib(nibName: "MarketPlaceServiceCell", bundle: nil), forCellReuseIdentifier: "MarketPlaceServiceCell")
        serviceTableView.register(UINib(nibName: "TaskerServiceCell", bundle: nil), forCellReuseIdentifier: "TaskerServiceCell")

        self.paymentView.backgroundColor = PRIMARY_COLOR
        self.amtLbl.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .left, text: "")

        self.nextBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .right, title: "next")
        self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "save")
        self.noItemLbl.config(color: TEXT_LITE_COLOR!, font: headReg, align: .center, text: "no_service_available")
        let defaultDict = LocalDefault.shared.appDefaults()
        currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        self.amtLbl.text = "\(currency_code) 0"

        self.noItemView.isHidden = true
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.titleLbl.text = self.sub_cat_name
        self.titleLbl.adjustsFontSizeToFitWidth = true
        self.serviceTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.startLoading()
        self.getServices()
        self.addPullDownRefresh()
        if LocalDefault().isUser()!{
            self.saveBtn.isHidden = true
            if parent_cat_type != "professional"{
                self.paymentView.isHidden = true
            }
        }else{
            self.paymentView.isHidden = true
        }
    }
    
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.serviceTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.isDataAvailable = false
            self.getServices()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnTapped(_ sender: Any) {
        if self.bookingArray.count != 0 {
            let describeObj = DescribeTask()
            describeObj.parent_cat_id = self.parent_cat_id
            describeObj.parent_cat_name = self.parent_cat_name
            describeObj.parent_cat_type = self.parent_cat_type
            describeObj.sub_cat_id = self.sub_cat_id
            describeObj.sub_cat_name = self.sub_cat_name
            let totalamt = self.amtLbl.text?.replacingOccurrences(of:"\(currency_code) " , with: "")
            describeObj.booking_amt = totalamt!
            describeObj.bookingArray = self.bookingArray
            describeObj.locationType = self.location_type

            self.navigationController?.pushViewController(describeObj, animated: true)
            
        }else{
            Utility.shared.showToast(msg: "add_atleast_one")
        }
    }
    
    //get services
    func getServices(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(parent_cat_id, forKey: "parent_category_id")
            request.setValue(sub_cat_id, forKey: "subcategory_id")
            var api_name = String()
            if LocalDefault().isUser()!{
                api_name = SERVICES_API
            }else{
                api_name = MY_SERVICES_API
            }
            Obj.baseService(subURl: api_name, params: request as? Parameters, onSuccess: {response in
                do{
                    self.isDataAvailable = true
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(ServicesModel.self, from: response.data!)
                    if model.status_code == 200{
                        if model.services?.count != 0{
                            self.noItemView.isHidden = true
                            self.services = model.services
                            for service in self.services! as [Services]{
                                if service.is_new == "false"{
                                    self.servicesIDs.add(service.service_id!)
                                    let dict =  NSMutableDictionary()
                                    dict.setValue(service.service_id, forKey: "service_id")
                                    dict.setValue(service.service_price, forKey: "service_price")
                                    self.servicesArray.add(dict)
                                    self.isEdit = true
                                }
                            }
                            self.serviceTableView.delegate = self
                            self.serviceTableView.dataSource = self
                            self.serviceTableView.reloadData()
                        }else{
                            self.saveBtn.isHidden = true
                            self.noItemView.isHidden = false
                        }
                        self.serviceTableView.fty.pullToRefresh.end()
                    }else if model.status_code == 400{
                        
                    }
                    self.stopLoading()
                    
                }catch{
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if !self.isDataAvailable {
                self.isDataAvailable = false
                self.getServices()
            }
        }
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = services![indexPath.row]
        
        var customCell = UITableViewCell()
        
        if LocalDefault.shared.viewFrom() == "choose"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
            cell.tag = indexPath.row + 1000
            cell.config(model: model,type:parent_cat_type,selectedIDs: servicesIDs,isEdit: isEdit)
            cell.priceLbl.isHidden = true
            cell.inActiveView.isHidden = true
            customCell = cell
        }else{
            if LocalDefault().isUser()!{
                if parent_cat_type == "professional"{
                    let proCell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalServiceCell", for: indexPath) as! ProfessionalServiceCell
                    proCell.tag = indexPath.row + 1000
                    proCell.config(model: model,selectedIDs: servicesIDs,isEdit: isEdit)
                    proCell.increaseBtn.tag = indexPath.row
                    proCell.decreaseBtn.tag = indexPath.row
                    proCell.increaseBtn.addTarget(self, action: #selector(self.increaseTapped(_:)), for: .touchUpInside)
                    proCell.decreaseBtn.addTarget(self, action: #selector(self.decreaseTapped(_:)), for: .touchUpInside)
                    customCell = proCell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
                    cell.tag = indexPath.row + 1000
                    cell.config(model: model,type:parent_cat_type,selectedIDs: servicesIDs,isEdit: isEdit)
                    cell.priceLbl.isHidden = true
                    cell.inActiveView.isHidden = true
                    customCell = cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskerServiceCell", for: indexPath) as! TaskerServiceCell
                cell.tag = indexPath.row + 1000
                cell.config(model: model,type:parent_cat_type,selectedIDs: servicesIDs,isEdit: isEdit)
                customCell = cell
            }
        }
        return customCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if LocalDefault().isUser()!{
            return 70
        }else{
            return 75
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = services![indexPath.row]
        
        if LocalDefault.shared.viewFrom() == "choose"{
            let dict = NSMutableDictionary()
                dict.setValue(model.service_id, forKey: "service_id")
                dict.setValue(model.service_name, forKey: "service_name")
                dict.setValue(self.sub_cat_id, forKey: "sub_cat_id")
                dict.setValue(self.sub_cat_name, forKey: "sub_cat_name")
                dict.setValue(self.parent_cat_id, forKey: "parent_cat_id")
                dict.setValue(self.parent_cat_name, forKey: "parent_cat_name")
                dict.setValue(self.location_type, forKey: "location_type")
                LocalDefault.shared.selectCat(data: dict)
            for controller in self.navigationController!.viewControllers as Array {

                if controller.isKind(of: PostNeeds.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
//            self.navigationController?.popToRootViewController(animated: true)
        }else{
            if LocalDefault().isUser()!{
                if parent_cat_type == "marketplace"{
                    let dict = NSMutableDictionary()
                    dict.setValue(model.service_id, forKey: "service_id")
                    dict.setValue(model.service_pricing, forKey: "service_pricing")
                    dict.setValue(model.service_image, forKey: "service_image")
                    dict.setValue(model.service_name, forKey: "service_name")

                    self.bookingArray.add(dict)
                    
                    let describeObj = DescribeTask()
                    describeObj.parent_cat_id = self.parent_cat_id
                    describeObj.parent_cat_name = self.parent_cat_name
                    describeObj.parent_cat_type = self.parent_cat_type
                    describeObj.sub_cat_id = self.sub_cat_id
                    describeObj.sub_cat_name = self.sub_cat_name
                    describeObj.locationType = self.location_type
                    describeObj.service_name = model.service_name!
                    describeObj.locationType = self.location_type
                    describeObj.bookingArray = self.bookingArray
                    self.navigationController?.pushViewController(describeObj, animated: true)
                }
            }else{ // tasker page
                if model.service_status == "1" {
                    if parent_cat_type == "marketplace"{
                        let cell = self.view.viewWithTag(indexPath.row + 1000) as! TaskerServiceCell
                        let fullStr = cell.priceLbl.text?.replacingOccurrences(of: currency_code, with: "")
                        let amtStr = fullStr!.replacingOccurrences(of: "/\(model.service_pricing!)", with: "")
                        let alertObj = AlertPage()
                        alertObj.modalPresentationStyle = .overCurrentContext
                        alertObj.viewType = "addservice"
                        alertObj.service = model
                        alertObj.amtStr = amtStr.replacingOccurrences(of: " ", with: "")
                        alertObj.addPrice = { price in
                            self.isEdit = false
                            if price != "" {
                                cell.priceLbl.text = "\(self.currency_code) \(price)/\(model.service_pricing!)"
                            }
                            cell.priceLbl.adjustsFontSizeToFitWidth = true

                            self.addService(model: model, price: price)
                        }
                        self.navigationController?.present(alertObj, animated: false, completion: nil)
                    }else{
                        self.addService(model: model, price:"\(model.service_price!)")
                    }
                }else{
                    Utility.shared.showToast(msg: "service_disabled")
                }
            }
        }
        
    }
    
    //increase cart
    @objc func increaseTapped(_ sender: UIButton){
        let cell = self.view.viewWithTag(sender.tag + 1000) as! ProfessionalServiceCell
        let model = services![sender.tag]
        cell.decreaseBtn.isUserInteractionEnabled = true
        cell.increaseBtn.tintColor = PRIMARY_COLOR
        cell.decreaseBtn.tintColor = TEXT_BLACK_COLOR
        
        var count = Double()
        if cell.quantityLbl.text == (Utility.shared.Json().value(forKey: "add") as! String) {
            count += 1
        }else{
            let currentVal = Double("\(cell.quantityLbl.text!)") ?? .nan

            if currentVal == 10 {
                Utility.shared.showToast(msg: "maximum_limit_exceeds")
                return
            }else{
                count = currentVal
                count += 1
            }
        }
        let price = Double("\(model.service_price!)") ?? .nan

//        let price:Int? = Int(model.service_price!)
        total_amt += price
        
        self.amtLbl.text = "\(currency_code) \(String(format:"%.02f", total_amt))"
        cell.quantityLbl.text = "\(Int(count))"
        self.addBookingService(model: model, quantity: count)
    }
    //decrease cart
    @objc func decreaseTapped(_ sender: UIButton){
        let cell = self.view.viewWithTag(sender.tag + 1000) as! ProfessionalServiceCell
        let model = services![sender.tag]
        
        var count = Double()
        if cell.quantityLbl.text == (Utility.shared.Json().value(forKey: "add") as! String) || cell.quantityLbl.text == "1"{
            cell.quantityLbl.text = (Utility.shared.Json().value(forKey: "add") as! String)
            cell.increaseBtn.tintColor = TEXT_BLACK_COLOR
            cell.decreaseBtn.tintColor = LINE_COLOR
            cell.decreaseBtn.isUserInteractionEnabled = false
            let price = Double("\(model.service_price!)") ?? .nan
            total_amt -= price
            self.amtLbl.text = "\(currency_code) \(String(format:"%.02f", total_amt))"
            if total_amt == 0{
                self.amtLbl.text = "\(currency_code) 0"
            }
            count = 0
        }else{
            cell.increaseBtn.tintColor = TEXT_BLACK_COLOR
            cell.decreaseBtn.tintColor = PRIMARY_COLOR
            cell.decreaseBtn.isUserInteractionEnabled = true
            let currentVal = Double("\(cell.quantityLbl.text!)") ?? .nan
            count = currentVal
            count -= 1
            cell.quantityLbl.text = "\(Int(count))"
            let price = Double("\(model.service_price!)") ?? .nan
            total_amt -= price
            self.amtLbl.text = "\(currency_code) \(String(format:"%.02f", total_amt))"
        }
        self.addBookingService(model: model, quantity: count)
    }
    // added wanted service
    func addBookingService(model:Services,quantity:Double)  {
        if self.servicesIDs.contains(model.service_id as Any) {
            print("AVAILABLE \(self.bookingArray)")
            for dict in self.bookingArray {
                let oldDict = dict as! NSMutableDictionary
                let serviceID = oldDict.value(forKey: "service_id") as! String
                if serviceID == model.service_id{
                    if quantity != 0{
                        let price = Double("\(model.service_price!)") ?? .nan
                        let final_price = quantity * price
                        let newDict = NSMutableDictionary.init(dictionary: oldDict)
                        newDict.removeObject(forKey: "service_quantity")
                        newDict.removeObject(forKey: "service_total_price")
                        newDict.setValue(quantity, forKey: "service_quantity")
                        newDict.setValue("\(String(format:"%.02f", final_price))", forKey: "service_total_price")
                        self.bookingArray.add(newDict)
                    }else{
                        self.servicesIDs.remove(model.service_id as Any)
                    }
                    self.bookingArray.remove(oldDict)
                }
            }
        }else{
            print("UN-AVAILABLE")

            let price = Double("\(model.service_price!)") ?? .nan
            let final_price = quantity * price
            let dict = NSMutableDictionary()
            dict.setValue(model.service_id, forKey: "service_id")
            dict.setValue(model.service_price, forKey: "service_price")
            dict.setValue(model.service_pricing, forKey: "service_pricing")
            dict.setValue(model.service_image, forKey: "service_image")
            dict.setValue(model.service_name, forKey: "service_name")            
            dict.setValue(quantity, forKey: "service_quantity")
            dict.setValue("\(String(format:"%.02f", final_price))", forKey: "service_total_price")
            self.bookingArray.add(dict)
            self.servicesIDs.add(model.service_id as Any)
        }
    }
    
    // add price or remove price based on the marketplace or professional
    func addService(model:Services,price:String)  {
        if self.servicesIDs.contains(model.service_id as Any){
            if price == "" || parent_cat_type == "professional" {
                self.servicesIDs.remove(model.service_id as Any)
                for serviceDict in self.servicesArray {
                    let removeDict = serviceDict as! NSDictionary
                    let removeid = removeDict.value(forKey: "service_id") as! String
                    if model.service_id == removeid{
                        self.servicesArray.remove(serviceDict)
                        break
                    }
                }
            }else{
                self.servicesIDs.add(model.service_id as Any)
                let dict = NSMutableDictionary()
                dict.setValue(model.service_id, forKey: "service_id")
                dict.setValue(price, forKey: "service_price")
                self.servicesArray.add(dict)
            }
        }else{
            if price != "" {
                self.servicesIDs.add(model.service_id as Any)
                let dict = NSMutableDictionary()
                dict.setValue(model.service_id, forKey: "service_id")
                dict.setValue(price, forKey: "service_price")
                self.servicesArray.add(dict)
            }
        }
        print("service array \(self.servicesArray)")
        self.serviceTableView.reloadData()
    }
    //remove particular service
    func removeService(service_id:String)  {
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.parent_cat_id, forKey: "parent_category_id")
        request.setValue(self.sub_cat_id, forKey: "subcategory_id")
        request.setValue(service_id, forKey: "service_id")
        Obj.baseService(subURl: DELETE_SERVICE_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
            }
        })
    }
    // save btn
    @IBAction func saveBtnTapped(_ sender: Any) {
        if self.servicesArray.count == 0{
            Utility.shared.showToast(msg: "add_atleast_one")
        }else{
            self.addServicesAPI()
            self.startLoading()
        }
    }
    
    //add services
    func addServicesAPI(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(parent_cat_id, forKey: "parent_category_id")
            request.setValue(sub_cat_id, forKey: "subcategory_id")
            request.setValue("add", forKey: "type")
            request.setValue(Utility.shared.json(from: self.servicesArray), forKey: "services")
            Obj.baseService(subURl: ADD_SERVICES_API, params: request as? Parameters, onSuccess: {response in
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(ServicesModel.self, from: response.data!)
                    if model.status_code == 200{
                        if LocalDefault.shared.viewFrom() == "addservice"{
                            Utility.shared.showToast(msg: "service_added")
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            let  bioObj = BioPage()
                            self.navigationController?.pushViewController(bioObj, animated: true)
                        }
                    }else if model.status_code == 400{
                        Utility.shared.showToast(msg: "something_went_wrong")
                    }
                    self.stopLoading()
                }catch{
                }
            })
        }
    }
    
}

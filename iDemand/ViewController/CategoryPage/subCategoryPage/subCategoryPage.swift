//
//  subCategoryPage.swift
//  iDemand
//
//  Created by Roby on 12/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class subCategoryPage: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var noItemLbl: UILabel!
    @IBOutlet var subCategoryTableView: UITableView!
    @IBOutlet var noItemView: UIView!
    @IBOutlet var howitworksBtn: UIButton!
    @IBOutlet var aboutBtn: UIButton!
    @IBOutlet var reviewBtn: UIButton!
    @IBOutlet var reviewArrow: UIImageView!
    @IBOutlet var reviewLbl: UILabel!
    @IBOutlet var faqArrow: UIImageView!
    @IBOutlet var faqBtn: UIButton!
    @IBOutlet var infoView: UIView!
    @IBOutlet var saveBtn: UIButton!
    
    var subCategories:[Subcategory]?
    var TakserCategories:[Subcategory]?
    var parent_cat_id = String()
    var parent_cat_name = String()
    var parent_cat_type = String()
    var location_type = String()
    var subCat:subcategoryModel?
    var isDataAvailable = false
    var services:[MyWorks]?
    var sub_cat_id = String()
    var addServiceArray = NSMutableArray()
    //qwerty
    var viewType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.updateTheme()
        self.infoView.backgroundColor = POPUP_COLOR
        if self.viewType == "addservice" || LocalDefault.shared.viewFrom() == "signup"{
            self.saveBtn.isHidden  = false
        } else{
            self.saveBtn.isHidden  = true
        }
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        let height = FULL_HEIGHT-(self.navigationView.frame.size.height + self.infoView.frame.size.height)
        if !UIDevice.current.hasNotch {
            self.subCategoryTableView.frame = CGRect.init(x: 0, y: self.navigationView.frame.size.height, width: FULL_WIDTH, height: height+15)
        }else{
            self.subCategoryTableView.frame = CGRect.init(x: 0, y: self.navigationView.frame.size.height, width: FULL_WIDTH, height: height)
        }
        self.checkRTL()
        self.saveBtn.topRadius()
    }
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.reviewBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.faqBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.howitworksBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noItemView.transform = CGAffineTransform(scaleX: -1, y: 1)            
            self.reviewBtn.contentHorizontalAlignment = .right
            self.faqBtn.contentHorizontalAlignment = .right
            self.aboutBtn.contentHorizontalAlignment = .right
            self.howitworksBtn.contentHorizontalAlignment = .right
        }
    }
    //initial set up
    func initalSetup()  {
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        subCategoryTableView.register(UINib(nibName: "SubCatCell", bundle: nil), forCellReuseIdentifier: "SubCatCell")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.titleLbl.text = parent_cat_name
        self.titleLbl.adjustsFontSizeToFitWidth = true
        self.saveBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "save")
        self.noItemLbl.config(color: TEXT_LITE_COLOR!, font: headReg, align: .center, text: "no_service_available")
        self.howitworksBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "how_it_works")
        self.reviewBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "reviews")
        self.aboutBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "about")
        self.faqBtn.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, title: "faq")
        
        self.noItemView.isHidden = true
        self.startLoading()
        self.getSubCatgories()
        self.addPullDownRefresh()
        
        if parent_cat_type == "marketplace"{
            self.faqBtn.frame.origin.y = self.reviewBtn.frame.origin.y
            self.faqArrow.frame.origin.y = self.reviewArrow.frame.origin.y
            self.infoView.frame.origin.y += 50
            self.reviewBtn.isHidden = true
            self.reviewLbl.isHidden = true
            self.reviewArrow.isHidden = true
        }
        if !UIDevice.current.hasNotch {
            self.infoView.frame.origin.y += 10
        }
        self.infoView.isHidden = true
        self.viewDidLayoutSubviews()
    }
    
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.subCategoryTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.isDataAvailable = false
            self.getSubCatgories()
        }
    }
    @IBAction func howitWorksBtnTapped(_ sender: Any) {
        if subCat?.how_it_works != nil {
            let dict = NSMutableDictionary()
            dict.setValue(Utility.shared.Json().value(forKey: "how_it_works"), forKey: "name")
            dict.setValue(subCat?.how_it_works, forKey: "description")
            let contentObj = WebPage()
            contentObj.helpDict = dict
            self.navigationController?.pushViewController(contentObj, animated: true)
        }
    }
    
    @IBAction func aboutBtnTapped(_ sender: Any) {
        if subCat?.about_task != nil {
            let dict = NSMutableDictionary()
            dict.setValue(Utility.shared.Json().value(forKey: "about"), forKey: "name")
            dict.setValue(subCat?.about_task, forKey: "description")
            let contentObj = WebPage()
            contentObj.helpDict = dict
            self.navigationController?.pushViewController(contentObj, animated: true)
        }
    }
    
    @IBAction func reviewBtnTapped(_ sender: Any) {
        let reviewObj = ReviewsList()
        reviewObj.viewType = "category"
        reviewObj.reviwer_id = self.parent_cat_id
        self.navigationController?.pushViewController(reviewObj, animated: true)
    }
    
    @IBAction func faqBtnTapped(_ sender: Any) {
        if subCat?.faq != nil {
            let dict = NSMutableDictionary()
            dict.setValue(Utility.shared.Json().value(forKey: "faq"), forKey: "name")
            dict.setValue(subCat?.faq, forKey: "description")
            let contentObj = WebPage()
            contentObj.helpDict = dict
            self.navigationController?.pushViewController(contentObj, animated: true)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //get categories list
    func getSubCatgories(){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(parent_cat_id, forKey: "parent_category_id")
        Obj.baseService(subURl: SUB_CATEGORIES_API, params: request as? Parameters, onSuccess: {response in
            self.isDataAvailable = true
            do{
                let jsonDecoder = JSONDecoder()
                self.subCat = try jsonDecoder.decode(subcategoryModel.self, from: response.data!)
                if self.subCat?.status_code == 200{
                    if self.subCat?.subcategory?.count != 0{
                       // self.infoView.isHidden = false
                        self.noItemView.isHidden = true
                        self.subCategoryTableView.delegate = self
                        self.subCategoryTableView.dataSource = self
                        self.subCategories = self.subCat?.subcategory!
                        if self.viewType == "addservice" || LocalDefault.shared.viewFrom() == "signup" {
                            self.getTaskerAddedSerivce()
                        } else{
                            self.subCategoryTableView.reloadData()
                        }
                    }else{
                        self.noItemView.isHidden = false
                    }
                    self.subCategoryTableView.fty.pullToRefresh.end()
                    self.stopLoading()
                }else if self.subCat?.status_code == 400{
                }
            }catch{
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if !self.isDataAvailable {
                self.isDataAvailable = false
                self.getSubCatgories()
            }
        }
    }
    func getTaskerAddedSerivce(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.parent_cat_id, forKey: "parent_category_id")
            
            Obj.baseService(subURl: MY_SERVICES_API, params: request as? Parameters, onSuccess: { [self]response in
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(MyServicesModel.self, from: response.data!)
                    if model.status_code == 200{
                        self.services = model.services!
                        if self.services?.count != 0{
                            for i in self.services!{
                                self.addServiceArray.add(i.subcategory_id)
                            }
                        }
                        
                        self.subCategoryTableView.reloadData()
                    }else if model.status_code == 400{
                    }
                    self.stopLoading()
                }catch{
                }
            })
        }
    }
    @objc func checkBoxBtnTapped(sender:UIButton){
        let btnSender: UIButton = sender
        let tag = sender.tag
        if self.addServiceArray.contains(self.subCategories![tag].sub_category_id){
            self.addServiceArray.remove(self.subCategories![tag].sub_category_id)
        } else{
            self.addServiceArray.add(self.subCategories![tag].sub_category_id)
        }
        self.subCategoryTableView.reloadData()
//        if self.addServiceArray.contains(self.subCategories![btnSender.tag].sub_category_id as Any){
////            self.addServiceArray.remove(self.subCategories![btnSender.tag].sub_category_id as Any)
//        }
//        else{
////            self.addServiceArray.add(self.subCategories![btnSender.tag].sub_category_id as Any)
//        }
//        self.subCategoryTableView.reloadData()
//        print(addServiceArray)

    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategories!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatCell", for: indexPath) as! SubCatCell
        let category = self.subCategories![indexPath.row]
        let item_img = URL.init(string: category.sub_category_image!)
        cell.subCatImgView.sd_setImage(with: item_img, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        cell.nameLbl.text = category.sub_category_name
        if self.viewType == "addservice" || LocalDefault.shared.viewFrom() == "signup"{
            cell.checkBox.isHidden = false
            cell.checkBoxView.isHidden = false
            cell.checkBox.tag = indexPath.row
            cell.checkBox.addTarget(self, action: #selector(checkBoxBtnTapped(sender:)), for: .touchUpInside)
            if self.addServiceArray.contains(category.sub_category_id){
                cell.checkBoxView.setOn(true)
            } else{
                cell.checkBoxView.setOn(false)
            }
        } else{
            cell.checkBox.isHidden = true
            cell.checkBoxView.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCatCell", for: indexPath) as! SubCatCell
       let subCategory = self.subCategories![indexPath.row]
        //qwerty
//        let serviceObj = ServiceListPage()
//        serviceObj.parent_cat_id = self.parent_cat_id
//        serviceObj.parent_cat_name = self.parent_cat_name
//        serviceObj.parent_cat_type = self.parent_cat_type
//        serviceObj.sub_cat_id = subCategory.sub_category_id!
//        serviceObj.sub_cat_name = subCategory.sub_category_name!
//        serviceObj.location_type = self.location_type
//        self.navigationController?.pushViewController(serviceObj, animated: true)
        
        let dict = NSMutableDictionary()
            dict.setValue("", forKey: "service_id")
            dict.setValue("", forKey: "service_name")
            dict.setValue(subCategory.sub_category_id!, forKey: "sub_cat_id")
            dict.setValue(subCategory.sub_category_name!, forKey: "sub_cat_name")
            dict.setValue(self.parent_cat_id, forKey: "parent_cat_id")
            dict.setValue(self.parent_cat_name, forKey: "parent_cat_name")
            dict.setValue(self.location_type, forKey: "location_type")
            LocalDefault.shared.selectCat(data: dict)

        if self.viewType == "addservice"
        {
            if self.addServiceArray.contains(subCategory.sub_category_id!){
                self.addServiceArray.remove(subCategory.sub_category_id!)
            } else{
                self.addServiceArray.add(subCategory.sub_category_id!)
            }
            self.subCategoryTableView.reloadData()
        }
        // qwerty
        else if LocalDefault.shared.viewFrom() == "signup" {
            if self.addServiceArray.contains(subCategory.sub_category_id!){
                self.addServiceArray.remove(subCategory.sub_category_id!)
            } else{
                self.addServiceArray.add(subCategory.sub_category_id!)
            }
            self.subCategoryTableView.reloadData()
//            addServicesAPI()
        }
        else {
            if LocalDefault.shared.viewFrom() == "choose" {
                
            for controller in self.navigationController!.viewControllers as Array {

                if controller.isKind(of: PostNeeds.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            } else {
                let needObj = PostNeeds()
                needObj.parent_cat_id = self.parent_cat_id
                needObj.parent_cat_name = self.parent_cat_name
                needObj.parent_cat_type = self.parent_cat_type
                needObj.sub_cat_id = subCategory.sub_category_id!
                needObj.sub_cat_name = subCategory.sub_category_name!
                needObj.location_type = self.location_type
                self.navigationController?.pushViewController(needObj, animated: true)
            }
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {

            addServicesAPI()

    }
    //get formatted json from array
        func json(from object:Any) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        }
    
    //add services
    func addServicesAPI(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(parent_cat_id, forKey: "parent_category_id")
//            request.setValue(sub_cat_id, forKey: "subcategory_id")
            request.setValue("add", forKey: "type")
//            let tempDict = NSMutableDictionary()
//            tempDict.setValue(sub_cat_id, forKey: "subcategory_id")
//            let tempArray = NSMutableArray()
//            tempArray.add(tempDict)
            let tempArray = NSMutableArray()
            for i in self.addServiceArray{
                let tempDict = NSMutableDictionary()
                tempDict.setValue(i, forKey: "subcategory_id")
                tempArray.add(tempDict)
            }
            request.setValue(Utility.shared.json(from: tempArray), forKey: "subcategory_id")
//            request.setValue(Utility.shared.json(from: self.servicesArray), forKey: "services")
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




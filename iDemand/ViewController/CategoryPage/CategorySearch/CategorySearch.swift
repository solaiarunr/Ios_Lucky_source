//
//  CategorySearch.swift
//  iDemand
//
//  Created by Roby on 28/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class CategorySearch: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet var noItemView: UIView!
    @IBOutlet var noItemLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var serviceTableView: UITableView!
    @IBOutlet var searchTF: UITextField!
    
    var categoriesArray = NSMutableArray()
    var pageCount = 1
    var isFinished = false
    var isKeyboardEnable = false

    // qwerty
    var viewType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noItemView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noItemLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.clearButtonMode = .never
            self.searchTF.addPadding(left: false)
            self.searchTF.textAlignment = .right
        }else{
            self.searchTF.addPadding(left: true)
            
        }
        
    }
    //initial design works
    func initialSetup()  {
           //keyboard manager
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationView.backgroundColor = PRIMARY_COLOR
        serviceTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "search")
        self.noItemLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text:"service_not_found")
        self.searchTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "search_for_services")
        self.searchTF.radius(value: 10)
        self.searchTF.backgroundColor = SEARCH_BG_COLOR
        self.searchTF.becomeFirstResponder()
        self.pageCount = 1
        self.getCatgories(search: "")
        self.addPullDownRefresh()
        self.checkRTL()
    }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.serviceTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.pageCount = 1
            self.getCatgories(search: self.searchTF.text!)
        }
        
        
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.searchTF.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    //get categories list
    func getCatgories(search:String){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(search, forKey: "search_key")
            request.setValue(self.pageCount, forKey: "page")
            Obj.baseService(subURl: SEARCH_CATEGORIES_API, params: request as? Parameters, onSuccess: {response in
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(SearchModel.self, from: response.data!)
                    if model.status_code == 200{
                        if self.pageCount == 1 {
                            self.categoriesArray.removeAllObjects()
                            self.serviceTableView.reloadData()
                        }
                        self.pageCount += 1
                        if model.items?.count != 0{
                            self.categoriesArray.addObjects(from: model.items!)
                        }
                        self.checkAvailablity()
                    }else if model.status_code == 400{
                    }
                    self.isFinished = true
                    self.serviceTableView.fty.pullToRefresh.end()
                }catch{
                    self.isFinished = true
                }
            })
        }
    }
    //textfiled delecate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     /*   var newString = String()
        if string.isEmpty{
                newString = String(newString.dropLast())
            }else{
                newString = textField.text!+string
            }
        print(newString)
        serviceTableView.isHidden = true
        self.categoriesArray.removeAllObjects()
        self.serviceTableView.reloadData()
        // remove all data that belongs to previous search
        if newString.count > 2{
            if self.isFinished{
                self.isFinished = false
                self.pageCount = 1
                self.getCatgories(search: newString)
            }
        }else{
            self.noItemView.isHidden = true
        } */
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(" field \(textField.text)")
        // remove all data that belongs to previous search
        serviceTableView.isHidden = true
        self.categoriesArray.removeAllObjects()
        self.serviceTableView.reloadData()
        
        if textField.text!.count > 2 || textField.text == ""{
            if self.isFinished{
                self.isFinished = false
                self.pageCount = 1
                self.getCatgories(search: self.searchTF.text!)
            }else{
                self.noItemView.isHidden = true
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.categoriesArray.removeAllObjects()
        self.checkAvailablity()
        return true
    }
    func checkAvailablity() {
        if self.categoriesArray.count == 0 {
            self.serviceTableView.isHidden = true
            self.noItemView.isHidden = false
        }else{
            self.serviceTableView.isHidden = false
            self.noItemView.isHidden = true
            self.serviceTableView.delegate = self
            self.serviceTableView.dataSource = self
            self.serviceTableView.reloadData()
        }
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let model = categoriesArray.object(at: indexPath.row) as! search_items
        var type = String()
        var imgURL = String()
        var name = String()
        
        if model.type == "category" {
            type = Utility.shared.Json().value(forKey: "category") as! String
            imgURL = model.parent_category_image ?? ""
            name = model.parent_category_name ?? ""
        }else if model.type == "subcategory" {
            type = "\(model.parent_category_name ?? "")-\(model.subcategory_name ?? "")"
            imgURL = model.subcategory_image ?? ""
            name = model.subcategory_name ?? ""
        }else if model.type == "service" {
            type = "\(model.parent_category_name ?? "")-\(model.subcategory_name ?? "")-\(model.service_name ?? "")"
            imgURL = model.service_image ?? ""
            name = model.service_name ?? ""
        }
        
        let serviceimgURL = URL.init(string: imgURL)
        cell.categoryImgView.sd_setImage(with: serviceimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        
        cell.serviceNameLbl.text = name
        cell.typeLbl.text = type
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = categoriesArray.object(at: indexPath.row) as! search_items
        
        if model.type == "category" {
            let subCatObj = subCategoryPage()
            subCatObj.viewType = self.viewType
            subCatObj.parent_cat_id = model.parent_category_id!
            subCatObj.parent_cat_name = model.parent_category_name!
            subCatObj.parent_cat_type = model.parent_category_type!
            subCatObj.location_type = model.location_type!
            self.navigationController?.pushViewController(subCatObj, animated: true)
        }else if model.type == "subcategory" {
            // qwerty
//            let serviceObj = ServiceListPage()
//            serviceObj.parent_cat_id = model.parent_category_id!
//            serviceObj.parent_cat_name = model.parent_category_name!
//            serviceObj.parent_cat_type = model.parent_category_type!
//            serviceObj.sub_cat_id = model.subcategory_id!
//            serviceObj.sub_cat_name = model.subcategory_name!
//            serviceObj.location_type = model.location_type!
//            self.navigationController?.pushViewController(serviceObj, animated: true)
            if self.viewType == "addservice" {
                addServicesAPI(sub_cat_id : model.subcategory_id!, parent_cat_id : model.parent_category_id!)
            } else {
                let needObj = PostNeeds()
                needObj.parent_cat_id = model.parent_category_id!
                needObj.parent_cat_name = model.parent_category_name!
                needObj.parent_cat_type = model.parent_category_type!
                needObj.sub_cat_id = model.subcategory_id!
                needObj.sub_cat_name = model.subcategory_name!
                needObj.location_type = model.location_type!
                self.navigationController?.pushViewController(needObj, animated: true)
            }

            
        }else if model.type == "service" {
            let serviceObj = ServiceListPage()
            serviceObj.parent_cat_id = model.parent_category_id!
            serviceObj.parent_cat_name = model.parent_category_name!
            serviceObj.parent_cat_type = model.parent_category_type!
            serviceObj.sub_cat_id = model.subcategory_id!
            serviceObj.sub_cat_name = model.subcategory_name!
            serviceObj.location_type = model.location_type!
            self.navigationController?.pushViewController(serviceObj, animated: true)
        }
    }
    
    //add services
    func addServicesAPI(sub_cat_id : String, parent_cat_id : String ){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(parent_cat_id, forKey: "parent_category_id")
            request.setValue(sub_cat_id, forKey: "subcategory_id")
            request.setValue("add", forKey: "type")
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
    
    //MARK: Keyboard hide/show
    @objc func keyboardWillShow(sender: NSNotification) {
        if !isKeyboardEnable {
            isKeyboardEnable = true
            let info = sender.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                 
            self.serviceTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)

        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.serviceTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        isKeyboardEnable = false
    }
    //scroll view delegate
 
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{
            if maximumOffset - currentOffset <= 200 {
                if self.categoriesArray.count != 0{
                    if self.pageCount != 0{
                        self.getCatgories(search: self.searchTF.text!)
                    }else{
                        self.serviceTableView.fty.infiniteScroll.end()
                    }
                }
            }
        }
    }
}

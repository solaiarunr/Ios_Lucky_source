//
//  MyServices.swift
//  iDemand
//
//  Created by Roby on 07/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class MyServices: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var serviceTableView: UITableView!
    
    var services:[MyWorks]?
    var viewType = String()
    var parent_cat_id = String()
    var parent_cat_name = String()
    var parent_cat_type = String()
    var refreshRequest: (() -> Void)?
    var works:MyWorks?
    var isLast = false
    var tagId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.checkRTL()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl layout
      func checkRTL()  {
          if Utility.shared.isRTL(){
              self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
          }
      }
    //initial setup
    func initalSetup()  {
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        self.titleLbl.text = parent_cat_name
        serviceTableView.register(UINib(nibName: "MyServicesCell", bundle: nil), forCellReuseIdentifier: "MyServicesCell")
        self.startLoading()
        self.getServices()
        self.addPullDownRefresh()
    }
    
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.serviceTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getServices()
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //get my services list
    func getServices(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.parent_cat_id, forKey: "parent_category_id")
            
            Obj.baseService(subURl: MY_SERVICES_API, params: request as? Parameters, onSuccess: {response in
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(MyServicesModel.self, from: response.data!)
                    if model.status_code == 200{
                        self.serviceTableView.delegate = self
                        self.serviceTableView.dataSource = self
                        self.services = model.services!
                        self.serviceTableView.reloadData()
                        self.serviceTableView.fty.pullToRefresh.end()
                    }else if model.status_code == 400{
                    }
                    self.stopLoading()
                }catch{
                }
            })
        }
    }
    
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyServicesCell", for: indexPath) as! MyServicesCell
        let model = services![indexPath.row]
        print(services?.count as Any)
        //qwerty
//        let item_img = URL.init(string: model.service_image!)
        let item_img = URL.init(string: model.subcategory_image!)

        cell.serviceImgView.sd_setImage(with: item_img, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        self.tagId = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteBtn), for: .touchUpInside)
//        cell.serviceNameLbl.text = model.service_name
//        cell.subCategoryNameLbl.text = model.subcategory_name
//        let defaultDict = LocalDefault.shared.appDefaults()
//        if model.service_status == "0" {
//            cell.inActiveView.isHidden = false
//        }else{
//            cell.inActiveView.isHidden = true
//        }
//        cell.priceLbl.text = "\(defaultDict?.value(forKey: "currency_symbol") as! String) \(model.service_price!)/\(model.service_pricing!)"
//        cell.priceLbl.adjustsFontSizeToFitWidth = true
        cell.serviceNameLbl.text = model.subcategory_name
        cell.subCategoryNameLbl.isHidden = true
        cell.priceLbl.isHidden = true
        cell.inActiveView.isHidden = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //qwerty
//        let model = services![indexPath.row]
//        if model.service_status == "0" {
//            Utility.shared.showToast(msg: "service_disabled")
//        }else{
//            let detailObj = ServiceDetails()
//              if services?.count == 1{
//                  detailObj.isLast = true
//              }
//              detailObj.works = model
//              detailObj.parent_cat_id = self.parent_cat_id
//              detailObj.parent_cat_type = self.parent_cat_type
//              detailObj.refreshRequest = {
//                  self.getServices()
//              }
//              self.navigationController?.pushViewController(detailObj, animated: true)
//        }
        
    }
    @objc func deleteBtn()  {
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "delete"
        alertObj.deleteRequest = {
            self.deleteService()
        }
        self.navigationController?.present(alertObj, animated: false, completion: nil)
    }
    //get formatted json from array
        func json(from object:Any) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        }
    func deleteService(){
        if Utility.shared.isConnectedToNetwork(){
            
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(self.parent_cat_id, forKey: "parent_category_id")
//            let tempDist = NSMutableDictionary()
//            tempDist.setValue(services![tagId].subcategory_id, forKey: "subcategory_id")
//            let tempArray = NSMutableArray()
//            tempArray.add(tempDist)
//            request.setValue(self.json(from:tempArray), forKey: "subcategory_id")
//            request.setValue("delete", forKey: "type")
            request.setValue(services![tagId].subcategory_id, forKey: "subcategory_id")
//            request.setValue(services![tagId].service_id, forKey: "service_id")
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
}

//
//  HirePage.swift
//  iDemand
//
//  Created by Roby on 21/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class HirePage: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var hireTableView: UITableView!
    @IBOutlet var sortBtn: UIButton!
    @IBOutlet var noView: UIView!
    @IBOutlet var noLbl: UILabel!
    
    var bookingArray = NSMutableArray()
    var parent_cat_id = String()
    var sub_cat_id = String()
    var dateStr = String()
    var aboutTask = String()
    var location = String()
    var sortIndex = Int()
    var usersArray = NSMutableArray()
    var pageCount = 1
    
    var locationType = String()
    var sourceLat = Double()
    var sourceLon = Double()
    var dropLat = Double()
    var dropLon = Double()
    var sourceLocation = String()
    var dropLocation = String()

    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //config initial setup
    func initialSetup()  {
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "")
        let dict = self.bookingArray.object(at: 0) as! NSDictionary
        self.titleLbl.text = dict.value(forKey: "service_name") as? String
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "tasker_not_found")
        self.noView.isHidden = true
        hireTableView.register(UINib(nibName: "HireCell", bundle: nil), forCellReuseIdentifier: "HireCell")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let img = #imageLiteral(resourceName: "sort_icon").withRenderingMode(.alwaysTemplate)
        self.sortBtn.setImage(img, for: .normal)
        self.sortBtn.tintColor = .white
        self.addLoader()
        self.addPullDownRefresh()
        self.startLoading()
        self.getHireList()
        self.checkRTL()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    // back btn tapped
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //sorting
    @IBAction func sortBtnTapped(_ sender: Any) {
        let sortObj = SortPage()
        sortObj.modalPresentationStyle = .overCurrentContext
        sortObj.selectedIndex = { sort in
            self.sortIndex = sort
            self.usersArray.removeAllObjects()
            self.pageCount = 1
            self.getHireList()
        }
        sortObj.sort_index = self.sortIndex
        self.navigationController?.present(sortObj, animated: true, completion: nil)
    }
    
    //pull down and loadmore refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.hireTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.pageCount = 1
            self.getHireList()
        }
    }
    
    //get hire list
    func getHireList(){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        let dict = self.bookingArray.object(at: 0) as! NSDictionary
        request.setValue(dict.value(forKey: "service_id") as! String, forKey: "service_id")
        request.setValue(self.sortIndex, forKey: "sort")
        request.setValue(self.pageCount, forKey: "page")
        request.setValue(self.parent_cat_id, forKey: "parent_category_id")
        request.setValue(self.locationType, forKey: "location_type")
        if self.locationType == "transport"{
            request.setValue(self.sourceLocation, forKey: "source_location")
            request.setValue(self.dropLocation, forKey: "dest_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.dropLat, forKey: "dest_lat")
                request.setValue(self.dropLon, forKey: "dest_lon")
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }else if self.locationType == "home"{
            request.setValue(self.sourceLocation, forKey: "source_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }
       
        

        Obj.baseService(subURl: HIRE_TASKER_API, params: request as? Parameters, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(HireModel.self, from: response.data!)
                if model.status_code == 200{
                    if model.items!.count != 0 {
                        if self.pageCount == 1{
                            self.usersArray.removeAllObjects()
                        }
                        self.pageCount += 1
                        self.noView.isHidden = true
                        self.hireTableView.delegate = self
                        self.hireTableView.dataSource = self
                        self.usersArray.addObjects(from: model.items!)
                        self.hireTableView.reloadData()
                        
                    }else{
                        self.pageCount = 1
                        self.checkAvailability()
                    }
                }else{
                    self.pageCount = 1
                    self.checkAvailability()
                }
                self.hireTableView.fty.pullToRefresh.end()
                self.hireTableView.fty.infiniteScroll.end()
                self.stopLoading()
            }catch{
            }
        })
        
    }
    //check data available
    func checkAvailability()  {
        if self.usersArray.count == 0{
            self.noView.isHidden = false
        }else{
            self.noView.isHidden = true
        }
    }
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HireCell", for: indexPath) as! HireCell
        let model = self.usersArray.object(at: indexPath.row) as! Technicians
        cell.config(model: model)
        cell.profileBtn.tag = indexPath.row
        cell.hireBtn.tag = indexPath.row
        cell.profileBtn.addTarget(self, action: #selector(self.profileBtnTapped(_:)), for: .touchUpInside)
        cell.hireBtn.addTarget(self, action: #selector(self.hireBtnTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    //view profile
    @objc func profileBtnTapped(_ sender: UIButton){
        let model = self.usersArray.object(at: sender.tag) as! Technicians
        let profileObj = TaskerDetails()
        profileObj.user = model
        profileObj.viewType = "hire"
        profileObj.tasker_id = model.user_id!
        profileObj.hireTasker = {
            self.bookTasker(model: model)
        }
        self.navigationController?.pushViewController(profileObj, animated: true)
    }
    //hire tasker
    @objc func hireBtnTapped(_ sender: UIButton){
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "hire_confirm"
        alertObj.deleteRequest = {
            let model = self.usersArray.object(at: sender.tag) as! Technicians
             self.bookTasker(model: model)
        }
        self.present(alertObj, animated: false, completion: nil)
 
    }
    func bookTasker(model:Technicians)  {
        self.startLoading()
        let dict = self.bookingArray.object(at: 0) as! NSDictionary
        let quantity = Double("\(dict.value(forKey: "service_quantity") as! String)") ?? .nan
        let appDefault = LocalDefault.shared.appDefaults()
        let commissionPercent = Double(appDefault?.value(forKey: "site_commission") as! String)
        let taxPercent = Double(appDefault?.value(forKey: "site_tax") as! String)
        let price = Double("\(model.price!)") ?? .nan
        let bookingAmt =  price * quantity        
        let taxAmt = self.get(value: bookingAmt, percent: taxPercent!)
        let commissionAmt = self.get(value: Double(bookingAmt), percent: commissionPercent!)
        let totalAmt = Double(bookingAmt) + taxAmt + commissionAmt
        
        let bookingDict = NSMutableDictionary.init(dictionary:dict)
        bookingDict.setValue(model.price, forKey: "service_price")
        bookingDict.setValue(Double(bookingAmt), forKey: "service_total_price")
        
        let newArray = NSMutableArray()
        newArray.add(bookingDict)
        
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(parent_cat_id, forKey: "parent_category_id")
        request.setValue(sub_cat_id, forKey: "subcategory_id")
        request.setValue(model.user_id, forKey: "tasker_id")
        request.setValue(self.dateStr, forKey: "date")
        request.setValue(bookingAmt, forKey: "total")
        request.setValue(String(format: "%.2f", totalAmt), forKey: "price")
        request.setValue(self.aboutTask, forKey: "description")
        request.setValue(Utility.shared.json(from: newArray), forKey: "services")
        
        if self.locationType == "transport"{
            request.setValue(self.sourceLocation, forKey: "source_location")
            request.setValue(self.dropLocation, forKey: "dest_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.dropLat, forKey: "dest_lat")
                request.setValue(self.dropLon, forKey: "dest_lon")
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }else if self.locationType == "home"{
            request.setValue(self.sourceLocation, forKey: "source_location")
            if LocalDefault.shared.isLiveTrack()!{
                request.setValue(self.sourceLat, forKey: "source_lat")
                request.setValue(self.sourceLon, forKey: "source_lon")
            }
        }
        
        Obj.baseService(subURl: BOOK_SERVICE_API, params: request as? Parameters, onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            if status_code == 200{
                let availability = dict.value(forKey: "availability") as! String
                if availability == "true"{
                    
                    let chat_id = dict.value(forKey: "chat_id") as! String
                    self.initiateServiceChat(chat_id: chat_id, tasker_id: model.user_id!, price: String(bookingAmt))
                    let booking_id = dict.value(forKey: "booking_id") as! String
                    let bookingObj = BookingDetails()
                    bookingObj.viewType = "booking"
                    bookingObj.bookingID = booking_id
                    bookingObj.refreshRequest = {
                        
                    }
                    self.navigationController?.pushViewController(bookingObj, animated: true)
                }
            }
            self.stopLoading()
        })
    }
    //initiate first msg
    func initiateServiceChat(chat_id:String,tasker_id:String,price:String)  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            //send msg
            let requestDict = NSMutableDictionary()
            requestDict.setValue("bookingchat", forKey: "type")
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            requestDict.setValue(profile.name, forKey: "user_name")
            requestDict.setValue(profile.user_image, forKey: "user_image")
            requestDict.setValue(tasker_id, forKey: "receiver_id")
            requestDict.setValue(chat_id, forKey: "chat_id")
            requestDict.setValue(Utility.shared.UTC(), forKey: "date")
            requestDict.setValue(Utility.shared.messageID(), forKey: "message_id")
            requestDict.setValue("request", forKey: "message_type")
            let msgDict = NSMutableDictionary()
            msgDict.setValue(Utility.shared.Json().value(forKey: "service_request"), forKey: "message")
            msgDict.setValue("request", forKey: "type")
            msgDict.setValue(price, forKey: "quote_price")
            msgDict.setValue("true", forKey: "isActive")
            requestDict.setValue(msgDict, forKey: "message")
            SocketClass.sharedInstance.send(msg: requestDict)
        }catch{
        }
        
    }
    
    //calculate percent
    public func get(value:Double,percent:Double)->Double{
        let val = value * percent
        return val / 100.00
    }
    //scroll view delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{
        if maximumOffset - currentOffset <= 200 {
            if self.usersArray.count != 0{
                if self.pageCount != 1{
                    self.getHireList()
                }
            }
        }
        }
    }
    
}

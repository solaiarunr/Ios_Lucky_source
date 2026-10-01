//
//  NotificationPage.swift
//  iDemand
//
//  Created by Roby on 29/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class NotificationPage: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet var notificationTableView: UITableView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    
    var notificationArray = NSMutableArray()
    
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
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    //initial set up
    func initialSetup()  {
        self.addLoader()
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "notifications")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.addLoader()
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_notification")
        notificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        self.notificationTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.addPullDownRefresh()
        self.noView.isHidden = true
        self.startLoading()
        self.getNotifications(offset: "0")
        self.checkRTL()
    }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.notificationTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getNotifications(offset: "0")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //get notifications
    func getNotifications(offset:String)  {
        let Obj = BaseAPI()
        var subURL = String()
        if LocalDefault.shared.isUser()!{
            subURL = "\(USER_NOTIFICATIONS_API)/\(LocalDefault.shared.userID() ?? "")/\(offset)/20"
        }else{
            subURL = "\(TASKER_NOTIFICATIONS_API)/\(LocalDefault.shared.userID() ?? "")/\(offset)/20"
        }
        Obj.getDetails(subURl: subURL, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(NotificationModal.self, from: response.data!)
                if model.status_code == 200{
                    if offset == "0"{
                        self.notificationArray.removeAllObjects()
                    }
                    if model.items!.count != 0 {
                        self.noView.isHidden = true
                        self.notificationTableView.delegate = self
                        self.notificationTableView.dataSource = self
                        self.notificationArray.addObjects(from: model.items!)
                        self.notificationTableView.reloadData()
                    }else{
                        self.checkAvailability()
                    }
                }else{
                    self.checkAvailability()
                }
                self.notificationTableView.fty.pullToRefresh.end()
                self.notificationTableView.fty.infiniteScroll.end()
                self.stopLoading()
            }catch{
            }
        })
        
    }
    
    //check data available
    func checkAvailability()  {
        if self.notificationArray.count == 0{
            self.noView.isHidden = false
        }else{
            self.noView.isHidden = true
        }
    }
    
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let model = self.notificationArray.object(at: indexPath.row) as! Notify
        cell.notificationImgView.sd_setImage(with:URL.init(string: model.user_image!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        cell.nameLbl.text = model.name
        let referID = "\(Utility.shared.Json().value(forKey: "id") ?? "") : #\(model.reference_id!)"
        cell.referenceIDLbl.text = referID.uppercased()
        cell.bookingDateLbl.text = model.service_names?.joined(separator: ",")
        if model.item_type == "Tasker Approval" || model.item_type == "Settlement Amount"{
            cell.nameLbl.text = "\(APP_NAME) \(Utility.shared.Json().value(forKey: "team") ?? "")"
            cell.dateLbl.isHidden = true
            cell.notificationImgView.sd_setImage(with:URL.init(string: model.user_image!), placeholderImage: #imageLiteral(resourceName: "app_icon"))
            cell.bookingDateLbl.isHidden = true
            cell.referenceIDLbl.isHidden = true
        }
        else{
            cell.dateLbl.isHidden = false
            cell.bookingDateLbl.isHidden = false
            cell.referenceIDLbl.isHidden = false
            cell.dateLbl.text = Utility.shared.toLocal(dateStr: model.date!, format: "dd.MMM.yyyy")
        }
        cell.msgLbl.text = model.description
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.notificationArray.object(at: indexPath.row) as! Notify
        if model.item_type == "review"{
            let reviewObj = ReviewsList()
            reviewObj.viewType = "tasker"
            reviewObj.reviwer_id = LocalDefault.shared.userID()!
            self.navigationController?.pushViewController(reviewObj, animated: true)
        }else if model.item_type == "Tasker Approval" || model.item_type == "Settlement Amount" {}
        else{
            if LocalDefault.shared.isUser()!{
                let detailObj = BookingDetails()
                detailObj.bookingID = model.item_id!
                detailObj.refreshRequest = {
                }
                let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navigationController!.pushViewController(detailObj, animated: true)
            }else{
                let detailObj = TaskerBookingDetails()
                detailObj.bookingID = model.item_id!
                detailObj.refreshRequest = {
                }
                let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navigationController!.pushViewController(detailObj, animated: true)
            }
        }
        
    }
    
    //scroll view delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{
            if maximumOffset - currentOffset <= 200 {
                self.getNotifications(offset: "\(String(describing: self.notificationArray.count))")
            }
        }
    }
}




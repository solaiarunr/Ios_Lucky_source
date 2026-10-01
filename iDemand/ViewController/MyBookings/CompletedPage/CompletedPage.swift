//
//  CompletedPage.swift
//  iDemand
//
//  Created by Roby on 15/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class CompletedPage: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet var completedTableView: UITableView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var loader: UIActivityIndicatorView!
    var bookingArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    //initial set up
    func initialSetup()  {
        self.loader.color = PRIMARY_COLOR
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_completed_yet")
        completedTableView.register(UINib(nibName: "AcceptCell", bundle: nil), forCellReuseIdentifier: "AcceptCell")
        completedTableView.reloadData()
        self.completedTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.addPullDownRefresh()
        self.loader.startAnimating()
        self.noView.isHidden = true
        self.getCompletedTask(offset: "0")

    }
    override func viewWillAppear(_ animated: Bool) {
        self.checkRTL()
        self.updateTheme()
    }
    //check rtl layout
       func checkRTL()  {
           if Utility.shared.isRTL(){
               noView.transform = CGAffineTransform(scaleX: -1, y: 1)
               self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
           }
       }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.completedTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getCompletedTask(offset: "0")
        }
    }

    //get ongoing task
    func getCompletedTask(offset:String)  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue("20", forKey: "limit")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue("completed", forKey: "type")
        var subURL = String()
        if LocalDefault().isUser()!{
            subURL = USER_BOOKING_LIST_API
        }else{
            subURL = TASKER_BOOKING_LIST_API
        }
        Obj.baseService(subURl: subURL, params: requestDict as? Parameters, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(bookingModel.self, from: response.data!)
                if model.status_code == 200{
                    if model.items!.count != 0 {
                        if offset == "0"{
                            self.bookingArray.removeAllObjects()
                        }
                        self.noView.isHidden = true
                        self.completedTableView.delegate = self
                        self.completedTableView.dataSource = self
                        self.bookingArray.addObjects(from: model.items!)
                        self.completedTableView.reloadData()
                        
                    }else{
                        self.checkAvailability()
                    }
                }else{
                    self.checkAvailability()
                }
                self.completedTableView.fty.pullToRefresh.end()
                self.completedTableView.fty.infiniteScroll.end()
                self.loader.stopAnimating()
            }catch{
            }
        })
    }
    //check data available
    func checkAvailability()  {
        if self.bookingArray.count == 0{
            self.noView.isHidden = false
        }else{
            self.noView.isHidden = true
        }
    }
    
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptCell", for: indexPath) as! AcceptCell
        let model = self.bookingArray.object(at: indexPath.row) as! bookingItems
        cell.config(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.bookingArray.object(at: indexPath.row) as! bookingItems
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
    //scroll view delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{

        if maximumOffset - currentOffset <= 200 {
            self.getCompletedTask(offset: "\(String(describing: self.bookingArray.count))")
        }
        }
    }
}

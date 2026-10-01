//
//  MyNeeds.swift
//  iDemand
//
//  Created by Roby on 23/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class MyNeeds: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet var needsTableView: UITableView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var floatingView: MDCCard!

    var needsArray = NSMutableArray()
    var isInfiniteEnd = false
    var viewFrom = String()
    
    //qwerty
    var items = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getNeeds(offset: "0")
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        if !UIDevice.current.hasNotch{
                self.floatingView.frame.origin.y = FULL_HEIGHT - 85
            }
    }
    
    //initial set up
    func initialSetup()  {
        self.addLoader()
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_needs")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.addLoader()
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_needs_yet")
        needsTableView.register(UINib(nibName: "AcceptCell", bundle: nil), forCellReuseIdentifier: "AcceptCell")
        needsTableView.reloadData()
        self.needsTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.addPullDownRefresh()
        self.noView.isHidden = true
        self.startLoading()
        self.floatingView.backgroundColor = PRIMARY_COLOR
              self.floatingView.elevation(radius: 30)
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.needsTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.isInfiniteEnd = false
            self.getNeeds(offset: "0")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if viewFrom == "home"{
            if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                myDelegate.setInitialViewController()
            }
//            UIApplication.shared.keyWindow?.rootViewController?.navigationController?.popToRootViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //get my needs
    func getNeeds(offset:String)  {
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        requestDict.setValue("20", forKey: "limit")
        requestDict.setValue(offset, forKey: "offset")
        Obj.baseService(subURl: MY_NEEDS_API, params: requestDict as? Parameters, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(NeedModal.self, from: response.data!)
                if offset == "0"{
                    self.needsArray.removeAllObjects()
                }
                if model.status_code == 200{
                    if model.items!.count != 0 {
                        self.noView.isHidden = true
                        self.needsTableView.delegate = self
                        self.needsTableView.dataSource = self
                        self.needsArray.addObjects(from: model.items!)
                        self.needsTableView.reloadData()
                        
                        let resDict = response.value as! NSDictionary
                        self.items = resDict.value(forKey: "items") as! [NSDictionary]
                    }else{
                        self.checkAvailability()
                    }
                }else if model.status_code == 400{
                    self.isInfiniteEnd = true
                    self.needsTableView.reloadData()
                    self.checkAvailability()
                    
                }
                self.needsTableView.fty.pullToRefresh.end()
                self.needsTableView.fty.infiniteScroll.end()
                
                self.stopLoading()
            }catch{
            }
        })
    }
    //check data available
    func checkAvailability()  {
        if self.needsArray.count == 0{
            self.noView.isHidden = false
        }else{
            self.noView.isHidden = true
        }
    }
    
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.needsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptCell", for: indexPath) as! AcceptCell
        let model = self.needsArray.object(at: indexPath.row) as! Needs
        cell.config(need: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalDefault.shared.removeCategory()
        let model = self.needsArray.object(at: indexPath.row) as! Needs
        let detailObj = PostNeeds()
        detailObj.need = model
        detailObj.viewType = "edit"
        
        if model.due_status == "true"{
            let subcat = model.subcategory_name
            for item in self.items {
            if (item.value(forKey: "subcategory_name") as! String == subcat) && (item.value(forKey: "due_status") as! String == "false") {
                
                detailObj.already_active = "true"
                
                break
                }
            }
        }
        
        detailObj.refreshRequest = {
            self.getNeeds(offset: "0")
        }

        self.navigationController!.pushViewController(detailObj, animated: true)
    }
    
    //scroll view delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{

        if maximumOffset - currentOffset <= 200 {
            if !self.isInfiniteEnd{
                self.getNeeds(offset: "\(String(describing: self.needsArray.count))")
            }
        }
        }
    }
    
    @IBAction func addNeedBtnTapped(_ sender: Any) {
        LocalDefault.shared.removeCategory()

        let needObj = PostNeeds()
        needObj.refreshRequest = {
            self.getNeeds(offset: "0")
        }

        self.navigationController?.pushViewController(needObj, animated: true)
    }
    
}

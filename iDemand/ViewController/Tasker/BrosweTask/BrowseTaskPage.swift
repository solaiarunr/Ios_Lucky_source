//
//  BrowseTaskPage.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BrowseTaskPage: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate,UIScrollViewDelegate,GADBannerViewDelegate{
    
    @IBOutlet var browseTableView: UITableView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var bannerView: GADBannerView!
    
    var needsArray = NSMutableArray()
    var isFinished = false
    var searchText = String()
    
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
        let height = (tabBarController?.tabBar.frame.size.height)!+40
        bannerView.frame.origin.y = FULL_HEIGHT - height
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTasks(offset: "0")
        self.updateTheme()
        
    }
    
    //initial set up
    func initialSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.loader.color = PRIMARY_COLOR
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_needs_available")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "user_needs")
        browseTableView.register(UINib(nibName: "BrowseCell", bundle: nil), forCellReuseIdentifier: "BrowseCell")
        browseTableView.reloadData()
        self.browseTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        self.searchTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "search_for_jobs")
        self.searchTF.radius(value: 10)
        self.searchTF.backgroundColor = SEARCH_BG_COLOR
        self.addPullDownRefresh()
        self.loader.startAnimating()
        self.noView.isHidden = true
        self.checkRTL()
        self.configBanner()
        
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.clearButtonMode = .never
            self.searchTF.textAlignment = .right
            self.searchTF.addPadding(left: false)
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        }else{
            self.searchTF.addPadding(left: true)
        }
        
    }
    
    // config banner
    func configBanner()  {
        if ADD_ON {
            //            self.browseTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
            bannerView.adUnitID = BANNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }else{
            bannerView.isHidden = true
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    }
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.browseTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getTasks(offset: "0")
        }
    }
    
    //browse needs
    func getTasks(offset:String)  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            
            let Obj = BaseAPI()
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            requestDict.setValue("20", forKey: "limit")
            requestDict.setValue(offset, forKey: "offset")
            requestDict.setValue(self.searchTF.text, forKey: "search_key")
            requestDict.setValue(profile.location, forKey: "source_location")
            requestDict.setValue(profile.lat, forKey: "source_lat")
            requestDict.setValue(profile.lon, forKey: "source_lon")
            
            Obj.baseService(subURl: TASKER_BROWSE_NEEDS_API, params: requestDict as? Parameters, onSuccess: {response in
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(BrowseModal.self, from: response.data!)
                    if offset == "0"{
                        self.needsArray.removeAllObjects()
                        self.browseTableView.reloadData()
                    }
                    if model.status_code == 200{
                        if model.items != nil {
                            if model.items!.count != 0 {
                                self.noView.isHidden = true
                                self.browseTableView.delegate = self
                                self.browseTableView.dataSource = self
                                self.needsArray.addObjects(from: model.items!)
                                self.browseTableView.reloadData()
                            }else{
                                self.checkAvailability()
                            }
                        }
                        else {
                            self.browseTableView.reloadData()
                            self.checkAvailability()
                        }
                    }else{
                        self.browseTableView.reloadData()
                        self.checkAvailability()
                    }
                    self.browseTableView.fty.pullToRefresh.end()
                    self.browseTableView.fty.infiniteScroll.end()
                    self.loader.stopAnimating()
                }catch{
                }
                self.isFinished = true
            })
        }catch{
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseCell", for: indexPath) as! BrowseCell
        let model = self.needsArray.object(at: indexPath.row) as! Jobs
        cell.itemImgView.sd_setImage(with: URL.init(string: model.service_image!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        cell.titleLbl.text = model.name
        cell.catLbl.text = "\(model.parent_category_name!) - \(model.subcategory_name!)"
        cell.timeLbl.text = Utility.shared.toLocal(dateStr: model.date!, format: "dd.MM.yyyy")
        cell.locationLbl.text = model.location
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        cell.priceLbl.text = "\(currency_code) \(model.booking_price!)"
        cell.priceLbl.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.needsArray.object(at: indexPath.row) as! Jobs
        let detailObj = TaskerBookingDetails()
        detailObj.bookingID = model.item_id!
        detailObj.viewType = "need"
        detailObj.viewFrom = "browse"
        detailObj.titleStr = model.name!
        detailObj.refreshRequest = {
        }
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        navigationController!.pushViewController(detailObj, animated: true)
        
    }
    
    //textfiled delecate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        if string.isEmpty{
        //            searchText = String(searchText.dropLast())
        //        }else{
        //            searchText = textField.text!+string
        //        }
        //        self.needsArray.removeAllObjects()
        //        self.browseTableView.reloadData()
        //        print("search text \(searchText)")
        //        // remove all data that belongs to previous search
        //        if searchText.count > 2 || string == "" || string == " "{
        //            if self.isFinished{
        //                self.isFinished = false
        //                self.needsArray.removeAllObjects()
        //                self.getTasks(offset: "0")
        //            }else{
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        //                    self.isFinished = false
        //                    self.needsArray.removeAllObjects()
        //                    self.getTasks(offset: "0")
        //                }
        //            }
        //        }else{
        //            self.noView.isHidden = true
        //        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(" field \(textField.text)")
        // remove all data that belongs to previous search
        if textField.text!.count > 2 || textField.text == ""{
            if self.isFinished{
                self.isFinished = false
                self.needsArray.removeAllObjects()
                self.browseTableView.reloadData()
                self.getTasks(offset: "0")
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.isFinished = false
                    self.needsArray.removeAllObjects()
                    self.getTasks(offset: "0")
                }
            }
        }else{
            self.noView.isHidden = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchText = ""
        textField.text = ""
        self.needsArray.removeAllObjects()
        self.getTasks(offset: "0")
        return true
    }
    
    //scroll view delegate
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{
            if maximumOffset - currentOffset <= 200 {
                self.getTasks(offset: "\(String(describing: self.needsArray.count))")
            }
        }
    }
}


//
//  TaskerDetails.swift
//  iDemand
//
//  Created by Roby on 21/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class TaskerDetails: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var taskImgLbl: UILabel!
    @IBOutlet var imgScrollView: UIScrollView!
    @IBOutlet var reviewLbl: UILabel!
    @IBOutlet var viewAllBtn: UIButton!
    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ratingCountLbl: UILabel!
    @IBOutlet var aboutLbl: UILabel!
    @IBOutlet var completedJobsLbl: UILabel!
    @IBOutlet var desLbl: UILabel!
    @IBOutlet var hireBtn: UIButton!
    @IBOutlet var reviewView: UIView!
    //modified-AR
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet var phoneBtn: UIButton!
    //modifed-AR
    var pageFrom = ""
    var tasker_serviece = String()
    var subcat = String()
    var tasker_id = String()
    var userDict = NSDictionary()
    var priceStr = String()
    var reviewsArray = NSMutableArray()
    var taskImages = NSMutableArray()
    var user:Technicians?
    var hireTasker: (() -> Void)?
    var gettaskandjobs:(() -> Void)?
    var viewType = String()
    var subcatId = String()
    var isHire = false
    var hirebtntapped = false
    
    //qwerty
    var needsArray = NSMutableArray()
    var userNeed = NSDictionary()
    var currency_code = String()
    var bookingDict = NSDictionary()
    var chatDict = NSDictionary()
    var chatID = String()
    //modified-AR
    var quoteDes = String()
    var bookingId = String()
    
    var datePicker :UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
        //qwerty
//        getNeeds()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.hireBtn.topRadius()
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.bottomView.frame.origin.y+self.bottomView.frame.size.height)
        
        
    }
    //check rtl layout
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taskImgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.reviewLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.viewAllBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingCountLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.aboutLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.completedJobsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.hireBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.phoneBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
            self.reviewLbl.textAlignment = .right
            self.ratingCountLbl.textAlignment = .right
            self.aboutLbl.textAlignment = .right
            self.completedJobsLbl.textAlignment = .right
            self.desLbl.textAlignment = .right
            self.desLbl.frame.origin.x = 20
            self.phoneBtn.contentHorizontalAlignment = .right
            self.taskImgLbl.textAlignment = .right
            self.viewAllBtn.contentHorizontalAlignment = .left
            
        }
    }
    // initial design set up
    func initialSetup() {
        //modified-AR
        //change languagejson file
        self.activityLoader.color = PRIMARY_COLOR
        self.activityLoader.hidesWhenStopped = true
        self.activityLoader.startAnimating()
        self.phoneBtn.isHidden = true
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "profile")
        self.taskImgLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "task_images")
        self.reviewLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "review_rating")
        self.aboutLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "about")
        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.phoneBtn.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, title: "")
        self.ratingCountLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.completedJobsLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        reviewTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.reviewTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0 )
        self.viewAllBtn.config(color:PRIMARY_COLOR!, font: smallReg, align: .right, title: "view_all")
        self.userImgView.radius(value: 5.0)
        self.userImgView.backgroundColor = LINE_COLOR
        self.hireBtn.backgroundColor = PRIMARY_COLOR
        self.hireBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "request")
        self.reviewView.isHidden = true
        
        self.getProfile()
    }
    //set values
    func setDetails()  {
        let ratingTxt = "★ \(self.userDict.value(forKey: "rating") as! String) (\(self.userDict.value(forKey: "reviews") as! String) \(Utility.shared.Json().value(forKey: "reviews") as! String))"
        
        let actTxt = "★ \(self.userDict.value(forKey: "rating") as! String)"
        let attributedStr = NSMutableAttributedString(string: ratingTxt)
        let termsRange = (ratingTxt as NSString).range(of: actTxt)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: RATING_GREEN!, range: termsRange)
        self.ratingCountLbl.attributedText = attributedStr
        let userimgURL = URL.init(string: self.userDict.value(forKey: "user_image") as! String)
        self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        self.nameLbl.text = self.userDict.value(forKey: "name") as? String
        self.phoneBtn.setTitle(self.userDict.value(forKey: "mobile") as? String, for: .normal)
        self.completedJobsLbl.text = "\(self.userDict.value(forKey: "completed_jobs") as! String) \(Utility.shared.Json().value(forKey: "jobs") ?? "")"
        if viewType != "hire"{
            self.hireBtn.isHidden = true
        }
        self.desLbl.text = self.userDict.value(forKey: "about") as? String
        self.desLbl.numberOfLines = 0
        self.desLbl.sizeToFit()
        
        self.bottomView.frame.origin.y = self.desLbl.frame.origin.y + self.desLbl.frame.size.height + 15
        self.taskImages.removeAllObjects()
        self.taskImages.addObjects(from: self.userDict.value(forKey: "portfolio") as! [Any])
        if taskImages.count == 0{
            self.imgScrollView.isHidden = true
            self.taskImgLbl.isHidden = true
        }else{
            self.imgScrollView.isHidden = false
            self.taskImgLbl.isHidden = false
        }
        
        self.reviewsArray.removeAllObjects()
        self.reviewsArray.addObjects(from: self.userDict.value(forKey: "recent_reviews") as! [Any])
        if reviewsArray.count == 0{
            self.reviewView.isHidden = true
        }else{
            if taskImages.count == 0{
                self.reviewView.frame.origin.y = 0
            }
            self.reviewView.isHidden = false
        }
        
        var leftPadding = 20
        let item_width = (FULL_WIDTH/3)+20
        var index = 0
        for dict in self.taskImages{
            let imageDict = dict as! NSDictionary
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: leftPadding, y: 0, width: Int(item_width), height: 110)
            let taskimgURL = URL.init(string: imageDict.value(forKey: "item_url") as! String)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.radius(value: 5.0)
            if(taskimgURL?.pathExtension == "pdf")
            {
                imgView.image = #imageLiteral(resourceName:"pdf_icon")
                imgView.contentMode = .scaleAspectFit
            }
            else if(taskimgURL?.pathExtension == "doc")
            {
                imgView.image = #imageLiteral(resourceName:"document_icon")
                imgView.contentMode = .scaleAspectFit
            }
            else if(taskimgURL?.pathExtension == "docx")
            {
                imgView.image = #imageLiteral(resourceName:"document_icon")
                imgView.contentMode = .scaleAspectFit
            }
            
            else if (taskimgURL?.pathExtension == "jpg" || taskimgURL?.pathExtension == "png" || taskimgURL?.pathExtension == "jpeg"){
                imgView.sd_setImage(with:taskimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }
            //imgView.sd_setImage(with: taskimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            self.imgScrollView.addSubview(imgView)
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 0, width: Int(item_width), height: 110)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.imageBtnTapped(_:)), for: .touchUpInside)
            if Utility.shared.isRTL(){
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            self.imgScrollView.addSubview(imageBtn)
            leftPadding += Int(item_width+20)
            index += 1
            self.imgScrollView.contentSize = CGSize.init(width:leftPadding , height: 100)
        }
        self.reviewTableView.reloadData()
        self.checkRTL()
    }
    
    func setValueforTaskerDetail(){
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
        self.nameLbl.text = self.userDict.value(forKey: "name") as? String
        
        self.ratingCountLbl.config(color: .blue, font: subReg, align: .left, text: "")
        self.ratingCountLbl.text = tasker_serviece
        let userimgURL = URL.init(string: self.userDict.value(forKey: "user_image") as! String)
        self.userImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        
        //        self.phoneBtn.setTitle(self.userDict.value(forKey: "mobile") as? String, for: .normal)
        self.completedJobsLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.completedJobsLbl.frame.origin.y += 2
        self.completedJobsLbl.text = (self.userDict.value(forKey: "location") as! String)//"\(self.userDict.value(forKey: "completed_jobs") as! String) \(Utility.shared.Json().value(forKey: "jobs") ?? "")"
        
        self.desLbl.text = self.userDict.value(forKey: "about") as? String
        self.desLbl.numberOfLines = 2
        self.desLbl.sizeToFit()
        
        self.bottomView.frame.origin.y = self.desLbl.frame.origin.y + self.desLbl.frame.size.height + 15
        self.taskImages.removeAllObjects()
        self.taskImages.addObjects(from: self.userDict.value(forKey: "portfolio") as! [Any])
        if taskImages.count == 0{
            self.imgScrollView.isHidden = true
            self.taskImgLbl.isHidden = true
        }else{
            self.imgScrollView.isHidden = false
            self.taskImgLbl.isHidden = false
        }
        
        self.reviewsArray.removeAllObjects()
        self.reviewsArray.addObjects(from: self.userDict.value(forKey: "recent_reviews") as! [Any])
        if reviewsArray.count == 0{
            self.reviewView.isHidden = true
        }else{
            if taskImages.count == 0{
                self.reviewView.frame.origin.y = 0
            }
            self.reviewView.isHidden = false
        }
        
        var leftPadding = 20
        let item_width = (FULL_WIDTH/3)+20
        var index = 0
        for dict in self.taskImages{
            let imageDict = dict as! NSDictionary
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: leftPadding, y: 0, width: Int(item_width), height: 110)
            let taskimgURL = URL.init(string: imageDict.value(forKey: "item_url") as! String)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.radius(value: 5.0)
            if(taskimgURL?.pathExtension == "pdf")
            {
                imgView.image = #imageLiteral(resourceName:"pdf_icon")
                imgView.contentMode = .scaleAspectFit
            }
            else if(taskimgURL?.pathExtension == "doc")
            {
                imgView.image = #imageLiteral(resourceName:"document_icon")
                imgView.contentMode = .scaleAspectFit
            }
            else if(taskimgURL?.pathExtension == "docx")
            {
                imgView.image = #imageLiteral(resourceName:"document_icon")
                imgView.contentMode = .scaleAspectFit
            }
            
            else {
                imgView.sd_setImage(with: taskimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }
            self.imgScrollView.addSubview(imgView)
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 0, width: Int(item_width), height: 110)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.imageBtnTapped(_:)), for: .touchUpInside)
            if Utility.shared.isRTL(){
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            self.imgScrollView.addSubview(imageBtn)
            leftPadding += Int(item_width+20)
            index += 1
            self.imgScrollView.contentSize = CGSize.init(width:leftPadding , height: 100)
        }
        self.reviewTableView.reloadData()
        self.checkRTL()
        self.activityLoader.stopAnimating()
        
    }
    
    @IBAction func phoneBtnTapped(_ sender: Any) {
        let phoneNo = self.phoneBtn.titleLabel?.text
        if let url = URL(string: "tel://\(phoneNo!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    //image btn tapped
    @objc func imageBtnTapped(_ sender: UIButton){
        let dict = self.taskImages.object(at: sender.tag) as! NSDictionary
        let taskimgURL = URL.init(string: dict.value(forKey: "item_url") as! String)
        if(taskimgURL?.pathExtension == "pdf" || taskimgURL?.pathExtension == "doc" || taskimgURL?.pathExtension == "docx" || taskimgURL?.pathExtension == "xlsx")
        {
            let docView = documentViewController()
            docView.selectedDict = dict
            self.navigationController?.present(docView, animated: true, completion: nil)
        }
        else
        {
        let imgView = ImageViewer()
        imgView.modalPresentationStyle = .fullScreen
        imgView.viewType = "portfolio"
        imgView.selectedDict = dict
        imgView.selectedIndex = sender.tag
        imgView.imageListArray = self.taskImages
        self.navigationController?.present(imgView, animated: true, completion: nil)
        }
    }
    //get profile details
    func getProfile()  {
        self.scrollView.isHidden = true
        self.startLoading()
        let Obj = BaseAPI()
        Obj.getDetails(subURl: "\(VIEW_TASKER_API)/\(self.tasker_id)", onSuccess: {response in
            self.userDict = response.value as! NSDictionary
            let status_code = self.userDict.value(forKey: "status_code") as! Int
            if status_code == 200{
                if self.pageFrom == "mapPage"{
                    self.pageFrom = ""
                    self.setValueforTaskerDetail()
                }
                else{
                    self.setDetails()
                }
                self.scrollView.isHidden = false
                
            }
            self.stopLoading()
        })
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.gettaskandjobs?()
    }
    
    @IBAction func viewAllBtnTapped(_ sender: Any) {
        let reviewObj = ReviewsList()
        reviewObj.viewType = "tasker"
        reviewObj.reviwer_id = self.tasker_id
        self.navigationController?.pushViewController(reviewObj, animated: true)
    }
    @IBAction func hireBtnTapped(_ sender: Any) {
        self.activityLoader.startAnimating()
        self.getTaskDetatils()
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let reviewDict =  self.reviewsArray.object(at: indexPath.row) as! NSDictionary
        cell.nameLbl.text = reviewDict.value(forKey: "name") as? String
        let dateStr = reviewDict.value(forKey: "date") as? String
        cell.userImgView.sd_setImage(with: URL.init(string:reviewDict.value(forKey: "user_image") as! String), placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        cell.timeLbl.text = Utility.shared.toLocal(dateStr: dateStr!, format: "dd.MMM.yyyy")
        cell.ratingLbl.text = reviewDict.value(forKey: "rating") as? String
        cell.locationLbl.text = reviewDict.value(forKey: "location") as? String
        cell.ratingDesLbl.text = reviewDict.value(forKey: "description") as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
}

//qwerty
extension TaskerDetails {
    
    //get my needs
//    func getNeeds()  {
//        self.startLoading()
//        let Obj = BaseAPI()
//        let requestDict = NSMutableDictionary.init()
//        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
//        requestDict.setValue(300, forKey: "limit")
//        requestDict.setValue(0, forKey: "offset")
//        Obj.baseService(subURl: MY_NEEDS_API, params: requestDict as? Parameters, onSuccess: {response in
//
//            do{
//                let resDict = response.value as! NSDictionary
//                let status_code = resDict.value(forKey: "status_code") as! Int
//                if status_code == 200{
//                    let items = resDict.value(forKey: "items") as! [NSDictionary]
//                    for item in items {
//                        if (item.value(forKey: "subcategory_name") as! String == self.subcat) && (item.value(forKey: "active_status") as! String == "true") {
//                            self.userNeed = item
//                            print("qwerty self.userNeed",self.userNeed)
////                            modified-AR
//                            break
//                        }
//                    }
//                    self.getBookingDetails()
//                }
//            }catch{
//            }
//        })
//    }
    //get taskDetatils
    func getTaskDetatils(){
        self.startLoading()
        let Obj = BaseAPI()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
//        requestDict.setValue(self.userDict.value(forKey:"subcategory_id"), forKey: "subcategory_id")
        requestDict.setValue(self.subcatId, forKey: "subcategory_id")
        Obj.baseService(subURl: GET_TASK_DETAILS, params: requestDict as? Parameters, onSuccess: {response in
            do{
                let resDict = response.value as! NSDictionary
                let status_code = resDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(GetTaskDetatilModel.self, from: response.data!)
                    self.bookingId = model.items[0].item_id ?? ""
                    self.activityLoader.stopAnimating()
                    if model.items[0].due_status == "true"{
                        self.updateTaskDetatil(model: model.items[0])
                    }else if model.items[0].active_status == "true"{
                        self.getBookingDetails(booking_id: self.bookingId)
                    }
                } else if status_code == 400{
                    self.activityLoader.stopAnimating()
                    self.requestNewPost()
                }
                else{
                    self.activityLoader.stopAnimating()
                }
            }catch{
            }
        })
    }
    func updateTaskDetatil(model: Needs){
//        //create alert for update Tasks
        let alertController = UIAlertController (title: "Alert", message: Utility.shared.Json().value(forKey: "job_expired") as? String, preferredStyle: .alert)
        //create button actions for alert
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let updateBtn = UIAlertAction(title: "Update", style: .default) { (_) -> Void in
            //update Btn tapped
            //let model = model as! Needs
            let detailObj = PostNeeds()
            detailObj.need = model as! Needs
            detailObj.viewType = "edit"
            detailObj.already_active = "false"
            detailObj.refreshRequest = {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.getTaskDetatils()
                })
            }
            self.navigationController!.pushViewController(detailObj, animated: true)
        }
        //add button actions for alert
        alertController.addAction(cancelBtn)
        alertController.addAction(updateBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    func requestNewPost(){
        let alertController = UIAlertController (title: "Alert", message: Utility.shared.Json().value(forKey: "no_post") as? String, preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let postBtn = UIAlertAction(title: "Post", style: .default) { (_) -> Void in
            let needObj = PostNeeds()
            needObj.viewType = "Tasker_Page"
            needObj.parent_cat_id = self.userDict.value(forKey: "parent_category_id") as? String ?? ""
            needObj.parent_cat_name = self.userDict.value(forKey: "parent_category_name") as? String ?? ""
            needObj.parent_cat_type = self.userDict.value(forKey: "") as? String ?? ""
            needObj.sub_cat_id = self.userDict.value(forKey: "subcategory_id") as? String ?? ""
            needObj.sub_cat_name = self.userDict.value(forKey: "subcategory_name") as? String ?? ""
            needObj.location_type = self.userDict.value(forKey: "location_type") as? String ?? ""
            needObj.refreshRequest = {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.getTaskDetatils()
                })
            }
            self.navigationController?.pushViewController(needObj, animated: true)
        }
        alertController.addAction(cancelBtn)
        alertController.addAction(postBtn)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    //booking information
    func getBookingDetails(booking_id: String){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.userNeed.value(forKey:"item_id"), forKey: "booking_id")
        
        Obj.getDetails(subURl: "\(BOOKING_DETAILS_API)/\(booking_id)", onSuccess: {response in
            let dict = response.value as! NSDictionary
            let status_code = dict.value(forKey: "status_code") as! Int
            self.scrollView.isHidden = false
            if status_code == 200{
                self.bookingDict = dict
                self.chatID = self.bookingDict.value(forKey: "chat_id") as! String
                self.checkChatAvailablity(type: "quote")
            }else{
                self.stopLoading()
            }

        })
        
    }
    
    
    //check if there chat is available
    func checkChatAvailablity(type:String)  {
        //        self.chatID = self.bookingDict.value(forKey: "chat_id") as! String
        if self.chatID == ""{
            if type == "quote"{
                self.showQoutePopup()
            }
//            self.startLoading()
//            self.createChatID()
        }else{
            if type == "quote"{
                self.showQoutePopup()
            }else if type == "professional"{
                self.goToChat()
            }
        }
    }
    
    //chat information
    func getChatInfo(type:String,chat_id:String){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(chat_id, forKey: "chat_id")
            //modified-AR
            request.setValue((self.userDict.value(forKey: "user_image") as! String), forKey: "user_image")
            request.setValue((self.userDict.value(forKey: "name") as! String), forKey: "name")
//            request.setValue(self.tasker_id, forKey: "user_id")
            Obj.baseService(subURl: USER_CHAT_INFO, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.chatDict = responseDict
                    self.chatID = self.chatDict.value(forKey: "chat_id") as! String
                    //                    if type == "create"{
                    //                    self.goToChat()
                    //                    }
//                    modified-AR
                    if type == "create"{
                        self.setChat()
                    }
                    
//                    self.showQoutePopup()
                }
                self.stopLoading()
            })
        }
    }
    
    //quote menu
    func showQoutePopup()  {
        //modified-AR
        //        let bookingArray = self.bookingDict.value(forKey: "services") as! NSArray
        //        let serviceDict = bookingArray.object(at: 0) as! NSDictionary
        
        let appDefault = LocalDefault.shared.appDefaults()
        currency_code = appDefault?.value(forKey: "currency_symbol") as! String
        
        let serviceDict = self.bookingDict
        let quoteObj = QuotePage()
        quoteObj.modalPresentationStyle = .overCurrentContext
        quoteObj.serviceDict = serviceDict
        
        quoteObj.priceStr = serviceDict.value(forKey: "price") as? String ?? ""
        if quoteObj.priceStr == ""{
            
        }
        quoteObj.quoted = { [self] price,des in
            self.quoteDes = des
            if self.chatID == ""{
                self.activityLoader.startAnimating()
                self.createChatID()
            }
//            let msgDict = NSMutableDictionary()
//            msgDict.setValue("\(Utility.shared.Json().value(forKey: "quoted_price") ?? "") \(self.currency_code)\(price) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))", forKey: "message")
//            msgDict.setValue(des, forKey: "description")
//            msgDict.setValue("quote", forKey: "type")
//            msgDict.setValue(price, forKey: "quote_price")
//            msgDict.setValue("true", forKey: "isActive")
//            msgDict.setValue("\(self.currency_code)\(price)", forKey: "price")
//            //modified-AR
//
//            self.bookTasker(model: msgDict)
////            self.initiateServiceChat(msgDict: msgDict, type: "request")
            
        }
        self.activityLoader.stopAnimating()
        self.navigationController?.present(quoteObj, animated: true, completion: nil)
    }

    
    func setChat(){
        let msgDict = NSMutableDictionary()
        msgDict.setValue("\(Utility.shared.Json().value(forKey: "quoted_price") ?? "") \(self.currency_code)\(self.bookingDict.value(forKey: "price")) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))", forKey: "message")
        msgDict.setValue(self.quoteDes, forKey: "description")
        msgDict.setValue("quote", forKey: "type")
        msgDict.setValue(self.bookingDict.value(forKey: "price"), forKey: "quote_price")
        msgDict.setValue("true", forKey: "isActive")
        msgDict.setValue("\(self.currency_code)\(self.bookingDict.value(forKey: "price") as? String ?? "")", forKey: "price")
        //modified-AR
        
        self.bookTasker(model: msgDict)
//            self.initiateServiceChat(msgDict: msgDict, type: "request")
    }
    
    /*
    //initiate first msg
    func initiateServiceChat(msgDict:NSDictionary,type:String)  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
            //send msg
            let requestDict = NSMutableDictionary()
            requestDict.setValue("bookingchat", forKey: "type")
            requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            //modified-AR
            requestDict.setValue(profile.name, forKey: "user_name")
            requestDict.setValue(profile.user_image, forKey: "user_image")
//            requestDict.setValue(self.userDict.value(forKey: "name"), forKey: "user_name")
//            requestDict.setValue(self.userDict.value(forKey: "user_image"), forKey: "user_image")
            //            requestDict.setValue(LocalDefault.shared.userID(), forKey: "receiver_id")
            requestDict.setValue(self.tasker_id, forKey: "receiver_id")  //receiver_id
//            requestDict.setValue(self.chatDict.value(forKey:"chat_id"), forKey: "chat_id")
            requestDict.setValue(self.chatID, forKey: "chat_id")
            requestDict.setValue(Utility.shared.UTC(), forKey: "date")
            requestDict.setValue(Utility.shared.messageID(), forKey: "message_id")
            requestDict.setValue(type, forKey: "message_type")
            requestDict.setValue(msgDict, forKey: "message")
            SocketClass.sharedInstance.send(msg: requestDict)
            self.goToChat()
        }catch{
        }
        
    }
    */
    
    //create chat id
    func createChatID(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
//            request.setValue(self.userNeed.value(forKey:"item_id"), forKey: "booking_id")
            request.setValue(self.bookingId, forKey: "booking_id")
            request.setValue(self.tasker_id, forKey: "tasker_id")
            Obj.baseService(subURl: USER_CREATE_CHAT_ID, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.chatID = responseDict.value(forKey: "chat_id") as! String
                    self.getChatInfo(type: "create",chat_id:self.chatID)
                }
            })
        }
    }
    
    //go to chat
    func goToChat()  {
        if self.bookingDict.value(forKey: "chat_id") != nil{
            //            if viewFrom == "chat"{
            //                self.navigationController?.popViewController(animated: true)
            //            }else{
            let detailObj = MessageDetails()
            detailObj.viewFrom = "booking"
            detailObj.chatDict =  self.chatDict
            detailObj.receiverID =  self.tasker_id
            detailObj.chatID =  self.chatDict.value(forKey: "chat_id") as! String
            detailObj.viewType = "chat"
            detailObj.bookingID =  self.chatDict.value(forKey:"booking_id") as! String
            detailObj.refreshChat = {
            }
            
            self.activityLoader.stopAnimating()
            self.navigationController?.pushViewController(detailObj, animated: true)
            //            }
        }
    }
    
}


extension TaskerDetails {
    
    func bookTasker(model: NSDictionary)  {
        self.startLoading()
        let dict = self.bookingDict as! NSDictionary
//        let quantity = Double("\(dict.value(forKey: "service_quantity") as! String)") ?? .nan
        let quantity = 1.0

        let appDefault = LocalDefault.shared.appDefaults()
        let commissionPercent = Double(appDefault?.value(forKey: "site_commission") as! String)
        let taxPercent = Double(appDefault?.value(forKey: "site_tax") as! String)
        let price = Double("\(model.value(forKey: "quote_price")!)") ?? .nan
        let bookingAmt =  price * quantity
        let taxAmt = self.get(value: bookingAmt, percent: taxPercent!)
        let commissionAmt = self.get(value: Double(bookingAmt), percent: commissionPercent!)
        let totalAmt = Double(bookingAmt) + taxAmt + commissionAmt
        
        let bookingDict = NSMutableDictionary.init(dictionary:dict)
        bookingDict.setValue(price, forKey: "service_price")
        bookingDict.setValue(Double(bookingAmt), forKey: "service_total_price")
        
        let newArray = NSMutableArray()
        newArray.add(bookingDict)
        
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.bookingDict.value(forKey:"parent_category_id"), forKey: "parent_category_id")
        request.setValue(self.bookingDict.value(forKey:"subcategory_id"), forKey: "subcategory_id")
        request.setValue(self.tasker_id, forKey: "tasker_id")
//        let dateStr = Utility.shared.toUTC(local: datePicker.date)!
//        let dateStr = "2021-10-16T08:20:47.089+0000"
        let dateStr = Utility.shared.UTC()
        request.setValue(dateStr, forKey: "date")
        request.setValue(bookingAmt, forKey: "total")
        request.setValue(String(format: "%.2f", totalAmt), forKey: "price")
        request.setValue(model.value(forKey:"description"), forKey: "description")
        request.setValue(Utility.shared.json(from: newArray), forKey: "services")
        
//        if self.locationType == "transport"{
//            request.setValue(self.sourceLocation, forKey: "source_location")
//            request.setValue(self.dropLocation, forKey: "dest_location")
//            if LocalDefault.shared.isLiveTrack()!{
//                request.setValue(self.dropLat, forKey: "dest_lat")
//                request.setValue(self.dropLon, forKey: "dest_lon")
//                request.setValue(self.sourceLat, forKey: "source_lat")
//                request.setValue(self.sourceLon, forKey: "source_lon")
//            }
//        }else
//        if self.locationType == "home"{
//            request.setValue(self.sourceLocation, forKey: "source_location")
//            if LocalDefault.shared.isLiveTrack()!{
//                request.setValue(self.sourceLat, forKey: "source_lat")
//                request.setValue(self.sourceLon, forKey: "source_lon")
//            }
//        }
        
        self.initiateServiceChat(chat_id: self.chatID, tasker_id: self.tasker_id, price: String(bookingAmt), msgDict: model)

//        Obj.baseService(subURl: BOOK_SERVICE_API, params: request as? Parameters, onSuccess: {response in
//            let dict = response.value as! NSDictionary
//            let status_code = dict.value(forKey: "status_code") as! Int
//            if status_code == 200{
//                let availability = dict.value(forKey: "availability") as! String
//                if availability == "true"{
//
//                    let chat_id = dict.value(forKey: "chat_id") as! String
//                    self.initiateServiceChat(chat_id: chat_id, tasker_id: self.tasker_id, price: String(bookingAmt))
//                    let booking_id = dict.value(forKey: "booking_id") as! String
//                    let bookingObj = BookingDetails()
//                    bookingObj.viewType = "booking"
//                    bookingObj.bookingID = booking_id
//                    bookingObj.refreshRequest = {
//
//                    }
//                    self.navigationController?.pushViewController(bookingObj, animated: true)
//                }
//            }
//            self.stopLoading()
//        })
    }
    
    
    //initiate first msg
    //modified-AR add the msgDict params
    func initiateServiceChat(chat_id:String,tasker_id:String,price:String,msgDict: NSDictionary)  {
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
//            modified_AR
//            let msgDict = NSMutableDictionary()
//            msgDict.setValue(Utility.shared.Json().value(forKey: "service_request"), forKey: "message")
//            msgDict.setValue("request", forKey: "type")
//            msgDict.setValue(price, forKey: "quote_price")
//            msgDict.setValue("true", forKey: "isActive")
            requestDict.setValue(msgDict, forKey: "message")
            SocketClass.sharedInstance.send(msg: requestDict)
            goToChat()
        }catch{
        }
        
    }
    
    //calculate percent
    public func get(value:Double,percent:Double)->Double{
        let val = value * percent
        return val / 100.00
    }
}

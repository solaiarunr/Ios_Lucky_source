//
//  CategoryPage.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import GoogleMobileAds


class CategoryPage: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate ,GADBannerViewDelegate{
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var bannerView: GADBannerView!
    
    var categories:[Category]?
    var viewType = String()
    var selected_id = String()
    var isDataAvailable = false
    
    @IBOutlet var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.selected_id = ""
        self.categoryCollectionView.reloadData()
        self.updateTheme()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        if viewType == "tab"{
            let height = (tabBarController?.tabBar.frame.size.height)!+40
            bannerView.frame.origin.y = FULL_HEIGHT - height
        }else{
            bannerView.frame.origin.y = FULL_HEIGHT - 55
        }
    }
    //initial set up
    func initalSetup()  {
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_category_found")
        self.noView.isHidden = true
        self.loader.color = PRIMARY_COLOR
        self.navigationView.backgroundColor = PRIMARY_COLOR
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "categories")
        self.searchTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "search_for_services")
        self.searchTF.radius(value: 10)
        self.searchTF.backgroundColor = SEARCH_BG_COLOR 
        if viewType == "tab"{
            self.backBtn.isHidden = true
        }
        self.categoryCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 20, right: 20)
        self.loader.startAnimating()
        self.getCatgories()
     
        self.addPullDownRefresh()
        self.checkRTL()
        self.configBanner()
        
    }
    
    // config banner
    func configBanner()  {
        if ADD_ON {
            self.categoryCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 40, right: 20)
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
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.textAlignment = .right
            self.searchTF.clearButtonMode = .never
            self.searchTF.addPadding(left: false)
            self.bannerView.transform = CGAffineTransform(scaleX: -1, y: 1)

        }else{
            self.searchTF.addPadding(left: true)
        }
    }
    
    
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.categoryCollectionView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.isDataAvailable = false
            self.getCatgories()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if !LocalDefault().isUser()!{
            if LocalDefault.shared.viewFrom() == "signup"{
                let alertObj = AlertPage()
                alertObj.modalPresentationStyle = .overCurrentContext
                alertObj.viewType = "tasker_info"
                alertObj.deleteRequest = {
                    if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
                        myDelegate.setInitialViewController()
                    }
                }
                self.navigationController?.present(alertObj, animated: false, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //get categories list
    func getCatgories(){
        if Utility.shared.isConnectedToNetwork(){
            let Obj = BaseAPI()
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            Obj.baseService(subURl: CATEGORIES_API, params: request as? Parameters, onSuccess: {response in
                self.isDataAvailable = true
                do{
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(categoryModel.self, from: response.data!)
                    if model.status_code == 200{
                        self.categoryCollectionView.delegate = self
                        self.categoryCollectionView.dataSource = self
                        self.categories = model.category!
                        self.categoryCollectionView.reloadData()
                        self.categoryCollectionView.fty.pullToRefresh.end()
                    }else if model.status_code == 400{
                    }
                    self.loader.stopAnimating()
                    if self.categories?.count == 0 {
                        self.noView.isHidden = false
                    }else{
                        self.noView.isHidden = true
                    }
                }catch{
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if !self.isDataAvailable {
                self.isDataAvailable = false
                self.getCatgories()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchObj = CategorySearch()
        // qwerty
        searchObj.viewType = self.viewType
        self.navigationController?.pushViewController(searchObj, animated: true)
    }
    //collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = self.categories![indexPath.row]
        let item_img = URL.init(string: category.parent_category_image!)
        cell.categoryImgView.sd_setImage(with: item_img, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        cell.inActiveView.isHidden = true
        
        cell.nameLbl.text = category.parent_category_name
        if selected_id == category.parent_category_id {
            cell.nameLbl.textColor = PRIMARY_COLOR
            cell.categoryImgView.addBorder(width: 3, color: PRIMARY_COLOR!)
        }else{
            cell.nameLbl.textColor = TEXT_BLACK_COLOR
            cell.categoryImgView.addBorder(width: 3, color: .clear)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = CGFloat()
        collectionViewSize = (categoryCollectionView.frame.size.width)-60
        return CGSize(width: (collectionViewSize/2), height:(collectionViewSize/2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.categories![indexPath.row]
        selected_id = category.parent_category_id!
        let subCatObj = subCategoryPage()
        subCatObj.parent_cat_id = category.parent_category_id!
        subCatObj.parent_cat_name = category.parent_category_name!
        subCatObj.parent_cat_type = category.parent_category_type!
        subCatObj.location_type = category.location_type ?? ""
        //qwerty
        subCatObj.viewType = self.viewType
        self.navigationController?.pushViewController(subCatObj, animated: true)
        self.categoryCollectionView.reloadData()
        
        self.searchTF.resignFirstResponder()
    }
}

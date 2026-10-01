//
//  MyServicesCategory.swift
//  iDemand
//
//  Created by Roby on 07/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class MyServicesCategory: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var serviceCollectionView: UICollectionView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet var noView: UIView!
    @IBOutlet var addBtn: UIButton!
    
    var categories:[Category]?
    var viewType = String()
    var selected_id = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.addBtn.topRadius()

    }
    func initalSetup()  {
        self.navigationView.backgroundColor = PRIMARY_COLOR
        serviceCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_services")
        self.addBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "add_new_service")
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "service_not_added_yet")
        self.serviceCollectionView.contentInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        self.noView.isHidden = true
        self.getServiceCatgories()
        self.addPullDownRefresh()
        self.checkRTL()
    }
    
    //check rtl layout
      func checkRTL()  {
          if Utility.shared.isRTL(){
              self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
              self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
          }
      }
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.serviceCollectionView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getServiceCatgories()
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //get categories list
    func getServiceCatgories(){
        if Utility.shared.isConnectedToNetwork(){
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        Obj.baseService(subURl: MY_SERVICE_CATEGORY_API, params: request as? Parameters, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(categoryModel.self, from: response.data!)
                if model.status_code == 200{
                    self.categories = model.servicecategories!
                    self.serviceCollectionView.fty.pullToRefresh.end()
                    self.serviceCollectionView.delegate = self
                    self.serviceCollectionView.dataSource = self
                    self.serviceCollectionView.reloadData()
                    if self.categories?.count == 0{
                        self.noView.isHidden = false
                    }else{
                        self.noView.isHidden = true
                    }
                }else{
                    self.noView.isHidden = false

                }

            }catch{
            }
        })
        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        LocalDefault.shared.setView(from: "addservice")
        // qwerty
//        if self.noView.isHidden == true {
//
//        let alertObj = AlertPage()
//        alertObj.modalPresentationStyle = .overCurrentContext
//        alertObj.viewType = "please_delete_existing_service"
//        alertObj.deleteRequest = {
//                    let categoryObj = CategoryPage()
//                    categoryObj.viewType = "delete"
//                    self.navigationController?.pushViewController(categoryObj, animated: true)
//
//        }
//        self.navigationController?.present(alertObj, animated: false, completion: nil)
//        }else {
            let categoryObj = CategoryPage()
            categoryObj.viewType = "addservice"
            self.navigationController?.pushViewController(categoryObj, animated: true)
//        }
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchObj = CategorySearch()
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

        if category.parent_category_status == "1"{
            cell.inActiveView.isHidden = true
        }else{
            cell.inActiveView.isHidden = false
        }
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
        collectionViewSize = (serviceCollectionView.frame.size.width)-60
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
        if category.parent_category_status == "1"{

        let serviceObj = MyServices()
        serviceObj.parent_cat_name = category.parent_category_name!
        serviceObj.parent_cat_id = category.parent_category_id!
            //qwerty
//        serviceObj.parent_cat_type = category.parent_category_type!
            serviceObj.parent_cat_type = ""
            serviceObj.refreshRequest = {
                self.getServiceCatgories()
            }

        self.navigationController?.pushViewController(serviceObj, animated: true)
        }else{
            Utility.shared.showToast(msg: "service_disabled")

        }
       
    }
}

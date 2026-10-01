//
//  ReviewsList.swift
//  iDemand
//
//  Created by Roby on 21/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ReviewsList: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    @IBOutlet var navigationView: UIView!
    @IBOutlet var reviewTableview: UITableView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var noLbl: UILabel!
      @IBOutlet var noView: UIView!
    
    var viewType = String()
    var reviwer_id = String()
    var reviewsArray = NSMutableArray()
    
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
        self.addLoader()
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .center, text: "no_reviews_yet")
        self.reviewTableview.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0 )
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "reviews")
        reviewTableview.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        self.reviewTableview.reloadData()
        self.noView.isHidden = true
        self.startLoading()
        self.reviewsList(offset: "0")
        self.addPullDownRefresh()
        self.checkRTL()
    }
    
    //pull down refresh
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.reviewTableview.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.reviewsList(offset: "0")
        }
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
    //booking information
    func reviewsList(offset:String){
          let Obj = BaseAPI()
          Obj.getDetails(subURl: "\(REVIEWS_LIST_API)/\(viewType)/\(reviwer_id)/\(offset)/20", onSuccess: {response in
              do{
                  let jsonDecoder = JSONDecoder()
                  let model = try jsonDecoder.decode(ReviewsModal.self, from: response.data!)
                  if model.status_code == 200{
                      if model.items!.count != 0 {
                          if offset == "0"{
                              self.reviewsArray.removeAllObjects()
                          }
                          self.noView.isHidden = true
                          self.reviewTableview.delegate = self
                          self.reviewTableview.dataSource = self
                          self.reviewsArray.addObjects(from: model.items!)
                          self.reviewTableview.reloadData()
                      }else{
                          self.checkAvailability()
                      }
                  }else{
                      self.checkAvailability()
                  }
                  self.reviewTableview.fty.pullToRefresh.end()
                  self.reviewTableview.fty.infiniteScroll.end()
                  self.stopLoading()
              }catch{
              }
          })
      }
      //check data available
      func checkAvailability()  {
          if self.reviewsArray.count == 0{
              self.noView.isHidden = false
          }else{
              self.noView.isHidden = true
          }
      }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let model = reviewsArray.object(at: indexPath.row) as! reviews_items
        cell.userImgView.sd_setImage(with: URL.init(string: model.user_image!), placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
        cell.nameLbl.text = model.user_name
        cell.timeLbl.text = Utility.shared.toLocal(dateStr: model.date!,format:"dd.MMM.yyyy")
        cell.ratingLbl.text = model.rating
        cell.locationLbl.text = model.location
        cell.ratingDesLbl.text = model.description
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    }
    
    //scroll view delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        // Change value to adjust the distance from bottom
        if currentOffset > 0{
        if maximumOffset - currentOffset <= 200 {
            self.reviewsList(offset: "\(String(describing: self.reviewsArray.count))")
        }
        }
    }
}

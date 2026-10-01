
//  clusterMapViewController.swift
//  iDemand
//
//  Created by HTS-105 on 17/09/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//
// qwerty
import GoogleMaps
import GoogleMapsUtils
import MapKit
import UIKit
import MaterialComponents
import GooglePlaces
import DropDown
protocol customLocationDelegate {
  func locationAct(city: String, state: String, country: String, countryCode: String, lat: String, long: String, location: String)
  
}
class clusterMapViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NoView: UIView!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var PaymentView: UIView!
    @IBOutlet weak var PaymentViewLbl: UILabel!
    @IBOutlet weak var PaymentBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterImgView: UIImageView!
    @IBOutlet weak var filterIndicatorView: UIView!
    @IBOutlet weak var filterindexLbl: UILabel!
    @IBOutlet weak var myServiceBtnView: MDCCard!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var currentLocation: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var markerButton: UIButton!
    var locationManager = CLLocationManager()
    var clusterManager: GMUClusterManager!
    var fetcher:GMSAutocompleteFetcher?
    var session_token = GMSAutocompleteSessionToken()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var latitude: Double!
    var longitude: Double!
    var markerDataArray = [Tasker]()
    var LocationArray = [Tasker]()
    var taskermarkerDataArray = [Item]()
    var taskerLocationArray = [Item]()
    var LocationArray2 = [NSDictionary]()
    var bottomViewHeight: CGFloat!
    var locationModel = locationViewModel()
    var dropDown = DropDown()
    var placesClient:GMSPlacesClient!
    var delegate:customLocationDelegate?
    var markerFrom: String!
    var locationArray = NSMutableArray()
    var selectedMarkerTitle = [String]()
    var first_lat_lon = [String]()
    var status_code = Int()
    var if_status_code_400 = false
    var pageFrom = String()
    var opened = false
    var if_first = true
    var FilterArray = [Subcategory1]()
    let placesClient1 = GMSPlacesClient.shared()
    var placeName = String()
    var selectedFilterArray = NSMutableArray()
    var isUser = Bool()
    var navigationToTaskerProfile = false
    var city = ""
    var state = ""
    var country = ""
    var countryCode = ""
    var lat = ""
    var long = ""
    var locationString = ""
    var count = Int()
    var coordinate=CLLocationCoordinate2D()
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        isUser = LocalDefault().isUser()!
        self.bottomView.isHidden = true
        self.mapView.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 20)
        self.changeLocationBtnFrame()
        self.filterIndicatorView.layer.cornerRadius = filterIndicatorView.bounds.size.width/2
        self.filterindexLbl.layer.cornerRadius = filterindexLbl.bounds.size.width/2
        self.filterIndicatorView.clipsToBounds = true
        self.initialSetup()
        checkLocationAccess()
        self.changeLocationBtnFrame()
        UpdateTheme()
        self.markerFrom = ""
        self.opened = true
        self.cloneDidappar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        bottomToTopAnimate()
        UpdateTheme()
        if(self.appdelegate?.loctionString != "")
        {
        if self.isUser{
            self.longitude = self.appdelegate?.current_lon
            self.latitude = self.appdelegate?.current_lat
            self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray,reset:self.appdelegate?.reset ?? "")
        }
        else{
            let json_Decoder = JSONDecoder()
            let profile = try? json_Decoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
//            if profile?.payment_verified == "false"{
            if !(LocalDefault.shared.get_paymentAdded()){
                loader.stopAnimating()
                self.bottomView.isHidden = false
                self.PaymentView.isHidden = false
                self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                self.bottomToTopAnimate()
            }
            else{
                if(self.appdelegate?.loctionString != "")
                {
                    self.longitude = self.appdelegate?.current_lon
                    self.latitude = self.appdelegate?.current_lat
                }
                self.PaymentView.isHidden = true
                self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!) //
            }
        }
        }
        else{
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.FilterArray.count != 0{
            self.selectedFilterArray.removeAllObjects()
            self.selectedFilterArray.addObjects(from: delegate.FilterArray as! [Any])
            self.filterindexLbl.text = self.selectedFilterArray.count.description
        }else{
            self.filterIndicatorView.isHidden = true
        }
        self.navigationToTaskerProfile = false
        if (self.pageFrom != "true"){
//            self.initialSetup()
//            checkLocationAccess()
//            self.changeLocationBtnFrame()
//            UpdateTheme()
//            self.markerFrom = ""
//            self.opened = true
        }
        else{
            self.pageFrom = ""
        }
        
    }
    func filterindexupdate(){
        if selectedFilterArray.count != 0{
            self.filterIndicatorView.isHidden = false
            self.filterindexLbl.text = self.selectedFilterArray.count.description
        }else{
            self.filterIndicatorView.isHidden = true
        }
    }
    func cloneDidappar(){
        if (self.pageFrom != "true"){
            self.initialSetup()
            checkLocationAccess()
            self.changeLocationBtnFrame()
            UpdateTheme()
            self.markerFrom = ""
            self.opened = true
        }
        else{
            self.pageFrom = ""
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if pageFrom != "true"{
            self.markerDataArray.removeAll()
            self.taskermarkerDataArray.removeAll()
            self.LocationArray.removeAll()
            self.taskerLocationArray.removeAll()
            self.selectedMarkerTitle.removeAll()
            tableView.reloadData()
            self.bottomView.isHidden = true
            self.if_status_code_400 = false
            self.if_first = true
            self.opened = true
        }
        if !(self.navigationToTaskerProfile){
            self.selectedFilterArray.removeAllObjects()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.bottomView.topRadius()
        self.changeLocationBtnFrame()
        if self.isUser{
            self.titleLbl.textAlignment = .center
        }
        else{
            self.titleLbl.textAlignment = .center
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func currentLocationButtonAct(_ sender: UIButton) {
        self.locationString = ""
        self.appdelegate?.loctionString = ""
        self.locationManager.startUpdatingLocation()
    }
    func initialSetup(){
        self.filterView.backgroundColor = .clear
        self.markerButton.isHidden = false
        self.filterBtn.backgroundColor = .clear
        if self.isUser{
        self.filterImgView.image = #imageLiteral(resourceName: "ic_filter")
        self.myServiceBtnView.isHidden = true
        }else{
           self.filterImgView.image = #imageLiteral(resourceName: "notification_icon")
            self.filterIndicatorView.isHidden = true
            self.myServiceBtnView.isHidden = false
            self.myServiceBtnView.backgroundColor = PRIMARY_COLOR
            self.myServiceBtnView.elevation(radius: 30)
            self.mapView.bringSubviewToFront(myServiceBtnView)
        }
        searchView.layer.shadowColor = UIColor.gray.cgColor
        searchView.layer.shadowOpacity = 0.3
        searchView.layer.shadowOffset = CGSize.zero
        searchView.layer.shadowRadius = 6
        searchView.layer.cornerRadius = 5
        locationView.layer.cornerRadius = locationView.frame.height / 2
        locationView.clipsToBounds = true

        locationView.layer.masksToBounds = false
        locationView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        locationView.layer.shadowRadius = 3;
//        self.layer.shouldRasterize = true
        locationView.layer.shadowOpacity = 1;
        locationView.layer.shadowColor = UIColor.gray.cgColor
        self.bottomView.isHidden = true
        self.PaymentView.isHidden = true
        self.loader.color = PRIMARY_COLOR
        self.loader.hidesWhenStopped = true
        self.loader.startAnimating()
        self.bottomView.backgroundColor = BACKGROUND_COLOR
        self.NoView.backgroundColor = BACKGROUND_COLOR
        self.PaymentView.backgroundColor = BACKGROUND_COLOR
        self.tableView.backgroundColor = BACKGROUND_COLOR
        self.PaymentViewLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "add_payment_hint")
        self.PaymentBtn.config(color: PRIMARY_COLOR!, font: subReg, align: .center, title:"click_here")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: isUser ? "tasker" : "user_needs")
        warningLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .center, text: isUser ? "no_tasker_warning" : "no_jobs_warning")
        
        self.ConfigMapView()
        self.ConfigLocationManger()
        self.ConfigClusterGenerator()
    }
    
    @IBAction func PaymentBtnTapped(_ sender: Any) {
        let webObj = WebPage()
        webObj.viewType = "stripe"
        self.navigationController?.pushViewController(webObj, animated: true)
    }
    
    
}




// MARK: TableView Delegate

extension clusterMapViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case self.tableView:
            return 100
            break
        default:
            break
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        //bottom tasker/task table view funcion
        case self.tableView:
            print("normal@@@@@@")
            var size: Int!
            size = isUser ? markerDataArray.count : taskermarkerDataArray.count
            
            for const in self.bottomView.constraints{
                if const.identifier == "viewHeight"{
                    if size == 0{
                        const.constant = CGFloat(100)
                        self.bottomToTopAnimate()
                        self.bottomToTopAnimate()
                        self.tableView.isScrollEnabled = false
                        break
                    } else if size <= 3 {
                        const.constant = CGFloat(size * 100)
                        self.bottomToTopAnimate()
                        self.bottomToTopAnimate()
                        self.tableView.isScrollEnabled = false
                        break
                    } else if size >= 4{
                        const.constant = CGFloat(300)
                        self.bottomToTopAnimate()
                        self.bottomToTopAnimate()
                        self.tableView.isScrollEnabled = true
                        break
                    }
                    else{
                        break
                        self.tableView.isScrollEnabled = false
                    }
                }
            }
            return size
            break
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        //botom taskr/task table view
        case self.tableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! tableCell
            
            if isUser{
                let ArrayIndex = markerDataArray[indexPath.row]
                cell.taskerNameLbl.text = ArrayIndex.taskerName ?? "tasker name unavailable"
                cell.taskeNameLbl.text = "\(ArrayIndex.categoryName!) - \(ArrayIndex.subCategoryName!)"
                cell.taskeNameLbl.textColor = PRIMARY_COLOR
                cell.locationLbl.text = ArrayIndex.taskerLocation ?? "location unavailable"
                cell.userImage.sd_setImage(with:URL.init(string:  ArrayIndex.taskerImage!), placeholderImage:  #imageLiteral(resourceName: "placeholder_img"))
            } else{
                let ArrayIndex = taskermarkerDataArray[indexPath.row]
                cell.taskerNameLbl.text = ArrayIndex.name ?? "unavailable"
                let price: NSString = "Price: $\(ArrayIndex.bookingPrice!)" as NSString
                let range = (price).range(of: "Price:")
                let attribute = NSMutableAttributedString.init(string: price as String)
                
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: TEXT_BLACK_COLOR! , range: range)
                cell.taskeNameLbl.attributedText = attribute
                cell.locationLbl.text = Utility().toLocal(dateStr: taskerLocationArray[indexPath.row].date!, format: "dd.MMM.yyyy")
                cell.userImage.sd_setImage(with:URL.init(string:  ArrayIndex.userImage!), placeholderImage:  #imageLiteral(resourceName: "placeholder_img"))
            }
            return cell
            break
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! tableCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.pageFrom = "true"
        switch tableView {
        case self.tableView:
            if isUser{
                let vc = TaskerDetails()
                vc.tasker_id = markerDataArray[indexPath.row].taskerID!
                vc.tasker_serviece = ("\(markerDataArray[indexPath.row].categoryName!) - \(markerDataArray[indexPath.row].subCategoryName!)")
                vc.subcat = markerDataArray[indexPath.row].subCategoryName!
                vc.pageFrom = "mapPage"
                vc.subcatId = markerDataArray[indexPath.row].subcategoryId!
                self.navigationToTaskerProfile = true
                self.navigationController?.pushViewController(vc, animated: true)
                vc.gettaskandjobs = {
                   // if(self.appdelegate?.loctionString != "")
                 //   {
                      //  self.longitude = self.appdelegate?.current_lon
                      //  self.latitude = self.appdelegate?.current_lat
                        self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray,reset:self.appdelegate?.reset ?? "")
                  //  }
                }
               
            }
            else{
                let detailObj = TaskerBookingDetails()
                detailObj.bookingID = taskermarkerDataArray[indexPath.row].itemID!
                detailObj.viewType = "need"
                detailObj.viewFrom = "browse"
                detailObj.titleStr = taskermarkerDataArray[indexPath.row].name!
                detailObj.refreshRequest = {
                    self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!) //
                }
                self.navigationToTaskerProfile = true
//                let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                self.navigationController?.pushViewController(detailObj, animated: true)
            }
            break
        default:
            break
        }
    }
}

// MARK: Cluster Delegate

extension clusterMapViewController: GMUClusterManagerDelegate, GMUClusterRendererDelegate{
    
    func ConfigClusterGenerator() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        //        let algorithm = GMUGridBasedClusterAlgorithm()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.minimumClusterSize = 2
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        renderer.delegate = self
        clusterManager.setDelegate(self as GMUClusterManagerDelegate, mapDelegate: self)
    }
    
    private func generateClusterItems() {
        self.clusterManager.clearItems()
        if isUser{
            for i in LocationArray{
               
                for (co, selectmarker) in selectedMarkerTitle.enumerated(){
                    if i.taskerID == selectmarker{
                        addMarker(lat: (i.lat! as NSString).doubleValue, lng: (i.lon! as NSString).doubleValue, title: i.taskerID!, isselect: true)
                        break
                    }
                    else if co == selectedMarkerTitle.count-1{
                        addMarker(lat: (i.lat! as NSString).doubleValue, lng: (i.lon! as NSString).doubleValue, title: i.taskerID!, isselect: false)
                        
                    }
                    else{
                        //else
                    }
                }
                
            }
        }
        else{
            for i in taskerLocationArray{
                for (co, selectedMarker) in selectedMarkerTitle.enumerated(){
                    if i.itemID == selectedMarker{
                    addMarker(lat: (i.lat! as NSString).doubleValue, lng: (i.lon! as NSString).doubleValue, title: i.itemID!, isselect: true)
                        break
                    }
                    else if co == selectedMarkerTitle.count-1
                    {
                        addMarker(lat: (i.lat! as NSString).doubleValue, lng: (i.lon! as NSString).doubleValue, title: i.itemID!, isselect: false)
                    }
                    
                }
                
            }
        }
        self.clusterManager.cluster()
    }
    
    func addMarker(lat : Double , lng: Double, title : String, isselect: Bool){
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        marker.title = title
        
        let OuterImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0 , width: (OuterImgView.frame.size.width - 2), height: (OuterImgView.frame.size.height)))
        label.text = "1"
        label.font = subBold
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.center = OuterImgView.center
        label.frame.origin.y = -4
        OuterImgView.addSubview(label)
        
//        if self.selectedMarkerTitle == title {
//            OuterImgView.image = UIImage(named: "SelectedMapMarker")
//            if isUser{
//                for i in self.LocationArray{
//                    if i.taskerID == self.selectedMarkerTitle{
//                        self.markerDataArray.removeAll()
//                        self.markerDataArray.append(i)
//                        self.tableView.reloadData()
//                        break
//                    }
//                }
//            }
//            else{
//                for i in self.taskerLocationArray{
//                    if i.itemID == self.selectedMarkerTitle{
//                        self.taskermarkerDataArray.removeAll()
//                        self.taskermarkerDataArray.append(i)
//                        self.tableView.reloadData()
//                        break
//                    }
//                }
//            }
//        } else {
//            OuterImgView.image = UIImage(named: "mapMarker")
//        }
        if isselect{
            OuterImgView.image = UIImage(named: "SelectedMapMarker")
            
        }
        else {
            OuterImgView.image = UIImage(named: "mapMarker")
        }
        if selectedMarkerTitle.count == 1
        {
            if isUser{
                for i in self.LocationArray{
//                    if i.taskerID == self.selectedMarkerTitle[0] && self.opened{ //AS
                        if self.LocationArray.count > self.markerDataArray.count{
//                            self.markerDataArray.removeAll() //AS
                            self.markerDataArray.append(i)
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }else{
                            break
                        }
//                    }
//                        break
//                    }
                }
            }
            else{
                for i in self.taskerLocationArray{
//                    if i.itemID == self.selectedMarkerTitle[0] && self.opened{ //AS
                    if self.taskerLocationArray.count > self.taskermarkerDataArray.count{
//                        self.taskermarkerDataArray.removeAll() //AS
                        self.taskermarkerDataArray.append(i)
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }else{
                        break
                    }
                }
            }
        }
        marker.iconView = OuterImgView
        clusterManager.add(marker)
    }
    
//    if isUser{
//        self.markerDataArray.removeAll()
//        for i in self.LocationArray{
////                    if i.taskerID == self.selectedMarkerTitle[0] && self.opened{
//                if self.LocationArray.count > self.markerDataArray.count{
//                    self.markerDataArray.append(i)
//                    self.tableView.isHidden = false
//                    self.tableView.reloadData()
//                }else{
//                    break
//                }
////                    }
////                        break
////                    }
//        }
//    }else{
//    for i in self.taskerLocationArray{
//        if i.itemID == self.selectedMarkerTitle[0] && self.opened{
//            self.taskermarkerDataArray.removeAll()
//            self.taskermarkerDataArray.append(i)
//            self.tableView.isHidden = false
//            self.tableView.reloadData()
//            break
//        }
//    }
//}
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        marker.tracksViewChanges = false
        marker.tracksInfoWindowChanges = false
        
        if marker.title == nil {
            let userdata: GMUCluster = marker.userData! as! GMUCluster
            
            let OuterImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
            let label = UILabel(frame: CGRect(x: 0, y: 0 , width: (OuterImgView.frame.size.width - 2), height: (OuterImgView.frame.size.height)))
            label.text = String(userdata.count)
            label.font = subBold
            label.numberOfLines = 0
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.textColor = .white
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.center = OuterImgView.center
            label.frame.origin.y = -4
            OuterImgView.addSubview(label)
            OuterImgView.image = UIImage(named: "mapMarker")
//            for i in userdata.items{
//                if i.title == selectedMarkerTitle{
//                    OuterImgView.image = UIImage(named: "SelectedMapMarker")
//                }
//                if (i.title == selectedMarkerTitle && (self.markerFrom == "tap" || self.markerFrom == "open")){
//                    self.markerFrom = ""
//                    OuterImgView.image = UIImage(named: "SelectedMapMarker")
//                    self.markerDataArray.removeAll()
//                    self.taskermarkerDataArray.removeAll()
//
//                    if isUser{
//                        for i in LocationArray{
//                            for j in userdata.items {
//                                if i.taskerID == j.title{
//                                    markerDataArray.append(i)
//                                    break
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        for i in taskerLocationArray{
//                            for j in userdata.items {
//                                if i.itemID == j.title{
//                                    taskermarkerDataArray.append(i)
//                                    break
//                                }
//                            }
//                        }
//                    }
//                    self.tableView.reloadData()
//                    break
//                }
//            }
            for i in userdata.items{
                for selectmarker in selectedMarkerTitle{
                    if i.title == selectmarker{
                        OuterImgView.image = UIImage(named: "SelectedMapMarker")
                        break
                    }
//                    else if i.title != selectmarker{
//                        OuterImgView.image = UIImage(named: "mapMarker")
//                        break
//                    }
                }
                //&& self.opened)
                if (i.title == selectedMarkerTitle.first ?? "" && (self.markerFrom == "tap" || self.markerFrom == "open")) {
                    print("FUNCTIONCalledSuc:\(self.markerFrom)")
                    self.markerFrom = ""
                    OuterImgView.image = UIImage(named: "SelectedMapMarker")
                    self.markerDataArray.removeAll()
                    self.taskermarkerDataArray.removeAll()
                    self.selectedMarkerTitle.removeAll()
                    
                    if isUser{
                        for i in LocationArray{
//                            for j in userdata.items {
//                                if i.taskerID == j.title{
//                                    markerDataArray.append(i)
                                    self.selectedMarkerTitle.append(i.taskerID!)
                                    break
//                                }
//                            }
                        }
                        self.clusterManager.clearItems()
                        self.generateClusterItems()
                    }
                    else{
                        for i in taskerLocationArray{
//                            for j in userdata.items {
//                                if i.itemID == j.title{
//                                    taskermarkerDataArray.append(i)
                                    self.selectedMarkerTitle.append(i.itemID!)
                                    break
//                                }
//                            }
                        }
                        self.clusterManager.clearItems()
                        self.generateClusterItems()
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    break
                }
            }
            marker.iconView = OuterImgView
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
        print(marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.NoView.isHidden = true
        if marker.title == nil {
            let userdata: GMUCluster = marker.userData! as! GMUCluster
//            self.selectedMarkerTitle.removeAll()
//            self.selectedMarkerTitle.append(userdata.items[0].title!!)
            self.opened = true
            self.markerFrom = "tap"
            // zoom in on tapped cluster
//            self.mapView.animate(toZoom: mapView.camera.zoom + 1)
        } else {
            self.selectedMarkerTitle.removeAll()
            self.selectedMarkerTitle.append(marker.title!)
            self.opened = true
            self.markerFrom = ""
//            self.mapView.animate(toLocation: marker.position)
        }
        self.generateClusterItems()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.markerFrom = ""
        self.if_first = false
//        self.bottomToTopAnimate()
        print(position)
        if #available(iOS 14.0, *) {
            if self.locationManager.authorizationStatus == .denied{
                self.checkLocationAccess()
            }
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        //modified-AR
        //if status_code == 400{
        self.lat = "\(mapView.camera.target.latitude)"
        self.long = "\(mapView.camera.target.longitude)"
     //   let camera = GMSCameraPosition.camera(withLatitude:self.lat , longitude:self.long , zoom: 16.0)
        self.latitude = self.mapView.camera.target.latitude
        self.longitude = self.mapView.camera.target.longitude
//        if status_code == 400 && !isUser{
        if status_code == 400{ //Sathish
            if position.zoom <= 17{
                self.opened = false
                if isUser{
                    self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray as! NSMutableArray,reset:self.appdelegate?.reset ?? "")
                }
                else{
                    self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!)
                }
            }
        }
        else{
            if isUser{
                self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray as! NSMutableArray,reset:self.appdelegate?.reset ?? "")
            }
            else{
                self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!)
            }
        }
    }
    
}

//MARK: GET API Func

extension clusterMapViewController {
    //get formatted json from array
        func json(from object:Any) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        }
    func getTaskers(distance: String, distance_type: String, filter: NSMutableArray,reset:String){
        
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(reset, forKey: "reset")
        request.setValue(self.latitude, forKey: "lat") //
        request.setValue(self.longitude, forKey: "lon") //
        request.setValue(distance, forKey: "distance")  //LocalDefault.shared.Distance()
        request.setValue(distance_type, forKey: "distance_type")
        //LocalDefault.shared.DistanceType()
        if filter.count != 0{
            request.setValue(self.json(from: filter), forKey: "filter")
        }
        
        Obj.baseService(subURl: GET_TASKER, params: request as? Parameters, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(GetTaskerListModel.self, from: response.data!)
                self.status_code = model.statusCode ?? 0
                if model.statusCode == 200{
                    if model.tasker?.count != 0{
                        self.LocationArray = [Tasker]()
                        self.LocationArray.removeAll()
                        self.LocationArray = model.tasker!
//                        self.first_lat_lon.removeAll()
//                        self.first_lat_lon.append((self.LocationArray.first?.lat)!)
//                        self.first_lat_lon.append((self.LocationArray.first?.lon)!)
                        self.markerDataArray.removeAll()
//                        if !self.if_status_code_400{
                            self.selectedMarkerTitle.removeAll()
                            self.selectedMarkerTitle.append((self.LocationArray.first?.taskerID)!)
                            self.markerFrom = "open"
//                            self.animateMap(lat: (self.LocationArray.first?.lat)!, lon: (self.LocationArray.first?.lon)!) //sathish
//                        }
        
                        self.tableView.isHidden = false
                        self.NoView.isHidden = true
                        self.bottomView.isHidden = false
//                        if self.if_status_code_400{
////                            self.bottomView.isHidden = true
//                            self.NoView.isHidden = false
//                            self.selectedMarkerTitle.removeAll()
//                            self.selectedMarkerTitle.append("")
//                        }
//                        else{
                            self.opened = true
                            self.bottomView.isHidden = false
                            self.bottomToTopAnimate()
//                        }
                        self.generateClusterItems()
                        self.loader.stopAnimating()
                    } else{
                        self.loader.stopAnimating()
                    }
                }else if model.statusCode == 400{
                    self.if_status_code_400 = true
                    self.LocationArray.removeAll()
//                    self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                    self.bottomViewHeightConstraint.constant = CGFloat(100)
                    self.tableView.isHidden = true
                    self.NoView.isHidden = false
                    self.bottomView.isHidden = false
                    self.bottomToTopAnimate()
                    self.generateClusterItems()
                    self.loader.stopAnimating()
                    //qwerty
                    self.warningLbl.text = model.message ?? ""
                }
                else{
                    self.LocationArray.removeAll()
//                    self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                    self.bottomView.isHidden = false
                    self.bottomToTopAnimate()
                    self.loader.stopAnimating()
                    
                    //modified-AR
                    self.tableView.isHidden = true
                    self.NoView.isHidden = false
                    self.warningLbl.text = model.message ?? ""
                }
            }catch{
                
            }
        })
        
    }
    
    func getTask(distance: String, distance_type: String){
        
        let Obj = BaseAPI()
        let request = NSMutableDictionary()
        request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        request.setValue(self.latitude, forKey: "lat") //
        request.setValue(self.longitude, forKey: "lon") //
        request.setValue(distance, forKey: "distance") //LocalDefault.shared.Distance()
        request.setValue(distance_type, forKey: "distance_type") //LocalDefault.shared.DistanceType()
        
        Obj.baseService(subURl: GET_TASK, params: request as? Parameters, onSuccess: { [self]response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(GetTaskListModel.self, from: response.data!)
                self.status_code = model.statusCode ?? 0
                if model.statusCode == 200{
                    if model.items?.count != 0{
                        self.taskerLocationArray.removeAll()
                        self.taskerLocationArray = model.items!
//                        self.first_lat_lon.removeAll()
//                        self.first_lat_lon.append((self.taskerLocationArray.first?.lat)!)
//                        self.first_lat_lon.append((self.taskerLocationArray.first?.lon)!)
                   //     if !self.if_status_code_400{
                            self.selectedMarkerTitle.removeAll()
                            self.selectedMarkerTitle.append((self.taskerLocationArray.first?.itemID)!)
                            self.markerFrom = "open"
//                            self.animateMap(lat: (self.taskerLocationArray.first?.lat)!, lon: (self.taskerLocationArray.first?.lon)!) //sathish
                     //   }
                        
                        
                        self.NoView.isHidden = true
                        
                       // if self.if_status_code_400{
//                            self.bottomView.isHidden = true
//                            self.NoView.isHidden = false
//                            self.selectedMarkerTitle.removeAll()
//                            self.selectedMarkerTitle.append("")
                     //   }
                     //   else{
                            self.opened = true
                            self.bottomView.isHidden = false
                            self.bottomToTopAnimate()
                     //   }
                        
                        self.generateClusterItems()
                        self.loader.stopAnimating()
                    } else{
                        self.loader.stopAnimating()
                    }
                }else if model.statusCode == 400{
                    self.if_status_code_400 = true
                    self.taskerLocationArray.removeAll()
                    self.generateClusterItems()
                    self.loader.stopAnimating()
                   // self.bottomView.isHidden = false
//                    if self.if_first{
//                        self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                        self.bottomViewHeightConstraint.constant = CGFloat(100)
                        self.NoView.isHidden = false
                        self.bottomView.isHidden = false
                        self.bottomToTopAnimate()
//                    }
                }
                else{
                    self.taskerLocationArray.removeAll()
                    if if_first{
//                        self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                        self.bottomView.isHidden = false
                        self.bottomToTopAnimate()
                        self.NoView.isHidden = false
                    }
                    self.loader.stopAnimating()
                    //modified-AR
                    self.warningLbl.text = model.message ?? ""
                }
            }catch{
                
            }
        })
        
    }
    func animateMap(lat: String, lon: String){
        let lat = (lat as NSString).doubleValue
        let lon = (lon as NSString).doubleValue
        let camera = GMSCameraPosition(latitude: lat , longitude: lon , zoom: 17)
        self.mapView.camera = camera
//        self.mapView.animate(to: camera)
    }
}



//MARK: Animate Bottom Sheet

extension clusterMapViewController {
    
    func bottomToTopAnimate(){
        self.bottomView.center.y += self.bottomView.bounds.height
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
            
            self.bottomView.center.y -= self.bottomView.bounds.height
            self.bottomView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func topToBottomAnimate(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
            self.bottomView.center.y += self.bottomView.bounds.height - 25
            self.bottomView.layoutIfNeeded()
            
        },  completion: {(_ completed: Bool) -> Void in
            for i in self.bottomView.constraints{
                if i.identifier == "viewHeight"{
                    i.constant = 25
                    break
                }
            }
//            self.bottomView.isHidden = true
        })
    }
}


//MARK: Theme Change

extension clusterMapViewController {
    
    func UpdateTheme(){
        if #available(iOS 13.0, *) {
            if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
                overrideUserInterfaceStyle = .dark
                self.applyDarkMode()
            }else if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "light") as? NSString{
                overrideUserInterfaceStyle = .light
                self.mapView.mapStyle = nil
            }
        }
    }
    
    func applyDarkMode()  {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        //        self.view = mapView
    }
}

//MARK: Location Manger
extension clusterMapViewController{
    
    func ConfigLocationManger(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if self.appdelegate?.loctionString == ""
            {
                locationManager.startUpdatingLocation()
            }
        } else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func ConfigMapView(){
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.mapView.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 17)
        self.mapView.setMinZoom(0, maxZoom: 19.5)
        self.mapView.settings.rotateGestures = false
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if self.locationString == "" && self.appdelegate?.loctionString == "" {
            self.locationManager.startUpdatingLocation()
        }
        else {
            if(self.appdelegate?.loctionString != "")
           
            {
                self.searchTextField.text = self.appdelegate?.loctionString
                self.getLocationFromAddr(self.searchTextField.text!)
            }
            else
            {
            self.searchTextField.text = self.locationString
            self.getLocationFromAddr(self.searchTextField.text!)
            }
        }
        fetcher = GMSAutocompleteFetcher.init()
        fetcher?.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        session_token=GMSAutocompleteSessionToken.init()
        fetcher?.provide(session_token)
        let fetcherFilter = GMSAutocompleteFilter()
        fetcherFilter.type = .establishment
       // fetcherFilter.country = "IN"
        fetcher?.autocompleteFilter=fetcherFilter
     //   self.searchTextField.text = self.locationString
//        let camera = GMSCameraPosition(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0, zoom: 10)
//        self.mapView.animate(to: camera)
    }
    
    func changeLocationBtnFrame(){
        DispatchQueue.main.async {
            self.mapView.isMyLocationEnabled = true
           // self.mapView.settings.myLocationButton = true
            for obj in self.mapView.subviews{
                if String(describing: obj.classForCoder) == "GMSUISettingsPaddingView"{
                    for viw in obj.subviews{
                        if String(describing: viw.classForCoder) == "GMSUISettingsView"{
                            for btn in viw.subviews{
                                if String(describing: btn.classForCoder) == "GMSx_MDCFloatingButton"{
                                    let frame = btn.frame
                                    print("old : \(frame)")
                                    btn.frame = CGRect(x: frame.origin.x, y: 65, width: frame.width, height: frame.height)
                                    print("afer_change : \(btn.frame)")
                                    break
                                }
                            }
                            break
                        }
                    }
                    break
                }
            }
        }
        
    }
    
    func checkLocationAccess(){
        if #available(iOS 14.0, *) {
            if self.locationManager.authorizationStatus == .denied{
                let alertController = UIAlertController (title: "Allow \"Lucki.app\" to use your location", message: Utility.shared.Json().value(forKey: "location_permission_denied") as? String, preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = locationManager.location?.coordinate.latitude
        self.longitude = locationManager.location?.coordinate.longitude
        self.appDelegate?.current_lat = self.latitude
        self.appDelegate?.current_lon = self.longitude

        let location = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 16.0)
        self.mapView.animate(to: camera)
        self.lat = "\(location.coordinate.latitude)"
        self.long = "\(location.coordinate.longitude)"
        //        self.marker.position = location.coordinate
        //        self.marker.map = self.mapView
        // Set Current Location
        self.updateLocation(location.coordinate) { (location) in
            if self.locationString != "" && self.appdelegate?.loctionString != "" {
                self.searchTextField.text = self.appdelegate?.loctionString
                self.getLocationFromAddr(self.searchTextField.text!)
            }
            else {
                    self.searchTextField.text = location
                }
        }
        if self.isUser{
            self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray,reset:self.appdelegate?.reset ?? "")
        } else{
            let json_Decoder = JSONDecoder()
            let profile = try? json_Decoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
//            if profile?.payment_verified == "false"{
            if !(LocalDefault.shared.get_paymentAdded()){
                loader.stopAnimating()
                self.bottomView.isHidden = false
                self.PaymentView.isHidden = false
                self.animateMap(lat: String(self.latitude), lon: String(self.longitude))
                self.bottomToTopAnimate()
            }
            else{
                self.PaymentView.isHidden = true
                self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!) //
            }
        }
//        let camera = GMSCameraPosition(latitude: self.latitude , longitude: self.longitude , zoom: 15)
//        self.mapView.animate(to: camera)
        
        
//        if first_lat_lon.count != 0{
//            let lat = (first_lat_lon[0] as NSString).doubleValue
//            let lon = (first_lat_lon[1] as NSString).doubleValue
//            let camera = GMSCameraPosition(latitude: lat , longitude: lon , zoom: 19.5)
//            self.mapView.animate(to: camera)
//        }
//        else{
//
//        }
        

        
//        let camera = GMSCameraPosition(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0, zoom: 10)
        
        locationManager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways:
                self.locationManager.requestAlwaysAuthorization()
            case .authorizedWhenInUse:
                self.locationManager.requestWhenInUseAuthorization()
            case .denied:
                checkLocationAccess()
            case.restricted:
                locationManager.requestWhenInUseAuthorization()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}


//MARK: Filter View funcnolity
extension clusterMapViewController {
    @IBAction func filterBtnTapped(_ sender: Any) {
        if self.isUser{
        if self.FilterArray.count != 0{
            self.presentFilterViewController()
        }
        else{
            self.getSubCategory()
        }}
        else{
            let notifyObj = NotificationPage()
            self.navigationController?.pushViewController(notifyObj, animated: true)
        }
    }
    func presentFilterViewController(){
        let obj = FilterPageVC()
        obj.modalPresentationStyle = .overCurrentContext
        obj.subcategories = self.FilterArray
        obj.filterArray.removeAllObjects()
        obj.filterArray.addObjects(from: self.selectedFilterArray as! [Any])
        print("cluster_send \(self.selectedFilterArray)")
        
        obj.refreshMap = { filterArray in
            
            print("cluster_recive \(filterArray)")
            self.selectedFilterArray.removeAllObjects()
            if filterArray.count != 0{
                self.selectedFilterArray.addObjects(from: filterArray as! [Any])
            }
            self.filterindexupdate()
            self.bottomView.isHidden = true
            self.loader.startAnimating()
            self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray,reset:self.appdelegate?.reset ?? "")
        }
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func myServiceTapped(_ sender: Any) {
        self.navigationController?.pushViewController(MyServicesCategory(), animated: true)
    }
    
    //getSubCategory from web end
    func getSubCategory() {
        self.loader.startAnimating()
        let Obj = BaseAPI()
        Obj.getDetails(subURl: GET_SUBCATEGORIES, onSuccess: {response in
            do{
                let jsonDecoder = JSONDecoder()
                let model = try? jsonDecoder.decode(GetSubcategoryModel.self, from: response.data!)
                if model!.statusCode == 200{
                    self.FilterArray.removeAll()
                    self.FilterArray = model!.subcategories
                    self.loader.stopAnimating()
                    self.presentFilterViewController()
                }
                else{
                    self.loader.stopAnimating()
                }
            }catch{
                
            }
        })
    }
}

//MARK: view funcionts for bottom view actions
extension clusterMapViewController {
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        var count = Int()
    //        if isUser{
    //            count = markerDataArray.count
    //        }
    //        else{
    //            count = taskermarkerDataArray.count
    //        }
    //        for i in bottomView.constraints{
    //            if i.identifier == "viewHeight"{
    //                if i.constant == 20{
    //                    if count <= 3 {
    //                        i.constant = CGFloat(count * 100+20)
    //                        self.bottomToTopAnimate()
    //                        self.bottomToTopAnimate()
    //                        break
    //                    } else{
    //                        i.constant = CGFloat(320)
    //                        self.bottomToTopAnimate()
    //                        self.bottomToTopAnimate()
    //                        break
    //                    }
    //                }
    //                else{
    //                    self.topToBottomAnimate()
    //                    break
    //                }
    //        }
    //    }
    //    }
//        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            let touch = touches.first
//            if (touch?.location(in: self.bottomView) == touch?.previousLocation(in: self.bottomView) && NoView.isHidden){
//                let count = isUser ? markerDataArray.count : taskermarkerDataArray.count
//                for i in bottomView.constraints{
//                    if i.identifier == "viewHeight"{
//                        if i.constant == 25{
//                            if count <= 3 {
//                                i.constant = CGFloat(count * 100+20)
//                                self.bottomToTopAnimate()
//                                self.bottomToTopAnimate()
//                                break
//                            } else{
//                                i.constant = CGFloat(320)
//                                self.bottomToTopAnimate()
//                                self.bottomToTopAnimate()
//                                break
//                            }
//                        }
//                        else{
//                            self.topToBottomAnimate()
//                            break
//                        }
//                }
//            }
//            }
//        }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        var size: Int!
//        size = isUser ? markerDataArray.count : taskermarkerDataArray.count
//
//        if let touch = touches.first{
//            let currentTouchPoint = touch.location(in: self.bottomView)
//            let previousTouchPoint = touch.previousLocation(in: self.bottomView)
//
//            let deltaY = currentTouchPoint.y - previousTouchPoint.y
//            for const in bottomView.constraints{
//                if const.identifier == "viewHeight"{
//
//                    if ((CGFloat(size * 100 + 20) > CGFloat(const.constant - deltaY)) && CGFloat(const.constant - deltaY) < 320 && CGFloat(const.constant - deltaY) > 25){
//                        const.constant -= deltaY
//                    }
//                }
//            }
//
//        }
//
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
    }
    //get place information by placeid via google place client
    func getPlaceDataByPlaceID(pPlaceID: String){
        self.placesClient1.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.placeName = String(describing: place.name!)
                print("NAME : \(String(describing: place.name)) COORDINATE : \(place.coordinate)")
                self.getAddress(lat: place.coordinate.latitude, lon: place.coordinate.longitude)
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 17.0)
                self.mapView?.animate(to: camera)
                self.session_token = GMSAutocompleteSessionToken.init()
                self.fetcher?.provide(self.session_token)
                self.latitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                if self.isUser{
                    self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray as! NSMutableArray,reset:self.appdelegate?.reset ?? "")
                }
                else{
                    self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!)
                }
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }
}
extension clusterMapViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      self.session_token = GMSAutocompleteSessionToken.init()
      self.fetcher?.provide(self.session_token)
      self.locationManager.stopUpdatingLocation()
      locationManager.stopMonitoringSignificantLocationChanges()
      self.dropDown.hide()
      return true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
      self.searchForRide(textField: textField)
      print(textField.text!)
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
      //        textField.resignFirstResponder()
      self.searchForRide(textField: textField)
      return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
  {
      if string.containsEmoji() {
          return false
      }
      self.city = ""
      self.state = ""
      self.country = ""
      self.lat = ""
      self.long = ""
      fetcher?.sourceTextHasChanged(textField.text!+string)
      return true
  }
  func searchForRide(textField:UITextField)  {
      textField.resignFirstResponder()
  }
}
extension clusterMapViewController:GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("your Auto Complete Error is \(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func updateLocation(_ coordinate: CLLocationCoordinate2D, location: @escaping (String) -> Void) {
        let geocoder = GMSGeocoder()
        var locString = ""
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                self.city = address.locality ?? ""
                self.state = address.administrativeArea ?? ""
                self.country = address.country ?? ""
                locString = lines.joined(separator: "\n")
            }
            location(locString)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                let point = mapView.center
                let coordinates = mapView.projection.coordinate(for: CGPoint(x: point.x, y: point.y))
                
                self.lat = "\(coordinates.latitude)"
                self.long = "\(coordinates.longitude)"
                self.latitude = Double(coordinates.latitude)
                self.longitude = Double(coordinates.longitude)
                self.updateLocation(coordinates) { (location) in
                    self.searchTextField.text = location
                }
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        self.getPlaceDataByPlaceID(pPlaceID: placeID)
    }
    
    func getLocationFromAddr(_ location: String) {
       locationModel.loadLocationData(address: location, onSuccess: { (result) in
            if result["status"].stringValue == "OK" {
                for addressDict in result["results",0,"address_components"].arrayValue {
                    let type = addressDict["types"].arrayValue
                    if type.contains("locality") {
                        self.city = addressDict["long_name"].stringValue
                    }
                    else if type.contains("administrative_area_level_1") {
                        self.state = addressDict["long_name"].stringValue
                    }
                    else if type.contains("country") {
                        self.country = addressDict["long_name"].stringValue
                    }
                }
                self.locationString = self.searchTextField.text!
           //     self.appdelegate?.loctionString = self.searchTextField.text!
                self.lat = result["results",0,"geometry","location","lat"].stringValue
                self.long = result["results",0,"geometry","location","lng"].stringValue
                
                let camera = GMSCameraPosition.camera(withLatitude: result["results",0,"geometry","location","lat"].doubleValue, longitude: result["results",0,"geometry","location","lng"].doubleValue, zoom: 16.0)
                self.mapView.isHidden = false
                self.markerButton.isHidden = false
                self.mapView.animate(to: camera)
                self.latitude = result["results",0,"geometry","location","lat"].doubleValue
                self.longitude = result["results",0,"geometry","location","lng"].doubleValue
                if self.isUser{
                    self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray as! NSMutableArray,reset:self.appdelegate?.reset ?? "")
                }
                else{
                    self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!)
                }
               // self.setLocationButton.isUserInteractionEnabled = true
                //                self.mapView.camera = camera
                //                self.marker.position = CLLocationCoordinate2D(latitude: result["results",0,"geometry","location","lat"].doubleValue, longitude: result["results",0,"geometry","location","lng"].doubleValue)
                //                self.marker.map = self.mapView
            }
        }) { (failure) in
        }
    }
    func reverseGeoCoding(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                return
            }
        }
    }
    //get full address
    func getAddress(lat: Double,lon: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail")
                                        }
                                        if placemarks != nil {
                                            let pm = placemarks! as [CLPlacemark]
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                var addressString : String = ""
                                                if self.placeName != ""{
                                                    addressString = addressString + self.placeName + ", "
                                                }
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }
                                                print("addressString:: \(addressString)")
                                                self.searchTextField.text = addressString
                                                self.placeName = ""
                                            }
                                        }
                                    })
        if self.isUser{
            self.getTaskers(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!, filter: self.selectedFilterArray as! NSMutableArray,reset:self.appdelegate?.reset ?? "")
        }
        else{
            self.getTask(distance: LocalDefault.shared.Distance()!, distance_type: LocalDefault.shared.DistanceType()!)
        }
    }
}
extension clusterMapViewController: GMSAutocompleteFetcherDelegate {
  
  func didFailAutocompleteWithError(_ error: Error) {
      print("Did Fail Auto Complete With Error :\(error.localizedDescription)")
      
  }
  
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
      self.locationArray.removeAllObjects()
      for prediction in predictions{
          let mutableDict = NSMutableDictionary()
          print("prediction value in predictions : \(prediction)")
          mutableDict.setValue(prediction.attributedPrimaryText.string, forKey: "address_first")
          mutableDict.setValue(prediction.attributedSecondaryText?.string, forKey: "address_second")
          mutableDict.setValue(prediction.placeID, forKey: "placeID")
          mutableDict.setValue(prediction.attributedFullText.string, forKey: "address_full")
          self.locationArray.addObjects(from: [mutableDict])
      }
      if self.locationArray.count == 0
      {
          self.dropDown.hide()
      }
      else
      {
          configDropDownView()
          DispatchQueue.main.async {
              self.dropDown.show()
          }
      }
  }
  func configDropDownView() {
      dropDown.anchorView = self.searchView
      dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
      dropDown.width = self.searchView.frame.width
      dropDown.semanticContentAttribute = .unspecified
      _ = self.locationArray
      var countryArray = [String]()
      for country in self.locationArray {
          let countryDict = country as! Dictionary<String, Any>
          countryArray.append(countryDict["address_full"] as? String ?? "")
      }
      dropDown.dataSource = countryArray
      dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//          self.setLocationButton.isUserInteractionEnabled = false
          self.searchTextField.text = item
          self.searchTextField.endEditing(true)
          //            let countryDict = self.locationArray[index] as! Dictionary<String, Any>
          self.getLocationFromAddr(item)
          print("Selected item: \(item) at index: \(index)")
          self.appdelegate?.loctionString = item
      }
  }
}



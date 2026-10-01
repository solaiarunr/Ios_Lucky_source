//
//  MapPage.swift
//  iDemand
//
//  Created by Roby on 28/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapPage: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GMSMapViewDelegate,socketDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var mapIcon: UIImageView!
    @IBOutlet var locationTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var locationArray = NSMutableArray()
    var fetcher: GMSAutocompleteFetcher?
    var session_token = GMSAutocompleteSessionToken()
    let placesClient = GMSPlacesClient.shared()
    let locationManager = CLLocationManager()
    var currentLocation: ((_ lat:Double ,_ lon:Double,_ address:String) -> Void)?
    
    var polyLineCron = Timer()
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var grabEnable = Bool()
    var isValidLocation = false
    
    var drawOnce = Bool()
    var moveCamera = Bool()
    var animationEnable = Bool()
    var routeArray = NSArray()
    var taskerID = String()
    var locationCron = Timer()
    var viewType = String()
    var locationType = String()
    var lat = Double()
    var lon = Double()
    var pickUpCoordination = CLLocationCoordinate2D()
    var dropCoordination = CLLocationCoordinate2D()
    var currentLoc = CLLocationCoordinate2D()
    var isFromChat = false
    var placeName = ""
    var dict:String = ""
    var selectyes = false
    let markerTasker = GMSMarker()
    
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
        self.shareBtn.topRadius()
        self.locationTableView.frame.origin.y = self.searchTF.frame.size.height + self.searchTF.frame.origin.y + 20
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
                overrideUserInterfaceStyle = .dark
                self.applyDarkMode()
                self.searchTF.backgroundColor = BACKGROUND_COLOR
            }else if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "light") as? NSString{
                overrideUserInterfaceStyle = .light
                self.searchTF.backgroundColor = LINE_COLOR
            }else{
                self.searchTF.backgroundColor = LINE_COLOR
            }
        }
    }
    //arabic
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.clearButtonMode = .never
            self.searchTF.addPadding(left: false)
            self.searchTF.textAlignment = .right
        }else{
            self.searchTF.addPadding(left: true)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if viewType == "tracking"{
            UIApplication.shared.isIdleTimerDisabled = false
            self.polyLineCron.invalidate()
            self.locationCron.invalidate()
        }
    }
    //initial setup
    func initialSetup()  {
//        GMSServices.provideAPIKey(GOOGLE_API_KEY)
//        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        
        self.searchTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "search_location")
        self.searchTF.radius(value: 10.0)
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "location")
        self.shareBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "share")
        locationTableView.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
        self.locationTableView.isHidden = true
        self.shareBtn.backgroundColor = PRIMARY_COLOR
        self.navigationView.backgroundColor = PRIMARY_COLOR
        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        if viewType == "edit"{
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
            self.mapView?.animate(to: camera)
        }
        else if viewType == "view" || viewType == "tracking"  {
            self.shareBtn.isHidden = true
            self.searchTF.isHidden = true
            self.configTrackInformation()
            UIApplication.shared.isIdleTimerDisabled = true

        }
        if !LocalDefault.shared.isLiveTrack()!{
            self.searchTF.isHidden = true
        }
        
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.shareBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        self.checkRTL()
    }
    
    //config track location
    func configTrackInformation()  {
        if viewType == "tracking"{
            self.mapIcon.isHidden = true
            SocketClass.sharedInstance.delegate = self
            self.getLiveLocation()
            self.locationCron = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getLiveLocation), userInfo: nil, repeats: true)
            self.markerTasker.icon = #imageLiteral(resourceName: "tasker_icon")
            
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.appDelegate?.current_lon = locationManager.location?.coordinate.longitude ?? 0
        self.appDelegate?.current_lat = locationManager.location?.coordinate.latitude ?? 0
        let location = locations.last
        
        if viewType == "view"{
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
            self.mapView?.animate(to: camera)
        }else if viewType == "tracking"{
            self.getPolylineRoute()
            self.locationManager.stopUpdatingLocation()
        }
//        modified-AR
        else if viewType == "edit"{
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
            self.mapView?.animate(to: camera)
        }
        else{
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
            self.mapView?.animate(to: camera)
        }
        self.currentLoc = location!.coordinate
        
        if LocalDefault.shared.isLiveTrack()!{
            self.setBounds(coordinate: location!.coordinate)
        }
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    //select btn tapped
    @IBAction func shareBtnTapped(_ sender: Any) {
        if isValidLocation {
            let coordinate = mapView.projection.coordinate(for: mapView.center)
            self.currentLocation!(coordinate.latitude,coordinate.longitude, self.searchTF.text!)
            self.dismiss(animated: true, completion: nil)
        }else{
            Utility.shared.showToast(msg: "choose_valid_location")
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        print("Latitude: \(location.latitude) & Longitude: \(location.longitude) & PlaceID: \(placeID)& name: \(name)")
        self.getPlaceDataByPlaceID(pPlaceID: placeID)
        
    }
    
    
    //MARK: TextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isValidLocation = false
        self.session_token = GMSAutocompleteSessionToken.init()
        self.fetcher?.provide(self.session_token)
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        self.locationTableView.isHidden = true
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.searchTF.text != "" && self.lat != 0 && self.lon != 0 {
            self.isValidLocation = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let location = textField.text!+string
        self.lat = 0
        self.lon = 0
        if location.count > 2 {
            fetcher?.sourceTextHasChanged(location)
        }else{
            self.locationTableView.isHidden = true
        }
        return true
    }
}

//MARK: Location auto complete fetcher
extension MapPage: GMSAutocompleteFetcherDelegate{
    //autocompletion result
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.locationArray.removeAllObjects()
        for prediction in predictions{
            let mutableDict = NSMutableDictionary()
            mutableDict.setValue(prediction.attributedPrimaryText.string, forKey: "address_first")
            mutableDict.setValue(prediction.attributedSecondaryText?.string, forKey: "address_second")
            mutableDict.setValue(prediction.attributedFullText.string, forKey: "address_full")
            mutableDict.setValue(prediction.placeID, forKey: "google_place_id")
            self.locationArray.addObjects(from: [mutableDict])
        }
        print(self.locationArray)
        if locationArray.count == 0{
            self.locationTableView.isHidden = true
        }else{
            self.locationTableView.isHidden = false
            self.locationTableView.reloadData()
        }
    }
    //autocompletion failed
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    //get location when idle
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle location ")
        if LocalDefault.shared.isLiveTrack()!{
            
            if self.viewType != "tracking" {
                
                lat = mapView.camera.target.latitude
                lon = mapView.camera.target.longitude
                //        let centerIcon = mapView.projection.coordinate(for: mapIcon.center)
                //        lat = centerIcon.latitude
                //        lon = centerIcon.longitude
                let coordinate = CLLocationCoordinate2DMake(Double(lat),lon)
                self.getAddress(lat: coordinate.latitude, lon: coordinate.longitude)
            }
        }
        else if isFromChat {
            
            lat = mapView.camera.target.latitude
            lon = mapView.camera.target.longitude
            //        let centerIcon = mapView.projection.coordinate(for: mapIcon.center)
            //        lat = centerIcon.latitude
            //        lon = centerIcon.longitude
            let coordinate = CLLocationCoordinate2DMake(Double(lat),lon)
            self.getAddress(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.locationTableView.isHidden = true

    }
    
    //set filter bounds to fetch near by location as first
    func setBounds(coordinate:CLLocationCoordinate2D) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let mylocation = CLLocationCoordinate2D.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let bounds = GMSCoordinateBounds.init(coordinate: mylocation, coordinate: mylocation)
        //        fetcher = GMSAutocompleteFetcher.init(filter: filter)
        fetcher = GMSAutocompleteFetcher.init(bounds:bounds , filter:filter)
        fetcher?.delegate = self
    }
    
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationObj = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
        let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row) as! NSDictionary
        var second_add = String()
        if locationDict.value(forKey: "address_second") == nil {
            second_add = locationDict.value(forKey: "address_full") as! String
        }else{
            second_add = locationDict.value(forKey: "address_second") as! String
        }
        locationObj.addressLbl.text = (locationDict.value(forKey: "address_first") as! String)
        locationObj.fullAddressLbl.text = second_add
        return locationObj
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row) as! NSDictionary
        self.appDelegate?.addressDict = locationDict
        let place_id = locationDict.value(forKey: "google_place_id") as! String
//       self.getGeoCode(address: locationDict.value(forKey: "address_full") as! String, placeID: place_id)
        self.getPlaceDataByPlaceID(pPlaceID: place_id)
        self.isValidLocation = true
        self.selectyes = true
        self.dict = locationDict.value(forKey: "address_full") as! String
       // self.getLocationFromAddr(self.searchTF.text!)
        self.locationTableView.isHidden = true
    }
    
    //get place information by placeid via google place client
    func getPlaceDataByPlaceID(pPlaceID: String){
        self.placesClient.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.locationTableView.isHidden = true
                self.placeName = String(describing: place.name!)
                print("NAME : \(String(describing: place.name)) COORDINATE : \(place.coordinate)")
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
                self.mapView?.animate(to: camera)
                self.session_token = GMSAutocompleteSessionToken.init()
                self.fetcher?.provide(self.session_token)
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }
    
    //get full details from geo code
    func getGeoCode(address:String,placeID:String)  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.getPlaceDataByPlaceID(pPlaceID: placeID)
            }
            if let placemark = placemarks?.first {
                self.locationTableView.isHidden = true
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.lat = coordinates.latitude
                self.lon = coordinates.longitude
                let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 15.0)
                self.mapView?.animate(to: camera)
            }
        })
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
                                                self.isValidLocation = true
                                                if(self.selectyes == true)
                                                {
                                                    self.searchTF.text  = self.dict
                                                    self.selectyes = false
                                                }
                                                else
                                                {
                                                self.searchTF.text = addressString
                                                    self.placeName = ""
                                                }
                                            }
                                        }
                                    })
    }

    //get location details from google api
    func getPolylineRoute(){
        let apiObj = BaseAPI()
        var destination = CLLocationCoordinate2D()
        if locationType == "home"{
            destination = currentLoc
        }else{
            destination = self.dropCoordination
        }
        //qwerty
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // your code here
        apiObj.getLocation(destinationCoordination: destination, pickupCoordination: self.pickUpCoordination, onSuccess: {response in
            let responseDict = response.value as! NSDictionary
            let status:String = responseDict.value(forKey: "status") as! String
            if destination.longitude == 0.0 || destination.latitude == 0.0 {
                self.getPolylineRoute()
            }
            if status == "OVER_QUERY_LIMIT"{
                self.getPolylineRoute()
            }else  if status == "ZERO_RESULTS"{
                
            }else{
                self.routeArray = responseDict.value(forKey:"routes") as! NSArray
                self.drawRoute()
            }
        }, onProgress: {errorResponse in
        })
//        }
    }
    
    //MARK: Draw polyline routes
    func drawRoute() {
        
        if (self.routeArray.count > 0)
        {
            if !drawOnce {
                drawOnce = true
                let routeDict = routeArray[0] as! Dictionary<String, Any>
                let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
                let points = routeOverviewPolyline["points"]
                self.path = GMSPath.init(fromEncodedPath: points as! String)!
                self.polyline.path = path
                self.polyline.strokeWidth = 3.0
                self.polyline.strokeColor = PRIMARY_COLOR!
                self.polyline.map = self.mapView
                if !moveCamera{
                    moveCamera = true
                    let mapBounds = GMSCoordinateBounds(path: self.path)
                    let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
                    mapView.moveCamera(cameraUpdate)
                    self.animatePolylinePath()
                    //                    self.polyLineCron = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
                }
            }
        }
        
    }
    //animate polyline with stroke color
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = PRIMARY_COLOR!
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    func applyDarkMode()  {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view = mapView
    }
}
//MARK: LIVE TRACKING

extension MapPage{
    //get tasker current location
    @objc func getLiveLocation()  {
        let locationDict = NSMutableDictionary()
        locationDict.setValue("getLocation", forKey: "type")
        locationDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
        locationDict.setValue(self.taskerID, forKey: "tasker_id")
        SocketClass.sharedInstance.send(msg: locationDict)
        self.showLocationTipView()
    }
    
    //MARK: SOCKET CLASS
    func gotSocket(msg: NSDictionary, type: String) {
        print("SOCKET MSG : \(msg)")
        if type == "receiveMessage"{
            let msgType = msg.value(forKey: "type") as! NSString
            if msgType == "getLocation"{
                let currentLat = msg.value(forKey: "lat") as! NSNumber
                let currentLon = msg.value(forKey: "lon") as! NSNumber
                
                let oldlat = Double(self.markerTasker.position.latitude)
                let oldlong = Double(self.markerTasker.position.longitude)
                let old = CLLocationCoordinate2D(latitude: oldlat , longitude: oldlong )
                let new = CLLocationCoordinate2D(latitude:currentLat.doubleValue , longitude: currentLon.doubleValue)
                let calBearing: Float = self.getHeadingForDirection(fromCoordinate: old, toCoordinate: new)
                self.markerTasker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                if calBearing != 0{
                    self.markerTasker.rotation = CLLocationDegrees(calBearing);
                }//found bearing value by calculation when marker add
                self.markerTasker.position = old; //this can be old position to make car movement to new position
                //marker movement animation
                CATransaction.begin()
                CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock({() -> Void in
                    if calBearing != 0{
                        self.markerTasker.rotation =  CLLocationDegrees(calBearing)
                    }
                    //found bearing value by calculation when marker add
                })
                self.markerTasker.position = new; //this can be new position after car moved from old position to new position with animation
                self.markerTasker.map = self.mapView;
                if calBearing != 0{
                    self.markerTasker.rotation = CLLocationDegrees(calBearing);
                }
                CATransaction.commit()
            }
        }
    }
    
    //MARK: Show marker tip view
    func showLocationTipView()  {
        let markerStart = GMSMarker()
        markerStart.position = CLLocationCoordinate2D(latitude: self.pickUpCoordination.latitude, longitude: self.pickUpCoordination.longitude)
        let markerStartView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerStartView.image = #imageLiteral(resourceName: "pickup_locatioon")
        markerStartView.contentMode = .scaleAspectFit
        markerStart.iconView = markerStartView
        markerStart.map = mapView
        
        let markerEnd = GMSMarker()
        if locationType == "home" {
            markerEnd.position = CLLocationCoordinate2D(latitude: self.currentLoc.latitude, longitude: self.currentLoc.longitude)
        }else{
            markerEnd.position = CLLocationCoordinate2D(latitude: self.dropCoordination.latitude, longitude: self.dropCoordination.longitude)
        }
        let markerEndView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerEndView.image = #imageLiteral(resourceName: "drop_location")
        markerEndView.contentMode = .scaleAspectFit
        markerEnd.iconView = markerEndView
        markerEnd.map = mapView
    }
    
    //MARK: NAVIGATION ROTATION
    
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        return (degree >= 0) ? degree : (360 + degree)
    }
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
}

//
//  LocationPage.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class LocationPage: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!    
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var noLbl: UILabel!
    
    var locationArray = NSMutableArray()
    var tempLocation = NSMutableArray()
    var didSelectedLocation: ((_ location:String) -> Void)?
    var selectedLocation = String()
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
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "search_location")
        locationTableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        self.noLbl.config(color: TEXT_LITE_COLOR!, font: headReg, align: .center, text: "no_location")
        self.navigationView.backgroundColor = PRIMARY_COLOR
        let appDefault = LocalDefault.shared.appDefaults()
        self.locationArray.addObjects(from: appDefault?.value(forKey: "cities") as! [Any])
        self.tempLocation.addObjects(from: appDefault?.value(forKey: "cities") as! [Any])
        self.searchTF.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, place: "search_your_location")
        self.searchTF.leftPadding()
        self.searchTF.radius(value: 10)
        self.searchTF.backgroundColor = SEARCH_BG_COLOR
        self.checkAvailablity()
        if Utility.shared.isRTL(){
                 self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
                 self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)

            self.searchTF.clearButtonMode = .never
            self.searchTF.addPadding(left: false)
            self.searchTF.textAlignment = .right
        }else{
            self.searchTF.addPadding(left: true)

        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location : String? = self.locationArray[indexPath.row] as? String

        if location != nil{
            cell.locationLbl.text = location
        }else{
            cell.locationLbl.text = ""
        }
        if selectedLocation == location{
            cell.tickIcon.isHidden = false
            cell.tickIcon.image = #imageLiteral(resourceName: "tick_icon")
        }else{
            cell.tickIcon.isHidden = true
        }
        if Utility.shared.isRTL(){
                     cell.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                    cell.tickIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
                 }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation = (locationArray[indexPath.row] as! String)
        self.locationTableView.reloadData()
        self.didSelectedLocation!(self.selectedLocation)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Textfield delegate
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        locationTableView.isHidden = false
        locationArray = tempLocation.mutableCopy() as! NSMutableArray
        self.checkAvailablity()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if tempLocation.count == 0 {
        } else {
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            locationTableView.isHidden = true
            locationArray.removeAllObjects()
            // remove all data that belongs to previous search
            if (newString == "") || newString == nil {
                locationTableView.isHidden = false
                locationArray = tempLocation.mutableCopy() as! NSMutableArray
                self.checkAvailablity()
                return true
            }
            var counter: Int = 0
            for locationName in tempLocation {
                let location = locationName as! String
                let range = location.range(of: newString!, options: NSString.CompareOptions.caseInsensitive, range: nil,locale: nil)
                if range != nil {
                    self.locationArray.add(locationName)
                }
                counter += 1
            }
            self.checkAvailablity()
        }
        return true
    }
    
    //check contacts available or not
    func checkAvailablity()  {
        if locationArray.count == 0 {
            self.locationTableView.isHidden = true
            self.noLbl.isHidden = false
        }else{
            self.locationTableView.isHidden = false
            self.locationTableView.reloadData()
            self.noLbl.isHidden = true
        }
    }
}

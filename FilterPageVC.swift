//
//  FilterPageVC.swift
//  iDemand
//
//  Created by HTS-105 on 28/01/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//


import UIKit
class FilterPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    var subcategories = [Subcategory1]()
    var filterArray = NSMutableArray()
    var refreshMap: ((_ filterArray: NSMutableArray) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    override func viewDidLayoutSubviews() {
        self.bottomView.topRadius()
        DispatchQueue.main.async {
            self.applyBtn.corner(position: .topRight)
            self.resetBtn.corner(position: .topLeft)
        }
        //        self.applyBtn.corner(position: .topRight)
        //        self.resetBtn.corner(position: .topLeft)
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.applyBtn.corner(position: .topRight)
//        self.resetBtn.corner(position: .topLeft)
    }
    func initialSetup(){
        self.applyBtn.backgroundColor = PRIMARY_COLOR
        self.resetBtn.backgroundColor = SECONDARY_COLOR
        self.applyBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "apply")
        self.resetBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "reset")
        self.serviceLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "services")
        //register cell
        self.filterTableView.register(UINib(nibName: "filterTableCell", bundle: nil), forCellReuseIdentifier: "filterCell")
        self.filterTableView.separatorStyle = .none
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self

        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        self.bottomView.backgroundColor = BACKGROUND_COLOR
        self.filterTableView.backgroundColor = BACKGROUND_COLOR
        self.filterTableView.reloadData()
    }

//    func getSubCat() {
//        let Obj = BaseAPI()
//        Obj.getDetails(subURl: GET_SUBCATEGORIES, onSuccess: {response in
//            do{
//                let jsonDecoder = JSONDecoder()
//                let model = try? jsonDecoder.decode(GetSubcategoryModel.self, from: response.data!)
//                if model!.statusCode == 200{
//                    self.subcategories.removeAll()
//                    self.subcategories = model!.subcategories
//                    self.filterTableView.reloadData()
//                }
//                else{
//                }
//            }catch{
//
//            }
//        })
//    }
    
    //MARK: TableViewMethods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! filterTableCell
        cell.checkBoxBtn.tag = indexPath.row
        cell.checkBoxBtn.addTarget(self, action: #selector(checkBoxBtnTapped(sender:)), for: .touchUpInside)
        
        cell.itemLbl.text = self.subcategories[indexPath.row].subcategoryName
        cell.indexpath_row = indexPath.row
        cell.selectionStyle = .none
        if filterArray.contains(self.subcategories[indexPath.row].id){
            cell.itemLbl.textColor = PRIMARY_COLOR
            cell.checkBox.borderColor = PRIMARY_COLOR
            cell.subCategoryID = self.subcategories[indexPath.row].id
            cell.checkBox.setOn(true)
        }
        else{
            cell.itemLbl.textColor = TEXT_BLACK_COLOR
            cell.checkBox.borderColor = LINE_COLOR
            cell.subCategoryID = self.subcategories[indexPath.row].id
            cell.checkBox.setOn(false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filterArray.contains(self.subcategories[indexPath.row].id){
            self.filterArray.remove(self.subcategories[indexPath.row].id)
        }
        else{
            self.filterArray.add(self.subcategories[indexPath.row].id)
        }
        self.filterTableView.reloadData()
        print(filterArray)
    }
    
    //MARK: custom checkbox button funcion
    @objc func checkBoxBtnTapped(sender:UIButton){
        let btnSender: UIButton = sender
        if self.filterArray.contains(self.subcategories[btnSender.tag].id){
            self.filterArray.remove(self.subcategories[btnSender.tag].id)
        }
        else{
            self.filterArray.add(self.subcategories[btnSender.tag].id)
        }
        self.filterTableView.reloadData()
        print(filterArray)
    }
    @IBAction func resetBtnTapped(_ sender: Any) {
        self.filterArray.removeAllObjects()
        LocalDefault.shared.clearFilterArray()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.FilterArray.removeAllObjects()
        delegate.reset = "true"
        self.refreshMap!(filterArray)
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func applyBtnTapped(_ sender: Any) {
        LocalDefault.shared.setFilterArray(filter: self.filterArray)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.FilterArray.removeAllObjects()
        if self.filterArray.count != 0{
            delegate.FilterArray.addObjects(from: self.filterArray as! [Any])
        }
        self.refreshMap!(filterArray)
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  CertificatePage.swift
//  iDemand
//
//  Created by Roby on 29/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MobileCoreServices
import TCProgressBar

class CertificatePage: UIViewController,UIDocumentPickerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource , UIImagePickerControllerDelegate{
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var certificateTableView: UITableView!
    @IBOutlet var uploadView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var infoTV: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var uploadIcon: UIImageView!
    @IBOutlet var UploadLbl: UILabel!
    
    
    var viewType = String()
    
    let certificateArray = NSMutableArray()
    let apiObj =  BaseAPI()
    var currentUploadIndex = -1
    var isProgressing = false
    var uploadLimit = 0
    var desHeight = CGFloat()
    var picker = UIImagePickerController()
    var addedLine = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
//        if !addedLine{
//            self.uploadView.frame.size.width = FULL_WIDTH - 40
//            self.uploadIcon.frame.origin.x = (self.uploadView.frame.size.width/2) - 9
//            self.uploadView.addDottedLine()
//            self.addedLine = true
//        }
        self.uploadView.addDottedLine()

        self.nextBtn.topRadius()
        let topPadding = CGFloat(self.certificateArray.count*90)+15
        self.certificateTableView.frame =  CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height:topPadding)
        infoTV.frame = CGRect.init(x: 20, y: topPadding, width: FULL_WIDTH-40, height:infoTV.contentSize.height)
        self.scrollView.contentSize = CGSize.init(width: FULL_WIDTH, height: self.infoTV.frame.origin.y + self.infoTV.contentSize.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.infoTV.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.infoTV.textAlignment = .right
            
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //initial setup
    func initalSetup()  {
        self.addLoader()
        self.certificateTableView.reloadData()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        certificateTableView.register(UINib(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        self.certificateTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 80, right: 0)
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_certificate")
        self.UploadLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "upload_description")
        self.UploadLbl.adjustsFontSizeToFitWidth = true
        self.infoTV.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, place: "")
        self.nextBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "next")
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        
        if viewType == "profile"{
            self.nextBtn.isHidden = true
        }
        
        let defalutDict = LocalDefault.shared.appDefaults()
        let limit = defalutDict?.value(forKey: "tasker_documents_limit") as! NSString
        uploadLimit = Int(limit.intValue)
        if defalutDict?.value(forKey: "tasker_verification_guide") != nil {
            let description = defalutDict?.value(forKey: "tasker_verification_guide") as! String
            var contentString = "<font face=\(APP_FONT_REGULAR) size='6' color='black'>\(description)"
            if #available(iOS 13.0, *) {
                if LocalDefault.shared.theme() == "Dark" || UITraitCollection.current.userInterfaceStyle == .dark{
                     contentString = "<font face=\(APP_FONT_REGULAR) size='6' color='white'>\(description)"
                }  //overrideUserInterfaceStyle = .dark
            }
            // Set the label
            let attrDes = try? NSAttributedString(htmlString: contentString)
            self.infoTV.isHidden = true
            self.infoTV.attributedText = attrDes
            self.infoTV.sizeToFit()
            
            self.viewDidLayoutSubviews()
            print("attrdes \(attrDes)")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.chooseImage(_:)))
        self.uploadView.addGestureRecognizer(tap)
        self.addPullDownRefresh()
        self.getCertificates()
        self.checkRTL()
        self.startLoading()
        
    }
    //add pull down
    func addPullDownRefresh() {
        let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.certificateTableView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
            self.getCertificates()
        }
    }
    @IBAction func nextBtnTapped(_ sender: Any) {
        if self.certificateArray.count != 0 {
            let portObj = PortfolioPage()
            self.navigationController?.pushViewController(portObj, animated: true)
        }else{
            Utility.shared.showToast(msg: "add_atleast_one")
        }
        
    }
    
    //get certificate list
    func getCertificates(){
        if Utility.shared.isConnectedToNetwork(){
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue("document", forKey: "type")
            apiObj.baseService(subURl: GET_MEDIA_API, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.certificateArray.removeAllObjects()
                    self.certificateArray.addObjects(from: responseDict.value(forKey: "items")  as! [Any])
                    self.certificateTableView.delegate = self
                    self.certificateTableView.dataSource = self
                    self.infoTV.isHidden = false
                    self.certificateTableView.reloadData()
                    self.viewDidLayoutSubviews()

                }else{
                    self.certificateArray.removeAllObjects()
                }
                self.certificateTableView.fty.pullToRefresh.end()
                
                self.stopLoading()
            })
        }
    }
    //remove alert
    @objc func removeAlert(sender:UIButton){
        let alertObj = AlertPage()
        alertObj.modalPresentationStyle = .overCurrentContext
        alertObj.viewType = "delete"
        alertObj.deleteRequest = {
            self.removeMedia(index: sender.tag)
        }
        self.navigationController?.present(alertObj, animated: false, completion: nil)
    }
    //remove file
    func removeMedia(index:Int)  {
        if Utility.shared.isConnectedToNetwork(){
            let fileDict = self.certificateArray.object(at: index) as! NSDictionary
            let item_id = fileDict.value(forKey: "item_id") as! String
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(item_id, forKey: "media_id")
            apiObj.baseService(subURl: DELETE_MEDIA_API, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.certificateArray.removeObject(at: index)
                    self.certificateTableView.reloadData()
                    self.viewDidLayoutSubviews()

                }
            })
        }
    }
    //download file
    @objc func downloadDocument(sender:UIButton){
        DispatchQueue.main.async {
        self.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        let fileDict = self.certificateArray.object(at: sender.tag) as! NSDictionary
         let item_url = fileDict.value(forKey: "item_url") as! String
         do {
             let fileData = try Data.init(contentsOf: URL.init(string: item_url)!)
             let activityController = UIActivityViewController(activityItems: [fileData], applicationActivities: nil)
             self.present(activityController, animated: true, completion: nil)
            
                         self.stopLoading()

         } catch  {
             Utility.shared.showToast(msg: "file_not_available")
            self.stopLoading()
         }
        }
        }
  
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.certificateArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! FileCell
        let dict =  self.certificateArray.object(at: indexPath.row) as! NSDictionary
        cell.tag =  indexPath.row + 1000
        cell.nameLbl.text = (dict.value(forKey: "item_name") as! String)
        let url = URL.init(string: dict.value(forKey: "item_url") as! String)
        if url?.pathExtension == "pdf" {
            cell.typeIcon.setImage(#imageLiteral(resourceName: "pdf_icon"), for: .normal)
        }else{
            cell.typeIcon.setImage(#imageLiteral(resourceName: "image_file_icon"), for: .normal)
        }
        let index = indexPath.row + 1000
        if index !=  currentUploadIndex{
            cell.progress.value = 1
        }else{
            cell.progress.value = 0
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.removeAlert(sender:)), for: .touchUpInside)
        
        cell.downloadBtn.tag = indexPath.row
        cell.downloadBtn.addTarget(self, action: #selector(self.downloadDocument(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    //choose file to upload
    @objc func chooseImage(_ sender: UITapGestureRecognizer? = nil) {
        if uploadLimit > self.certificateArray.count {
            if isProgressing {
                Utility.shared.showToast(msg: "portfolio_in_progress")
            }else{
                // handling code
                self.uploadMenu()
            }
        }else{
            Utility.shared.customToast(msg: "\(Utility.shared.Json().value(forKey:"upload_limit") as! String) \(uploadLimit)")
        }
    }
    
    func uploadMenu() {
        if uploadLimit > self.certificateArray.count {
            if isProgressing {
                Utility.shared.showToast(msg: "certificate_in_progress")
            }else{
                
                let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                // Create and add the Cancel action
                let cancelAction = UIAlertAction(title: (Utility.shared.Json().value(forKey: "cancel") as! String), style: .cancel) { action -> Void in
                    // Just dismiss the action sheet
                }
                action.addAction(cancelAction)
                
                // Create and add first option action
                let camera = UIAlertAction(title: (Utility.shared.Json().value(forKey: "camera") as! String), style: .default) { action -> Void in
                    self.picker.delegate = self
                    self.picker.sourceType = .camera
                    self.picker.allowsEditing = false
                    self.picker.modalPresentationStyle = .fullScreen
                    self.present(self.picker, animated: true, completion: nil)
                }
                action.addAction(camera)
                
                // Create and add a second option action
                let gallery = UIAlertAction(title: (Utility.shared.Json().value(forKey: "gallery") as! String), style: .default) { action -> Void in
                    self.picker.delegate = self
                    self.picker.sourceType = .photoLibrary
                    self.picker.allowsEditing = false
                    self.picker.modalPresentationStyle = .fullScreen
                    self.present(self.picker, animated: true, completion: nil)
                }
                action.addAction(gallery)
                
                // Create and add a second option action
                let document = UIAlertAction(title: (Utility.shared.Json().value(forKey: "document") as! String), style: .default) { action -> Void in
                    // handling code
                    let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeImage,kUTTypePNG,kUTTypeJPEG)
                    let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
                    documentPicker.delegate = self
                    documentPicker.modalPresentationStyle = .fullScreen
                    self.present(documentPicker, animated: true, completion: nil)
                }
                action.addAction(document)
                // Present the AlertController
                self.present(action, animated: true, completion: nil)
                
            }
        }else{
            Utility.shared.customToast(msg: "\(Utility.shared.Json().value(forKey:"upload_limit") as! String) \(uploadLimit)")
        }    }
    
    //image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            Utility.shared.showAlert(msg: "image_not_valid")
            return
        }

            let imageData = image.jpegData(compressionQuality: 0.5)
            let imageSize: Int = imageData!.count
            let size = Double(imageSize) / 1000.0
            if size <= 2000{
                let extensionType = ".jpeg"
                let tempDict = NSMutableDictionary()
                tempDict.setValue("image", forKey: "item_name")
                tempDict.setValue("", forKey: "item_id")
                tempDict.setValue("", forKey: "item_url")
                self.currentUploadIndex = 1000 + self.certificateArray.count
                self.certificateArray.add(tempDict)
                self.certificateTableView.reloadData()
                self.viewDidLayoutSubviews()

                isProgressing = true
                apiObj.uploadFile(image: imageData! as Data, fileType: extensionType, name: "image", type: "document", onSuccess: {response in
                    let dict = response.value as! NSDictionary
                    let status_code =  dict.value(forKey: "status_code") as! Int
                    if status_code == 200{
                        self.currentUploadIndex = -1
                        self.isProgressing = false
                        self.getCertificates()
                        Utility.shared.showToast(msg: "added_successfully")
                    }
                }, onProgress: { prog in
                    let fileCell = self.view.viewWithTag(self.currentUploadIndex) as? FileCell
                    if fileCell != nil{
                        fileCell!.progress?.value = CGFloat(prog!.fractionCompleted)
                    }else{
                        print("GET NIL")
                    }
                })
            }else{
                Utility.shared.showToast(msg: "maximum_limit")
            }
    }
        
    //document picker delegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        let fileData = NSData.init(contentsOf: URL.init(string: "\(urls[0])")!)
        let imageSize: Int = fileData!.count
        let size = Double(imageSize) / 1000.0
        if size <= 2000{
            let fileName = urls[0].lastPathComponent
            let extensionType = ".\(urls[0].pathExtension)"
            let tempDict = NSMutableDictionary()
            tempDict.setValue(fileName, forKey: "item_name")
            tempDict.setValue("", forKey: "item_id")
            tempDict.setValue(myURL.absoluteString, forKey: "item_url")
            self.currentUploadIndex = 1000 + self.certificateArray.count
            self.certificateArray.add(tempDict)
            self.certificateTableView.reloadData()
            self.viewDidLayoutSubviews()

            isProgressing = true
            apiObj.uploadFile(image: fileData! as Data, fileType: extensionType, name: fileName, type: "document", onSuccess: {response in
                let dict = response.value as! NSDictionary
                let status_code =  dict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.currentUploadIndex = -1
                    self.isProgressing = false
                    self.getCertificates()
                }
            }, onProgress: { prog in
                let fileCell = self.view.viewWithTag(self.currentUploadIndex) as? FileCell
                if fileCell != nil{
                    fileCell!.progress?.value = CGFloat(prog!.fractionCompleted)
                }
            })
        }else{
            Utility.shared.showToast(msg: "maximum_limit")
        }
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

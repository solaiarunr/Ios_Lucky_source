//
//  PortfolioPage.swift
//  iDemand
//
//  Created by Roby on 29/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos
import MobileCoreServices
class PortfolioPage: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIDocumentPickerDelegate{
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var portfolioCollectionView: UICollectionView!
    @IBOutlet var uploadView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var uploadtitleLbl: UILabel!
    
    let portfolioArray = NSMutableArray()
    let apiObj =  BaseAPI()
    var currentUploadIndex = -1
    var viewType = String()
    var isProgressing = false
    var uploadLimit = 0
    var picker = UIImagePickerController()
    var count = 1
    var clicked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.navigationView.bottomRadius()
        self.uploadView.addDottedLine()
        self.nextBtn.topRadius()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //initial setup
    func initalSetup()  {
        self.addLoader()
        self.portfolioCollectionView.reloadData()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        portfolioCollectionView.register(UINib(nibName: "PortfolioCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioCell")
        self.portfolioCollectionView.contentInset = UIEdgeInsets.init(top: 15, left: 20, bottom: 80, right: 20)
        self.uploadtitleLbl.config(color: TEXT_BLACK_COLOR!,font:subReg,align: .center, text:"portfolio_description")
        self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_portfolio")
        self.nextBtn.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, title: "next")
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        
        if viewType == "profile"{
            self.nextBtn.isHidden = true
        }
        
        let defalutDict = LocalDefault.shared.appDefaults()
        let limit = defalutDict?.value(forKey: "tasker_portfolio_limit") as! NSString
        uploadLimit = Int(limit.intValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.chooseImage(_:)))
        self.uploadView.addGestureRecognizer(tap)
        self.addPullDownRefresh()
        self.getPortfolioList()
        self.checkRTL()
        self.startLoading()
        
    }
    //add pull down
     func addPullDownRefresh() {
         let animator = DefaultRefreshAnimator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
         self.portfolioCollectionView.fty.pullToRefresh.add(animator: animator) { [unowned self] in
             self.getPortfolioList()
         }
     }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if self.portfolioArray.count != 0{
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                LocalDefault.shared.setHint(status: "true")
                appDelegate.setInitialViewController()
            }
        }else{
            Utility.shared.showToast(msg: "add_atleast_one")
        }
        
    }
    
    //get portfolio list
    func getPortfolioList(){
        if Utility.shared.isConnectedToNetwork(){
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue("portfolio", forKey: "type")
            apiObj.baseService(subURl: GET_MEDIA_API, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.portfolioArray.removeAllObjects()
                    self.portfolioArray.addObjects(from: responseDict.value(forKey: "items")  as! [Any])
                    self.portfolioCollectionView.delegate = self
                    self.portfolioCollectionView.dataSource = self
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.portfolioCollectionView.reloadData()
                    }
                }else{
                    self.portfolioArray.removeAllObjects()
                }
                self.stopLoading()
                self.portfolioCollectionView.fty.pullToRefresh.end()
            })
        }
    }
//    func getCertificates(){
//        if Utility.shared.isConnectedToNetwork(){
//            let request = NSMutableDictionary()
//            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
//            request.setValue("document", forKey: "type")
//            apiObj.baseService(subURl: GET_MEDIA_API, params: request as? Parameters, onSuccess: {response in
//                let responseDict = response.value as! NSDictionary
//                let status_code = responseDict.value(forKey: "status_code") as! Int
//                if status_code == 200{
//                    self.portfolioArray.removeAllObjects()
//                    self.portfolioArray.addObjects(from: responseDict.value(forKey: "items")  as! [Any])
//                    self.portfolioCollectionView.delegate = self
//                    self.portfolioCollectionView.dataSource = self
//                    self.portfolioCollectionView.reloadData()
//
//                }else{
//                    self.portfolioArray.removeAllObjects()
//                }
//                self.portfolioCollectionView.fty.pullToRefresh.end()
//
//                self.stopLoading()
//            })
//        }
//    }
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
    @objc func downloaddocument(sender:UIButton){
        DispatchQueue.main.async {
        self.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        let fileDict = self.portfolioArray.object(at: sender.tag) as! NSDictionary
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
    //remove file
    func removeMedia(index:Int)  {
        self.portfolioCollectionView.isUserInteractionEnabled = false
        if Utility.shared.isConnectedToNetwork(){
            let fileDict = self.portfolioArray.object(at: index) as! NSDictionary
            let item_id = fileDict.value(forKey: "item_id") as! String
            let request = NSMutableDictionary()
            request.setValue(LocalDefault.shared.userID(), forKey: "user_id")
            request.setValue(item_id, forKey: "media_id")
            apiObj.baseService(subURl: DELETE_MEDIA_API, params: request as? Parameters, onSuccess: {response in
                let responseDict = response.value as! NSDictionary
                let status_code = responseDict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.portfolioArray.removeObject(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.portfolioCollectionView.reloadData()
                        self.portfolioCollectionView.isUserInteractionEnabled = true
                    }
                }
            })
        }
    }
    
    
    //collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.portfolioArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PortfolioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell
        let portfolioDict = self.portfolioArray.object(at: indexPath.row) as! NSDictionary
//        cell.tag =  indexPath.row + 5000
        let index = indexPath.row + 5000
        print("cellvalue \(self.portfolioArray)")
        print("cellvalue1 \(portfolioDict)")
        let userimgURL = URL.init(string: portfolioDict.value(forKey: "item_url") as! String)
        let filetype = portfolioDict.value(forKey: "item_url") as! String
//        if(userimgURL?.pathExtension == "pdf")
        cell.portfolioImgView.image = nil
        if((filetype.range(of:".pdf")) != nil)
        {
            cell.portfolioImgView.image = #imageLiteral(resourceName:"pdf_icon")
            cell.portfolioImgView.contentMode = .scaleAspectFit
            cell.documentnameLbl.isHidden = false
            cell.documentnameLbl.text = (portfolioDict.value(forKey:"item_name") as! String)
            cell.downloadButton.isHidden = true
        }
        else if((filetype.range(of:".doc")) != nil)
        {
            cell.portfolioImgView.image = #imageLiteral(resourceName:"document_icon")
           cell.portfolioImgView.contentMode = .scaleAspectFit
            cell.documentnameLbl.isHidden = false
            cell.documentnameLbl.text = (portfolioDict.value(forKey:"item_name") as! String)
           cell.downloadButton.isHidden = true
        }
        else if((filetype.range(of:".docx")) != nil)
        {
            cell.portfolioImgView.image = #imageLiteral(resourceName:"document_icon")
            cell.portfolioImgView.contentMode = .scaleAspectFit
            cell.documentnameLbl.isHidden = false
            cell.documentnameLbl.text = (portfolioDict.value(forKey:"item_name") as! String)
            cell.downloadButton.isHidden = true
        }else if((filetype.range(of:".jpg")) != nil || (filetype.range(of:".png")) != nil){
            if(indexPath.row==0){
                print("url cell:,\(portfolioDict.value(forKey: "item_url") ?? "")")
            }
            cell.portfolioImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            cell.documentnameLbl.isHidden = true        }
        
//        else if (userimgURL?.pathExtension == "jpg" || userimgURL?.pathExtension == ".jpg"){
//            cell.portfolioImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
//            cell.documentnameLbl.isHidden = true
//        }
        
        cell.portfolioImgView.backgroundColor = LINE_COLOR
        if index !=  currentUploadIndex{
        }
        else{
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.removeAlert(sender:)), for: .touchUpInside)
        cell.downloadButton.tag = indexPath.row
        cell.downloadButton.addTarget(self, action: #selector(self.downloaddocument(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var collectionViewSize = CGFloat()
        collectionViewSize = (portfolioCollectionView.frame.size.width)-60
        
        return CGSize(width: (collectionViewSize/2), height:(collectionViewSize/2)-30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let portfolioDict = self.portfolioArray.object(at: indexPath.row) as! NSDictionary
        let userimgURL = URL.init(string: portfolioDict.value(forKey: "item_url") as! String)
        if(userimgURL?.pathExtension == "pdf" || userimgURL?.pathExtension == "doc" || userimgURL?.pathExtension == "docx" || userimgURL?.pathExtension == "xlsx")
        {
            let docView = documentViewController()
            docView.selectedDict = portfolioDict
            self.navigationController?.present(docView, animated: true, completion: nil)
        }
        else{
            let imgView = ImageViewer()
            imgView.modalPresentationStyle = .fullScreen
            imgView.viewType = "portfolio"
            imgView.selectedDict = portfolioDict
            if(indexPath.row == 0)
            {
                imgView.selectedIndex = indexPath.row
                imgView.imageListArray = self.portfolioArray
            }
            else
            {
            imgView.selectedIndex = indexPath.row
            imgView.imageListArray = self.portfolioArray
            }
            self.navigationController?.present(imgView, animated: true, completion: nil)
        }
    }
    
    //choose file to upload
    @objc func chooseImage(_ sender: UITapGestureRecognizer? = nil) {
        if uploadLimit > self.portfolioArray.count {
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
//            self.picker.delegate = self
//            self.picker.sourceType = .photoLibrary
//            self.picker.allowsEditing = false
//            self.picker.modalPresentationStyle = .fullScreen
//            self.present(self.picker, animated: true, completion: nil)
            let picker = AssetsPickerViewController()
            picker.pickerDelegate = self
            picker.pickerConfig.assetIsShowCameraButton = false
            picker.pickerConfig.selectedAssets = [PHAsset]()
            let options = PHFetchOptions()
            options.predicate =  NSPredicate(format:"mediaType=%d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors=[NSSortDescriptor(key:"duration", ascending: true)]
            picker.pickerConfig.assetFetchOptions=[
                .smartAlbum:options,.album:options]
            picker.navigationBar.barTintColor = UIColor(named: "PRIMARY_COLOR")
            picker.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: APP_FONT_REGULAR, size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(named: "rating_green") ?? .black]
            picker.navigationBar.tintColor = UIColor(named: "PRIMARY_COLOR")
            picker.modalPresentationStyle = .fullScreen
    //        self.setStatusBarBackgroundColor(color: UIColor(named: "AppThemeColor") ?? .black)
            self.present(picker, animated: true, completion: nil)
            
        }
        action.addAction(gallery)
        let document = UIAlertAction(title: (Utility.shared.Json().value(forKey: "document") as! String), style: .default) { action -> Void in
            // handling code
            let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeImage,kUTTypePNG,kUTTypeJPEG,"com.microsoft.word.doc" as CFString, "org.openxmlformats.wordprocessingml.document")
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
            documentPicker.delegate = self
            if #available(iOS 11.0, *) {
                         documentPicker.allowsMultipleSelection = true
                     }
            documentPicker.modalPresentationStyle = .fullScreen
            self.present(documentPicker, animated: false, completion: nil)
        }
        action.addAction(document)
        // Present the AlertController
        self.present(action, animated: true, completion: nil)
        // Present the AlertController
   }
    
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
            self.startLoading()
            let tempDict = NSMutableDictionary()
            tempDict.setValue("image", forKey: "item_name")
            tempDict.setValue("", forKey: "item_id")
            tempDict.setValue("jpg", forKey: "item_url")
            self.currentUploadIndex = 5000 + self.portfolioArray.count
            self.portfolioArray.add(tempDict)
            
            self.portfolioCollectionView.reloadData()
            
            print("current indexxx \(self.currentUploadIndex)")
            let cell = self.view.viewWithTag(self.currentUploadIndex) as? PortfolioCell
            
            isProgressing = true
            apiObj.uploadFile(image: imageData!, fileType: "jpeg", name: "image", type: "portfolio", onSuccess: {response in
                let dict = response.value as! NSDictionary
                let status_code =  dict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.currentUploadIndex = -1
                    self.isProgressing = false
                    self.getPortfolioList()
                    Utility.shared.showToast(msg: "added_successfully")
                    
                }
                self.stopLoading()
            }, onProgress: { prog in
                print("check progress here \(prog?.fractionCompleted)")
            }
            )
        }else{
            Utility.shared.showAlert(msg: "maximum_limit")
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        let boolcount = uploadLimit - self.portfolioArray.count
        if (count <= boolcount)
        {
            for i in 0 ..< urls.count
        {
        let fileData = NSData.init(contentsOf: URL.init(string: "\(urls[i])")!)
        let imageSize: Int = fileData!.count
        let size = Double(imageSize) / 1000.0
        if size <= 2000{
            let fileName = urls[i].lastPathComponent
            let extensionType = ".\(urls[i].pathExtension)"
            let tempDict = NSMutableDictionary()
            tempDict.setValue(fileName, forKey: "item_name")
            tempDict.setValue("", forKey: "item_id")
            tempDict.setValue(myURL.absoluteString, forKey: "item_url")
            self.currentUploadIndex = 5000 + self.portfolioArray.count
            self.portfolioArray.add(tempDict)
            self.portfolioCollectionView.reloadData()
            isProgressing = true
            apiObj.uploadFile(image: fileData! as Data, fileType: extensionType, name: fileName, type: "portfolio", onSuccess: {response in
                let dict = response.value as! NSDictionary
                let status_code =  dict.value(forKey: "status_code") as! Int
                if status_code == 200{
                    self.currentUploadIndex = -1
                    self.isProgressing = false
                    //self.getCertificates()
                    self.getPortfolioList()
                }
                self.stopLoading()
            }, onProgress: { prog in
                print("check progress here \(prog?.fractionCompleted)")
            })
        }else{
            Utility.shared.showToast(msg: "maximum_limit")
      
        }
        }
            count = count + 1
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
extension PortfolioPage:AssetsPickerViewControllerDelegate{
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        let imageManager={
            return PHCachingImageManager()
        }()
        if(assets.count+self.portfolioArray.count <= uploadLimit)
        {
        for i in 0..<assets.count{
            
            let requestImageOption = PHImageRequestOptions()
            requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat

            let manager = PHImageManager.default()
            manager.requestImage(for: assets[i], targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { (image:UIImage?, _) in
                    // process the original image

            }
            
            
            imageManager.requestImageData(for: assets[i], options: nil){(data,message,imageOrientation,info) in
                if let imageData = data,let image = UIImage(data: imageData){
                    let imagedata = image.jpegData(compressionQuality: 0.5)
                    let imageSize: Int = imagedata!.count
                    let size = Double(imageSize) / 1000.0
                    if size <= 2000{
                        self.startLoading()
                        let tempDict = NSMutableDictionary()
                        tempDict.setValue("image", forKey: "item_name")
                        tempDict.setValue("", forKey: "item_id")
                        tempDict.setValue(".jpg", forKey: "item_url")
                        self.currentUploadIndex = 5000 + self.portfolioArray.count
                        self.portfolioArray.add(tempDict)
                        self.portfolioCollectionView.reloadData()
                        
                        print("current indexxx \(self.currentUploadIndex)")
//                        let cell = self.view.viewWithTag(self.currentUploadIndex) as? PortfolioCell
                        var file_types = ""
                        self.isProgressing = true
                        
                        switch imagedata![0] {
                               case 0x89:
                            file_types =  "png"
                               case 0xFF:
                            file_types =  "jpg"
                               case 0x47:
                            file_types =  "gif"
                               case 0x49, 0x4D:
                            file_types =  "tiff"
                        case 0x52 where imagedata!.count >= 12:
                                   let subdata = imagedata![0...11]

                                   if let dataString = String(data: subdata, encoding: .ascii),
                                       dataString.hasPrefix("RIFF"),
                                       dataString.hasSuffix("WEBP")
                                   {
                                       file_types =  "webp"
                                   }

                               case 0x00 where imagedata!.count >= 12 :
                                   let subdata = imagedata![8...11]

                                   if let dataString = String(data: subdata, encoding: .ascii),
                                       Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
                                       ///OLD: "ftypheic", "ftypheix", "ftyphevc", "ftyphevx"
                                   {
                                       file_types =  "heic"
                                   }
                               default:
                                   break
                               }
                        
                        
                        self.apiObj.uploadFile(image: imagedata!, fileType: file_types, name: "image", type: "portfolio", onSuccess: {response in
                            let dict = response.value as! NSDictionary
                         
                            let status_code =  dict.value(forKey: "status_code") as! Int
                            if status_code == 200{
                                self.currentUploadIndex = -1
                                self.isProgressing = false
                                self.getPortfolioList()
                                Utility.shared.showToast(msg: "added_successfully")
                            }
                            self.stopLoading()
                        }, onProgress: { prog in
                            print("check progress here \(prog?.fractionCompleted)")
                        }
                      
                        )
                    }else{
                        Utility.shared.showAlert(msg: "maximum_limit")
                    }
                }
            }
        }
            self.addPullDownRefresh()
        }
    }
func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
    if controller.selectedAssets.count+self.portfolioArray.count >= uploadLimit {
            Utility.shared.customToast(msg: "\(Utility.shared.Json().value(forKey:"upload_limit") as! String) \(uploadLimit)")
        return false
        }
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
    }
}

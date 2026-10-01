//
//  ImageViewer.swift
//  iDemand
//
//  Created by Roby on 08/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//
import UIKit
import ImageViewer_swift
class ImageViewer: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var imgScrollView: UIScrollView!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var mainScrollView: UIScrollView!

    var viewType =  String()
    var imageListArray =  NSMutableArray()
    var imgtempArray = NSMutableArray()
    var selectedIndex = Int()
    var selectedDict = NSDictionary()
    var bottomHide = false
    var imgUrl =  String()
    var string = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalSetup()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    override func viewDidLayoutSubviews() {
        let item_width = (FULL_WIDTH/2)-30
        let item_height = item_width-30
        self.imgScrollView.frame = CGRect.init(x: 0, y: FULL_HEIGHT-(item_height+20), width: FULL_WIDTH, height: item_height)
        self.navigationView.bottomRadius()
    }
    
    //check rtl
    func checkRTL()  {
        if Utility.shared.isRTL(){
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.profileImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    //intial setup
    func initalSetup()  {
        self.mainScrollView.delegate = self
        self.addLoader()
        self.navigationView.backgroundColor = PRIMARY_COLOR
        if viewType != "chat"{
            self.titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: viewType)
        }

        if viewType == "portfolio"{
            
            let userimgURL = URL.init(string: selectedDict.value(forKey: "item_url") as! String)
            if(userimgURL?.pathExtension == "pdf")
            {
                self.profileImgView.image=#imageLiteral(resourceName:"pdf_icon")
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissBottom(_:)))
                  self.view.addGestureRecognizer(tap)
                  self.setImageList()
            }
            else
            {
            self.profileImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissBottom(_:)))
              self.view.addGestureRecognizer(tap)
              self.setImageList()
            }
        }else if viewType == "profile" || viewType == "chat" {
            self.mainScrollView.isHidden = true
            print("img \(self.imgUrl)")
            let userimgURL = URL.init(string: self.imgUrl)
            self.profileImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        }
        self.checkRTL()
    }
    
    //dismiss view
    @objc func dismissBottom(_ sender: UITapGestureRecognizer? = nil) {
        let item_width = (FULL_WIDTH/2)-30
        let item_height = item_width-30
        if bottomHide{
            bottomHide = false
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.imgScrollView.frame = CGRect.init(x: 0, y: FULL_HEIGHT-(item_height+20), width: FULL_WIDTH, height: item_height)
            }, completion: nil)
        }else{
            bottomHide = true
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.imgScrollView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: item_height)
            }, completion: nil)
        }
    }
    
    //set image list
    func setImageList()  {
        var leftPadding = 20
        var fullImgPadding = 0
        var index = 0
        let item_width = (FULL_WIDTH/2)-30
        let item_height = item_width-50
        self.clearAllViews()
        for imageDict in self.imageListArray{
            let dict = imageDict as! NSDictionary
            let userimgURL = URL.init(string:dict.value(forKey: "item_url") as! String )
            if(userimgURL?.pathExtension != "pdf" && userimgURL?.pathExtension != "doc" && userimgURL?.pathExtension != "docx")
            {
                self.imgtempArray.add(imageDict)
            }
        }
        for imageDict in self.imgtempArray {
            let dict = imageDict as! NSDictionary
            //image
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: leftPadding, y: 0, width:Int(item_width) , height: Int(item_height))
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            let userimgURL = URL.init(string:dict.value(forKey: "item_url") as! String )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.tag = index+1000
            self.imgScrollView.addSubview(imgView)
            
            let fullView = UIImageView()
            fullView.frame = CGRect.init(x: fullImgPadding, y: -50, width:Int(FULL_WIDTH) , height: Int(FULL_HEIGHT-self.navigationView.frame.size.height))
            fullView.contentMode = .scaleAspectFit
            if(viewType == "portfolio")
            {
                if(userimgURL?.pathExtension == "pdf")
                {
                    fullView.image=#imageLiteral(resourceName:"pdf_icon")
                }
                else
                {
                    fullView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
                }
            }
            else
            {
            fullView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }
            fullView.setupImageViewer()
            self.mainScrollView.addSubview(fullView)
            if selectedIndex == index{
                imgView.addBorder(width: 3, color: PRIMARY_COLOR!)
            }else{
                imgView.addBorder(width: 3, color: .clear)
            }
            //btn action
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 0, width:Int(item_width) , height: Int(item_height))
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.imgTapped(_:)), for: .touchUpInside)
            self.imgScrollView.addSubview(imageBtn)
            
            leftPadding += Int(item_width)+20
            fullImgPadding += Int(FULL_WIDTH)
            index += 1
            self.imgScrollView.contentSize = CGSize.init(width: leftPadding, height: 50)
            self.mainScrollView.contentSize = CGSize.init(width: fullImgPadding, height: Int(FULL_WIDTH))
        }
        self.mainScrollView.contentOffset = CGPoint.init(x: self.selectedIndex*Int(FULL_WIDTH), y: 0)

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //image tapped
    @objc func imgTapped(_ sender: UIButton){
        let prevIndex =  self.selectedIndex + 1000
        let imgView = self.view.viewWithTag(prevIndex) as! UIImageView
        imgView.addBorder(width: 3, color: .clear)
        
        let currentIndex =  sender.tag + 1000
        let selectedView = self.view.viewWithTag(currentIndex) as! UIImageView
        selectedView.addBorder(width: 3, color: PRIMARY_COLOR!)
        
        self.selectedIndex = sender.tag

        let dict = self.imageListArray.object(at: sender.tag) as! NSDictionary
        let userimgURL = URL.init(string: dict.value(forKey: "item_url") as! String)
        self.profileImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.mainScrollView.contentOffset = CGPoint.init(x: self.selectedIndex*Int(FULL_WIDTH), y: 0)
        }, completion: nil)

    }
    
    @IBAction func downloadBtnTapped(_ sender: Any) {
        PhotoAlbum.sharedInstance.save(image: self.profileImgView.image ?? #imageLiteral(resourceName: "service_placeholder"))
        Utility.shared.showToast(msg: "saved")

    }
    func clearAllViews()  {
        let subviews = self.imgScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
    
    //scroll view delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print(pageNumber)
        let prevIndex =  self.selectedIndex + 1000
        let imgView = self.view.viewWithTag(prevIndex) as! UIImageView
        imgView.addBorder(width: 3, color: .clear)
        
        let currentIndex =  Int(pageNumber) + 1000
        let selectedView = self.view.viewWithTag(currentIndex) as! UIImageView
        selectedView.addBorder(width: 3, color: PRIMARY_COLOR!)
        let item_width = (FULL_WIDTH/2)-30
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.imgScrollView.contentOffset = CGPoint.init(x: item_width*pageNumber, y: 0)
        }, completion: nil)
        selectedIndex = Int(pageNumber)
        
        let dict = self.imageListArray.object(at: selectedIndex) as! NSDictionary
        print("dict \(dict)")

        let portfolioURL = URL.init(string: dict.value(forKey: "item_url") as! String)
        self.profileImgView.sd_setImage(with: portfolioURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
    }
}


//
//  HomeRecentCell.swift
//  iDemand
//
//  Created by Roby on 08/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
protocol recentDelegate: AnyObject {
    func recentTaskAct(cell: HomeRecentCell,index:Int)
}
class HomeRecentCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var itemScrollView: UIScrollView!
    @IBOutlet var viewAllBtn: UIButton!
    weak var delegate: recentDelegate?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "recent_tasks")
        self.viewAllBtn.config(color: PRIMARY_COLOR!, font: smallReg, align: .right, title: "view_all")
        if Utility.shared.isRTL(){
            titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //recent
    func config(recents:NSArray)  {
        var leftPadding = 20
        let item_width = 270
        var index = 0
        self.clearAllViews()
        for recent in recents {
            let recentDict = recent as! NSDictionary
            let containerView = MDCCard()
            containerView.frame = CGRect.init(x: leftPadding, y: 5, width: item_width, height: 150)
            containerView.elevation(radius: 15.0)
            containerView.backgroundColor = POPUP_COLOR
            self.itemScrollView.addSubview(containerView)
            
            let serviceView = MDCCard()
            serviceView.frame = CGRect.init(x: 0, y: 0, width: item_width, height: 100)
            serviceView.elevation(radius: 15.0)
            serviceView.setShadowElevation(.lite, for: .normal)
            serviceView.backgroundColor = POPUP_COLOR
            containerView.addSubview(serviceView)
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: 0, y: 0, width: item_width, height: 150)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.recentTaskTabbed(_:)), for: .touchUpInside)
            containerView.addSubview(imageBtn)
            
            let serviceNameLbl = UILabel()
            serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
            serviceNameLbl.frame = CGRect.init(x: 15, y: 20, width:160 , height: 30)
            serviceNameLbl.text = (recentDict.value(forKey:"subcategory_name") as! String)
            serviceView.addSubview(serviceNameLbl)
            
            let priceNameLbl = UILabel()
            priceNameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
            priceNameLbl.frame = CGRect.init(x: 15, y: 50, width:160 , height: 30)
            let appDefault = LocalDefault.shared.appDefaults()
            let currency_code = appDefault?.value(forKey: "currency_symbol") as! String

            if Utility.shared.isRTL(){
                priceNameLbl.text = "\(recentDict.value(forKey:"price") as! String) \(currency_code)"
            }else{
                priceNameLbl.text = "\(currency_code) \(recentDict.value(forKey:"price") as! String)"
            }
            serviceView.addSubview(priceNameLbl)
            
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: item_width-80, y: 27, width:65 , height: 45)
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            if LocalDefault.shared.isUser()!{
                let userimgURL = URL.init(string:(recentDict.value(forKey:"item_image") as! String) )
                imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }else{
                let userimgURL = URL.init(string:(recentDict.value(forKey:"user_image") as! String) )
                imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }
            imgView.backgroundColor = LINE_COLOR
            serviceView.addSubview(imgView)
            //btn action
            
            
            let desLbl = UILabel()
            desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            desLbl.frame = CGRect.init(x: 15, y: 100, width:item_width-20 , height: 50)
            desLbl.numberOfLines = 2
            if recentDict.value(forKey:"description") != nil{
                desLbl.text = (recentDict.value(forKey:"description") as! String)
            }
            containerView.addSubview(desLbl)
            imageBtn.bringSubviewToFront(containerView)
            leftPadding += Int(item_width+20)
            if Utility.shared.isRTL(){
                containerView.transform = CGAffineTransform(scaleX: -1, y: 1)

//                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
//                desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
//                serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
//                priceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                serviceNameLbl.textAlignment = .right
                priceNameLbl.textAlignment = .right
                desLbl.textAlignment = .right

            }
            self.itemScrollView.frame = CGRect.init(x: 0, y: 40, width: FULL_WIDTH, height: 160)
            self.itemScrollView.contentSize = CGSize.init(width: leftPadding, height: 160)
            index += 1
        }
    }
    @objc func recentTaskTabbed(_ sender: UIButton){
        delegate?.recentTaskAct(cell: self,index: sender.tag)
    }
    func clearAllViews()  {
        let subviews = self.itemScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
}

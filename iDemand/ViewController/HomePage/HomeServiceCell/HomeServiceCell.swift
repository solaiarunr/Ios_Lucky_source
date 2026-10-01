//
//  HomeServiceCell.swift
//  iDemand
//
//  Created by Roby on 08/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

protocol serviceDelegate: AnyObject {
    func categoryTapped(cell: HomeServiceCell,index:Int)
}
class HomeServiceCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var viewAllBtn: UIButton!
    @IBOutlet var itemScrollView: UIScrollView!
    weak var delegate: serviceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "categories")
        self.viewAllBtn.config(color: PRIMARY_COLOR!, font: smallReg, align: .right, title: "view_all")
        
        if Utility.shared.isRTL(){
            titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewAllBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.viewAllBtn.contentHorizontalAlignment = .left
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK : SERVICE
    func config(services:NSArray)  {
        //        self.viewAllBtn.isHidden = true
        var leftPadding = 20
        var index = 0
        let item_width = (FULL_WIDTH/2.1)-20
        let item_height = ((item_width/3)*2)-15
        self.clearAllViews()
        
        for serviceModel in services {
            let serviceDict = serviceModel as! NSDictionary
            //image
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: leftPadding, y: 0, width:Int(item_width) , height: Int(item_height))
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            let userimgURL = URL.init(string:serviceDict.value(forKey: "item_image") as! String )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.backgroundColor = LINE_COLOR
            self.itemScrollView.addSubview(imgView)
            
            //service lbl
            let nameLbl = UILabel()
            nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .center, text: "")
            nameLbl.frame = CGRect.init(x: leftPadding, y: Int(item_height)+5, width:Int(item_width) , height: 30)
            nameLbl.text = (serviceDict.value(forKey: "item_name") as! String)
            self.itemScrollView.addSubview(nameLbl)
            
            if Utility.shared.isRTL(){
                nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                nameLbl.textAlignment = .right
            }
            
            //btn action
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 0, width:Int(item_width) , height: Int(item_height)+40)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.categoryTapped(_:)), for: .touchUpInside)
            self.itemScrollView.addSubview(imageBtn)
            
            leftPadding += Int(item_width)+20
            index += 1
            self.itemScrollView.frame = CGRect.init(x: 0, y: 37, width: FULL_WIDTH, height: item_height+40)
            self.itemScrollView.contentSize = CGSize.init(width: leftPadding, height: 50)
        }
    }
    @objc func categoryTapped(_ sender: UIButton){
        delegate?.categoryTapped(cell: self,index: sender.tag)
    }
    
    func clearAllViews()  {
        let subviews = self.itemScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
}

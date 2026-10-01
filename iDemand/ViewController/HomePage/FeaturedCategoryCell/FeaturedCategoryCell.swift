//
//  FeaturedCategoryCell.swift
//  iDemand
//
//  Created by Roby on 12/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

protocol featureCatDelegate: AnyObject {
    func featureCategoryTapped(cell: FeaturedCategoryCell,index:Int)
    
}
class FeaturedCategoryCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var viewAllBtn: UIButton!
    @IBOutlet var itemScrollView: UIScrollView!
    
    weak var delegate: featureCatDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "services")
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
    
    
    //MARK : FEATURE CATEGORY
    func config(featureCategory:NSDictionary)  {
        var leftPadding = 20
        var index = 0
        let image_width = Int(FULL_WIDTH/3)+30
        let item_height = (FULL_WIDTH/3)-20
        self.titleLbl.text = (featureCategory.value(forKey: "item_name") as! String)
        let items = featureCategory.value(forKey: "items") as! NSArray
        self.clearAllViews()
        for category in items {
            let categoryDict = category as! NSDictionary
            let imgView = UIImageView()
            imgView.frame = CGRect.init(x: leftPadding, y: 0, width:image_width , height: Int(item_height))
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 5)
            let userimgURL = URL.init(string:categoryDict.value(forKey: "item_image") as! String )
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.backgroundColor = LINE_COLOR
            self.itemScrollView.addSubview(imgView)
            
            let desLbl = UILabel()
            desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
            desLbl.frame = CGRect.init(x: leftPadding, y: Int(item_height)+5, width:Int(image_width) , height: 30)
            desLbl.text = (categoryDict.value(forKey: "item_name") as! String)
            
            self.itemScrollView.addSubview(desLbl)
            
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 0, width:Int(image_width) , height: Int(item_height)+40)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.featureCategoryTapped(_:)), for: .touchUpInside)
            self.itemScrollView.addSubview(imageBtn)
            if Utility.shared.isRTL(){
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                desLbl.textAlignment = .right
            }
            
            leftPadding += Int(image_width)+20
            index += 1
            self.itemScrollView.frame = CGRect.init(x: 0, y: 37, width: Int(FULL_WIDTH), height: Int(item_height)+40)
            self.itemScrollView.contentSize = CGSize.init(width: leftPadding, height: 50)
        }
    }
    @objc func featureCategoryTapped(_ sender: UIButton){
        delegate?.featureCategoryTapped(cell: self,index: sender.tag)
    }
    func clearAllViews()  {
        let subviews = self.itemScrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
    }
}

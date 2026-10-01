//
//  MyServicesCell.swift
//  iDemand
//
//  Created by Roby on 07/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
//protocol deleteDelegate: AnyObject {
//    func recentTaskAct(cell: MyServicesCell,index:Int)
//}

class MyServicesCell: UITableViewCell {
    
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var subCategoryNameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var inActiveView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
//    weak var delegate: deleteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.subCategoryNameLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.serviceImgView.radius(value: 5.0)
        self.serviceImgView.backgroundColor = LINE_COLOR
        self.inActiveView.radius(value: 5.0)
        
        if Utility.shared.isRTL(){
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.inActiveView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.subCategoryNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.subCategoryNameLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

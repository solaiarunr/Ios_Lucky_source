//
//  BrowseCell.swift
//  iDemand
//
//  Created by Roby on 25/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class BrowseCell: UITableViewCell {
    
    @IBOutlet var itemImgView: UIImageView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var catLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemImgView.backgroundColor = LINE_COLOR
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.locationLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.catLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
        self.itemImgView.radius(value: 5.0)
        
        if Utility.shared.isRTL(){
            self.itemImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.catLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.catLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
            self.timeLbl.textAlignment = .right
            self.locationLbl.textAlignment = .right

        }
    }
    
}

//
//  CategoryCell.swift
//  iDemand
//
//  Created by Roby on 12/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var cardView: MDCCard!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var inActiveView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryImgView.backgroundColor = LINE_COLOR
        nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "")
        nameLbl.text = "Construction"
        self.categoryImgView.radius(value: 5.0)
        self.cardView.elevation(radius: 5.0)
        self.inActiveView.radius(value: 5.0)
        self.cardView.setShadowElevation(.none, for: .normal)
        inActiveView.isHidden = true
        //check rtl
        if Utility.shared.isRTL(){
            self.categoryImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            self.categoryImgView.transform = .identity
            self.nameLbl.transform = .identity
        }
    }
    
}

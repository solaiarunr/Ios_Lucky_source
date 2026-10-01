//
//  CollectionViewCell.swift
//  iDemand
//
//  Created by HTS-105 on 21/09/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
        
    }
    func setup(){
        self.fullView.layer.cornerRadius = 10
        self.profileView.layer.cornerRadius = 10
        self.profileImg.layer.cornerRadius = 5
        self.fullView.backgroundColor = .white
        self.profileView.backgroundColor = .white
        self.taskNameLbl.config(color: SECONDARY_COLOR!, font: smallReg, align: .left, text: "")
        self.priceLbl.config(color: SECONDARY_COLOR!, font: headReg, align: .left, text: "")
        self.descriptionLbl.config(color: SECONDARY_COLOR!, font: normalReg, align: .left, text: "")
        self.descriptionLbl.numberOfLines = 2
//        self.profileView.dropShadow(color: TEXT_BLACK_COLOR!, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    
        
        self.profileView.dropShadow(opacity: 0.08)
        self.fullView.dropShadow(opacity: 0.08)
        
        //shaddow
        
    }

}

//
//  ReviewCell.swift
//  iDemand
//
//  Created by Roby on 21/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var ratingDesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImgView.radius(value: 5.0)
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.timeLbl.config(color: TEXT_BLACK_COLOR!, font: normalReg, align: .right, text: "")
        self.locationLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.ratingLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.ratingDesLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")

        //check rtl
            if Utility.shared.isRTL(){
                self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.locationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ratingDesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)

                self.nameLbl.textAlignment = .right
                self.timeLbl.textAlignment = .left
                self.locationLbl.textAlignment = .right
                self.ratingLbl.textAlignment = .right
                self.ratingDesLbl.textAlignment = .right

            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

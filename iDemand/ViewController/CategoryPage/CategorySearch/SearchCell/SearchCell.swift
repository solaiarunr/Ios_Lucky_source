//
//  SearchCell.swift
//  iDemand
//
//  Created by Roby on 28/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var serviceNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.typeLbl.config(color: TEXT_LITE_COLOR!, font: subReg, align: .left, text: "")
        self.categoryImgView.backgroundColor = LINE_COLOR
        self.categoryImgView.radius(value: 5.0)
        if Utility.shared.isRTL(){
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.typeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.typeLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

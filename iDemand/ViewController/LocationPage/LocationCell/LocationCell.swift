//
//  LocationCell.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet var locationLbl: UILabel!
    
    @IBOutlet var tickIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.locationLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        if Utility.shared.isRTL(){
            self.locationLbl.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

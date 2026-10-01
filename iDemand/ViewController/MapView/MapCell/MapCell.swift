//
//  MapCell.swift
//  iDemand
//
//  Created by Roby on 04/12/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var fullAddressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addressLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.fullAddressLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        if Utility.shared.isRTL(){
            self.addressLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fullAddressLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.addressLbl.textAlignment = .right
            self.fullAddressLbl.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

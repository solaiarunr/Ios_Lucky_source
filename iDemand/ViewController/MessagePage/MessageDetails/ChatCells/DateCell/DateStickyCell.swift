//
//  DateStickyCell.swift
//  iDemand
//
//  Created by Roby on 29/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class DateStickyCell: UITableViewCell {

    @IBOutlet var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .center, text: "")
        if Utility.shared.isRTL(){
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

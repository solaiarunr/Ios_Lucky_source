//
//  HelpCell.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class HelpCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        if Utility.shared.isRTL(){
               self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
              }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

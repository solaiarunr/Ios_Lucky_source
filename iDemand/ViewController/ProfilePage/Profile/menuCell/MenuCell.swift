//
//  MenuCell.swift
//  iDemand
//
//  Created by Roby on 04/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet var menuNameLbl: UILabel!
    @IBOutlet var menuIcon: UIImageView!
    @IBOutlet var hintLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.menuNameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.hintLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")

           if Utility.shared.isRTL(){
            self.menuNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.hintLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.menuIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.menuNameLbl.textAlignment = .right
            self.hintLbl.textAlignment = .right
            
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

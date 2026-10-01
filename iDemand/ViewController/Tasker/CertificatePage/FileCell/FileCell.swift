//
//  FileCell.swift
//  iDemand
//
//  Created by Roby on 05/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import TCProgressBar

class FileCell: UITableViewCell {
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var typeIcon: UIButton!
    @IBOutlet var progress: TCProgressBar!
    
    @IBOutlet var downloadBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.progress.progressColor = PRIMARY_COLOR!
        self.progress.backgroundColor = LINE_COLOR!
        self.progress.outlineColor = .clear
        self.progress.spacing = 0
        self.progress.outlineWidth = 0
        self.progress.value = 0.0
        self.typeIcon.backgroundColor = LINE_COLOR!
        self.typeIcon.radius(value: 5.0)
        if Utility.shared.isRTL(){
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.progress.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.typeIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

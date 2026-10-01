//
//  NotificationCell.swift
//  iDemand
//
//  Created by Roby on 31/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var notificationImgView: UIImageView!
    @IBOutlet var bookingDateLbl: UILabel!
    @IBOutlet var msgLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
        @IBOutlet var referenceIDLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.notificationImgView.backgroundColor = LINE_COLOR
        self.notificationImgView.radius(value: 5.0)
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.bookingDateLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.referenceIDLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")

        self.dateLbl.config(color: TEXT_BLACK_COLOR!, font: normalReg, align: .right, text: "")
        self.msgLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        if Utility.shared.isRTL(){
            self.notificationImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.referenceIDLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingDateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.referenceIDLbl.textAlignment = .right
            self.bookingDateLbl.textAlignment = .right
            self.nameLbl.textAlignment = .right
            self.dateLbl.textAlignment = .right
            self.msgLbl.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

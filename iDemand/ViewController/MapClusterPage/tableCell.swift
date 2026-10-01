//
//  tableCell.swift
//  iDemand
//
//  Created by HTS-105 on 20/09/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//
// qwerty
import UIKit

class tableCell: UITableViewCell {

    @IBOutlet weak var taskerNameLbl: UILabel!
    @IBOutlet weak var taskeNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    var taskerName: String!
    var taskname: String!
    var location: String!
    var imageUrl: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = BACKGROUND_COLOR
        self.userImage.backgroundColor = TEXT_BLACK_COLOR
        self.userImage.layer.cornerRadius = 10
        if LocalDefault().isUser()!{
//            let url = URL(string: imageUrl)
//            let data = try? Data(contentsOf: url!)
//            self.imageView?.image = UIImage(data: data!)
//            self.taskerNameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "")
//            self.taskeNameLbl.config(color: .blue, font: smallReg, align: .left, text: "")
//            self.locationLbl.config(color: TEXT_LITE_COLOR!, font: liteReg, align: .left, text: "")
            self.taskerNameLbl.textColor = TEXT_BLACK_COLOR
            self.taskerNameLbl.font = headBold
            self.taskerNameLbl.textAlignment = .left
            
            self.taskeNameLbl.textColor = PRIMARY_COLOR
            self.taskeNameLbl.font = smallReg
            self.taskeNameLbl.textAlignment = .left
            
            self.locationLbl.textColor = TEXT_BLACK_COLOR
            self.locationLbl.font = liteReg
            self.locationLbl.textAlignment = .left
            
            
        }
        else{
            //modified-AR
            self.taskerNameLbl.textColor = TEXT_BLACK_COLOR
            self.taskerNameLbl.font = headBold
            self.taskerNameLbl.textAlignment = .left
            
            
//            self.taskeNameLbl.textColor = TEXT_BLACK_COLOR
            self.taskeNameLbl.font = headBold
            self.taskeNameLbl.textAlignment = .left
            
            self.locationLbl.textColor = TEXT_BLACK_COLOR
            self.locationLbl.font = liteReg
            self.locationLbl.textAlignment = .left
            
        }
//        self.taskerNameLbl.text = taskerName ?? "Tasker"
//        self.taskeNameLbl.text = taskname ?? "Task"
//        self.locationLbl.text = location ?? "location"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  SubCatCell.swift
//  iDemand
//
//  Created by Roby on 29/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class SubCatCell: UITableViewCell {

    @IBOutlet var subCatImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var checkBoxView: VKCheckbox!
    @IBOutlet var checkBox: UIButton!
    
    var subCategoryID = ""
    var indexpath_row = 0
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.subCatImgView.backgroundColor = LINE_COLOR
        self.subCatImgView.radius(value: 5.0)
        initiatSetup()
        
        if Utility.shared.isRTL(){
             self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
             self.subCatImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
         }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initiatSetup(){
        configCheckBox()
    }
    
    func configCheckBox(){
        self.checkBoxView.line = .thin
//        self.checkBox.bgColorSelected  = PRIMARY_COLOR!
        self.checkBoxView.bgColorSelected  = .clear
        self.checkBoxView.bgColor          = .clear
        self.checkBoxView.color            = PRIMARY_COLOR!
        self.checkBoxView.borderWidth      = 1
        self.checkBoxView.cornerRadius     = 5
        if self.isChecked{
            self.checkBoxView.borderColor      = PRIMARY_COLOR!
        }
        else{
            self.checkBoxView.borderColor      = LINE_COLOR
        }
    }
    
}

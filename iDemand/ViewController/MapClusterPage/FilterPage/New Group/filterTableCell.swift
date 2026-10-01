//
//  filterTableCell.swift
//  iDemand
//
//  Created by HTS-105 on 31/01/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import UIKit

class filterTableCell: UITableViewCell {

    @IBOutlet weak var checkBox: VKCheckbox!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    var subCategoryID = ""
    var indexpath_row = 0
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initiatSetup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func initiatSetup(){
        self.itemLbl.font = subReg
        self.contentView.backgroundColor = BACKGROUND_COLOR
        self.configCheckBox()
    }
    func configCheckBox(){
        self.checkBox.line             = .thin
//        self.checkBox.bgColorSelected  = PRIMARY_COLOR!
        self.checkBox.bgColorSelected  = .clear
        self.checkBox.bgColor          = .clear
        self.checkBox.color            = PRIMARY_COLOR!
        self.checkBox.borderWidth      = 1
        self.checkBox.cornerRadius     = 5
        if self.isChecked{
            self.checkBox.borderColor      = PRIMARY_COLOR!
        }
        else{
            self.checkBox.borderColor      = LINE_COLOR
        }
    }
}

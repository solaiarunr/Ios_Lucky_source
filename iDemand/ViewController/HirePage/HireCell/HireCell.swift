//
//  HireCell.swift
//  iDemand
//
//  Created by Roby on 21/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class HireCell: UITableViewCell {

    @IBOutlet var userImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var completedLbl: UILabel!
    @IBOutlet var hireBtn: UIButton!
    @IBOutlet var profileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImgView.backgroundColor = LINE_COLOR
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.ratingLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.completedLbl.config(color: TEXT_LITE_COLOR!, font: smallReg, align: .left, text: "")
        self.hireBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "hire")
        self.hireBtn.backgroundColor = PRIMARY_COLOR
        self.userImgView.radius(value: 5.0)
        self.hireBtn.radius(value: 5.0)
        
        //check rtl
            if Utility.shared.isRTL(){
                self.userImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.completedLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.hireBtn.transform = CGAffineTransform(scaleX: -1, y: 1)

                self.nameLbl.textAlignment = .right
                self.nameLbl.textAlignment = .right
                self.priceLbl.textAlignment = .right
                self.ratingLbl.textAlignment = .right
                self.completedLbl.textAlignment = .right

            }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(model:Technicians)  {
        self.userImgView.sd_setImage(with: URL.init(string: model.user_image!), placeholderImage: #imageLiteral(resourceName: "placeholder_img"))

        self.nameLbl.text = model.name
        let jobs = Utility.shared.Json().value(forKey: "jobs") as! String
        self.completedLbl.text = "\(model.completed_tasks!) \(jobs)"
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        let type = Utility.shared.Json().value(forKey: "hr") as! String
        self.priceLbl.text = "\(currency_code) \(model.price!) / \(type)"
        self.priceLbl.adjustsFontSizeToFitWidth = true

        let ratingTxt = "★ \(model.rating!) (\(model.reviews!) \(Utility.shared.Json().value(forKey: "ratings") as! String))"
        let actTxt = "★ \(model.rating!)"
        let attrStr = NSMutableAttributedString(string: ratingTxt)
        let termsRange = (ratingTxt as NSString).range(of: actTxt)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: RATING_GREEN!, range: termsRange)
        self.ratingLbl.attributedText = attrStr

    }
    
}

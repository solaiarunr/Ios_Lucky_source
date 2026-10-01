//
//  ProfessionalServiceCell.swift
//  iDemand
//
//  Created by Roby on 12/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ProfessionalServiceCell: UITableViewCell {
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var increaseBtn: UIButton!
    @IBOutlet var decreaseBtn: UIButton!
    @IBOutlet var quantityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
        self.priceLbl.text = ""
        self.serviceImgView.backgroundColor = LINE_COLOR
        self.serviceImgView.radius(value: 5.0)
        self.quantityLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .center, text: "add")
        let increaseImg = #imageLiteral(resourceName: "increase_icon").withRenderingMode(.alwaysTemplate)
        let decreaseImg = #imageLiteral(resourceName: "decrease_icon").withRenderingMode(.alwaysTemplate)
        self.increaseBtn.setImage(increaseImg, for: .normal)
        self.decreaseBtn.setImage(decreaseImg, for: .normal)
        self.increaseBtn.tintColor = TEXT_BLACK_COLOR
        self.decreaseBtn.tintColor = LINE_COLOR
        self.decreaseBtn.isUserInteractionEnabled = false
        
        if Utility.shared.isRTL(){
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.quantityLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
            self.priceLbl.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func config(model:Services,selectedIDs:NSMutableArray,isEdit:Bool)  {
        self.nameLbl.text = model.service_name
        let item_img = URL.init(string: model.service_image!)
        self.serviceImgView.sd_setImage(with: item_img, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        var quantityType  = String()
        if model.service_pricing == "unit"{
            quantityType = Utility.shared.Json().value(forKey: "unit") as! String
        }else{
            quantityType = Utility.shared.Json().value(forKey: "hr") as! String
        }
        
        self.priceLbl.text = "\(currency_code) \(model.service_price!)/\(quantityType)"
        if selectedIDs.contains(model.service_id!){
            self.nameLbl.textColor = PRIMARY_COLOR!
        }else{
            self.nameLbl.textColor = TEXT_BLACK_COLOR!
        }
        self.priceLbl.adjustsFontSizeToFitWidth = true

        
    }
}

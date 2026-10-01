//
//  Serviceself.swift
//  iDemand
//
//  Created by Roby on 29/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var inActiveView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .right, text: "")
        self.priceLbl.text = ""
        self.serviceImgView.backgroundColor = LINE_COLOR
        self.serviceImgView.radius(value: 5.0)
        self.inActiveView.radius(value: 5.0)
        
        if Utility.shared.isRTL(){
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.inActiveView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(model:Services,type:String,selectedIDs:NSMutableArray,isEdit:Bool)  {
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
        
        if type == "professional"{
            self.priceLbl.text = "\(currency_code) \(model.service_price!)/\(quantityType)"
        }else{
            if !selectedIDs.contains(model.service_id!){
                self.priceLbl.text = ""
            }else{
                if isEdit{
                    self.priceLbl.text = "\(currency_code) \(model.service_price!)/\(quantityType)"
                }
            }
        }
        self.priceLbl.adjustsFontSizeToFitWidth = true
        if selectedIDs.contains(model.service_id!){
            self.nameLbl.textColor = PRIMARY_COLOR!
        }else{
            self.nameLbl.textColor = TEXT_BLACK_COLOR!
        }
        //disable view
        if model.service_status == "0" {
            self.inActiveView.isHidden = false
        }else{
            self.inActiveView.isHidden = true
        }
    }
}

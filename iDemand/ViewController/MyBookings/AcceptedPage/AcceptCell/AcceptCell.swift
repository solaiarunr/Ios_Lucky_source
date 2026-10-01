//
//  AcceptCell.swift
//  iDemand
//
//  Created by Roby on 16/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class AcceptCell: UITableViewCell {
    
    @IBOutlet var itemImgView: UIImageView!
    @IBOutlet var referenceIDLbl: UILabel!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemImgView.backgroundColor = LINE_COLOR
        self.referenceIDLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .right, text: "")
        self.statusLbl.config(color: PRIMARY_COLOR!, font: smallReg, align: .left, text: "")
        self.dateLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.itemImgView.radius(value: 5.0)
        if Utility.shared.isRTL(){
            self.referenceIDLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.itemImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.textAlignment = .right
            self.referenceIDLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
            self.dateLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(model:bookingItems)  {
        self.itemImgView.sd_setImage(with: URL.init(string: model.item_image!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        if model.item_name != nil{
            self.serviceNameLbl.text = model.item_name!
        }
        self.dateLbl.text = Utility.shared.toLocal(dateStr: model.date!, format: "dd.MMM.yyyy") ?? ""
        let referID = "\(Utility.shared.Json().value(forKey: "id") ?? "") : #\(model.reference_id!)"
        self.referenceIDLbl.text = referID.uppercased()
        self.statusLbl.text = Utility.shared.get(status: model.status!)
        self.statusLbl.textColor = Utility.shared.color(status: model.status!)
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        self.priceLbl.text = "\(currency_code) \(model.price!)"
        self.priceLbl.adjustsFontSizeToFitWidth = true
    }
    
    func config(need:Needs)  {
        //qwerty
        self.itemImgView.sd_setImage(with: URL.init(string: need.subcategory_image!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
        self.serviceNameLbl.text = need.name!
        self.dateLbl.text = Utility.shared.toLocal(dateStr: need.date!, format: "dd.MMM.yyyy") ?? ""
        let referID = "\(Utility.shared.Json().value(forKey: "id") ?? "") : #\(need.reference_id!)"
        self.referenceIDLbl.text = referID.uppercased()
        if need.due_status == "true"{
            self.statusLbl.text = Utility.shared.Json().value(forKey: "expired") as? String
            self.statusLbl.textColor = Utility.shared.color(status: "expired")
        }else if need.active_status == "true"{
            self.statusLbl.text = Utility.shared.Json().value(forKey: "active") as? String
            self.statusLbl.textColor = Utility.shared.color(status: "active")
        }else if need.active_status == "false"{
            self.statusLbl.text = Utility.shared.Json().value(forKey: "pending") as? String
            self.statusLbl.textColor = Utility.shared.color(status: "pending")
        }
        let defaultDict = LocalDefault.shared.appDefaults()
        let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
        self.priceLbl.text = "\(currency_code) \(need.booking_price!)"
        self.priceLbl.adjustsFontSizeToFitWidth = true
    }

    
}

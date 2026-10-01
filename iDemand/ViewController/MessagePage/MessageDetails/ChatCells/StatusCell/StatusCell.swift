//
//  StatusCell.swift
//  iDemand
//
//  Created by Roby on 29/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class StatusCell: UITableViewCell {
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var imgBtn: UIButton!
    @IBOutlet var containerView: MDCCard!
    
    var booking_status = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.serviceImgView.backgroundColor = LINE_COLOR
        self.serviceImgView.radius(value: 5.0)
//        self.priceLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.priceLbl.config(color: UIColor.black, font: subBold, align: .left, text: "")
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.payBtn.config(color: TEXT_WHITE_COLOR!, font: subBold, align: .center, title: "pay")
        self.payBtn.radius(value: 5.0)
        self.statusLbl.config(color: RATING_GREEN!, font: subBold, align: .left, text: "request_accepted")
        
        self.payBtn.backgroundColor = RATING_GREEN
        if LocalDefault.shared.isUser()! {
            self.containerView.backgroundColor =  RECEIVER_BG
        }else{
            self.containerView.backgroundColor =  SENDER_BG
        }
        
        if Utility.shared.isRTL(){
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            
            self.priceLbl.textAlignment = .right
            self.statusLbl.textAlignment = .right
            self.timeLbl.textAlignment = .right
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(dict:NSDictionary,type:String,msgDict:NSDictionary)  {
        if dict.value(forKey: "service_image") != nil{
            self.booking_status = dict.value(forKey: "status") as! String
            
            if type == "accept"{
                self.statusLbl.textColor = RATING_GREEN!
                self.statusLbl.text = (Utility.shared.Json().value(forKey: "request_accepted") as! String)
            }else{
                self.statusLbl.textColor = PRIMARY_COLOR!
                self.statusLbl.text = (Utility.shared.Json().value(forKey: "request_declined") as! String)
            }
            self.serviceImgView.sd_setImage(with:URL.init(string: (dict.value(forKey: "service_image") as? String)!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            let defaultDict = LocalDefault.shared.appDefaults()
            let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
            self.priceLbl.text = "\(Utility.shared.Json().value(forKey: "price") ?? "") \(currency_code) \(msgDict.value(forKeyPath: "message.quote_price") as? String ?? "")"
            self.priceLbl.adjustsFontSizeToFitWidth = true
            
            self.timeLbl.text = Utility.shared.toLocal(dateStr:msgDict.value(forKey: "date") as! String , format:"hh.mm a" )
            if isActive(status: msgDict.value(forKeyPath: "message.isActive") as? String ?? ""){
                
            }
            
        }
    }
    
    func isActive(status:String) -> Bool {
        if  self.booking_status == "paid" || self.booking_status == "cancelled" || self.booking_status == "completed" || status == "false"  || self.booking_status == "accepted"{
            
            return false
        }else{
            return true
        }
    }
}

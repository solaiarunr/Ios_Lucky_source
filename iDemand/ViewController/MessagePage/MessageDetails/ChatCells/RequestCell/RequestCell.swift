//
//  RequestCell.swift
//  iDemand
//
//  Created by Roby on 27/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class RequestCell: UITableViewCell {
    @IBOutlet var requestView: MDCCard!
    @IBOutlet var requestLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceTitleLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var desLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var imgBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.requestView.switchElevation(radius: 5.0)
//        self.requestLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "sent_request")
        self.requestLbl.config(color: UIColor.black, font: subBold, align: .left, text: "sent_request")
        self.serviceImgView.radius(value: 5.0)
        self.serviceImgView.backgroundColor = LINE_COLOR
//        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
//        self.priceTitleLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "price")
        self.serviceNameLbl.config(color: UIColor.black, font: smallBold, align: .left, text: "")
        self.priceTitleLbl.config(color: UIColor.black, font: subBold, align: .left, text: "price")
        self.priceLbl.config(color: PRIMARY_COLOR!, font: subBold, align: .right, text: "")
//        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.desLbl.config(color: UIColor.black, font: smallReg, align: .left, text: "")
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .right, text: "")
        
        self.requestView.backgroundColor = RECEIVER_BG
        self.priceView.backgroundColor = RECEIVER_INNER_BG
        self.priceView.radius(value: 5.0)
        
        if Utility.shared.isRTL(){
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.requestLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)

            self.requestLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
            self.priceTitleLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
            self.desLbl.textAlignment = .right
            self.timeLbl.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(dict: NSDictionary,msgDict:NSDictionary)  {
        if dict.value(forKey: "service_name") != nil {
            let message_type = msgDict.value(forKey: "message_type") as! String
            if message_type == "quote"{
                self.requestLbl.text = (Utility.shared.Json().value(forKey: "sent_quote") as! String)
                self.desLbl.text = msgDict.value(forKeyPath: "message.description") as? String
                
            }else{
                self.requestLbl.text = (Utility.shared.Json().value(forKey: "sent_request") as! String)
                //modified-AR
//                self.desLbl.text = dict.value(forKey: "description") as? String
                self.desLbl.text = msgDict.value(forKeyPath: "message.description") as? String
            }
            self.serviceNameLbl.text = dict.value(forKey: "service_name") as? String
            self.serviceImgView.sd_setImage(with:URL.init(string: (dict.value(forKey: "service_image") as? String)!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            let defaultDict = LocalDefault.shared.appDefaults()
            let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
            let bookingAmt = Double(msgDict.value(forKeyPath: "message.quote_price") as? String ?? "")
            self.priceLbl.text = "\(currency_code) \(String(format: "%.2f", bookingAmt!))"
            self.timeLbl.text = Utility.shared.toLocal(dateStr:msgDict.value(forKey: "date") as! String , format:"hh.mm a" )
            self.priceLbl.adjustsFontSizeToFitWidth = true
        }
    }
    
}

//
//  QuoteCell.swift
//  iDemand
//
//  Created by Roby on 28/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class QuoteCell: UITableViewCell {
    
    @IBOutlet var requestView: MDCCard!
    
    @IBOutlet var requestLbl: UILabel!
    @IBOutlet var serviceImgView: UIImageView!
    @IBOutlet var serviceNameLbl: UILabel!
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceTitleLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var desLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var actionView: UIView!
    @IBOutlet var quoteBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    
    @IBOutlet var imgBtn: UIButton!
    var cellType = String()
    var booking_status = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.requestView.switchElevation(radius: 5.0)
        self.serviceImgView.radius(value: 5.0)
        self.serviceImgView.backgroundColor = LINE_COLOR
//        self.serviceNameLbl.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, text: "")
        self.serviceNameLbl.config(color: UIColor.black, font: smallBold, align: .left, text: "")
        self.priceLbl.config(color: PRIMARY_COLOR!, font: subBold, align: .right, text: "")
//        self.desLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.desLbl.config(color: UIColor.black, font: smallReg, align: .left, text: "")
        self.timeLbl.config(color: TEXT_BLACK_COLOR!, font: normalReg, align: .left, text: "")
        self.requestLbl.textColor = UIColor.black
        self.priceView.radius(value: 5.0)
        self.quoteBtn.config(color: TEXT_LITE_COLOR!, font: subBold, align: .center, title: "quote_price")
        self.acceptBtn.config(color: RATING_GREEN!, font: subBold, align: .center, title: "accept")
        self.priceTitleLbl.textColor = UIColor.black
        if Utility.shared.isRTL(){
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.requestLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.desLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.acceptBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.quoteBtn.transform = CGAffineTransform(scaleX: -1, y: 1)

            self.requestLbl.textAlignment = .right
            self.serviceNameLbl.textAlignment = .right
            self.priceTitleLbl.textAlignment = .right
            self.priceLbl.textAlignment = .left
            self.desLbl.textAlignment = .right
            self.timeLbl.textAlignment = .right
        }else{
            self.timeLbl.textAlignment = .left
        }
    }
    override func layoutSubviews() {
        self.timeLbl.frame.origin.y = self.requestView.frame.size.height + self.requestView.frame.origin.y

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(dict: NSDictionary,type:String,msgDict:NSDictionary)  {
        self.cellType = type
        if dict.value(forKey: "service_name") != nil{
            self.booking_status = dict.value(forKey: "status") as! String

            self.serviceNameLbl.text = dict.value(forKey: "service_name") as? String
            self.serviceImgView.sd_setImage(with:URL.init(string: (dict.value(forKey: "service_image") as? String)!), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            let defaultDict = LocalDefault.shared.appDefaults()
            let currency_code = defaultDict?.value(forKey: "currency_symbol") as! String
            
            self.timeLbl.text = Utility.shared.toLocal(dateStr:msgDict.value(forKey: "date") as! String , format:"hh.mm a" )
            if type == "quote"{
                self.requestLbl.text = (Utility.shared.Json().value(forKey: "quoted") as! String)

                self.desLbl.text = msgDict.value(forKeyPath: "message.description") as? String
                self.quoteBtn.config(color: TEXT_LITE_COLOR!, font: subBold, align: .center, title: "decline")
                self.acceptBtn.config(color: RATING_GREEN!, font: subBold, align: .center, title: "accept")
                self.priceTitleLbl.text = (Utility.shared.Json().value(forKey: "quote_price") as! String)

                self.priceLbl.text = "\(currency_code) \(msgDict.value(forKeyPath: "message.quote_price") as? String ?? "")"
            }
            //modified-AR
            else if type == "request"{
                self.requestLbl.text = (Utility.shared.Json().value(forKey: "quoted") as! String)

                self.desLbl.text = msgDict.value(forKeyPath: "message.description") as? String
                self.quoteBtn.config(color: TEXT_LITE_COLOR!, font: subBold, align: .center, title: "decline")
                self.acceptBtn.config(color: RATING_GREEN!, font: subBold, align: .center, title: "accept")
                self.priceTitleLbl.text = (Utility.shared.Json().value(forKey: "price") as! String)

                self.priceLbl.text = "\(currency_code) \(msgDict.value(forKeyPath: "message.quote_price") as? String ?? "")"
            }
            else{
                self.priceLbl.text = "\(currency_code) \(msgDict.value(forKeyPath: "message.quote_price") as? String ?? "")"
                self.requestLbl.text = (Utility.shared.Json().value(forKey: "receive_request") as! String)

                self.desLbl.text = dict.value(forKey: "description") as? String
                self.quoteBtn.config(color: TEXT_LITE_COLOR!, font: subBold, align: .center, title: "quote_price")
                self.acceptBtn.config(color: RATING_GREEN!, font: subBold, align: .center, title: "accept")
                self.priceTitleLbl.text = (Utility.shared.Json().value(forKey: "price") as! String)

            }
        }
        self.priceLbl.adjustsFontSizeToFitWidth = true

        var fixedWidth =  self.desLbl.intrinsicContentSize.width
        if fixedWidth > 240{
            fixedWidth = 240
        }
        self.desLbl.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize =  self.desLbl.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame =  self.desLbl.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.desLbl.frame = CGRect.init(x: 15, y: self.priceView.frame.origin.y + 55, width: newFrame.size.width, height: newFrame.size.height)
        
        self.actionView.frame = CGRect.init(x: 0, y:  self.desLbl.frame.origin.y +  self.desLbl.frame.size.height+10, width: self.requestView.frame.size.width, height: 50)
        self.requestView.frame.size.height = self.actionView.frame.origin.y + 50
        self.timeLbl.frame.origin.y = self.requestView.frame.size.height + self.requestView.frame.origin.y
        
     
                   self.requestView.backgroundColor = SENDER_BG
                   self.priceView.backgroundColor = SENDER_INNER_BG
        if !isActive(status: msgDict.value(forKeyPath: "message.isActive") as? String ?? ""){
            self.actionView.isHidden = true
        }else{
            self.actionView.isHidden = false
        }
    }
    
    func isActive(status:String) -> Bool {
        //modified-AR
//        if  self.booking_status == "paid" || self.booking_status == "cancelled" || self.booking_status == "completed" || status == "false" || self.booking_status == "accepted"{
        if  self.booking_status == "paid" || self.booking_status == "cancelled" || self.booking_status == "completed" || status == "false" || self.booking_status == "accepted" || self.booking_status == "payment_pending"{
            return false
        }else{
            return true
        }
    }
    
}

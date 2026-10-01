//
//  MessageCell.swift
//  iDemand
//
//  Created by Roby on 25/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet var serviceImgView: UIImageView!    
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var unreadView: UIView!
    @IBOutlet var referenceIDLbl: UILabel!
    @IBOutlet var bookingDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: subBold, align: .left, text: "")
        self.messageLbl.config(color: TEXT_BLACK_COLOR!, font: smallReg, align: .left, text: "")
        self.serviceImgView.radius(value: 10.0)
        self.serviceImgView.backgroundColor = LINE_COLOR
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .right, text: "")
        self.bookingDateLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.referenceIDLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.unreadView.backgroundColor = PRIMARY_COLOR
        self.countLbl.config(color: TEXT_WHITE_COLOR!, font: smallReg, align: .center, text: "")
        self.unreadView.radius(value: 15)
        if Utility.shared.isRTL(){
            self.nameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.referenceIDLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.messageLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.serviceImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.countLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingDateLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bookingDateLbl.textAlignment = .right
            self.nameLbl.textAlignment = .right
            self.messageLbl.textAlignment = .right
            self.timeLbl.textAlignment = .left
            self.referenceIDLbl.textAlignment = .right
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(dict:NSDictionary)  {
        let chat_type = dict.value(forKey: "chat_type") as! String
        if dict.value(forKey: "message") is String{
            self.messageLbl.text = ""
        }else{
                let type = dict.value(forKeyPath: "message.type") as? String
                if type == "cancel"{
                    self.messageLbl.text = Utility.shared.Json().value(forKey: "service_declined") as? String
                }else if type == "accept"{
                    self.messageLbl.text = Utility.shared.Json().value(forKey: "service_accpted") as? String
                    
                }else if type == "request"{
                    self.messageLbl.text = Utility.shared.Json().value(forKey: "service_request") as? String
                }else if type == "quote"{
                    let price = dict.value(forKeyPath: "message.price") as? String ?? ""
                    //qwerty
                    self.messageLbl.text = "\(Utility.shared.Json().value(forKey: "quoted_price") ?? "") \(String(describing: price)) \((Utility.shared.Json().value(forKey: "for_booking") ?? ""))"
                }else{
                    self.messageLbl.text = dict.value(forKeyPath: "message.message") as? String
                }
           
        }
        let dateStr = dict.value(forKey: "date") as? String
        if dateStr != ""{
            self.timeLbl.text = Utility.shared.msg(Time: ((dict.value(forKey: "date") as? String)!))
        }
        
        if chat_type == "admin"{
            self.nameLbl.frame.origin.y = 15
            self.messageLbl.frame.origin.y = 40
            
            self.referenceIDLbl.isHidden = true
            self.nameLbl.text = "\(APP_NAME) \(Utility.shared.Json().value(forKey: "team") ?? "")"
            self.messageLbl.text = Utility.shared.Json().value(forKey: "contact_us_for_queries") as? String
            self.serviceImgView.image = UIImage.init(named: "app_icon")
            self.unreadView.isHidden = true
            self.bookingDateLbl.isHidden = true
            self.timeLbl.isHidden = true
        }else{
            self.nameLbl.frame.origin.y = 5
            self.referenceIDLbl.isHidden = false
            self.timeLbl.isHidden = false
            self.bookingDateLbl.text = (Utility.shared.toLocal(dateStr: ((dict.value(forKey: "booking_date") as? String)!), format: "dd.MMM.yyyy") ?? "")
            let referID = "\(Utility.shared.Json().value(forKey: "id") ?? "") : #\((dict.value(forKey: "reference_id") as! String))"
            self.referenceIDLbl.text = referID.uppercased()
            self.nameLbl.text = (dict.value(forKey: "name") as! String)
            let userimgURL = URL.init(string: dict.value(forKey: "user_image") as! String)
            self.serviceImgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "placeholder_img"))
            let unread_count = dict.value(forKey: "unread_count") as? String
            if unread_count == "0"{
                self.unreadView.isHidden = true
            }else{
                self.unreadView.isHidden = false
                self.countLbl.text = unread_count
            }
        }
    }
}

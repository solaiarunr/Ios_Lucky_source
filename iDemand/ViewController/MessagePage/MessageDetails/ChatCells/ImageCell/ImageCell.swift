//
//  ImageCell.swift
//  iDemand
//
//  Created by Roby on 27/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftyGif

class ImageCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var containerView: MDCCard!
    @IBOutlet var gifImgView: UIImageView!
    @IBOutlet var locationView: UIView!
    
    @IBOutlet var shareLbl: UILabel!
    
    var receiver_id = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.switchElevation(radius: 5.0)
        self.imgView.radius(value: 5.0)
        self.imgView.backgroundColor = LINE_COLOR
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .right, text: "")
        self.shareLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .center, text: "location")

        if Utility.shared.isRTL(){
            self.imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.shareLbl.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //set view left
    func leftAligned()  {
        self.containerView.frame.origin.x = 10
        self.timeLbl.frame.origin.x = 10
        
        if Utility.shared.isRTL(){
            self.timeLbl.textAlignment = .right
        }else{
            self.timeLbl.textAlignment = .left
        }
        self.containerView.backgroundColor = SENDER_BG
    }
    //set view right
    func rightAligned()  {
        self.containerView.frame.origin.x = FULL_WIDTH-285
        self.timeLbl.frame.origin.x = FULL_WIDTH-285
        if Utility.shared.isRTL(){
            self.timeLbl.textAlignment = .left
        }else{
            self.timeLbl.textAlignment = .right
        }
        self.containerView.backgroundColor = RECEIVER_BG
    }
    override func layoutSubviews() {
        if receiver_id == LocalDefault.shared.userID(){
            self.leftAligned()
        }else{
            self.rightAligned()
        }
    }
    func config(dict:NSDictionary,type:String)  {
        self.gifImgView.isHidden = true
        self.imgView.isHidden = true
        self.locationView.isHidden = true
        var imageURL = String()
        if type == "location"{
            if LocalDefault.shared.isLiveTrack()! {
                self.imgView.isHidden = false
                let lat = dict.value(forKeyPath: "message.lat") as? Double ?? Double(0)
                let lon = dict.value(forKeyPath: "message.lon") as? Double ?? Double(0)
                imageURL = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(lon)&zoom=14&size=400x200&sensor=false&key=\(GOOGLE_API_KEY)&maptype=roadmap&markers=color:red%7Clabel:S%7C\(lat),\(lon)"
                self.imgView.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            }else{
                self.locationView.isHidden = false
            }
        }else if type == "image"{
            self.imgView.isHidden = false
            imageURL = dict.value(forKeyPath: "message.attachment") as! String
            self.imgView.sd_setImage(with: URL.init(string: imageURL), placeholderImage: #imageLiteral(resourceName: "service_placeholder"))

        }else if type == "gif"{
            self.gifImgView.isHidden = false
            imageURL = dict.value(forKeyPath: "message.attachment") as! String
            self.gifImgView.setGifFromURL(URL.init(string: imageURL)!)
        }
        self.timeLbl.text = Utility.shared.toLocal(dateStr:dict.value(forKey: "date") as! String , format:"hh.mm a" )
        receiver_id = dict.value(forKey: "receiver_id") as! String
        
        self.layoutSubviews()
    }
}

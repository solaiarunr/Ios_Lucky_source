//
//  AudioCell.swift
//  iDemand
//
//  Created by Roby on 27/01/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import UIKit

class AudioCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var durationLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var loader: UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .left, text: "")
        self.durationLbl.config(color: TEXT_LITE_COLOR!, font: normalReg, align: .right, text: "")
      
        self.containerView.radius(value: 5.0)
        self.durationLbl.text = "0.0"
        self.loader.color = PRIMARY_COLOR
        self.playBtn.setImage(#imageLiteral(resourceName: "play_icon"), for: .normal)
        self.changeToRTL()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeToRTL() {
        if Utility.shared.isRTL(){
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.durationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
    }
    
    func config(dict:NSDictionary)  {
      let  receiver_id = dict.value(forKey: "receiver_id") as! String
        if receiver_id ==  LocalDefault.shared.userID(){
            self.containerView.frame.origin.x = 15
            self.timeLbl.frame.origin.x = 15
            self.timeLbl.textAlignment = .left
            self.containerView.backgroundColor = RECEIVER_BG
        }else{
            self.containerView.frame.origin.x = FULL_WIDTH - 295
            self.timeLbl.frame.origin.x = FULL_WIDTH - 295
            self.timeLbl.textAlignment = .right
            self.containerView.backgroundColor = SENDER_BG
        }

        self.timeLbl.text = Utility.shared.toLocal(dateStr:dict.value(forKey: "date") as! String , format:"hh.mm a" )
        
        self.layoutSubviews()
    }
}

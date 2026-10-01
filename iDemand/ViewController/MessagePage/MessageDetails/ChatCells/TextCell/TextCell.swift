//
//  TextCell.swift
//  iDemand
//
//  Created by Roby on 27/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MaterialComponents

class TextCell: UITableViewCell {
    
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var msgTV: UITextView!
    @IBOutlet var translateBtn: UIButton!
    @IBOutlet var containerView: MDCCard!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeLbl.config(color: TEXT_LITE_COLOR!, font: liteReg, align: .right, text: "")
        self.translateBtn.config(color: PRIMARY_COLOR!, font: normalReg, align: .left, title: "translate")
        self.msgTV.isUserInteractionEnabled = true
        self.msgTV.textColor = .black
        self.msgTV.isEditable = false
        self.msgTV.isScrollEnabled = false
        self.msgTV.contentInsetAdjustmentBehavior = .never
        self.containerView.switchElevation(radius: 5.0)
        if Utility.shared.isRTL(){
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgTV.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(dict:NSDictionary,chatType:String)  {

        self.msgTV.text = dict.value(forKeyPath: "message.message") as? String
        var fixedWidth =  self.msgTV.intrinsicContentSize.width
        
        if fixedWidth > 240{
            if chatType == "admin"{
                fixedWidth = FULL_WIDTH - 40
            }else{
                fixedWidth = 240
            }
        }
        self.msgTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize =  self.msgTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame =  self.msgTV.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        if newFrame.size.width > 100{
            
            self.msgTV.frame = CGRect.init(x: 0, y: 0, width: newFrame.size.width, height: newFrame.size.height)
        }else{
            if chatType == "admin"{
                self.msgTV.frame = CGRect.init(x: 0, y: 0, width:newFrame.size.width+50, height: newFrame.size.height)
            }else{
                self.msgTV.frame = CGRect.init(x: 0, y: 0, width:newFrame.size.width, height: newFrame.size.height)
            }
        }
        let dateStr = dict.value(forKey: "date") as! String
        if dateStr != ""{
            if chatType == "admin"{
                self.timeLbl.text = Utility.shared.toLocal(dateStr:dateStr , format:"dd.MMM.yyy hh.mm a" )
            }else{
                self.timeLbl.text = Utility.shared.toLocal(dateStr:dateStr , format:"hh.mm a" )
            }
        }
        
        let receiver_id = dict.value(forKey: "receiver_id") as! String
        if receiver_id == LocalDefault.shared.userID() || receiver_id == ""{
            self.containerView.frame = CGRect.init(x: 10, y: 5, width: self.msgTV.frame.size.width, height: self.msgTV.frame.size.height)
            
            if ADD_ON{
                self.translateBtn.isHidden = false
                self.translateBtn.frame = CGRect.init(x: 5, y: newFrame.size.height, width: 125, height: 15)
                self.containerView.frame = CGRect.init(x: 10, y: 5, width: self.msgTV.frame.size.width+50, height: self.translateBtn.frame.size.height + self.translateBtn.frame.origin.y+5)
            }
            
            self.timeLbl.frame = CGRect.init(x: 10, y: self.containerView.frame.size.height+6, width: self.containerView.frame.width+30, height: 20)

            if Utility.shared.isRTL(){
                self.timeLbl.textAlignment = .right
                self.msgTV.textAlignment = .right
            }else{
                self.timeLbl.textAlignment = .left
                self.msgTV.textAlignment = .left
            }
            self.containerView.backgroundColor = SENDER_BG
        }else{
            self.translateBtn.isHidden = true

            self.containerView.frame = CGRect.init(x: FULL_WIDTH-(self.msgTV.frame.size.width+10), y: 5, width: self.msgTV.frame.size.width, height: self.msgTV.frame.size.height)
            self.timeLbl.frame = CGRect.init(x:  FULL_WIDTH-(self.containerView.frame.size.width+40), y: self.msgTV.frame.size.height+6, width: self.containerView.frame.width+30, height: 20)
       
            if Utility.shared.isRTL(){
                self.timeLbl.textAlignment = .left
                self.msgTV.textAlignment = .left
            }else{
                self.timeLbl.textAlignment = .right
                self.msgTV.textAlignment = .left
            }
            self.containerView.backgroundColor = RECEIVER_BG
        }
    }
}

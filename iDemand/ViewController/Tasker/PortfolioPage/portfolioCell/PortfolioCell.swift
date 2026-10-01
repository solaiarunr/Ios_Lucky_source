//
//  PortfolioCell.swift
//  iDemand
//
//  Created by Roby on 05/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class PortfolioCell: UICollectionViewCell {
    @IBOutlet var portfolioImgView: UIImageView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet weak var documentnameLbl: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.documentnameLbl.config(color: TEXT_BLACK_COLOR!, font: subReg, align: .left, text: "")
        self.portfolioImgView.radius(value: 5.0)
        if Utility.shared.isRTL(){
                self.portfolioImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.documentnameLbl.transform=CGAffineTransform(scaleX: -1, y: 1)
            }
    }

}

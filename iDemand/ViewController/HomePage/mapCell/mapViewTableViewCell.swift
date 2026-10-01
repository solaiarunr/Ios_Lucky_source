//
//  mapViewTableViewCell.swift
//  iDemand
//
//  Created by HTS-105 on 03/02/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import UIKit
import GoogleMaps
class mapViewTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapViewBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func initialSetup(){
        self.mapView.radius(value: 15.0)
    }
}

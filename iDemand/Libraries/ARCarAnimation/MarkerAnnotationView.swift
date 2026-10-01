//
//  MarkerAnnotationView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 12/05/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import MapKit

class MarkerAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? CarCustomAnnotation else { return }
            image = UIImage.init(named: annotation.pinCustomImageName)
        }
    }

}

//
//  mapViewVC.swift
//  iDemand
//
//  Created by HTS-105 on 20/09/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import UIKit

class mapViewVC: UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var bottomTableView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        self.navigationView.bottomRadius()
        self.navigationView.backgroundColor = .yellow
//        let screenSize: CGRect = UIScreen.main.bounds
        self.bottomTableView.topRadius()
        
    }

}

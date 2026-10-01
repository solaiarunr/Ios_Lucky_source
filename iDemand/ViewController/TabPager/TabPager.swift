//
//  TabPager.swift
//  iDemand
//
//  Created by Roby on 16/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import MXSegmentedPager

class TabPager: MXSegmentedPagerController,MXParallaxHeaderDelegate {
    
    let acceptObj = AcceptedPage()
    let completeObj = CompletedPage()
    let backBtn = UIButton()
    let navigationView = UIView()
    var topHeight = CGFloat()
    let titleLbl = UILabel()
    var viewType = String()
    var viewFrom = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("tab will appear")
        self.navigationView.isHidden = false
        self.initialSetup()
//        if viewType == "my_bookings"{
//            acceptObj.getOngoingTask(offset: "0")
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationView.isHidden = true
     
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //initial set up
    func initialSetup()  {
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.hasNotch{
            topHeight = 100
        }else if IS_IPHONE_PLUS{
            topHeight = 85
        }else{
            topHeight = 74
        }
        navigationView.frame = CGRect.init(x: 0 , y: 0, width: FULL_WIDTH, height: topHeight)
        navigationView.backgroundColor = PRIMARY_COLOR
        navigationView.bottomRadius()
        backBtn.frame = CGRect.init(x: 10, y: (topHeight/2)-5, width: 40, height: 40)
        backBtn.setImage(#imageLiteral(resourceName: "back_icon"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7)
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        titleLbl.frame = CGRect.init(x: 60, y: (topHeight/2)-5, width: FULL_WIDTH-120, height: 40)
        if LocalDefault.shared.isUser()!{
            titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: viewType)
        }else{
            titleLbl.config(color: TEXT_WHITE_COLOR!, font: headBold, align: .center, text: "my_tasks")
        }
        
        navigationView.addSubview(titleLbl)
        navigationView.addSubview(backBtn)
        UIApplication.shared.keyWindow?.rootViewController!.view.addSubview(navigationView)
        UIApplication.shared.keyWindow?.rootViewController!.view.bringSubviewToFront(navigationView)
        let line = UILabel()
        line.frame = CGRect.init(x: 0, y: 53, width: FULL_WIDTH, height: 2)
        line.backgroundColor = LINE_COLOR
        segmentedPager.segmentedControl.addSubview(line)
        segmentedPager.backgroundColor = BACKGROUND_COLOR
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 55
        segmentedPager.parallaxHeader.minimumHeight = 0
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.textColor = TEXT_BLACK_COLOR!
        segmentedPager.segmentedControl.selectedTextColor = PRIMARY_COLOR!
        segmentedPager.segmentedControl.font = subBold!
        segmentedPager.segmentedControl.indicator.lineHeight = 2.0
        segmentedPager.segmentedControl.separatorBottom = 5
        segmentedPager.segmentedControl.separatorColor = LINE_COLOR!
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = PRIMARY_COLOR!
        segmentedPager.segmentedControl.sendSubviewToBack(line)
        segmentedPager.parallaxHeader.delegate =  self
        
        if Utility.shared.isRTL(){
            navigationView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            segmentedPager.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            segmentedPager.segmentedControl.segment(at: 0)!.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.acceptObj.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.completeObj.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        }
        
    }
    
    @objc func backBtnTapped() {
        self.navigationView.isHidden = true
        if viewFrom == "payment"{
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //SEGMENT DELEGATE
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return 2
    }
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 55
    }
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        if viewType == "my_bookings"{
            return [acceptObj,completeObj][index]
        }else{
            return [acceptObj,completeObj][index]
        }
    }
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        if viewType == "my_bookings"{
            return [(Utility.shared.Json().value(forKey: "ongoing") as! String), (Utility.shared.Json().value(forKey: "completed") as! String)][index]
        }else{
            return [""][index]
        }
    }
    
}

//
//  TabBarClass.swift
//  iDemand
//
//  Created by Roby on 03/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class TabBarClass: UITabBarController,UITabBarControllerDelegate {
    
    let categoryObj = CategoryPage()
    var is_firstTime = true
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
//    if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
//        myDelegate.initialSetup()
////                myDelegate.setInitialViewController()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tabBar.backgroundColor = BACKGROUND_COLOR
        
        if #available(iOS 13.0, *) {
            if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "dark") as? NSString{
                overrideUserInterfaceStyle = .dark
            }else if LocalDefault.shared.theme() == Utility.shared.Json().value(forKey: "light") as? NSString{
                overrideUserInterfaceStyle = .light
            }
        }
        if self.appDelegate?.tabbarSelectedIndex == 1{
            self.appDelegate?.tabbarSelectedIndex = 0
            self.selectedIndex = 1
        } else if is_firstTime{
            self.is_firstTime = false
            if !LocalDefault().isUser()!{
            self.selectedIndex = 0
            }
        }
    }
    //initial set up
    func initialSetup()  {
        var edgeInset = UIEdgeInsets()
        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = LINE_COLOR
            tabBar.standardAppearance = appearance
            tabBar.tintColor = UIColor(named: "primary")
            edgeInset = UIEdgeInsets.init(top: 10, left: 0, bottom: -5, right: 0)
        }
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.delegate = self
        // Do any additional setup after loading the view.
        
        // USER PAGE
        let homeObj = HomePage()
        homeObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_home").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_home_sel").withRenderingMode(.alwaysTemplate))
        homeObj.tabBarItem.imageInsets = edgeInset
        
        //        categoryObj.viewType = "tab"
        //        categoryObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_category").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_category_Sel").withRenderingMode(.alwaysOriginal))
        //        categoryObj.tabBarItem.imageInsets = edgeInset
        
        let mapObj = clusterMapViewController()
        mapObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_browse").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_browse_sel").withRenderingMode(.alwaysTemplate))
        mapObj.tabBarItem.imageInsets = edgeInset
        
        // TASKER PAGE
        let dashboardObj = TaskerDashboard()
        dashboardObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_home").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_home_sel").withRenderingMode(.alwaysTemplate))
        dashboardObj.tabBarItem.imageInsets = edgeInset
        
        let browseObj = BrowseTaskPage()
        browseObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_browse").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_browse_sel").withRenderingMode(.alwaysTemplate))
        browseObj.tabBarItem.imageInsets = edgeInset
        
        let msgObj = MessagePage()
        msgObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_msg").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_msg_sel").withRenderingMode(.alwaysTemplate))
        msgObj.tabBarItem.imageInsets = edgeInset
        
        let profileObj = ProfilePage()
        profileObj.tabBarItem = UITabBarItem.init(title: nil, image: #imageLiteral(resourceName: "tab_profile").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_profile_sel").withRenderingMode(.alwaysTemplate))
        profileObj.tabBarItem.imageInsets = edgeInset
        
        if LocalDefault().isUser()!{
            self.viewControllers = [homeObj,mapObj,msgObj,profileObj]
        }else{
            self.viewControllers = [mapObj,dashboardObj,msgObj,profileObj]
        }
        if Utility.shared.isRTL(){
            //            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.tabBar.subviews[0].transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.tabBar.subviews[1].transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.tabBar.subviews[2].transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.tabBar.subviews[3].transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        if !LocalDefault().isUser()!{
        self.selectedIndex = 1
        }
    }
    //tab bar
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if !LocalDefault().isUser()!{
            do{
                let jsonDecoder = JSONDecoder()
                let profile = try jsonDecoder.decode(ProfileModel.self, from: LocalDefault.shared.userInfo()!)
//                if profile.payment_verified == "false"{
                if !(LocalDefault.shared.get_paymentAdded()){
                    Utility.shared.showToast(msg: "payment_details_pending")
                }else if profile.payment_verified == "true"{
                    LocalDefault.shared.set_paymentAdded(status: true)
                }
            }catch{

            }
        }else{
            if tabBarController.selectedIndex == 1{
                categoryObj.viewType = "tab"
            }
        }
    }
}

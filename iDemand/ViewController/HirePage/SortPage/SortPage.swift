//
//  SortPage.swift
//  iDemand
//
//  Created by Roby on 22/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class SortPage: UIViewController {
    
    @IBOutlet var sortingView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var highToLowBtn: UIButton!
    @IBOutlet var lowToHighBtn: UIButton!
    @IBOutlet var reviewsBtn: UIButton!
    @IBOutlet var completedJobsBtn: UIButton!
    
    var sort_index = Int()
    var selectedIndex: ((_ sort:Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLayoutSubviews() {
        self.sortingView.topRadius()
        
    }
    //initial setup
    func initialSetup()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.containerView.addGestureRecognizer(tap)
        self.lowToHighBtn.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, title: "sort_lowtohigh")
        self.highToLowBtn.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, title: "sort_hightolow")
        self.reviewsBtn.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, title: "sort_positive_reviews")
        self.completedJobsBtn.config(color: TEXT_BLACK_COLOR!, font: smallBold, align: .left, title: "sort_completed_task")
        
        if self.sort_index == 0{
            self.lowToHighBtn.setTitleColor(PRIMARY_COLOR, for: .normal)
        }else if self.sort_index == 1{
            self.highToLowBtn.setTitleColor(PRIMARY_COLOR, for: .normal)
        }else if self.sort_index == 2{
            self.reviewsBtn.setTitleColor(PRIMARY_COLOR, for: .normal)
        }else if self.sort_index == 3{
            self.completedJobsBtn.setTitleColor(PRIMARY_COLOR, for: .normal)
        }
    }
    
    //dismiss view
    @objc func dismissView(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sortBtnTapped(_ sender: UIButton) {
        self.selectedIndex!(sender.tag)
        self.dismiss(animated: false, completion: nil)
    }
    
}

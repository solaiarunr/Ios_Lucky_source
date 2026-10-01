//
//  HomeBannerCell.swift
//  iDemand
//
//  Created by Roby on 08/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import SDWebImage

protocol bannerDelegate: AnyObject {
    func bannerTapped(cell: HomeBannerCell,index:Int)
}
class HomeBannerCell: UITableViewCell,UIScrollViewDelegate {
    
    @IBOutlet var bannerScrollView: UIScrollView!
    weak var delegate: bannerDelegate?
    let pageControl = UIPageControl()
    var bannerTimer = Timer()
    var xPos = CGFloat()
    var bannerArray = NSArray()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bannerScrollView.delegate = self
        
    }
    override func layoutSubviews() {
        self.pageControl.frame = CGRect.init(x: (FULL_WIDTH/2)-10, y: 170, width: 20, height: 20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(banners:NSArray)  {
        self.bannerArray = banners
        self.configurePageControl()
        var leftPadding = 20
        
        var index = 0
        for bannerModel in banners {
            let bannerDict = bannerModel as! NSDictionary
            let imgView = UIImageView()
            let item_width = Int(FULL_WIDTH)-40
            imgView.frame = CGRect.init(x: leftPadding, y: 10, width:item_width , height: 180)
            imgView.contentMode = .scaleAspectFill
            imgView.radius(value: 15.0)
            let userimgURL = URL.init(string: bannerDict.value(forKey:"item_image") as! String)
            imgView.sd_setImage(with: userimgURL, placeholderImage: #imageLiteral(resourceName: "service_placeholder"))
            imgView.backgroundColor = LINE_COLOR
            if Utility.shared.isRTL(){
                imgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            
            let imageBtn = UIButton()
            imageBtn.frame = CGRect.init(x: leftPadding, y: 10, width:item_width , height: 180)
            imageBtn.tag = index
            imageBtn.addTarget(self, action: #selector(self.bannerBtnTapped(_:)), for: .touchUpInside)
            
            self.bannerScrollView.addSubview(imgView)
            self.bannerScrollView.addSubview(imageBtn)
            leftPadding += (item_width+40)
            index += 1
            
            self.bannerScrollView.contentSize = CGSize.init(width: leftPadding, height: 210)
            self.bannerScrollView.isPagingEnabled = true
            self.bannerScrollView.contentOffset.x = CGFloat(0)
            
        }
        if bannerTimer.isValid{
            bannerTimer.invalidate()
        }
        bannerTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        
        
    }
    
    
    @objc func bannerBtnTapped(_ sender: UIButton){
        delegate?.bannerTapped(cell: self,index: sender.tag)
    }
    
    //config page control
    func configurePageControl() {
        self.pageControl.numberOfPages = bannerArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = .darkGray
        self.pageControl.currentPageIndicatorTintColor = PRIMARY_COLOR
        self.contentView.addSubview(pageControl)
        self.layoutIfNeeded()
    }
    
    //automatic scrolling
    @objc func autoScroll() {
        let totalPossibleOffset = CGFloat(bannerArray.count - 1) * FULL_WIDTH
        if xPos == totalPossibleOffset {
            xPos = 0 // come back to the first image after the last image
            self.bannerScrollView.contentOffset.x = CGFloat(self.xPos)
            let pageNumber = round(self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width)
            self.pageControl.currentPage = Int(pageNumber)
        }else {
            xPos += CGFloat(FULL_WIDTH)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.bannerScrollView.contentOffset.x = CGFloat(self.xPos)
                    let pageNumber = round(self.bannerScrollView.contentOffset.x / self.bannerScrollView.frame.size.width)
                    self.pageControl.currentPage = Int(pageNumber)
                }, completion: nil)
                
            }
        }
    }
    //scroll view delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}

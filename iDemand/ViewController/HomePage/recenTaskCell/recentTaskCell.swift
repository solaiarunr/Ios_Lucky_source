//
//  recentTaskCell.swift
//  iDemand
//
//  Created by HTS-105 on 21/09/21.
//  Copyright © 2021 Hitasoft. All rights reserved.
//

import UIKit

class recentTaskCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup(){
        self.nameLbl.text = "Recent Tasks"
        self.nameLbl.config(color: TEXT_BLACK_COLOR!, font: headBold, align: .left, text: "Recent Tasks")
        self.viewAllBtn.titleLabel?.config(color: .blue, font: smallReg, align: .right, text: "View All")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: (width * 0.8), height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        let name = "cleaning"
        cell.taskNameLbl.text = (name.uppercased())
        cell.priceLbl.text = "$ 25"
        cell.descriptionLbl.text = "Carpert Stream clean before move in the floot Carpert Stream clean before move in the floot"
        cell.profileImg.image = UIImage(named: "test")
        
        return cell
    }
    
}

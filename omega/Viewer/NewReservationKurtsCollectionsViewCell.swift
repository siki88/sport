//
//  NewReservationKurtsCollectionsViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 31.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class NewReservationKurtsCollectionsViewCell: UITableViewCell {
    
    let testingMyTag = NewReservationKurtsViewController()
    
     var myReservationCurts:[ReservationTennis]?
    
    @IBOutlet weak var mainHoursLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
}

extension NewReservationKurtsCollectionsViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
        collectionView.backgroundColor = UIColor.white
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }

}

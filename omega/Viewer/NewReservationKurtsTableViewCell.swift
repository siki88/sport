//
//  NewReservationKurtsTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 31.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class NewReservationKurtsTableViewCell: UITableViewCell {

    @IBOutlet weak var hoursNumber: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionView<DataSource:UICollectionViewDataSource>(datasource:DataSource){
        self.collectionView.dataSource = datasource
    }

}

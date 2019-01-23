//
//  PlanCollectionViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 27.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minuts15: UILabel!
    @IBOutlet weak var minuts30: UILabel!
    @IBOutlet weak var minuts45: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

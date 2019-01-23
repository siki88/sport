//
//  OverviewTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 20.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoReservation: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

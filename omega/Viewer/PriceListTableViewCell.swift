//
//  PriceListTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 20.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class PriceListTableViewCell: UITableViewCell {
    
  //  @IBOutlet weak var sipkaVpravoOranzova: UIImageView!
    
    @IBOutlet weak var longTimeLabel: UILabel!
    @IBOutlet weak var costClenLabel: UILabel!
    @IBOutlet weak var costNeclenLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

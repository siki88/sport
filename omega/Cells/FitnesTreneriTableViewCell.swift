//
//  FitnesTreneriTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 07.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class FitnesTreneriTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var mainName: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telefon: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

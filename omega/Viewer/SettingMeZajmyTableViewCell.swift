//
//  SettingMeZajmyTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class SettingMeZajmyTableViewCell: UITableViewCell, BEMCheckBoxDelegate {

    @IBOutlet weak var myHobbyLabel: UILabel!
    
    @IBOutlet weak var myHobbySelected: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myHobbySelected.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func didTap(_ checkBox: BEMCheckBox){
        if checkBox.on {
            UserInterests.getInstance.id.append("\(checkBox.tag)")
        }else{
            if let indexInterests = UserInterests.getInstance.id.index(of: "\(checkBox.tag)") {
                UserInterests.getInstance.id.remove(at: indexInterests)
            }
        }
    }

}

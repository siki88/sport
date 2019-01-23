//
//  NewReservationExercisesTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 26.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class NewReservationExercisesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateExcercises: UILabel!
    @IBOutlet weak var nameExcercises: UILabel!
    @IBOutlet weak var freeSeatsExcercises: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func exercisesInit(date:String, freeSeats:String){
        self.dateExcercises.text = date
        self.freeSeatsExcercises.text = freeSeats
    }
    
}

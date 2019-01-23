//
//  ReservationTennis.swift
//  omega
//
//  Created by Lukas Spurny on 31.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class ReservationTennis {
    
    let id: Int
    let name: String
    let reservations: [Any]
    var reservationTennisKurts:[ReservationTennisKurts] = []
    
    init(id: Int,
         name: String,
         reservations: [Any],
         reservationTennisKurts:[ReservationTennisKurts]){
        
        self.id = id
        self.name = name
        self.reservations = reservations
        self.reservationTennisKurts = reservationTennisKurts
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"],
            let reservations = json["reservations"]{

            self.id = id as! Int
            self.name = name as! String
            self.reservations = reservations as! [Any]
            
            
            if let reservation = Optional(reservations), Optional(reservations) != nil {
                for reservatio in reservation as! [[String:Any]]{
                    self.reservationTennisKurts.append(ReservationTennisKurts(id: reservatio["id"] as! Int,
                                                                              date_from: reservatio["date_from"] as! String,
                                                                              date_to: reservatio["date_to"] as! String,
                                                                              img: reservatio["img"] as? String,
                                                                              length_in_minutes: reservatio["length_in_minutes"] as! Int))
                }
            }
 
            
            
            
            
            

        }else{
            return nil
        }
    }
    
}

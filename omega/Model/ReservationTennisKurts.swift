//
//  ReservationTennisKurts.swift
//  omega
//
//  Created by Lukas Spurny on 31.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class ReservationTennisKurts{
    
    let id: Int
    let date_from: String
    let date_to: String
    let img: String?
    let length_in_minutes: Int
    
    init(id: Int,
         date_from: String,
         date_to: String,
         img: String?,
         length_in_minutes: Int){
        
        self.id = id
        self.date_from = date_from
        self.date_to = date_to
        self.img = img
        self.length_in_minutes = length_in_minutes
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let date_from = json["date_from"],
            let date_to = json["date_to"],
            let length_in_minutes = json["length_in_minutes"]{
            let img = json["img"]
            
            self.id = id as! Int
            self.date_from = date_from as! String
            self.date_to = date_to as! String
            self.img = img as? String
            self.length_in_minutes = length_in_minutes as! Int

            
        }else{
            return nil
        }
    }
    
}

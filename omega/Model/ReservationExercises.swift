//
//  reservationExercises.swift
//  omega
//
//  Created by Lukas Spurny on 26.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class ReservationExercises {
   
    let id: Int
    let name: String
    let date_from: String
    let date_to: String
    let length_in_minutes: Int
    let instructor_firstname: String
    let instructor_lastname: String
    let capacity: Int?
    let used_capacity: Int?
    let price: String
    
    init(id: Int,
         name: String,
         date_from: String,
         date_to: String,
         length_in_minutes: Int,
         instructor_firstname: String,
         instructor_lastname: String,
         capacity: Int,
         used_capacity: Int,
         price: String){
        
        self.id = id
        self.name = name
        self.date_from = date_from
        self.date_to = date_to
        self.length_in_minutes = length_in_minutes
        self.instructor_firstname = instructor_firstname
        self.instructor_lastname = instructor_lastname
        self.capacity = capacity
        self.used_capacity = used_capacity
        self.price = price
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"],
            let date_from = json["date_from"],
            let date_to = json["date_to"],
            let length_in_minutes = json["length_in_minutes"],
            let instructor_firstname = json["instructor_firstname"],
            let instructor_lastname = json["instructor_lastname"],
            let price = json["price"]{
            let capacity = json["capacity"]
            let used_capacity = json["used_capacity"]
            
            
            self.id = id as! Int
            self.name = name as! String
            self.date_from = date_from as! String
            self.date_to = date_to as! String
            self.length_in_minutes = length_in_minutes as! Int
            self.instructor_firstname = instructor_firstname as! String
            self.instructor_lastname = instructor_lastname as! String
            self.capacity = capacity as? Int
            self.used_capacity = used_capacity as? Int
            self.price = price as! String
            
        }else{
            return nil
        }
    }
    
}

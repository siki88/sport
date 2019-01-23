//
//  PlanRegistration.swift
//  omega
//
//  Created by Lukas Spurny on 27.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class PlanRegistration{
   
    var hours: Int?
    var minuts15: Int?
    var minuts30: Int?
    var minuts45: Int?
    
    required init?(){
        
    }
    
    /*
    var hours: Int?
    var minuts15: Int?
    var minuts30: Int?
    var minuts45: Int?
    
    init(hours: Int,
         minuts15: Int,
         minuts30: Int,
         minuts45: Int){
        
        self.hours = hours
        self.minuts15 = minuts15
        self.minuts30 = minuts30
        self.minuts45 = minuts45
    }
    
    init?(json: [String:Any]){
        if let hours = json["hours"],
            let minuts15 = json["minuts15"],
            let minuts30 = json["minuts30"],
            let minuts45 = json["minuts45"]{
            
            self.hours = hours as? Int
            self.minuts15 = minuts15 as? Int
            self.minuts30 = minuts30 as? Int
            self.minuts45 = minuts45 as? Int
            
        }else{
            return nil
        }
    }
    */
    
}

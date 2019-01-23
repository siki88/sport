//
//  activities.swift
//  omega
//
//  Created by Lukas Spurny on 25.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Activities {
    
    let id: Int
    let name: String
    let type: Int
    
    init(id: Int,
         name: String,
         type: Int){
        
        self.id = id
        self.name = name
        self.type = type
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"],
            let type = json["type"]{
            
            self.id = id as! Int
            self.name = name as! String
            self.type = type as! Int
            
        }else{
            return nil
        }
    }
    
}

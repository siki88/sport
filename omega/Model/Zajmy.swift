//
//  Zajmy.swift
//  omega
//
//  Created by Lukas Spurny on 06.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Zajmy {
    
    let id: String
    let name: String
    
    init(id: String,
         name: String){
        
        self.id = id
        self.name = name
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"]{
            
            self.id = id as! String
            self.name = name as! String
            
        }else{
            return nil
        }
    }
    
}

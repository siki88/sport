//
//  Notifications.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Notifications {
    
    let id: String
    let date: String
    let text: String
    
    init(id: String,
         date: String,
         text: String){
        
        self.id = id
        self.date = date
        self.text = text
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let date = json["date"],
            let text = json["text"]{
            
            self.id = id as! String
            self.date = date as! String
            self.text = text as! String
            
        }else{
            return nil
        }
    }
    
}

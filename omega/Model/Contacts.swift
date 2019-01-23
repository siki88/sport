//
//  Contacts.swift
//  omega
//
//  Created by Lukas Spurny on 07.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Contact {
    
    let name: String
    let post: String
    let phone: String
    let email: String
    let image: String
    
    init(name: String,
         post: String,
         phone: String,
         email: String,
         image: String){
        
        self.name = name
        self.post = post
        self.phone = phone
        self.email = email
        self.image = image
    }
    
    init?(json: [String:Any]){
        if let name = json["name"],
            let post = json["post"],
            let phone = json["phone"],
            let email = json["email"],
            let image = json["image"]{
            
            self.name = name as! String
            self.post = post as! String
            self.phone = phone as! String
            self.email = email as! String
            self.image = image as! String
            
        }else{
            return nil
        }
    }
    
}

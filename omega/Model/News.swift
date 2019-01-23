//
//  News.swift
//  omega
//
//  Created by Lukas Spurny on 23.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class News {
    let id: String
    let name: String
    let date: String
    let img: String
    let text: String
    let gallery: [String]
    
    init(id: String,
         name: String,
         date: String,
         img: String,
         text: String,
         gallery: [String]){
        
        self.id = id
        self.name = name
        self.date = date
        self.img = img
        self.text = text
        self.gallery = gallery
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"],
            let date = json["date"],
            let img = json["img"],
            let text = json["text"],
            let gallery = json["gallery"]{
            
            self.id = id as! String
            self.name = name as! String
            self.date = date as! String
            self.img = img as! String
            self.text = text as! String
            self.gallery = gallery as! [String]
            
        }else{
            return nil
        }
    }
}

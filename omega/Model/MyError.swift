//
//  Error.swift
//  omega
//
//  Created by Lukas Spurny on 19.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class MyError {
  
    let error_msg: String
    let error: Int
    let error_code: Int

    init(error_msg: String,
         error: Int,
         error_code: Int){
        
        self.error_msg = error_msg
        self.error = error
        self.error_code = error_code
    }
    
    init?(json: [String:Any]){
        if let error_msg = json["error_msg"],
            let error = json["error"],
            let error_code = json["error_code"]{
            
            self.error_msg = error_msg as! String
            self.error = error as! Int
            self.error_code = error_code as! Int
            
        }else{
            return nil
        }
    }

}

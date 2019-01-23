//
//  Login.swift
//  omega
//
//  Created by Lukas Spurny on 19.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Login: NSObject, NSCoding {
    
    let id: Int
    let member_id: Int
    let name: String
    let surname: String
    let gender: String
    let email: String
    let phone: String
    let image: String?
    let interests: [String]
    let member_to: String
    let credit: Int
    let discount: Int
    let token: String
    
    init(id: Int,
         member_id: Int,
         name: String,
         surname: String,
         gender: String,
         email: String,
         phone: String,
         image: String,
         interests: [String],
         member_to: String,
         credit: Int,
         discount: Int,
         token: String) {
        
        self.id = id
        self.member_id = member_id
        self.name = name
        self.surname = surname
        self.gender = gender
        self.email = email
        self.phone = phone
        self.image = image
        self.interests = interests
        self.member_to = member_to
        self.credit = credit
        self.discount = discount
        self.token = token
        
    }
    
    init?(json: [String:Any]){
      if let id = json["id"],
         let member_id = json["member_id"],
         let name = json["name"],
         let surname = json["surname"],
         let gender = json["gender"],
         let email = json["email"],
         let phone = json["phone"],
         let image = json["image"],
         let interests = json["interests"],
         let member_to = json["member_to"],
         let credit = json["credit"],
         let discount = json["discount"],
         let token = json["token"]{
        
            self.id = id as! Int
            self.member_id = member_id as! Int
            self.name = name as! String
            self.surname = surname as! String
            self.gender = gender as! String
            self.email = email as! String
            self.phone = phone as! String
            self.image = image as? String
            self.interests = interests as! [String]
            self.member_to = member_to as! String
            self.credit = credit as! Int
            self.discount = discount as! Int
            self.token = token as! String
        
      }else{
        return nil
            }
      }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(member_id, forKey: "member_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(surname, forKey: "surname")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(interests, forKey: "interests")
        aCoder.encode(member_to, forKey: "member_to")
        aCoder.encode(credit, forKey: "credit")
        aCoder.encode(discount, forKey: "discount")
        aCoder.encode(token, forKey: "token")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id") 
        let member_id = aDecoder.decodeInteger(forKey: "member_id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let surname = aDecoder.decodeObject(forKey: "surname") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        var image = aDecoder.decodeObject(forKey: "image") as? String
        let interests = aDecoder.decodeObject(forKey: "interests") as! [String]
        let member_to = aDecoder.decodeObject(forKey: "member_to") as! String
        let credit = aDecoder.decodeInteger(forKey: "credit") 
        let discount = aDecoder.decodeInteger(forKey: "discount") 
        let token = aDecoder.decodeObject(forKey: "token") as! String
        
        if image == nil {
            image = "https://www.omegasport.cz/images/favicon.ico"
        }
        
        self.init(id: id,
                  member_id: member_id,
                  name: name,
                  surname: surname,
                  gender: gender,
                  email: email,
                  phone: phone,
                  image: image!,
                  interests: interests,
                  member_to: member_to,
                  credit: credit,
                  discount: discount,
                  token:token)
    }
    
  
}

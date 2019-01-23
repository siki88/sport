//
//  ReservationTableViewCell.swift
//  omega
//
//  Created by Lukas Spurny on 20.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation

class Reservation {

    let id: Int
    let id_activity: Int
    let id_place: Int
    let price: Int?
    let date_from: String
    let date_to: String
    let length: Int
    let activity_name: String
    let place_name: String
    
    init(id: Int,
         id_activity: Int,
         id_place: Int,
         price: Int?,
         date_from: String,
         date_to: String,
         length: Int,
         activity_name: String,
         place_name: String){
        
        self.id = id
        self.id_activity = id_activity
        self.id_place = id_place
        self.price = price
        self.date_from = date_from
        self.date_to = date_to
        self.length = length
        self.activity_name = activity_name
        self.place_name = place_name
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let id_activity = json["id_activity"],
            let id_place = json["id_place"],
            let price = json["price"],
            let date_from = json["date_from"],
            let date_to = json["date_to"],
            let length = json["length"],
            var activity_name = json["activity_name"],
            var place_name = json["place_name"]{
            
            if id_activity as! Int == 37 {
                activity_name = "Kadeřnictví"
                place_name = "Kadeřnictví"
            }
            
            self.id = id as! Int
            self.id_activity = id_activity as! Int
            self.id_place = id_place as! Int
            self.price = price as? Int
            self.date_from = date_from as! String
            self.date_to = date_to as! String
            self.length = length as! Int
            self.activity_name = activity_name as! String
            self.place_name = place_name as! String
            
        }else{
            return nil
        }
    }
    
    
    // MARK: VYHLEDANI LOGA PRO URCITOU REZERVACI
    static func logoReservation(idActivity:Int) -> String{
        
        var imageActivityName:String = "greenCircle.png"
        
        switch (idActivity) {
        case 1://tenis hala
            imageActivityName = "TenisHalaAntuka.png"
            break;
        case 2://badminton
            imageActivityName = "Badminton.png"
            break;
        case 8://tenis antuka
            imageActivityName = "TenisHalaAntuka.png"
            break;
        case 12://squash
            imageActivityName = "Squash.png"
            break;
        case 4://skupinova cviceni
            imageActivityName = "SkupinovaCviceni.png"
            break;
        case 40://trx
            imageActivityName = "TRX.png"
            break;
        case 46://sal 3
            imageActivityName = "SMSal.png"
            break;
        case 51://sm
            imageActivityName = "SMSal.png"
            break;
        case 37://sm
            imageActivityName = "greenCircle.png" // zde bude image kadeřnictví
            break;
        default:
            imageActivityName = "greenCircle.png"
        }
        
        return imageActivityName
    }
    
    // MARK: DATE FORMATED
    static func convertReservationDateFormater(dateFrom:String,dateTo:String) -> [String]{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let dateFromBack = dateFormatter.date(from: dateFrom)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let myDateFromBack = dateFormatter.string(from: dateFromBack!)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let hoursFromBack = dateFormatter.date(from: dateFrom)
        dateFormatter.dateFormat = "HH:mm"
        let myHoursFromBack = dateFormatter.string(from: hoursFromBack!)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let hoursToBack = dateFormatter.date(from: dateTo)
        dateFormatter.dateFormat = "HH:mm"
        let myHoursToBack = dateFormatter.string(from: hoursToBack!)
        
 //       let finishFormatDate = ("\(myDateFromBack) | \(myHoursFromBack) - \(myHoursToBack)")
        let finishFormatDate:[String] = [myDateFromBack,myHoursFromBack,myHoursToBack]
        return finishFormatDate
    }

}

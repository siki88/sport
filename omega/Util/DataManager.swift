//
//  DataManager.swift
//  omega
//
//  Created by Lukas Spurny on 19.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import Foundation
import Alamofire

class DataManager: UIViewController{
    
    var myResponse = [String:Any]()
    
    public func most(_ params:Parameters?,url:URL ,completionHandler: @escaping ([String:Any]?, String) -> ()) {
        sendPostRequest(params:params,url:url,completionHandler: completionHandler)
    }
    
    public func sendPostRequest(params:Parameters?,url:URL,completionHandler: @escaping ([String:Any]?, String) -> ()) {
        
        Alamofire.request(url, method: .post, parameters: params, headers: nil)
            .responseJSON { response in
                completionHandler(self.handleParseData(response),"false")
            }
    }
    
    public func handleParseData(_ data:DataResponse<Any>) -> [String:Any]{
        var returnData:[String:Any]?
        
        //control connect server
        
        switch data.result {
        case .success(let value):
            if let data = value as? [String:Any] {
                returnData = data
            }
        case .failure(_/*let error*/):
            print("ERROR FROM SERVER")
                returnData = ["error":true]
         //   break
        }
        
        if let myReturn = returnData , returnData != nil {
            return myReturn
        }else{
            return [:]
        }
    }
   
}

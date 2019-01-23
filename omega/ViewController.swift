//
//  ViewController.swift
//  omega
//
//  Created by Lukas Spurny on 18.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let requestDataManager = DataManager()
    
    @IBOutlet weak var logoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // CONTROL CONNECT INTERNET
        if CheckInternet.Connection(){

            //CONTROL USER TO MEMORY
            if isKeyPresentInUserDefaults(key: "User") {
                //UPDATE USER DATA ON MEMORY
                updatesUserData(key: "User")
            }else{
                //REDIRECTS LOGIN
                myRedirect(page:"LoginViewController")
            }
            
        }else{
            let alert = alertViewController.alert(title:"Připojení k internetu není k dispozici.",message:"Zkuste to prosím později.")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: CONTROL USER TO MEMORY
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //MARK: REDIRECT
    func myRedirect(page:String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: page)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK: SEND UPDATE DATA
    func updatesUserData(key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/login.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                // kody pro zvlast stránky
                if let dataObject = backResponse["user"] as? [String:Any], backResponse["user"] != nil {
                    let data = Login(json: dataObject)
                    
                    //SEND UPDATE MEMORY
                    self.loginOk(data:data!)

                    //REDIRECTS USER
                    self.myRedirect(page:"SWRevealViewController")
                }else{
                    // špatné přihlašovací údaje
                    print("UPDATE IS ERROR: \(backResponse)")
                    let error = MyError(json: backResponse)
                    
                        //poslat spársovat error, a v případě error code 111 vymazat memory a poslat do loginu
                        //v připadě změny tokenu odhlásí a smaže uživatele a přesměruje na login
                        if error?.error_code == 111 {
                            
                            //delete user data
                            let idForUserDefaults = "User"
                            let userDefaults = UserDefaults.standard
                            userDefaults.removeObject(forKey: idForUserDefaults)
                            userDefaults.synchronize()
                            
                            //require on loginpage
                            self.myRedirect(page:"LoginViewController")
                        }
                }
            }else{
                print("responseObject is nil")
            }
        }
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams() -> Parameters{ //WDMyXfRFn50TSoIKv2Mg1V26BFEJoj
        //READ USER DATA ON MEMORY
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login

            //VALUE
            let params: NSMutableDictionary? = ["token":decodedTeams.token]
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            //KEY
            let parameters: Parameters   = [
                "data" : json!
            ]
            return parameters
    }
    
    //MARK: LOGIN OK - PREPIS USER MEMORY
    func loginOk(data:Login){
        // SAVE USER TO MEMORY
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data )
        userDefaults.set(encodedData, forKey: "User")
        userDefaults.synchronize()
    }
    
}





//
//  SettingsZmenaHeslaViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class SettingsZmenaHeslaViewController: UIViewController, UITextFieldDelegate {

    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //reqest main
    let requestDataManager = DataManager()
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBOutlet weak var oldPasswordLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var passwordRepeatLabel: UITextField!
    @IBOutlet weak var zmenaHeslaButton: UIButton!
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    @IBAction func saveChange(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        if let newPassword = self.passwordLabel.text, self.passwordLabel.text != nil, self.passwordRepeatLabel.text != nil, self.passwordLabel.text == self.passwordRepeatLabel.text, self.oldPasswordLabel.text != nil, self.oldPasswordLabel.text != "", self.passwordLabel.text != "", self.passwordRepeatLabel.text != ""{
            requestMyReservation(key:"error",newPassword:newPassword,oldPassword:self.oldPasswordLabel.text!)
        }else{
            self.queryLoginAlert(title:"CHYBA.",message:"Zájmy byly neodeslány.")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        myActivityIndicator()
        
        self.zmenaHeslaButton.isEnabled = false
        
        self.passwordLabel.delegate = self
        self.passwordRepeatLabel.delegate = self
        self.oldPasswordLabel.delegate = self
    }
    
    //MAKR: Indicator activity
    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
    }
    
    //MARK: Alert Error
    func queryLoginAlert(title:String,message:String){
        let alert = alertViewController.alert(title:title,message:message)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: KLAVESNICE
    //skrýt klávesnici, když se uživatel dotkne mimo klávesnici
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //stiskne tlačítko návratu
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }

}

// MARK: CONNECTING
extension SettingsZmenaHeslaViewController {
    
    // MARK: CONNECT
    func requestMyReservation(key:String,newPassword:String,oldPassword:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/editpassword.php")
        //connect class
        requestDataManager.most(myParams(newPassword:newPassword,oldPassword:oldPassword), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                
                // kody pro zvlast stránky
                if let moreBack = backResponse[key]  {
                    print("moreBack: \(moreBack)")
                    self.activityIndicator.stopAnimating()
                    self.queryLoginAlert(title:"VPOŘÁDKU.",message:"Heslo aktualizováno.")
                    self.oldPasswordLabel.text = ""
                    self.passwordLabel.text = ""
                    self.passwordRepeatLabel.text = ""
                }else{
                    self.queryLoginAlert(title:"Heslo nebylo aktualizováno.",message:"Zkontrolujte prosím údaje.")
                    
                    print("empty")
                }
                
            }else{
                print("responseObject is nil")
            }
        }
        
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams(newPassword:String,oldPassword:String) -> Parameters{
        
        //decode user info
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        

        
        
        //VALUE
        let params: NSMutableDictionary? = ["id":decodedTeams.id,"old_pass":oldPassword, "new_pass":newPassword]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }
    
}

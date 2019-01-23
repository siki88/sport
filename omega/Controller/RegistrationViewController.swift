//
//  RegistrationViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let requestDataManager = DataManager()

    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField! // email
    @IBOutlet weak var telephoneLabel: UITextField! // telefon
    
    @IBAction func sendRegistrationFunc(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        let myQuery:NSMutableDictionary =  ["firstname": self.firstNameLabel.text, "lastname": self.surnameLabel.text, "phone": self.telephoneLabel.text, "email": self.emailLabel.text, "gender": segmentControll.selectedSegmentIndex]
        
        requestLogin(myQuery:myQuery)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameLabel.delegate = self
        self.surnameLabel.delegate = self
        self.emailLabel.delegate = self
        self.telephoneLabel.delegate = self
        
        //view scroll up on keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    
    //view scroll up on keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 125.0
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 125.0
            }
        }
    }
    
    //MARK: indicator activity
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
    
    // MARK: CONNECT
    private func requestLogin(myQuery:NSMutableDictionary){
        //url
        let url = URL(string: "http://omega.leksys.cz/registrace.php")
        //connect class
        requestDataManager.most(myParams(myQuery:myQuery), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                // kody pro zvlast stránky
                
                 self.activityIndicator.stopAnimating()
                
                if let requestReservation = backResponse["error"], backResponse["error"] != nil {
                    
                    if requestReservation as! Bool == true && requestReservation as! Int == 1 {
                        self.queryLoginAlert(title:"Chyba registrace.",message:"Zkontrolujte vyplněný formulář.")
                    }else{
                        self.alertForSend(title:"Byl jste úspěšně zaregistrován.",message:"Zkontrolujte si email.")
                    }
                   
                }else{
                    self.queryLoginAlert(title:"Chyba",message:"spojení")
                }

            }else{
                print("responseObject is nil")
            }
        }
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams(myQuery:NSMutableDictionary) -> Parameters{
            //VALUE
            let params: NSMutableDictionary? = myQuery
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            //KEY
            let parameters: Parameters   = [
                "data" : json!
            ]
            return parameters
    }
    

    
    //MARK: POTVRZENI REZERVACE
    func alertForSend(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))

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

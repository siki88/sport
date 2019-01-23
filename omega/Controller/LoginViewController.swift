//
//  LoginViewController.swift
//  omega
//
//  Created by Lukas Spurny on 18.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate {

    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let requestDataManager = DataManager()
  //  var data = Login()
    
    @IBOutlet weak var zapomenuteHeslo: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginField: LoginDataEntryTextField!
    @IBOutlet weak var passwordField: LoginDataEntryTextField!
    @IBOutlet weak var loginBtn: LoginButton!
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        if self.loginField.text! == "" && self.passwordField.text! == "" {
            loginField.jitter()
            passwordField.jitter()
            self.activityIndicator.stopAnimating()
        }else if self.loginField.text! == "" {
            loginField.jitter()
            self.activityIndicator.stopAnimating()
        }else if self.passwordField.text! == ""{
            passwordField.jitter()
            self.activityIndicator.stopAnimating()
        }else{
            //control internet function
            if CheckInternet.Connection() {
                // SEND CONNECT FUNCTION
                requestLogin()
            }else{
                self.queryLoginAlert(title:"Připojení k internetu není k dispozici.",message:"Zkuste to prosím později.")
            }
             
        }
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove memory user data
        UserDefaults.standard.removeObject(forKey: "User")

        // on click UIImageView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true

        //activate indicator activoty
        myActivityIndicator()
        
        self.zapomenuteHeslo.isHidden = true
        
        //view scroll up on keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //view scroll up on keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
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
    
    
    // MARK: CONNECT
    private func requestLogin(){
        //url
        let url = URL(string: "http://omega.leksys.cz/login.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                // kody pro zvlast stránky
                if let dataObject = backResponse["user"] as? [String:Any], backResponse["user"] != nil {
                    let data = Login(json: dataObject)
                    self.loginOk(data:data!)
                }else{
                    // špatné přihlašovací údaje
                    let data = MyError(json: backResponse)
                    if data?.error_code == 112 {
                        self.queryLoginAlert(title:"Neplatné přihlášení",message:"Zkontrolujte přihlašovací údaje")
                    }
                }
            }else{
                print("responseObject is nil")
            }
        }
     self.activityIndicator.stopAnimating()
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams() -> Parameters{
        if let email = self.loginField.text,let password = self.passwordField.text  {
            //VALUE
            let params: NSMutableDictionary? = ["email":email,"password":password]
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            //KEY
            let parameters: Parameters   = [
                "data" : json!
            ]
            
            return parameters
        }else{
            let parameters: Parameters   = [:]
            return parameters
        }
    }
    
    //MARK: LOGIN OK
    func loginOk(data:Login){ 
        // SAVE USER TO MEMORY
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data )
        userDefaults.set(encodedData, forKey: "User")
        userDefaults.synchronize()
        
        //odstraním všechny data ze zájmu protože příjdou pak nová
        UserInterests.getInstance.id.removeAll()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
        
//            let revealViewController:SWRevealViewController = self.revealViewController()
//            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            let newFrontViewController = UINavigationController.init(rootViewController: desController)
//            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
    }

    //MARK: Alert Error 
    func queryLoginAlert(title:String,message:String){
        let alert = alertViewController.alert(title:title,message:message)
        self.present(alert, animated: true, completion: nil)
    }
 /*
    //MARK: MORE NEWS
    func moreNews(){
        var parameter = self.scrollView.frame.midY
        if parameter == 450.0 {
            parameter = 220
        } else if parameter == 400.0 {
            parameter = 250
        } else if parameter == 316.0 {
            parameter = 345
        } else if parameter == 428.0 {
            parameter = 0
        } else if parameter == 378.0 {
            parameter = 0
        } else if parameter == 343.5 {
            parameter = 0
        } else {
            parameter = 153
        }
        if scrollView.contentOffset.y < 100{
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + parameter ), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
 */
    // MARK: KLAVESNICE
    //hidden keyboard on click UIImageView
    @objc func tappedMe()
    {
        self.view.endEditing(true)
    }

    //stiskne tlačítko návratu
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }

}

//
//  SettingsMeZajmyViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class SettingsMeZajmyViewController: UIViewController {

    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //object basic list zajmy
    var myZajmy = [Zajmy]()
    
    //reqest main
    let requestDataManager = DataManager()
    
    // auto load on scroll down
    //var fetchongMore = false
    
    //user interests
//    var userInterests:Array<String>?
    
    //menu button
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    //tableview
    @IBOutlet weak var tableView: UITableView! // menu
    
    //button for send aktualization
    @IBOutlet weak var meZajmyButton: UIButton!
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    @IBAction func saveChange(_ sender: Any) {
        self.activityIndicator.startAnimating()
        requestMyReservation(key:"error")
        print("me zajmy: \(UserInterests.getInstance.id)")
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        activityIndicator.startAnimating()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        
        //add interests on memory
        for myInterest in decodedTeams.interests{
            UserInterests.getInstance.id.append("\(myInterest)")
        }
        
        //request list zajmy
        let url = URL(string: "http://omega.leksys.cz/zajmy.php")
        requestActivities(url:url!, key: "interests")
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        //disable button click
        self.meZajmyButton.isEnabled = false
        
        // SEND CONNECT FUNCTION
        //requestMyReservation(key: "interests")

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

}


extension SettingsMeZajmyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myZajmy.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingMeZajmyTableCell", for: indexPath) as! SettingMeZajmyTableViewCell
        
        if let _ = UserInterests.getInstance.id.index(of: "\(self.myZajmy[indexPath.row].id)") {
          cell.myHobbySelected.on = true
        }else{
          cell.myHobbySelected.on = false
        }
        
        cell.myHobbySelected.tag = Int(self.myZajmy[indexPath.row].id)!
 
        cell.myHobbyLabel.text = self.myZajmy[indexPath.row].name
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
  //      cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    // zjistiji idecko
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    //MARK: PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         if segue.identifier == "detailNew" {
         let updateViewController:NewDetailViewController = segue.destination as! NewDetailViewController
         updateViewController.myNew = self.myNews[(self.tableView.indexPathForSelectedRow?.row)!]
         }
         */
    }
    
}


// MARK: CONNECTING
extension SettingsMeZajmyViewController {
    
    // MARK: CONNECT ACTIVITIES - alternative
    func requestActivities(url:URL,key:String){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let activitiesValue = response.result.value as? [String:Any]{
                    if let activities = activitiesValue[key] as? [[String:Any]]{
                        for activitie in activities{
                            if let parsenew = Zajmy(json: activitie as [String : Any]){
                                self.myZajmy.append(parsenew)
                            }
                        }
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
        }
        
    }
    
    

    // MARK: CONNECT
    func requestMyReservation(key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/edituser.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                
                // kody pro zvlast stránky
                if let moreBack = backResponse[key]  {
                    print("moreBack: \(moreBack)")
                    self.activityIndicator.stopAnimating()
                    self.queryLoginAlert(title:"VPOŘÁDKU.",message:"Zájmy byly odeslány.")
                }else{
                    self.queryLoginAlert(title:"CHYBA.",message:"Zájmy byly neodeslány.")

                    print("empty")
                }
                
            }else{
                print("responseObject is nil")
            }
        }
        
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams() -> Parameters{
        
        //decode user info
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        
        //VALUE
        let params: NSMutableDictionary? = ["id_user":decodedTeams.id,"interests":UserInterests.getInstance.id]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }

}
 



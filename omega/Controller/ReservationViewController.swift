//
//  Reservation ViewController.swift
//  omega
//
//  Created by Lukas Spurny on 19.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class ReservationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let requestDataManager = DataManager()
    var myReservation = [Reservation]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        sendQuery()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    func sendQuery(){
        activityIndicator.startAnimating()
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        
        self.tableView.separatorStyle = .none
        
        // SEND CONNECT FUNCTION
        requestMyReservation(userId:decodedTeams.id,key: "rezervace")
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
        
        sendQuery()
    }
    
    
    // MARK: CONNECT
    private func requestMyReservation(userId:Int,key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/mojerezervace.php")
        //connect class
        requestDataManager.most(myParams(userId:userId), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                
                // kody pro zvlast stránky
                if let singleReservation = backResponse["rezervace"] as? [[String:Any]],singleReservation.count != 0 ,backResponse["rezervace"] != nil, (responseObject?.count)! > 0 {
                    //zabezpecuji aby nebylo více údajů
                    for i in 0...singleReservation.count - 1{
                            if let parsenew = Reservation(json: singleReservation[i] as [String : Any]){
                                self.myReservation.append(parsenew)
                        }
                    }
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                }else if backResponse["error"] as! Bool == true && backResponse["error"] != nil{
                   self.queryLoginAlert(title:"Chyba spojení",message:"Opakujte zadání data")
                }else{
                    print("empty reservation")
                }
                self.activityIndicator.stopAnimating()
            }else{
                print("responseObject is nil")
            }
        }
        
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams(userId:Int) -> Parameters{
        
        //VALUE
        let params: NSMutableDictionary? = ["id":userId]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myReservation.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationTableCell", for: indexPath) as! ReservationTableViewCell
        cell.activityNameLabel.text = self.myReservation[indexPath.row].activity_name
        let reservationDate = Reservation.convertReservationDateFormater(dateFrom:self.myReservation[indexPath.row].date_from,dateTo:self.myReservation[indexPath.row].date_to)
        cell.dateLabel.text = ("\(reservationDate[0]) | \(reservationDate[1]) - \(reservationDate[2])")
        cell.logoReservation.image = UIImage(named: Reservation.logoReservation(idActivity:self.myReservation[indexPath.row].id_activity))
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // zjistiji idecko
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailReservation" {
            let updateViewController:ReservationDetailViewController = segue.destination as! ReservationDetailViewController
            updateViewController.myReservation = self.myReservation[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}

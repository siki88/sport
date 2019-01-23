//
//  OverviewViewController.swift
//  omega
//
//  Created by Lukas Spurny on 18.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let requestDataManager = DataManager()
    var myReservation = [Reservation]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var userNameLabel: OverviewLabel!
    @IBOutlet weak var memberToLabel: OverviewLabel!
    @IBOutlet weak var creditLabel: OverviewLabel!
    @IBOutlet weak var discountLabel: OverviewLabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.60, green: 0.79, blue: 0.12, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        
        self.tableView.separatorStyle = .none
        
        // SEND CONNECT FUNCTION
        requestMyReservation(userId:decodedTeams.id,key: "rezervace")
        
        //VIEW USER DETAIL
        userListing(userListing:decodedTeams)
    }
    
    
    // MARK: CONNECT
    private func requestMyReservation(userId:Int,key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/mojerezervace.php")
        //connect class
        requestDataManager.most(myParams(userId:userId), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                
                // kody pro zvlast stránky
                if let singleReservation = backResponse["rezervace"] as? [[String:Any]], singleReservation.count != 0 ,backResponse["rezervace"] != nil && (responseObject?.count)! > 0 {
                             //zabezpecuji aby nebylo více údajů
                    for i in 0...singleReservation.count - 1{
                        //zabezpecuji aby nebylo méně údajů
                        if i < 10 {
                            if let parsenew = Reservation(json: singleReservation[i] as [String : Any]){
                                self.myReservation.append(parsenew)
                            }else{
                                break
                            }
                        }
                    }
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                }else{
                    print("empty reservation on OverviewViewController")
                }
                
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
    
    //MARK: VIEW USER DETAIL
    func userListing(userListing:Login){
        self.userNameLabel.text = "\(userListing.name) \(userListing.surname)"
        self.memberToLabel.text = "Zaplaceno do: \(convertDateFormater(userListing.member_to))"
        self.creditLabel.text = "\(userListing.credit) Kč"
        self.discountLabel.text = "\(userListing.discount) Kč"
        
        
        Alamofire.request(userListing.image!).responseImage { response in
            if let image = response.result.value {
                self.userImage.image = image
            }else{
                self.userImage.image = UIImage(named: "greenCircle.png")
            }
        }
        
    
    }
    
    // MARK: Date formated:  dd. mm. yyyy -> yyyy-MM-dd
    // změna z sql na kompatibilní v ios
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myReservation.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 67
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overviewTableCell", for: indexPath) as! OverviewTableViewCell
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

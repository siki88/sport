//
//  ReservationDetailViewController.swift
//  omega
//
//  Created by Lukas Spurny on 23.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class ReservationDetailViewController: UIViewController {

    let requestDataManager = DataManager()
    var myReservation:Reservation?
    var userId = Int()
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBOutlet weak var logoUserImage: UIImageView!
    @IBOutlet weak var nameUserLabel: ReservationDetailTextField!
    @IBOutlet weak var dateReservationLabel: ReservationDetailTextField!
    @IBOutlet weak var dayReservationLabel: ReservationDetailTextField!
    @IBOutlet weak var hoursReservationLabel: ReservationDetailTextField!
    @IBOutlet weak var positionReservationLabel: ReservationDetailTextField!
    
    @IBOutlet weak var deleteReservationButton: UIButton!
    @IBAction func deleteReservationButtonFunc(_ sender: Any) {
        requestLogin()
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //LOAD USER DETAIL
        let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
        
        //VIEW USER DETAIL
        userListing(userListing:decodedTeams)
        self.userId = decodedTeams.id

    }
    
    //MARK: VIEW USER DETAIL
    func userListing(userListing:Login){
        self.nameUserLabel.text = self.myReservation?.activity_name
        let reservationDate = Reservation.convertReservationDateFormater(dateFrom:(self.myReservation?.date_from)!,dateTo:(self.myReservation?.date_to)!)
        self.dateReservationLabel.text = ("\(reservationDate[0]) | \(reservationDate[1]) - \(reservationDate[2])")
        self.dayReservationLabel.text = reservationDate[0]
        self.hoursReservationLabel.text = ("\(reservationDate[1]) - \(reservationDate[2])")
        self.positionReservationLabel.text = self.myReservation?.place_name
        self.logoUserImage.image = UIImage(named: Reservation.logoReservation(idActivity:(self.myReservation?.id_activity)!))
    }
    
    
    
    
    // MARK: CONNECT
    private func requestLogin(){
        //url
        let url = URL(string: "http://omega.leksys.cz/smazrezervaci.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                // kody pro zvlast stránky
                if let dataObject = backResponse["user"] as? [String:Any], backResponse["user"] != nil {
                    let data = Login(json: dataObject)
                    print("data \(String(describing: data))")
                    //self.loginOk(data:data!)
                }else{
                    // špatné přihlašovací údaje
                    //let data = MyError(json: backResponse)
                    //if data?.error_code == 112 {
                    //    self.queryLoginAlert(title:"Neplatné přihlášení",message:"Zkontrolujte přihlašovací údaje")
                    //}
                }
            }else{
                print("responseObject is nil")
            }
        }
    }
    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams() -> Parameters{
        if let idReservation = self.myReservation?.id{
            
            //VALUE  "id_activity", "id_reservation", "id_place", "id_user"
            let params: NSMutableDictionary? = ["id_reservation":idReservation,"id_user":self.userId,"id_activity":self.myReservation?.id_activity,"id_place":self.myReservation?.id_place]
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

}

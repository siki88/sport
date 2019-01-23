//
//  ContactUIViewController.swift
//  omega
//
//  Created by Lukas Spurny on 07.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireImage

class ContactViewController: UIViewController {
    
    //indicator
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let url = URL(string: "http://omega.leksys.cz/kontakty.php")
    var contact = [Contact]()
    
    
     @IBAction func btnCallingFirst(_ sender: Any){
     guard let number = URL(string: "tel://+420585205700") else { return }
     UIApplication.shared.open(number)
     }
    
    @IBAction func btnCallingSecond(_ sender: Any){
        guard let number = URL(string: "tel://+420585205800") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func btnSendEmail(_ sender: Any){
        let email = "info@omegasport.cz"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
 

    // MENU
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchCustomTableView: UISegmentedControl!
    @IBAction func switchCustomTableViewAction(_ sender: UISegmentedControl) {
        self.activityIndicator.startAnimating()
        self.contact.removeAll()
        if (switchCustomTableView.selectedSegmentIndex == 0){
            requestActivities(url:self.url!,key:"Vedení")
        }else if(switchCustomTableView.selectedSegmentIndex == 1){
            requestActivities(url:self.url!,key:"Fitness trenéři")
        }else if(switchCustomTableView.selectedSegmentIndex == 2){
            requestActivities(url:self.url!,key:"Ostatní")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        self.activityIndicator.startAnimating()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
     
    
        requestActivities(url:self.url!,key:"Vedení")
       
        let nib = UINib(nibName: "VedeniTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "vedeniTableCell")
        
   //     tableView.allowsSelection = false
    }
    
    //MAKR: Indicator activity
    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
    }

}


 //MARK: TABLE VIEW
 extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contact.count
     }
    
     // vyska jednoho pole
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "vedeniTableCell", for: indexPath) as! VedeniTableViewCell
        
            Alamofire.request(self.contact[indexPath.row].image).responseImage { response in
                if let image = response.result.value {
                    cell.avatar.image = image
                }else{
                    cell.avatar.image = UIImage(named: "greenCircle.png")
                }
            }
        
            cell.avatar.roundCorners(corners: [.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 90)

            cell.business.text = self.contact[indexPath.row].post
            cell.email.text = self.contact[indexPath.row].email
            cell.mainName.text = self.contact[indexPath.row].name
            cell.telefon.text = self.contact[indexPath.row].phone
        
            cell.selectionStyle = .none
        
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactTel = self.contact[indexPath.row].phone
        guard let number = URL(string: "tel://\(contactTel)") else { return }
        UIApplication.shared.open(number)
    }
    
    
    
    
    
    
    
 }
 //MARK: END TABLE VIEW


// MARK: CONNECTING
extension ContactViewController {
    
    func requestActivities(url:URL,key:String){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let activitiesValue = response.result.value as? [String:Any]{
                    if let activities = activitiesValue[key] as? [[String:Any]]{
                        
                        for activitie in activities{
                            if let parsenew = Contact(json: activitie as [String : Any]){
                                self.contact.append(parsenew)
                            }
                        }
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }

                }
        }
        
    }
    
}
//MARK: END CONNECT

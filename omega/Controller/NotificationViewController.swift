//
//  NotificationViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class NotificationViewController: UIViewController {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let requestDataManager = DataManager()
    var notifications = [Notifications]()
    var page: Int = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchongMore = false  // auto load on scroll down
    
    // back button
    @IBAction func backArrowFunc(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        activityIndicator.startAnimating()
        // SEND CONNECT FUNCTION
        requestMyReservation(key: "notifications")
        print("separator: \(self.tableView.separatorStyle)")
    }

    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        //        print("offsetY: \(offsetY) || contentHeight: \(contentHeight)")
        if offsetY <= 99.2 {
            //         autoScrollDown(redukce:-165)
        }
        if offsetY >= contentHeight - scrollView.frame.height {
            
            if !self.fetchongMore{
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        self.activityIndicator.startAnimating()
        fetchongMore = true
        requestMyReservation(key: "notifications")
        self.page = self.page + 1
    }

}



extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }

    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableViewCell
        
        cell.dateLabel.text = self.notifications[indexPath.row].date
        cell.notTextLabel.text = self.notifications[indexPath.row].text
        
        cell.selectionStyle = .none
        
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

extension NotificationViewController {

    // MARK: CONNECT
    func requestMyReservation(key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/notifications.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
  
                // kody pro zvlast stránky
                if let moreNews = backResponse[key] as? [[String:Any]],moreNews.count != 0 ,backResponse[key] != nil, (responseObject?.count)! > 0 {
                    for singleNews in moreNews{
                        if let parsenew = Notifications(json: singleNews as [String : Any]){
                            self.notifications.append(parsenew)
                        }
                    }
                    self.tableView.reloadData()
                    self.fetchongMore = false
                }else{
                    self.fetchongMore = true
                    // špatné přihlašovací údaje
                    //let data = MyError(json: backResponse)
                    //print("ERROR: \(String(describing: data?.error_msg)) AND error_Code \(String(describing: data?.error_code))")
                    //print("seconf responseObject.count: \(String(describing: responseObject?.count))")
                    print("empty news")
                }
                self.activityIndicator.stopAnimating()
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
        let params: NSMutableDictionary? = ["page":self.page,"id":decodedTeams.id]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }
    
}

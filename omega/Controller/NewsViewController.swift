//
//  NewsViewController.swift
//  omega
//
//  Created by Lukas Spurny on 19.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireImage

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let requestDataManager = DataManager()
    var myNews = [News]()
    var page: Int = 1
    
    var fetchongMore = false  // auto load on scroll down
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    
        // SEND CONNECT FUNCTION
        requestMyReservation(key: "news")
    }

    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // MARK: CONNECT
    private func requestMyReservation(key:String){
        //url
        let url = URL(string: "http://omega.leksys.cz/news.php")
        //connect class
        requestDataManager.most(myParams(), url:url!) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                
                // kody pro zvlast stránky
                if let moreNews = backResponse[key] as? [[String:Any]],moreNews.count != 0 ,backResponse[key] != nil, (responseObject?.count)! > 0 {
                    for singleNews in moreNews{
                        if let parsenew = News(json: singleNews as [String : Any]){
                            self.myNews.append(parsenew)
                        }
                    }
                    self.tableView.reloadData()
                    self.fetchongMore = false
                    self.activityIndicator.stopAnimating()
                }else{

                }
                self.activityIndicator.stopAnimating()
            }else{
                //print("responseObject is nil")
            }
        }
        
    }

    
    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams() -> Parameters{
        
        //VALUE
        let params: NSMutableDictionary? = ["page":self.page]
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myNews.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableViewCell
        
        Alamofire.request(self.myNews[indexPath.row].img).responseImage { response in
            if let image = response.result.value {
                cell.imageNews.image = image
            }else{
                cell.imageNews.image = UIImage(named: "greenCircle.png")
            }
        }

        cell.imageNews.roundCorners(corners: [.bottomRight], radius: 15)
        
        cell.titleNewsLabel.text = self.myNews[indexPath.row].name
        cell.dateNewsLabel.text = self.myNews[indexPath.row].date
      
        cell.selectionStyle = .none
        
        return cell
    }
    
    // zjistiji idecko
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNew" {
            let updateViewController:NewDetailViewController = segue.destination as! NewDetailViewController
            updateViewController.myNew = self.myNews[(self.tableView.indexPathForSelectedRow?.row)!]
        }
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
                activityIndicator.startAnimating()
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        fetchongMore = true
        requestMyReservation(key: "news")
            self.page = self.page + 1
    }


}




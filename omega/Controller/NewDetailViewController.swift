//
//  NewDetailViewController.swift
//  omega
//
//  Created by Lukas Spurny on 23.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class NewDetailViewController: UIViewController{
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var myNew:News?
    
    @IBOutlet weak var WebView: UIWebView!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var newDateLabel: UILabel!
    @IBOutlet weak var newTitleLabel: UILabel!
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        myWebView()
        newListing()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.stopAnimating()
    }
    
    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func myWebView(){
        // MARK: WebKit
        if let myWebView = self.myNew?.text,self.myNew?.text != nil,self.myNew?.text != "" {
            
            self.WebView.loadHTMLString("<span style=\"font-family: SFProText-Light; font-size: 13px; color: #000000\">\(myWebView)</span>", baseURL: nil)
            
        }
    }
    
    //MARK: VIEW USER DETAIL
    func newListing(){
        self.newDateLabel.text = self.myNew?.date
        self.newTitleLabel.text = self.myNew?.name
 
        Alamofire.request((self.myNew?.img)!).responseImage { response in
            if let image = response.result.value  {
                self.newImage.image = image
            }else{
                self.newImage.image = UIImage(named: "greenCircle.png")
            }
        }
        self.newImage.roundCorners(corners: [.bottomRight], radius: 15)
    }

}



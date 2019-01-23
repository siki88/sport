//
//  SettingsObchodniPodminkyViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class SettingsObchodniPodminkyViewController: UIViewController {

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBOutlet weak var WebView: UIWebView!
    
    @IBOutlet weak var obchodniPodminkyButton: UIButton!
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myActivityIndicator()
        activityIndicator.startAnimating()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        WebView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "ObchodniPodminky", ofType: "html")!)))
        
        self.obchodniPodminkyButton.isEnabled = false
        
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
    }

}

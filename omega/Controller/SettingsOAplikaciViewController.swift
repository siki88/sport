//
//  SettingsOAplikaciViewController.swift
//  omega
//
//  Created by Lukas Spurny on 03.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class SettingsOAplikaciViewController: UIViewController {

    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    @IBOutlet weak var versionApplicationLabel: UILabel!
    
    @IBOutlet weak var oAplikaciButton: UIButton!
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.oAplikaciButton.isEnabled = false
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionApplicationLabel.text = ("Verze aplikace: \(version)")
        }
     
    }


}

//
//  MenuViewController.swift
//  omega
//
//  Created by Lukas Spurny on 18.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    let imgIconArray = ["mojeOmega","menuAktuality","menuRezervace","menuCenik","contact","setting"]
    let lblMenuNameArray = ["Moje OMEGA","Aktuality","Rezervace","Ceník služeb","Kontakty","Nastavení"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change tableView backgorund color
        self.tableView.backgroundColor = UIColor(red: 31.0/255, green: 31.0/255, blue: 31.0/255, alpha: 1.0)
        // disable line tableView
        self.tableView.separatorStyle = .none
    }
    
    //MARK: start table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lblMenuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell", for: indexPath) as! MenuTableViewCell
        
        cell.imgIcon.image = UIImage(named: self.imgIconArray[indexPath.row])
        
        cell.lblMenuName.text = self.lblMenuNameArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController:SWRevealViewController = self.revealViewController()
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if cell.lblMenuName.text! == "Moje OMEGA"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "OverviewViewController") as! OverviewViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else if cell.lblMenuName.text! == "Aktuality"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else if cell.lblMenuName.text! == "Rezervace"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else if cell.lblMenuName.text! == "Ceník služeb"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "PriceListViewController") as! PriceListViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else if cell.lblMenuName.text! == "Kontakty"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else if cell.lblMenuName.text! == "Nastavení"{
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }else{
            
        }
    }
    //MARK: stop table view

}

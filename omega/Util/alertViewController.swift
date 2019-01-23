//
//  alertViewController.swift
//  test
//
//  Created by Lukas Spurny on 28.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import UIKit

class alertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: ALERT
    static func alert(title:String,message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        return alert
      //  self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: ALERT NON STATIC
    func alertNonStatic(title:String,message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        return alert
        //  self.present(alert, animated: true, completion: nil)
    }
    

}


// nastavení otáčení obrazovky
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

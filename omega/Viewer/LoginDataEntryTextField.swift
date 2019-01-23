//
//  LoginDataEntryTextField.swift
//  omega
//
//  Created by Lukas Spurny on 18.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class LoginDataEntryTextField: UITextField {

    func jitter() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
    

}

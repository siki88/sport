//
//  NewReservationTennis.swift
//  omega
//
//  Created by Lukas Spurny on 25.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class NewReservationTennis: UIView {

    
    
    @IBOutlet weak var imageView: UIView!
    
    
    
    let myNewReservationViewController = NewReservationViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let _ = loadViewFromNib()
    }
 
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "NewReservationTennis", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        return view
    }
    
    public func settingPicker(){
      //  self.timeNewReservation.inputView = myNewReservationViewController.pickerView
       // self.timeNewReservation.textAlignment = .center
       // self.timeNewReservation.tintColor = UIColor.clear
    }
    

    
}




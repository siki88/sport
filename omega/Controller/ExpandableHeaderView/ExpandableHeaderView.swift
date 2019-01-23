//
//  ExpandableHeaderView.swift
//  omega
//
//  Created by Lukas Spurny on 20.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor(red: 253/255, green: 91/255, blue: 0/255, alpha: 1)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.borderColor = UIColor(red: 217/255, green: 219/255, blue: 222/255, alpha: 1)
        self.contentView.borderWidth = 1
        
        
        // cell.textLabel?.textColor =  //UIColor(red: 253/255, green: 91/255, blue: 0/255, alpha: 1)
        // cell.backgroundColor = UIColor.white
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

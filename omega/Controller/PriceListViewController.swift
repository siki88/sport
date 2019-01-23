//
//  priceListViewController.swift
//  omega
//
//  Created by Lukas Spurny on 08.08.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit

class PriceListViewController: UIViewController, ExpandableHeaderViewDelegate{

    var sections:[Section]?
    
    var sectionsAdults = [
        Section(genre: "Tenis hala",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["340","340","340","340","340"],
                neclen: ["400","400","400","400","400"]),
        Section(genre: "Tenis antuka",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["170","150","170","170","170"],
                neclen: ["200","170","200","200","200"]),
        Section(genre: "Squash (stolní tenis)",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["160","145","200","160","180"],
                neclen: ["200","180","260","200","240"]),
        Section(genre: "Badminton",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["200","165","260","200","230"],
                neclen: ["250","220","330","250","290"]),
        Section(genre: "Skupinové lekce",
                movies: ["45min (SÁL 1,3)", "60min (SÁL 1,3)" , "75min (SÁL 1,3)" , "TRX (SÁL 1)", "AERO YOGA", "SM SYSTÉM", "HOT LEKCE 60min", "HOT LEKCE 90min", "WARM LEKCE 60min", "WARM LEKCE 75min", "TRAMPOLÍNKY 45min", "TRAMPOLÍNKY 60min", "TRAMPOLÍNKY 75min"],
                expanded: false,
                clen: ["65","70","75","105","105","130","120","150","105","115","80","90","100"],
                neclen: ["105","110","115","130","130","155","160","190","130","140","100","110","120"]),
        Section(genre: "Fitness",
                movies: ["OSOBNÍ TRENÉR 1 hod", "OSOBNÍ TRENÉR PÁR 1 hod" , "MĚSÍČNÍ FITNESS" , "ROČNÍ FITNESS - měs.splátky" , "ROČNÍ FITNESS - jednorázově", "POWER PLATE 30 min", "POWER PLATE PÁR 30 min"],
                expanded: false,
                clen: ["345","460","890","785","9050","200","250"],
                neclen: ["525","700","1090","990","11450","300","375"]),
        Section(genre: "Mokrá zóna",
                movies: ["PO-PÁ 6-15 hod, 21-23 hod", "PO-PÁ 15-21 hod", "Víkend a svátek"],
                expanded: false,
                clen: ["ZDARMA","ZDARMA","ZDARMA"],
                neclen: ["250","350","400"]),
        Section(genre: "Solárium / solárium turbo",
                movies: ["KLASICKÉ 1 min","TURBO 1 min"],
                expanded: false,
                clen: ["5", "10"],
                neclen: ["7","14"]),
        Section(genre: "Adventure golf",
                movies: ["DĚTI DO 6 LET", "DĚTI 7-15 LET" , "DOSPĚLÍ OD 16 LET" , "RODINA"],
                expanded: false,
                clen: ["20","50","80","200"],
                neclen: ["25","60","100","240"]),
    ]
    
    var sectionsStudent = [
        Section(genre: "Tenis hala",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["340","340","340","340","340"],
                neclen: ["400","400","400","400","500"]),
        Section(genre: "Tenis antuka",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["170","140","170","170","170"],
                neclen: ["200","150","200","200","200"]),
        Section(genre: "Squash (stolní tenis)",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["120","120","200","120","180"],
                neclen: ["140","140","260","140","240"]),
        Section(genre: "Badminton",
                movies: ["6:00 - 9:00", "9:00 - 15:00" , "15:00 - 21:00" , "21:00 - 23:00" , "Víkend a svátek"],
                expanded: false,
                clen: ["140","140","260","140","230"],
                neclen: ["220","210","330","220","290"]),
        Section(genre: "Skupinové lekce",
                movies: ["45min (SÁL 1,3)", "60min (SÁL 1,3)" , "75min (SÁL 1,3)" , "TRX (SÁL 1)", "AERO YOGA", "SM SYSTÉM", "HOT LEKCE 60min", "HOT LEKCE 90min", "WARM LEKCE 60min", "WARM LEKCE 75min", "TRAMPOLÍNKY 45min", "TRAMPOLÍNKY 60min", "TRAMPOLÍNKY 75min"],
                expanded: false,
                clen: ["60","65","70","105","105","130","120","150","105","115","80","90","100"],
                neclen: ["95","100","105","130","130","155","160","190","130","140","100","110","120"]),
        Section(genre: "Fitness",
                movies: ["OSOBNÍ TRENÉR 1 hod", "OSOBNÍ TRENÉR PÁR 1 hod" , "MĚSÍČNÍ FITNESS" , "ROČNÍ FITNESS - měs.splátky" , "ROČNÍ FITNESS - jednorázově", "POWER PLATE 30 min", "POWER PLATE PÁR 30 min"],
                expanded: false,
                clen: ["345","460","890","9050","785","200","250"],
                neclen: ["525","700","1090","11450","990","300","375"]),
        Section(genre: "Mokrá zóna",
                movies: ["PO-PÁ 6-15 hod, 21-23 hod", "PO-PÁ 15-21 hod", "Víkend a svátek"],
                expanded: false,
                clen: ["ZDARMA","ZDARMA","ZDARMA"],
                neclen: ["250","350","400"]),
        Section(genre: "Solárium / solárium turbo",
                movies: ["KLASICKÉ 1 min","TURBO 1 min"],
                expanded: false,
                clen: ["5", "10"],
                neclen: ["7","14"]),
        Section(genre: "Adventure golf",
                movies: ["DĚTI DO 6 LET", "DĚTI 7-15 LET" , "DOSPĚLÍ OD 16 LET" , "RODINA"],
                expanded: false,
                clen: ["20","50","80","200"],
                neclen: ["25","60","100","240"]),
        ]
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem! // menu
    
    @IBOutlet weak var tableView: UITableView! // menu
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentControlFunc(_ sender: UISegmentedControl) {
        
            if segmentControl.selectedSegmentIndex == 1{
                self.sections = self.sectionsStudent
                self.tableView.reloadData()
            }else{
                self.sections = self.sectionsAdults
                self.tableView.reloadData()
            }

    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation menu
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        btnMenuButton.target = revealViewController()
        btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.sections = self.sectionsAdults
        self.tableView.allowsSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections!.count
    }
    
}

// MARK: START TABLE VIEW
extension PriceListViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections![section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections![indexPath.section].expanded) {
            return 54
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections![section].genre, section: section, delegate: self)
        
//        let imageName = "sipkaVpravoOranzova.png"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: self.tableView.frame.size.width - 15, y: self.tableView.frame.size.height / 1.7, width: 5, height: 10)
//        header.addSubview(imageView)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as! PriceListTableViewCell
        cell.longTimeLabel.text = sections![indexPath.section].movies[indexPath.row]
        cell.costClenLabel.text = "\(sections![indexPath.section].clen[indexPath.row]) Kč"
        cell.costNeclenLabel.text = "\(sections![indexPath.section].neclen[indexPath.row]) Kč"
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections![section].expanded = !sections![section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections![section].movies.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
}
// MARK: END TABLE VIEW

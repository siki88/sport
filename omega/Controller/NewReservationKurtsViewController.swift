//
//  NewReservationKurtsViewController.swift
//  omega
//
//  Created by Lukas Spurny on 31.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class NewReservationKurtsViewController: UIViewController{

    let requestDataManager = DataManager()
    
    //mytest
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    
    //seznam kurtu podle počtu kurtu
    @IBOutlet weak var kurtViewLabel: UILabel!
    
    //text field for picker bar
    @IBOutlet weak var timeNewReservation: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    //TABLEVIEW
    @IBOutlet weak var tableView: UITableView!
    
    //SCROLLVIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    // přichází z předchozí stránky
    var myReservationCurts:[ReservationTennis]?
    
    //MARK: PICKER VIEW
    let pickerView = UIPickerView()
    let hourArray = [0.30,1.00,1.30,2.00,2.30,3.00,3.30,4.00,4.30,5.00,5.30,6.00,6.30,7.00,7.30,8.00,8.30,9.00,9.30,10.00,10.30,11.00,11.30,12.00,12.30,13.00,13.30,14.00,14.30,15.00,15.30,16.00,16.30,17.00,17.30,18.00]
    //main hours
    let myHourArray = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22] // 18
    
    var myActualHours:Int?
    
    var myReservationDate = [Double]()
    
    var idActivity:Int?
    var idKurt:Int?
    var idKurtControl: [Int] = []
    var selectDate:String?

    var LongReservation:Int?
    var SelectLongReservation:Int = 0
    
    var onClickCell:IndexPath?
    
    var plans = [PlanRegistration]() // na hovno

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
 
    /*
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "NewReservationViewController") as! NewReservationViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    */  
    
    //accept
    @IBOutlet weak var acceptReservationFirst: UIButton!
    @IBAction func acceptReservationFirstFunc(_ sender: Any) {
        
        if self.idKurtControl.count == 1 {
        
            self.idKurt = self.idKurtControl[0]
            
            if SelectLongReservation == myReservationDate.count / 2 &&  myReservationDate.count > 0{
            
                let myDateFrom = myReservationDate.min()
                let myDateTo = myReservationDate.max()
                
                //LOAD USER DETAIL
                let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
                let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
                
                let mydateSendFrom = universalConvertDateFormater(date:"\(selectDate!)-\(myDateFrom!)0",first:"yyyy-MM-dd-HH.m",second:"yyyy-MM-dd HH:mm:SS" )
                
                //kontroluji zda se neobjednává rezervace se starým datumem
                if mydateSendFrom > actualDate() {
                
                    let mydateSendTo = universalConvertDateFormater(date:"\(selectDate!)-\(myDateTo!)0",first:"yyyy-MM-dd-HH.m",second:"yyyy-MM-dd HH:mm:SS" )
                
                    let myDateAlertSendFrom = universalConvertDateFormater(date:"\(myDateFrom!)",first:"HH.mm",second:"HH:m" )
                    let myDateAlertSendTo = universalConvertDateFormater(date:"\(myDateTo!)",first:"HH.mm",second:"HH:m" )
                
                        let sendParam:NSMutableDictionary = ["id_activity":self.idActivity!,"id_place":self.idKurt!,"id_user":decodedTeams.id,"date_from":mydateSendFrom,"date_to":mydateSendTo]
                
                
                        alertForSend(title:"Potvrzení rezervace.",message:"Čas rezervace od: \(myDateAlertSendFrom)0 do \(myDateAlertSendTo)0 hodin.",sendParam:sendParam)
                }else{
                    self.queryLoginAlert(title:"Nelze rezervovat se starším datumem.",message:"Upravte rezervaci.")
                }
                
            }else{
                self.queryLoginAlert(title:"Délka rezervace nesouhlasí.",message:"Zkontrolujte čas s délkou v tabulce.")
            }
        }else{
            self.queryLoginAlert(title:"Vybráno více kurtů.",message:"Vyberte pouze jeden.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendVirtualCurts()

//        pickerBar()
        
        //activity indicator
        myActivityIndicator()
        
        // zakázání otačení obrazovky
        AppUtility.lockOrientation(.portrait)
        
        var myNumberCurts = ""
            for index in 0...(self.myReservationCurts?.count)! / 2 {
                if index != 0 {
                    if ((self.myReservationCurts?.count)! / 2) <= 4 {
                        myNumberCurts += "   \(index)         "
                    }else{
                        myNumberCurts += "\(index)    "
                    }
                }
            }
        self.kurtViewLabel.text = myNumberCurts
        
        tableView.separatorStyle = .none
        
//        self.timeNewReservation.isHidden = true
//        self.timeLabel.isHidden = true
        
        
    }
    
    func actualDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let result = formatter.string(from: date)
        return result
    }
    
    //MARK: POTVRZENI REZERVACE
    func alertForSend(title:String,message:String,sendParam:NSMutableDictionary){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ODESLAT", comment: "Default action"), style: .`default`, handler: { _ in
           // NSLog("The \"OK\" alert occured.")
            self.activityIndicator.startAnimating()
            //query on connect classic - pak předělat
            let url = URL(string: "http://omega.leksys.cz/novarezervace.php")
            self.requestMyReservation(url:url!,sendParam:sendParam)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("STORNO", comment: "Default action"), style: .`default`, handler: { _ in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Alert Error
    func queryLoginAlert(title:String,message:String){
        let alert = alertViewController.alert(title:title,message:message)
        self.present(alert, animated: true, completion: nil)
    }
    
    func appendVirtualCurts(){
        for convertDate in self.myReservationCurts! {
            self.myReservationCurts!.append(convertDate)
        }
    }

    func addValueCollection(){
        //add model - PlanRegistration
        if self.plans.count == 0 {
            var myHours:Int = 6
            for _ in 1...23 {
                let plan = PlanRegistration()
                plan?.hours = myHours
                plan?.minuts15 = 15
                plan?.minuts30 = 30
                plan?.minuts45 = 45
                self.plans.append(plan!)
                myHours += 1
            }
        }
    }
    
    // MARK: CONVERT Date formated
    func universalConvertDateFormater(date:String,first:String,second:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = first
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = second
        return  dateFormatter.string(from: date!)
    }
    
    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
    }
    
}


//MARK: PICKER VIEW
/*
extension NewReservationKurtsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func pickerBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Zvolit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(myDonePickerTwo))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.timeNewReservation.inputView = self.pickerView
        self.timeNewReservation.inputAccessoryView = toolBar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    @objc func myDonePickerTwo (sender:UIBarButtonItem){
        self.timeNewReservation.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView , titleForRow row: Int, forComponent component: Int) -> String? {
        return (universalConvertDateFormater(date:"\(self.hourArray[row])0",first:"HH.mm",second:"HH:mm" ))
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.timeNewReservation.text = universalConvertDateFormater(date:"\(self.hourArray[row])0",first:"HH.mm",second:"HH:mm" )
        
        pickerView.tag = hourArray.index(of: self.hourArray[row])!
        self.LongReservation = hourArray.index(of: self.hourArray[row])! + 1
 
    }
}
*/
// MARK: END PICKER VIEW



// MARK: START TABLE VIEW
extension NewReservationKurtsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myHourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? NewReservationKurtsCollectionsViewCell
        
        myActualHours = self.myHourArray[indexPath.row]
        
        cell?.tag = self.myHourArray[indexPath.row]
        cell?.mainHoursLabel.text = ("\(self.myHourArray[indexPath.row])")
        
        cell?.selectionStyle = .none
        
        cell?.collectionView.accessibilityIdentifier = String(self.myHourArray[indexPath.row])
        
        cell?.collectionView.reloadData()
        
        return cell!
    }
    
}
// MARK: END TABLE VIEW
    

// MARK: START COLLECTION VIEW
extension NewReservationKurtsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let curtsCount = self.myReservationCurts, curtsCount.count == 18{
            let myCountCGFloat = CGFloat(15 * CGFloat(curtsCount.count))
                collectionView.frame.size.width = myCountCGFloat
            return CGSize(width: 22, height: 31) //21
        }else{
            return CGSize(width: 52, height: 31)
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.myReservationCurts?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewReservationKurtsFirstCollectionViewCell
        
        if var myCount = self.myReservationCurts?.count, myCount > 0 {
            
            var delkaJednohocell:CGFloat = 52
            if myCount == 18 {
                delkaJednohocell = 23
            }
                
            myCount = myCount / 2
            let myCountCGFloat = CGFloat(delkaJednohocell * CGFloat(myCount)) //51.7499981
                collectionView.frame.size.width = myCountCGFloat
        }
        
        let singleKurt = self.myReservationCurts![indexPath.row]
        
        if let myActualHour = self.myActualHours , self.myActualHours != nil {
            var myActialHourDou = Double(myActualHour)
            
            if indexPath.row >= self.myReservationCurts!.count / 2 {
                myActialHourDou = (myActialHourDou + 0.30)
            }

            //projíždím obsazenost rezervací a dávám šedý background
            for convertDate in singleKurt.reservationTennisKurts{
                
                let dateFrom = universalConvertDateFormater(date:convertDate.date_from,first:"yyyy-MM-dd HH:mm:SS",second:"HH.mm" )
                let dateTo = universalConvertDateFormater(date:convertDate.date_to,first:"yyyy-MM-dd HH:mm:SS",second:"HH.mm" )

                
                if indexPath.row < self.myReservationCurts!.count / 2 {
                    if Double(dateFrom)! <= myActialHourDou && Double(dateTo)! > myActialHourDou {
                        cell.backgroundColor = UIColor.lightGray
                        cell.isUserInteractionEnabled = false
                    }
                }else{
                    if Double(dateFrom)! <= myActialHourDou && Double(dateTo)! > myActialHourDou {
                        cell.backgroundColor = UIColor.lightGray
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
            cell.myFirstLabelCell.text = ""
            cell.tag = singleKurt.id

        }
            cell.myFirstLabelCell.tag = singleKurt.id
    
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

            let cell = collectionView.cellForItem(at: indexPath)
            self.LongReservation = pickerView.tag  + 1 //4 - tu delka rezervace víše
            
            //actual hours
            if let myActialHourString = collectionView.accessibilityIdentifier {
                let myActialHourInt  = Int(myActialHourString)
                
                var myActialHourDoubleFrom:Double?
                var myActialHourDoubleTo:Double?
                
                myActialHourDoubleTo = Double(myActialHourInt!) + 0.30 //6:30
                myActialHourDoubleFrom = Double(myActialHourInt!)      //6:00
                
                
                if indexPath.row >= self.myReservationCurts!.count / 2 {
                    myActialHourDoubleFrom = Double(myActialHourInt!) + 0.30
                    myActialHourDoubleTo = Double(myActialHourInt!) + 1.00
                }else{
                    myActialHourDoubleFrom = Double(myActialHourInt!)
                    myActialHourDoubleTo = Double(myActialHourInt!) + 0.30
                }
            
                
                if cell?.backgroundColor == UIColor.gray{
                    //odklik
                    cell?.backgroundColor = UIColor.white
                    SelectLongReservation -= 1
                    
                    if let Index = myReservationDate.index(of: myActialHourDoubleFrom!) {
                        self.myReservationDate.remove(at: Index)
                    }
                    
                    if let Index = myReservationDate.index(of: myActialHourDoubleTo!) {
                        self.myReservationDate.remove(at: Index)
                    }
                    
                    if let Index = idKurtControl.index(of: (cell?.tag)!) {
                        self.idKurtControl.remove(at: Index)
                    }
                    
                }else{
                    //záklik
                    cell?.backgroundColor = UIColor.gray
                    SelectLongReservation += 1
                    
                    self.myReservationDate.append(myActialHourDoubleFrom!)
                    self.myReservationDate.append(myActialHourDoubleTo!)
                    
                    if !(self.idKurtControl.contains((cell?.tag)!)) {
                        self.idKurtControl.append((cell?.tag)!)
                    }
                    
                }

            }
        self.onClickCell = indexPath
    }
    
}
// MARK: END COLLECTION VIEW


//MARK: CONNECT
extension NewReservationKurtsViewController {

    // MARK: CONNECT ACTIVITIES - classic
    func requestMyReservation(url:URL,sendParam:NSMutableDictionary){

        //connect class
        requestDataManager.most(myParams(dateString: sendParam), url:url) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil{
                
                if let backResponseType:Int = backResponse["error"] as? Int, backResponseType == 0 {
                    self.activityIndicator.stopAnimating()
                    self.queryLoginAlert(title:"Rezervace úspěšně odeslána.",message:"Děkujeme.")
                }else{
                    if let requestReservation = backResponse["error"], backResponse["error"] != nil {
                        if let requestReservationCode = backResponse["error_code"], backResponse["error"] != nil {
                            if requestReservation as! Bool == true &&  requestReservationCode as! Int == -2 {
                                self.queryLoginAlert(title:"Nedostatek kreditu",message:"navýšte kredit")   
                            }else {
                                self.queryLoginAlert(title:"Rezervace nebyla odeslána.",message:"Opakujte později.")
                            }
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
                
            }else{

            }
        }
    }

    // MARK: PARSE PARAMETERS FOR SEND POST
    private func myParams(dateString:NSMutableDictionary) -> Parameters{

        //VALUE
        let params: NSMutableDictionary = dateString
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json: NSString! = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        //KEY
        let parameters: Parameters   = [
            "data" : json!
        ]
        return parameters
    }
}
//MARK: END CONNECT


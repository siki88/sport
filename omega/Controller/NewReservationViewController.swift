//
//  NewReservationViewController.swift
//  omega
//
//  Created by Lukas Spurny on 25.07.18.
//  Copyright © 2018 LEKSYS s.r.o. All rights reserved.
//

import UIKit
import Alamofire

class NewReservationViewController: UIViewController {
    
    private var myActivities = [Activities]()
    let requestDataManager = DataManager()
    var reservationExercises = [ReservationExercises]()
    var reservationTennis = [ReservationTennis]()
    var idPlaces:Int?
    var type:Int?
    var selectDate:String?
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    //VIEW
    @IBOutlet weak var viewAfterScroll: UIView!

    //SCROLLVIEW
    @IBOutlet weak var scrollView: UIScrollView!
    
    //COLLECTIONVIEW
    var plans = [PlanRegistration]()
    let PlanCollectionViewCellIdentificator = "PlanCollectionViewCell"
    
    //TABLEVIEW
    @IBOutlet weak var NewReservationExercisesTableView: UITableView!
    
    //PICKERVIEW
    let pickerView = UIPickerView()
    @IBOutlet weak var detailLabelPickerView: UITextField!  // tag 1
    
    //DATEPICKER
    var datePicker = UIDatePicker()
    @IBOutlet weak var dateLabelPickerView: UITextField!
    
    
    @IBAction func backArrowFunc(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        let newFrontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(newFrontViewController, animated: true)
    }
    @IBOutlet weak var labelLection: UILabel!
    
    //accept
    @IBOutlet weak var acceptReservationFirst: UIButton!
    @IBAction func acceptReservationFirstFunc(_ sender: Any) {
        
//print("my send palce: \(String(describing: self.idPlaces))")
        
        if let sendPlace  = self.idPlaces, self.idPlaces != nil {
            if sendPlace == 40 || sendPlace == 46 || sendPlace == 4 {
                
                activityIndicator.startAnimating()
                //LOAD USER DETAIL
                let decoded  = UserDefaults.standard.object(forKey: "User") as! Data
                let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Login
                
                
                
                //query on connect classic - pak předělat
                let url = URL(string: "http://omega.leksys.cz/novarezervace.php")
                
                let sendParam:NSMutableDictionary = ["id_activity":sendPlace,"id_lesson":self.reservationExercises[(self.NewReservationExercisesTableView.indexPathForSelectedRow?.row)!].id,"id_user":decodedTeams.id]
                
                requestMyReservation(url:url!,key:"error", value: valueType(),sendParam:sendParam)
                
            }
        }


    }
    //next
    @IBOutlet weak var acceptReservation: UIButton!
    @IBAction func acceptReservationFunc(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //activity indicator
        myActivityIndicator()
        
        sendQuery()
        
        //picker view
        pickerView.dataSource = self
        pickerView.delegate = self
        detailLabelPickerView.inputView = pickerView
        detailLabelPickerView.textAlignment = .center
        detailLabelPickerView.tintColor = UIColor.clear
        pickerBar()
        
        //datepicker
        dateLabelPickerView.inputView = datePicker
        dateLabelPickerView.textAlignment = .center
        myDatePicker()
        
        //nib/xib start
        let nib = UINib(nibName: "NewReservationExercisesTableViewCell", bundle: nil)
        NewReservationExercisesTableView .register(nib, forCellReuseIdentifier: "newReservationExercisesTableCell")
        
        //is hidden
        myIsHidden()
        
        NewReservationExercisesTableView.separatorStyle = .none
        
        self.scrollView.isScrollEnabled = false
        self.NewReservationExercisesTableView.isScrollEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //nastavení otačení obrazovky
        //AppUtility.lockOrientation(.portrait)

        activityIndicator.stopAnimating()
        
    }
    
    func myIsHidden(){
        self.dateLabelPickerView.isHidden = true
        self.NewReservationExercisesTableView.isHidden = true
        self.acceptReservation.isHidden = true
        self.acceptReservationFirst.isHidden = true
    }
    
    func sendQuery(){
        activityIndicator.startAnimating()
        let url = URL(string: "http://omega.leksys.cz/aktivity.php")
        requestActivities(url:url!,key:"activities")
    }

    func myActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.color = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        view.addSubview(activityIndicator)
        
    }
    
    func addValueCollection(){
        //add model - PlanRegistration
        if self.plans.count == 0 {
            var myHours:Int = 6
            for _ in 1...17 {
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
    
    
    
    //MARK ADD SUBVIEW TYPE RESERVATION
    func typeReservation(type:Int){
        
        self.dateLabelPickerView.isHidden = false
 
        switch (type) {
        case 1:
            addValueCollection()
            controlDesign(type:type,labelLection:"ČAS - VYBERTE/POTVRĎTE DATUM", NewReservationExercisesTableView:true,myAcceptReservation:true,myScrollView:false,myAcceptReservationFirst:false)
        case 2:
            controlDesign(type:type,labelLection:"LEKCE - VYBERTE/POTVRĎTE DATUM", NewReservationExercisesTableView:false,myAcceptReservation:true,myScrollView:true,myAcceptReservationFirst:true)
            self.NewReservationExercisesTableView.isScrollEnabled =  true
        case 3:
            controlDesign(type:type,labelLection:"TERMÍN - VYBERTE/POTVRĎTE DATUM",NewReservationExercisesTableView:true,myAcceptReservation:true,myScrollView:false,myAcceptReservationFirst:true)
            self.dateLabelPickerView.isHidden = true
        default:
            break
        }
    }
    
    
   
    
    func controlDesign(type:Int,labelLection:String,NewReservationExercisesTableView:Bool,myAcceptReservation:Bool,myScrollView:Bool,myAcceptReservationFirst:Bool){
        self.NewReservationExercisesTableView.isHidden = NewReservationExercisesTableView
        self.labelLection.text = labelLection
        self.scrollView.isScrollEnabled = myScrollView
        self.acceptReservation.isHidden = myAcceptReservation
        self.acceptReservationFirst.isHidden = myAcceptReservationFirst
    }

    //MARK: Alert Error
    func queryLoginAlert(title:String,message:String){
        let alert = alertViewController.alert(title:title,message:message)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: PICKER VIEW
extension NewReservationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func pickerBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Zvolit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//      let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.detailLabelPickerView.inputView = pickerView
        self.detailLabelPickerView.inputAccessoryView = toolBar
    }
    
    @objc func donePicker (sender:UIBarButtonItem)
    {
        self.detailLabelPickerView.resignFirstResponder()
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return myActivities.count
        }else{
            return myActivities.count // NOP
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView , titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.myActivities[row].name
        }else{
            return self.myActivities[row].name // NOP
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
            if self.myActivities.count > 0  {
                
                self.detailLabelPickerView.text = self.myActivities[row].name
                //add type on property
                self.idPlaces = self.myActivities[row].id
                self.type = self.myActivities[row].type

                self.reservationExercises.removeAll()
                self.NewReservationExercisesTableView.reloadData()
                self.acceptReservation.isHidden = true
                //view down view
                typeReservation(type:self.myActivities[row].type)
                
            }else{
                self.detailLabelPickerView.text = "OPAKUJTE VÝBĚR"
            }
        
    }
}
// MARK: END PICKER VIEW


//MARK: DATE-PICKER
extension NewReservationViewController {
    func myDatePicker(){
        // format for picker - vyjízdecí
        datePicker.datePickerMode = .date
//        self.selectDate = "\(datePicker.date)"
        datePicker.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.tintColor = UIColor(red: 154/255, green: 202/255, blue: 31/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Zvolit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        dateLabelPickerView?.inputAccessoryView = toolbar
        
        //assingning date picker to text field
        dateLabelPickerView?.inputView = datePicker
        
        activityIndicator.stopAnimating()
    }
    @objc func donePressed(){
activityIndicator.startAnimating()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        
        dateLabelPickerView.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateStyle = .medium
        myDateFormatter.timeStyle = .none
        let unformatDate = convertDateFormater(myDateFormatter.string(from: datePicker.date))
        self.selectDate = unformatDate
        
        //query on connect classic - pak předělat
        if let selectPlaces = self.idPlaces, self.idPlaces != nil {
            let url = URL(string: "http://omega.leksys.cz/mista.php")
            let sendParam:NSMutableDictionary = ["id":selectPlaces,"date":unformatDate]
            requestMyReservation(url:url!,key:"places", value: valueType(),sendParam:sendParam)
            self.acceptReservation.isHidden = true
        }
    }
    
    func valueType() -> String{
        var value:String = ""
        switch (self.type) {
        case 1:
            value = "reservationTennis"
        case 2:
            value = "reservationExercises"
        case 3:
            value = "massagge"
        default:
            break
        }
        return value
    }
    
    // MARK: CONVERT Date formated:  dd. mm. yyyy -> yyyy-MM-dd
    func convertDateFormater(_ date: String) -> String{
        
        let dateFormatter = DateFormatter()
        
            if #available(iOS 11.0, *) { // new
                dateFormatter.dateFormat = "MMM dd,yyyy"
            } else {  // old
                dateFormatter.dateFormat = "dd.MM.yyyy"
            }
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return  dateFormatter.string(from: date!)
    }
}
// MARK: END DATE-PICKER



//MARK: TABLE VIEW
extension NewReservationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reservationExercises.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newReservationExercisesTableCell", for: indexPath) as! NewReservationExercisesTableViewCell
        
        let dateFormatedFrom = convertDateFormaterTable(self.reservationExercises[indexPath.row].date_from)
        let dateFormatedTo = convertDateFormaterTable(self.reservationExercises[indexPath.row].date_to)
        
        cell.dateExcercises.text = "\(dateFormatedFrom) - \(dateFormatedTo)"
        
        if let myCapacity = self.reservationExercises[indexPath.row].capacity, self.reservationExercises[indexPath.row].capacity != nil, self.reservationExercises[indexPath.row].used_capacity != nil {
            cell.freeSeatsExcercises.text = "\(myCapacity - self.reservationExercises[indexPath.row].used_capacity!)"
        }else{
            cell.freeSeatsExcercises.text = "N/A"
        }
        
        cell.nameExcercises.text = self.reservationExercises[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let myCapacity = self.reservationExercises[indexPath.row].capacity, self.reservationExercises[indexPath.row].capacity != nil, self.reservationExercises[indexPath.row].used_capacity != nil {
            let realCapacity = (myCapacity - self.reservationExercises[indexPath.row].used_capacity!)
            if realCapacity <= 0 {
                self.acceptReservationFirst.isHidden = true
            }else{
                self.acceptReservationFirst.isHidden = false
            }
        }else{
           self.acceptReservationFirst.isHidden = true
        }
        
        self.acceptReservationFirst.frame = CGRect(x: self.view.frame.width / 13.5 ,y: NewReservationExercisesTableView.frame.size.height + 260 , width: scrollView.frame.size.width - 50, height: 53)
    }
    
    //MARK: PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextReservationKurt" {
            
            let updateViewController:NewReservationKurtsViewController = segue.destination as! NewReservationKurtsViewController
                updateViewController.myReservationCurts = self.reservationTennis
            if let sendPlace  = self.idPlaces, self.idPlaces != nil {
                updateViewController.idActivity = sendPlace //self.idPlaces
            }
            if let mySelectDate = self.selectDate, self.selectDate != nil{
                updateViewController.self.selectDate = mySelectDate
            }
            
        }
    }
    
    
    // MARK: CONVERT Date formated:
    func convertDateFormaterTable(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
}
//MARK: END TABLE VIEW


//MARK: CONNECT
extension NewReservationViewController {
    
    // MARK: CONNECT ACTIVITIES - alternative
    func requestActivities(url:URL,key:String){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let activitiesValue = response.result.value as? [String:Any]{
                    if let activities = activitiesValue["activities"] as? [[String:Any]]{
                        //if let valueError = products.removeValue(forKey: "error"), valueError as! String == "false" {
                        for activitie in activities{
                            if activitie["id"]! as! Int == 2 || activitie["id"]! as! Int == 4 || activitie["id"]! as! Int == 12 || activitie["id"]! as! Int == 46 || activitie["id"]! as! Int == 8 || activitie["id"]! as! Int == 1 || activitie["id"]! as! Int == 40 {
                                if let parsenew = Activities(json: activitie as [String : Any]){
                                    self.myActivities.append(parsenew)
                                }
                            }
                        }
                        self.pickerView.reloadAllComponents()
                    }
                }
        }
    }
    
    // MARK: CONNECT ACTIVITIES - classic
    func requestMyReservation(url:URL,key:String,value:String,sendParam:NSMutableDictionary){
        
        //connect class
        requestDataManager.most(myParams(dateString: sendParam), url:url) { responseObject, error in
            if let backResponse = responseObject,responseObject != nil  {
                if let backResponseType:Int = backResponse["type"] as? Int {
                
                // kody pro zvlast stránky
                if let singleReservation = backResponse[key] as? [[String:Any]],singleReservation.count != 0 ,backResponse[key] != nil, (responseObject?.count)! > 0,value == "reservationExercises",backResponseType == 2{

                    self.reservationExercises.removeAll()
                    
                    for reservation in singleReservation{
                            if let parsenew = ReservationExercises(json: reservation as [String : Any]){
                                self.reservationExercises.append(parsenew)
                            }
                    }
                    
                    //zaslani nastavení skrytí
                    self.controlDesign(type:self.type!,labelLection:"LEKCE", NewReservationExercisesTableView:false,myAcceptReservation:true,myScrollView:true,myAcceptReservationFirst:true)
                    
                    self.NewReservationExercisesTableView.reloadData()
                    
                    self.acceptReservation.setTitle("REZERVOVAT", for: .normal)
                    
                }else if let singleReservationTennis = backResponse[key], value == "reservationTennis" , backResponseType == 1 {
                    
                    self.acceptReservation.setTitle("DALŠÍ", for: .normal)
                    
                    self.reservationExercises.removeAll()
                    self.reservationTennis.removeAll()
                    
                    for reservationTennis in singleReservationTennis as! [[String : Any]]{
                        if let parsenew = ReservationTennis(json: reservationTennis ){
                            self.reservationTennis.append(parsenew)
                        }
                    }

                    self.controlDesign(type:self.type!,labelLection:"ČAS", NewReservationExercisesTableView:true,myAcceptReservation:false,myScrollView:true,myAcceptReservationFirst:true) // myAcceptReservation:true

                }else if(value == "massagge" && backResponseType == 3){
                    self.controlDesign(type:self.type!,labelLection:"TERMÍN", NewReservationExercisesTableView:true,myAcceptReservation:true,myScrollView:false,myAcceptReservationFirst:true)
                }else{
                    self.reservationExercises.removeAll()

                    self.NewReservationExercisesTableView.reloadData()
                    self.controlDesign(type:self.type!,labelLection:"BEZ TERMÍNŮ", NewReservationExercisesTableView:true,myAcceptReservation:true,myScrollView:true,myAcceptReservationFirst:true)
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(450))
                }
                    self.activityIndicator.stopAnimating()
                }else{
                    if let requestReservation = backResponse["error"], backResponse["error"] != nil {
                        
                       //  print("backResponse: \(backResponse)")
                        
                        if let requestReservationCode = backResponse["error_code"], backResponse["error"] != nil {
                            
                            if requestReservation as! Bool == true &&  requestReservationCode as! Int == -2 {
                                self.queryLoginAlert(title:"Nedostatek kreditu",message:"navýšte kredit")
                            }else if requestReservation as! Bool == true {
                                self.queryLoginAlert(title:"Chyba spojení",message:"Opakujte zadání data")
                                self.sendQuery()
                            }else if requestReservation as! Int == 0 {
                                self.queryLoginAlert(title:"Rezervováno",message:"")
                            }else{
                                self.queryLoginAlert(title:"Nerezervováno",message:"Zkuste to prosím později.")
                            }
                        }else{
                            if requestReservation as! Bool == true {
                                self.queryLoginAlert(title:"Chyba spojení",message:"Opakujte zadání data")
                                self.sendQuery()
                            }else if requestReservation as! Int == 0 {
                                self.queryLoginAlert(title:"Rezervováno",message:"")
                            }else{
                                self.queryLoginAlert(title:"Nerezervováno",message:"Zkuste to prosím později.")
                            }
                        }
                        self.activityIndicator.stopAnimating()
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



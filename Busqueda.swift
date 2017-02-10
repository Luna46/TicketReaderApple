//
//  OurViewController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//



import UIKit
import Firebase


class Busqueda: UIViewController, ASCalendarDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var button: UIButton!
    
    //var refresh = Busqueda()
    var count = 0
    var calDe = false
    var calA = false
    var store : String = ""
    var city : String = ""
    var idType : Int = 0
    var idStore : Int = 0

    @IBAction func barButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vueltaTickets", sender: self)
        
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func goToTableCom(_ sender: Any) {
        
        self.performSegue(withIdentifier: "viewSelection", sender: self)
        
    }
    
    
    @IBAction func goToTableCity(_ sender: Any) {
        self.performSegue(withIdentifier: "city", sender: self)
    }
    
    
    @IBAction func goToTableType(_ sender: Any) {
        self.performSegue(withIdentifier: "type", sender: self)
    }
    
    

    //@IBOutlet weak var quitSearch: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    //City
    @IBOutlet weak var TextFieldGroup: UITextField!
    
    @IBOutlet weak var TextFieldCom: UITextField!
    
    @IBOutlet weak var TextFieldType: UITextField!
    
    
    /**@IBAction func goToViewSelection(_ sender: Any) {
        
        self.performSegue(withIdentifier: "viewSelection", sender: self)
        TextFieldCom.endEditing(true)
    }*/
    
    
    /**@IBOutlet weak var dropDown: UIPickerView!
    var list = ["Rossi","Lorenzo","Pedrosa"]
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.TextFieldCom.text = self.list[row]
        self.dropDown.isHidden = true
        
    }*/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.TextFieldCom {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "viewSelection", sender: self)
            textField.endEditing(true)
        }
        
        else if textField == self.TextFieldGroup {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "city", sender: self)
            textField.endEditing(true)
        }
        
        else if textField == self.TextFieldType {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "type", sender: self)
            textField.endEditing(true)
        }
        
    }
    
    
    @IBOutlet weak var dateTextFieldA: UITextField!
    @IBOutlet weak var dateTextFieldD: UITextField!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    //@IBOutlet weak var backToTickets: UIButton!
    
    
    @IBAction func calendarD(_ sender: Any) {
        
        let calendarD = ASCalendar()
        calendarD.delegate = self
        calendarD.showCalendarAsLayer()
        calDe = true
        
        
    }
    
    @IBAction func calendar(_ sender: Any) {
        
        let calendar = ASCalendar()
        calendar.delegate = self
        calendar.showCalendarAsLayer()
        calA = true
        
        
    }
    
    func calendarSelect(_ day: Int, week: Int, month: Int, year: Int) {
        NSLog("%d-%d-%d (%d)", day, month, year, week)
        
        if calDe{
            dateTextFieldD.text = "\(day)-\(month)-\(year)"
            calDe = false
        }
        else {
        
            dateTextFieldA.text = "\(day)-\(month)-\(year)"
            calA = false
        }
        
        
    }
    
    /**@IBAction func backToTickets(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vueltaTickets", sender: self)
        
    }*/
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        let back = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = back
        navigationItem.title = "Búsqueda"
    }
    
    //Buscamos los Tickets en el servidor y lo conectamos con el "ListView".
    @IBAction func ticketsSearch(_ sender: Any) {
        
        var ciudad = TicketConstant.ciudad.getPoblacion()
        var comercio = TicketConstant.comercio.getComercio()
        var tipo = TicketConstant.tipo.getActividad()
        var fechaDe = self.dateTextFieldD.text
        var fechaA = self.dateTextFieldA.text
        
        var isEqualG = (ciudad == "")
        var isEqualT = (tipo == "")
        var isEqualC = (comercio == "")
        var isEqualD = (fechaDe == "")
        var isEqualA = (fechaA == "")
        
        if (isEqualG){
            ciudad = "%20"
        }
        
        
        
        if (isEqualT){
            tipo = "0"
        }
        
        if (isEqualD){
            fechaDe = "%20"
        }
        
        if (isEqualA){
            fechaA = "%20"
        }
        
        if (!isEqualC){
            let prueba = TicketWebServer()
            let newComercio = comercio.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            TicketConstant.ticketList = prueba.buscarBuena(userName: TicketConstant.Email, idActividad: TicketConstant.tipo.getId(), idComercio: TicketConstant.comercio.getId(), poblacion: ciudad, strDateFrom: fechaDe!, strDateTo: fechaA!, bIncludeAllTicket: false, fav: 0)
        }
        
        if (isEqualC){
            comercio = "0"
            let prueba = TicketWebServer()
            //var t = Ticket()
            
            TicketConstant.ticketList = prueba.buscarBuena(userName: TicketConstant.Email, idActividad: Int(tipo)!, idComercio: Int(comercio)!, poblacion: ciudad, strDateFrom: fechaDe!, strDateTo: fechaA!, bIncludeAllTicket: false, fav: 0)
        }
        
        
        
        //self.navigationController?.pushViewController(TicketList(), animated: false)
        var comp = TicketConstant.ticketList
        self.performSegue(withIdentifier: "siguiente", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        count += 1
        if count > 1{
            //
            //self.viewWillAppear(true)
            //self.tableCom.tintColor = UIColor.gray
            self.TextFieldGroup.text = ""
            self.TextFieldCom.text = ""
            self.TextFieldType.text = ""
            self.dateTextFieldD.text = ""
            self.dateTextFieldA.text = ""
            TicketConstant.comercio.getComercio()
            TicketConstant.ciudad.getPoblacion()
            TicketConstant.tipo.getActividad()
            self.viewDidLoad()
        }
    }
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        if count == 0 {
            if TicketConstant.comercio.getComercio() != ""{
                //TextFieldGroup.text = city
                TextFieldCom.text = TicketConstant.comercio.getComercio()          }
            if TicketConstant.ciudad.getPoblacion() != "" {
                //TextFieldCom.text = store
                TextFieldGroup.text = TicketConstant.ciudad.getPoblacion()            }
            if TicketConstant.tipo.getActividad() != "" {
                //TextFieldCom.text = store
                TextFieldType.text = TicketConstant.tipo.getActividad()}
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadView(_:)), name: .reload, object: nil)
                //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self.navigationController?.popToViewController(revealViewController(), animated: true), action: "someAction:")
        
        //self.navigationController?.popToRootViewController(animated: true)
        
        //navigationItem.popViewController(animated: true)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        
        
        //Personalización de botones.
        //tableCom.tintColor = UIColor.gray
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        //quitSearch.layer.cornerRadius = 10
        //quitSearch.clipsToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    func reloadView(_ notification: Notification) {
        //refresh.reloadView(notification)
        //tableView.reloadData()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

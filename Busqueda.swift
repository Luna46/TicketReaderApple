//
//  OurViewController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//



import UIKit
import Firebase


class Busqueda: UIViewController, ASCalendarDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    var count = 0
    var calDe = false
    var calA = false

    @IBAction func barButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vueltaTickets", sender: self)
        
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var quitSearch: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var TextFieldGroup: UITextField!
    @IBOutlet weak var TextFieldCom: UITextField!
    @IBOutlet weak var dateTextFieldA: UITextField!
    @IBOutlet weak var dateTextFieldD: UITextField!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var backToTickets: UIButton!
    
    
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
    
    @IBAction func backToTickets(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vueltaTickets", sender: self)
        
    }
    
    //Buscamos los Tickets en el servidor y lo conectamos con el "ListView".
    @IBAction func ticketsSearch(_ sender: Any) {
        
        var grupo = self.TextFieldGroup.text
        var comercio = self.TextFieldCom.text
        var fechaDe = self.dateTextFieldD.text
        var fechaA = self.dateTextFieldA.text
        
        var isEqualG = (grupo == "")
        var isEqualC = (comercio == "")
        var isEqualD = (fechaDe == "")
        var isEqualA = (fechaA == "")
        
        if (isEqualG){
            grupo = "%20"
        }
        
        if (isEqualC){
            comercio = "%20"
        }
        
        if (isEqualD){
            fechaDe = "%20"
        }
        
        if (isEqualA){
            fechaA = "%20"
        }
        
        let prueba = TicketWebServer()
        var t = Ticket()
        
        TicketConstant.ticketList = prueba.ticketsSearch(userName: TicketConstant.Email, grupo: grupo!, comercio: comercio!, strDateFrom: fechaDe!, strDateTo: fechaA!, bIncludeAllTicket: true)
        
        self.performSegue(withIdentifier: "siguiente", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self.navigationController?.popToViewController(revealViewController(), animated: true), action: "someAction:")
        
        //self.navigationController?.popToRootViewController(animated: true)
        
        //navigationItem.popViewController(animated: true)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        
        
        //Personalización de botones.
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        quitSearch.layer.cornerRadius = 10
        quitSearch.clipsToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

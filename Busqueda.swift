//
//  OurViewController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//



import UIKit
import Firebase


class Busqueda: UIViewController, UITextFieldDelegate  {
    
    //NO SE DE DONDE SALE
    /**
    @IBOutlet weak var button: UIButton!*/
    
    var fechaDesde : Bool = false
    var fechaHasta : Bool = false
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        
        /**let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        if (fechaHasta){
            //fechaDesde = false
            //fechaHasta = false
            if (etFechaHasta.text == "") {
                etFechaHasta.text = formater.string(from: datePicker.date)
            }
            if (etFechaDesde.text == etFechaHasta.text){
                etFechaHasta.text = ""
            }
            if (etFechaHasta.text != etFechaDesde.text){
                etFechaHasta.text = formater.string(from: datePicker.date)
            }
            //datePicker.isHidden = true
        }
        if (fechaDesde){
            //fechaHasta = false
            //fechaDesde = false
            if (etFechaDesde.text == "") {
                etFechaDesde.text = formater.string(from: datePicker.date)
            }
            if (etFechaDesde.text == etFechaHasta.text){
                etFechaDesde.text = ""
            }
            if (etFechaHasta.text != etFechaDesde.text){
                etFechaDesde.text = formater.string(from: datePicker.date)
            }
            //datePicker.isHidden = true
        }*/
        
    }
    @IBAction func putFecha(_ sender: Any) {
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        
        if (fechaHasta){
            fechaHasta = false
            etFechaHasta.text = formater.string(from: datePicker.date)
            TicketConstant.fechaHasta = etFechaHasta.text!
        }
        
        if (fechaDesde){
            fechaDesde = false
            etFechaDesde.text = formater.string(from: datePicker.date)
            TicketConstant.fechaDesde = etFechaDesde.text!
        }
        
        if (etFechaHasta.text != "" || etFechaDesde.text != ""){
            datePicker.isHidden = true
            viewDatePicker.isHidden = true
        }
        
    }
    
    @IBOutlet weak var okDatePicker: UIButton!
    @IBAction func quitDatePicker(_ sender: Any) {
        
        if (fechaHasta){
            etFechaHasta.text = ""
            fechaHasta = false
            datePicker.isHidden = true
            viewDatePicker.isHidden = true
        }
        if (fechaDesde){
            etFechaDesde.text = ""
            fechaDesde = false
            datePicker.isHidden = true
            viewDatePicker.isHidden = true
        }
        
    }
    
    @IBOutlet weak var viewDatePicker: UIView!
    
    @IBOutlet weak var etCiudad: UITextField!
    
    @IBOutlet weak var etComercio: UITextField!
    
    @IBOutlet weak var etTipo: UITextField!
    
    @IBOutlet weak var etFechaDesde: UITextField!
    
    @IBOutlet weak var etFechaHasta: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func ticketsSearch(_ sender: Any) {
        
        var ciudad = TicketConstant.ciudad.getPoblacion()
        var comercio = TicketConstant.comercio.getComercio()
        var tipo = TicketConstant.tipo.getActividad()
        var fechaDe = self.etFechaDesde.text
        var fechaA = self.etFechaHasta.text
        
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
            
            TicketConstant.ticketList = prueba.buscarBuena(userName: TicketConstant.Email, idActividad: TicketConstant.tipo.getId(), idComercio: TicketConstant.comercio.getId(), poblacion: ciudad, strDateFrom: fechaDe!, strDateTo: fechaA!, bIncludeAllTicket: false, fav: 0)
        }
        
        
        
        //self.navigationController?.pushViewController(TicketList(), animated: false)
        var comp = TicketConstant.ticketList
        self.performSegue(withIdentifier: "siguiente", sender: self)

        
    }
    
    
    
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
    
    
    //ANTERIOR
    /**
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
    
    @IBOutlet weak var TextFieldType: UITextField!*/
    
    
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
    
    //OJO CUIDADO
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.etComercio {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "viewSelection", sender: self)
            textField.endEditing(true)
        }
        
        else if textField == self.etCiudad {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "city", sender: self)
            textField.endEditing(true)
        }
        
        else if textField == self.etTipo {
            //self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            self.performSegue(withIdentifier: "type", sender: self)
            textField.endEditing(true)
        }
        
        else if textField == self.etFechaDesde{
            
            view.endEditing(true)
            fechaDesde = true
            datePicker.isHidden = false
            viewDatePicker.isHidden = false
            pickerValueChanged(self)
            
        }
        
        else {
            
            view.endEditing(true)
            fechaHasta = true
            datePicker.isHidden = false
            viewDatePicker.isHidden = false
            pickerValueChanged(self)
        }
    }
    
    //ANTERIOR
    /**
    @IBOutlet weak var dateTextFieldA: UITextField!
    @IBOutlet weak var dateTextFieldD: UITextField!*/
    @IBOutlet var menuButton: UIBarButtonItem!
    
    //@IBOutlet weak var backToTickets: UIButton!
    
    //ANTERIOR
    /**
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
        
        
    }*/
    
    
    //OJO CUIDADO
    /**
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
        
        
    }*/
    
    /**@IBAction func backToTickets(_ sender: Any) {
        
        self.performSegue(withIdentifier: "vueltaTickets", sender: self)
        
    }*/
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        let back = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = back
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Búsqueda"
    }
    
    //Buscamos los Tickets en el servidor y lo conectamos con el "ListView".
    //ANTERIOR
    /**
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
            
            TicketConstant.ticketList = prueba.buscarBuena(userName: TicketConstant.Email, idActividad: TicketConstant.tipo.getId(), idComercio: TicketConstant.comercio.getId(), poblacion: ciudad, strDateFrom: fechaDe!, strDateTo: fechaA!, bIncludeAllTicket: false, fav: 0)
        }
        
        
        
        //self.navigationController?.pushViewController(TicketList(), animated: false)
        var comp = TicketConstant.ticketList
        self.performSegue(withIdentifier: "siguiente", sender: self)
        
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        
        datePicker.reloadInputViews()
        
        count += 1
        if count > 1{
            //
            //self.viewWillAppear(true)
            //self.tableCom.tintColor = UIColor.gray
            
            //OJO CIUDADO
            
            self.etCiudad.text = ""
            self.etComercio.text = ""
            self.etTipo.text = ""
            self.etFechaHasta.text = ""
            self.etFechaDesde.text = ""
            //TicketConstant.comercio.getComercio()
            //TicketConstant.ciudad.getPoblacion()
            //TicketConstant.tipo.getActividad()
            self.viewDidLoad()
        }
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x, y:y, width: width, height: height)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        datePicker.reloadInputViews()
        
        datePicker.isHidden = true
        viewDatePicker.isHidden = true
        
        etCiudad.delegate = self
        self.etComercio.delegate = self
        self.etTipo.delegate = self
        self.etFechaHasta.delegate = self
        self.etFechaDesde.delegate = self
        
        var paddingView = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageView = UIImageView()
        var leftImage = UIImage(named: "flecha_edit_text.png")
        leftImageView.image = leftImage
        leftImageView.frame = CGRect(x: 258, y: 13, width: 10, height: 20)
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRectMake(10,10,30,30)
        etCiudad.addSubview(leftImageView)
        etCiudad.leftViewMode = UITextFieldViewMode.always
        etCiudad.rightViewMode = UITextFieldViewMode.always
        etCiudad.leftView = paddingView
        etCiudad.rightView = leftView
        etCiudad.attributedPlaceholder = NSAttributedString(string: "Ciudad", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        etCiudad.textColor = UIColor(hex: 0x279989)
        etCiudad.layer.cornerRadius = 8.0
        etCiudad.backgroundColor = UIColor.clear
        etCiudad.layer.borderWidth = 1
        etCiudad.layer.borderColor = UIColor(hex: 0x279989).cgColor
        //etCiudad.isUserInteractionEnabled = false
        
        var paddingViewComerce = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewComerce = UIImageView()
        var leftImageComerce = UIImage(named: "flecha_edit_text.png")
        leftImageViewComerce.image = leftImageComerce
        leftImageViewComerce.frame = CGRect(x: 258, y: 13, width: 10, height: 20)
        let leftViewComerce = UIView()
        leftViewComerce.addSubview(leftImageViewComerce)
        leftViewComerce.frame = CGRectMake(10,10,30,30)
        etComercio.addSubview(leftImageViewComerce)
        etComercio.leftViewMode = UITextFieldViewMode.always
        etComercio.rightViewMode = UITextFieldViewMode.always
        etComercio.leftView = paddingViewComerce
        etComercio.rightView = leftViewComerce
        etComercio.attributedPlaceholder = NSAttributedString(string: "Comercio", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        etComercio.textColor = UIColor(hex: 0x279989)
        etComercio.layer.cornerRadius = 8.0
        etComercio.backgroundColor = UIColor.clear
        etComercio.layer.borderWidth = 1
        etComercio.layer.borderColor = UIColor(hex: 0x279989).cgColor
        //etComercio.isUserInteractionEnabled = false
        
        var paddingViewType = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewType = UIImageView()
        var leftImageType = UIImage(named: "flecha_edit_text.png")
        leftImageViewType.image = leftImageType
        leftImageViewType.frame = CGRect(x: 258, y: 13, width: 10, height: 20)
        let leftViewType = UIView()
        leftViewType.addSubview(leftImageViewType)
        leftViewType.frame = CGRectMake(10,10,30,30)
        etTipo.addSubview(leftImageViewType)
        etTipo.leftViewMode = UITextFieldViewMode.always
        etTipo.rightViewMode = UITextFieldViewMode.always
        etTipo.leftView = paddingViewType
        etTipo.rightView = leftViewType
        etTipo.attributedPlaceholder = NSAttributedString(string: "Tipo", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        etTipo.textColor = UIColor(hex: 0x279989)
        etTipo.layer.cornerRadius = 8.0
        etTipo.backgroundColor = UIColor.clear
        etTipo.layer.borderWidth = 1
        etTipo.layer.borderColor = UIColor(hex: 0x279989).cgColor
        //etTipo.isUserInteractionEnabled = false
        
        var paddingViewFD = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewFD = UIImageView()
        var leftImageFD = UIImage(named: "calendar_search_ticket.png")
        leftImageViewFD.image = leftImageFD
        leftImageViewFD.frame = CGRect(x: 253, y: 13, width: 20, height: 20)
        let leftViewFD = UIView()
        leftViewFD.addSubview(leftImageViewFD)
        leftViewFD.frame = CGRectMake(10,10,30,30)
        etFechaDesde.addSubview(leftImageViewFD)
        etFechaDesde.leftViewMode = UITextFieldViewMode.always
        etFechaDesde.rightViewMode = UITextFieldViewMode.always
        etFechaDesde.leftView = paddingViewFD
        etFechaDesde.rightView = leftViewFD
        etFechaDesde.attributedPlaceholder = NSAttributedString(string: "Desde...", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        etFechaDesde.textColor = UIColor(hex: 0x279989)
        etFechaDesde.layer.cornerRadius = 8.0
        etFechaDesde.backgroundColor = UIColor.clear
        etFechaDesde.layer.borderWidth = 1
        etFechaDesde.layer.borderColor = UIColor(hex: 0x279989).cgColor
        //etFechaDesde.isUserInteractionEnabled = false
        
        var paddingViewFH = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewFH = UIImageView()
        var leftImageFH = UIImage(named: "calendar_search_ticket.png")
        leftImageViewFH.image = leftImageFH
        leftImageViewFH.frame = CGRect(x: 253, y: 13, width: 20, height: 20)
        let leftViewFH = UIView()
        leftViewFH.addSubview(leftImageViewFH)
        leftViewFH.frame = CGRectMake(10,10,30,30)
        etFechaHasta.addSubview(leftImageViewFH)
        etFechaHasta.leftViewMode = UITextFieldViewMode.always
        etFechaHasta.rightViewMode = UITextFieldViewMode.always
        etFechaHasta.leftView = paddingViewFH
        etFechaHasta.rightView = leftViewFH
        etFechaHasta.attributedPlaceholder = NSAttributedString(string: "Hasta...", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        etFechaHasta.textColor = UIColor(hex: 0x279989)
        etFechaHasta.layer.cornerRadius = 8.0
        etFechaHasta.backgroundColor = UIColor.clear
        etFechaHasta.layer.borderWidth = 1
        etFechaHasta.layer.borderColor = UIColor(hex: 0x279989).cgColor
        //etFechaHasta.isUserInteractionEnabled = false
        
        //ANTERIOR
        
        if count == 0 {
            if TicketConstant.comercio.getComercio() != ""{
                //TextFieldGroup.text = city
                etComercio.text = TicketConstant.comercio.getComercio()          }
            if TicketConstant.ciudad.getPoblacion() != "" {
                //TextFieldCom.text = store
                etCiudad.text = TicketConstant.ciudad.getPoblacion()            }
            if TicketConstant.tipo.getActividad() != "" {
                //TextFieldCom.text = store
                etTipo.text = TicketConstant.tipo.getActividad()
            }
            if TicketConstant.fechaDesde != "" {
                //TextFieldCom.text = store
                etFechaDesde.text = TicketConstant.fechaDesde
            }
            if TicketConstant.fechaHasta != "" {
                //TextFieldCom.text = store
                etFechaHasta.text = TicketConstant.fechaHasta
            }
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadView(_:)), name: .reload, object: nil)
                //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self.navigationController?.popToViewController(revealViewController(), animated: true), action: "someAction:")
        
        //self.navigationController?.popToRootViewController(animated: true)
        
        //navigationItem.popViewController(animated: true)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        
        
        //Personalización de botones.
        //tableCom.tintColor = UIColor.gray
        
        /**TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")*/
        
        
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        okDatePicker.layer.cornerRadius = 10
        okDatePicker.clipsToBounds = true
        
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

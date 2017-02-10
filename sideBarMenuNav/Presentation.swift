//
//  Presentation.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

public class Presentation: UIViewController {
    
    var checked = false
    
    @IBOutlet weak var pregistryButton: UIButton!
    @IBOutlet weak var ploginButton: UIButton!
    
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBOutlet weak var UIDText: UITextField!
    @IBOutlet weak var passWordtext: UITextField!
    @IBOutlet weak var emailText: UITextField!
    //Conexión de un boton con la interfaz gráfica del registro.
    
    @IBAction func check(_ sender: Any) {
        
        if !checked {
            var image : UIImage = UIImage(named: "selected")!
            checkboxButton.setImage(image, for: UIControlState())
            checked = true
            
            UIDText.isHidden = false
            cameraButton.isHidden = false
        }
            
        else if checked {
            var image2 : UIImage = UIImage(named: "checkboxD")!
            checkboxButton.setImage(image2, for: UIControlState())
            checked = false
            
            UIDText.isHidden = true
            cameraButton.isHidden = true
        }
        
    }
    
    
    @IBAction func buttonRegistry(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toRegistry", sender: self)
        
    }
    
    @IBAction func camera(_ sender: Any) {
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewControllerLogin") as! CameraViewControllerLogin
        
        datos.loginP = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
    }
    //Conexión de un botón con la interfaz gráfica del login.
    @IBAction func buttonLogin(_ sender: Any) {
        
        let email = self.emailText.text!
        let password = self.passWordtext.text!
        let UID = self.UIDText.text!
        
        let servidor = TicketWebServer()
        
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        servidor.loginUser(Email: email, Password: password, UID: UID, tocken: refreshedToken!) { message, error in
            
            let preferences = UserDefaults.standard
            
            var userRejected = (message == "No se ha encontrado el e-mail del usuario esoecificado")
            var UIDRejected = (message == "El dispositivo con el UID especificado no puede registrarse, porque ya está registrado a nombre de otro usuario")
            
            if userRejected {
                
                DispatchQueue.main.async {
                    
                    let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                    let toastLabel = UILabel(frame: rect)
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Email o contraseña incorrectos"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10;
                    toastLabel.clipsToBounds  =  true
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                    
                }
                
            }
                
            else if UIDRejected {
                
                DispatchQueue.main.async {
                    
                    let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                    let toastLabel = UILabel(frame: rect)
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "UID inválido"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10;
                    toastLabel.clipsToBounds  =  true
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                    
                }
                
            }
                
            else {
                
                print("APARCAO")
                TicketConstant.Email = email
                TicketConstant.Password = password
                TicketConstant.UID = UID
                preferences.set(TicketConstant.Email, forKey: "Email")
                //preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                preferences.set(TicketConstant.Password, forKey: "PassWord")
                preferences.set(TicketConstant.UID, forKey: "UID")
                preferences.synchronize()
                DispatchQueue.main.async {
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    let result = formatter.string(from: date as Date)
                    
                    let dateFrom = Calendar.current.date(byAdding: .day, value: -10, to: date)
                    let resultResta = formatter.string(from: dateFrom!)
                    /**TicketConstant.tag.append(TicketConstant.UID)
                    let prueba = TicketWebServer()
                    var t = Ticket()
                    
                    let date = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    let result = formatter.string(from: date as Date)
                    let myNSString = result as NSString
                    var day = Int(result.substring(to: result.characters.index(of: "-")!))
                    let startM = result.index(result.startIndex, offsetBy: 3)
                    let endM = result.index(result.endIndex, offsetBy: -5)
                    let rangeM = startM..<endM
                    var month = Int(result.substring(with: rangeM))!
                    month = month - 1
                    let start = result.index(result.startIndex, offsetBy: 6)
                    let end = result.index(result.endIndex, offsetBy: 0)
                    let range = start..<end
                    var year = Int(result.substring(with: range))!
                    var resta10 = day! - TicketConstant.diasAtras
                    if (resta10<=0){
                        resta10 = 30 - resta10
                        month = month - 1
                        if(month == 0){
                            month = 12
                            year = year - 1
                        }
                    }
                    var dayT = String(resta10)
                    var monthT = String(month)
                    var yearT = String(year)
                    let resultResta = "\(dayT)-\(monthT)-\(yearT)"
                    //var month = result.
                    //var name = "Stephen"
                    //var prueba = result.substring(with: NSRange(location: 0, length: 3))
                    //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"*/
                    let prueba = TicketWebServer()
                    TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: true, fav: 0)
                    
                    var comp = TicketConstant.ticketList
                    self.performSegue(withIdentifier: "Tab", sender: self)
                }
                
            }}
        
        //self.performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let preferences = UserDefaults.standard
        TicketConstant.UID = preferences.string(forKey: "UID")
        if (TicketConstant.UID == nil){
            
            TicketConstant.UID = ""
            
        }
        TicketConstant.Usuario = preferences.string(forKey: "Usuario")
        if (TicketConstant.Usuario == nil){
            
            TicketConstant.Usuario = ""
            
        }
        TicketConstant.Email = preferences.string(forKey: "Email")
        if (TicketConstant.Email == nil){
            
            TicketConstant.Email = ""
            
        }
        TicketConstant.Password = preferences.string(forKey: "PassWord")
        if (TicketConstant.Password == nil){
            
            TicketConstant.Password = ""
            
        }
        
        var queEs = TicketConstant.UID
        //TicketConstant.UID = preferences.object(forKey: "UID") as! String
        //TicketConstant.Email = preferences.object(forKey: "Email") as! String
        //TicketConstant.Usuario = preferences.object(forKey: "Usuario") as! String
        //TicketConstant.Password = preferences.object(forKey: "PassWord") as! String
        //let camino = preferences.object(forKey: "UID") as! String
        
        var isEqual = (TicketConstant.Email == "")
        
        //LEER SHARED PREFERENCES
        
        
        
        //Saber si es nuestra primera vez en la aplicación.
        if !isEqual {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let result = formatter.string(from: date as Date)
            
            let dateFrom = Calendar.current.date(byAdding: .day, value: -10, to: date)
            let resultResta = formatter.string(from: dateFrom!)
            //TicketConstant.tag.append(TicketConstant.UID)
            let prueba = TicketWebServer()
            /**var t = Ticket()
            
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let result = formatter.string(from: date as Date)
            let myNSString = result as NSString
            var day = Int(result.substring(to: result.characters.index(of: "-")!))
            let startM = result.index(result.startIndex, offsetBy: 3)
            let endM = result.index(result.endIndex, offsetBy: -5)
            let rangeM = startM..<endM
            var month = Int(result.substring(with: rangeM))!
            month = month - 1
            let start = result.index(result.startIndex, offsetBy: 6)
            let end = result.index(result.endIndex, offsetBy: 0)
            let range = start..<end
            var year = Int(result.substring(with: range))!
            var resta10 = day! - TicketConstant.diasAtras
            if (resta10<=0){
                resta10 = 30 - resta10
                month = month - 1
                if(month == 0){
                    month = 12
                    year = year - 1
                }
            }
            var dayT = String(resta10)
            var monthT = String(month)
            var yearT = String(year)
            let resultResta = "\(dayT)-\(monthT)-\(yearT)"
            //var month = result.
            //var name = "Stephen"
            //var prueba = result.substring(with: NSRange(location: 0, length: 3))
            //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"*/
            
            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: true, fav: 0)
            
            var comp = TicketConstant.ticketList
            //let camino = self.storyboard?.instantiateViewController(withIdentifier: "tags") as! TagsListViews
            self.performSegue(withIdentifier: "Tab", sender: self)
            //self.navigationController?.pushViewController(camino, animated: true)
        }
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        var comp = TicketConstant.diasAtras
        
        /**var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        localNotification.alertAction = "Nuevo ticket"
        localNotification.alertBody = "Ticket"
        //localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(localNotification)*/
        
        UIDText.isHidden = true
        cameraButton.isHidden = true
        
        //Personalización de botones.
        pregistryButton.layer.cornerRadius = 10
        pregistryButton.clipsToBounds = true
        ploginButton.layer.cornerRadius = 10
        ploginButton.clipsToBounds = true

        
        //PRUEBAS SHARED PREFERENCES
        /**let camino = (preferences.object(forKey: "UID") as! String)
        
        if camino == nil {
            preferences.set("01020304", forKey: "UID")
        }
        /**var camino: String = ""
        
        if preferences.object(forKey: camino) == nil {
            //var num = 7
            camino = "01020304"
            TicketConstant.UID = ...preferences.set(num, forKey: camino)
        }
        
        //Save to disk
        
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("ERROR GUARDANDO")
        }*/*/
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

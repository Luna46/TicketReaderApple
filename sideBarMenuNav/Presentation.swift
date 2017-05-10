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
    
    @IBOutlet weak var emailTextLogin: UITextField!
    
    @IBOutlet weak var passwordTextLogin: UITextField!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBAction func loginUser(_ sender: Any) {
        
        let email = self.emailTextLogin.text!
        let password = self.passwordTextLogin.text!
        let UID = self.tagTextLogin.text!
        
        let servidor = TicketWebServer()
        
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        servidor.loginUser(Email: email, Password: password, UID: UID, tocken: refreshedToken!) { message, error in
            
            let preferences = UserDefaults.standard
            
            var userRejected = (message == "No se ha encontrado el e-mail del usuario esoecificado")
            var UIDRejected = (message == "El dispositivo con el UID especificado no puede registrarse, porque ya está registrado a nombre de otro usuario")
            
            if message != "" {
                
                DispatchQueue.main.async {
                    
                    let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                    let toastLabel = UILabel(frame: rect)
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "\(message)"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10;
                    toastLabel.clipsToBounds  =  true
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                    
                }
                
            }
                
            /**else if UIDRejected {
                
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
                
            }*/
                
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
                    
                    let dateFrom = Calendar.current.date(byAdding: .day, value: TicketConstant.diasAtras, to: date)
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
                    TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: false, fav: 0)
                    
                    var comp = TicketConstant.ticketList
                    self.performSegue(withIdentifier: "Tab", sender: self)
                }
                
            }}

        
    }
    
    @IBAction func cameraTagLogin(_ sender: Any) {
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewControllerLogin") as! CameraViewControllerLogin
        
        datos.loginP = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
    }
    
    @IBOutlet weak var buttonCameraTag: UIButton!
    
    @IBOutlet weak var tagTextLogin: UITextField!
    
    @IBOutlet weak var buttonTag: UIButton!
    
    @IBAction func toRegistryArrow(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toRegistry", sender: self)
        
    }
    
    @IBOutlet weak var buttonGoToRegistryArrow: UIButton!
    
    @IBAction func toRegistry(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toRegistry", sender: self)
        
    }
    
    @IBOutlet weak var buttonGoToRegistry: UIButton!
    
    @IBAction func check(_ sender: Any) {
        
        if !checked {
            var image : UIImage = UIImage(named: "selected_trans.png")!
            buttonTag.setImage(image, for: UIControlState())
            checked = true
            
            //MOSTRAR
            
            tagTextLogin.isHidden = false
            buttonCameraTag.isHidden = false
        }
            
        else if checked {
            var image2 : UIImage = UIImage(named: "no_check_trans.png")!
            buttonTag.setImage(image2, for: UIControlState())
            checked = false
            
            //OCULTAR
            
            tagTextLogin.isHidden = true
            buttonCameraTag.isHidden = true
        }
        
    }
    
    
    /**ANTERIOR
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
                    
                    let dateFrom = Calendar.current.date(byAdding: .day, value: TicketConstant.diasAtras, to: date)
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
                    TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: false, fav: 0)
                    
                    var comp = TicketConstant.ticketList
                    self.performSegue(withIdentifier: "Tab", sender: self)
                }
                
            }}
        
        //self.performSegue(withIdentifier: "toLogin", sender: self)
        
    }*/
    
    override public func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        //tabBarController?.navigationController?.navigationItem.title = "Hola"
        //self.navigationItem.title = ""
        //self.navigationController?.navigationItem.title="Hola"
        //self.navigationController?.navigationBar.tintColor = UIColor(hex: 0xa1d884)
        //navigationController?.navigationController?.navigationItem.title = ""
        //navigationItem.title = ""
        //tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        /**navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = ""*/
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        
        
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
            
            let dateFrom = Calendar.current.date(byAdding: .day, value: TicketConstant.diasAtras, to: date)
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
            
            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: false, fav: 0)
            
            var comp = TicketConstant.ticketList
            //let camino = self.storyboard?.instantiateViewController(withIdentifier: "tags") as! TagsListViews
            self.performSegue(withIdentifier: "Tab", sender: self)
            //self.navigationController?.pushViewController(camino, animated: true)
        }
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x, y:y, width: width, height: height)
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        /**self.view.backgroundColor = UIColor(hex: 0xa1d884)
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(hex: 0xa1d884)
        let color2 = UIColor(hex: 0x5cb8b2)
        let color3 = UIColor(hex: 0x279989)
        gradientLayer.colors = [color1,color2,color3]
        gradientLayer.locations = [0.0,0.33,0.66]
        self.view.layer.addSublayer(gradientLayer)*/
        
        //DEGRADADO
        let color1 = UIColor(hex: 0xa1d884)
        let color3 = UIColor(hex: 0x279989)
        let gradientColors: [CGColor] = [color1.cgColor, color3.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
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

        //MODIFICACIÓN UITEXTFIELD USUARIO
        var paddingView = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageView = UIImageView()
        //var leftImage = UIImage(named: "email.png")
        //leftImageView.image = leftImage
        leftImageView.frame = CGRect(x: 205, y: 15, width: 20, height: 20)
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRectMake(10,10,30,30)
        emailTextLogin.addSubview(leftImageView)
        emailTextLogin.leftViewMode = UITextFieldViewMode.always
        emailTextLogin.rightViewMode = UITextFieldViewMode.always
        emailTextLogin.leftView = paddingView
        emailTextLogin.rightView = leftView
        emailTextLogin.attributedPlaceholder = NSAttributedString(string: "Usuario", attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTextLogin.textColor = UIColor.white
        emailTextLogin.layer.cornerRadius = 8.0
        emailTextLogin.backgroundColor = UIColor.clear
        emailTextLogin.layer.borderWidth = 1
        emailTextLogin.layer.borderColor = UIColor.white.cgColor
        
        //MODIFICACIÓN UITEXTFIELD CONTRASEÑA
        var paddingViewP = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewP = UIImageView()
        //var leftImageP = UIImage(named: "candado.png")
        //leftImageViewP.image = leftImageP
        leftImageViewP.frame = CGRect(x: 205, y: 15, width: 20, height: 20)
        let leftViewP = UIView()
        leftViewP.addSubview(leftImageViewP)
        leftViewP.frame = CGRectMake(10,10,30,30)
        passwordTextLogin.addSubview(leftImageViewP)
        passwordTextLogin.leftViewMode = UITextFieldViewMode.always
        passwordTextLogin.rightViewMode = UITextFieldViewMode.always
        passwordTextLogin.leftView = paddingViewP
        passwordTextLogin.rightView = leftViewP
        passwordTextLogin.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextLogin.textColor = UIColor.white
        passwordTextLogin.layer.cornerRadius = 8.0
        passwordTextLogin.backgroundColor = UIColor.clear
        passwordTextLogin.layer.borderWidth = 1
        passwordTextLogin.layer.borderColor = UIColor.white.cgColor
        
        //AÑADIR TAG
        buttonTag.frame = CGRectMake(75, 415, 170, 50)
        buttonTag.tintColor = UIColor(hex: 0xa1d884)
        buttonTag.setImage(UIImage(named: "no_check_trans.png"), for: UIControlState.normal)
        buttonTag.imageEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 90)
        buttonTag.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        buttonTag.setTitle("   Añadir tag", for: UIControlState.normal)
        buttonTag.layer.borderWidth = 1.0
        buttonTag.backgroundColor = UIColor(hex: 0x708090)
        buttonTag.layer.cornerRadius = 8
        buttonTag.clipsToBounds = true
        buttonTag.layer.borderColor = UIColor(hex: 0x708090).cgColor
        //añadir accion
        self.view.addSubview(buttonTag)
        //Personalización de botones
        buttonLogin.layer.cornerRadius = 8
        buttonLogin.clipsToBounds = true
        
        //MODIFICACIÓN UITEXTFIELD TAG
        var paddingViewT = UIView(frame:CGRectMake(0,0,15,15))
        var leftImageViewT = UIImageView()
        //var leftImageT = UIImage(named: "nfc.png")
        //leftImageViewT.image = leftImageT
        leftImageViewT.frame = CGRect(x: 170, y: 15, width: 20, height: 20)
        let leftViewT = UIView()
        leftViewT.addSubview(leftImageViewT)
        leftViewT.frame = CGRectMake(10,10,30,30)
        tagTextLogin.addSubview(leftImageViewT)
        tagTextLogin.leftViewMode = UITextFieldViewMode.always
        tagTextLogin.rightViewMode = UITextFieldViewMode.always
        tagTextLogin.leftView = paddingViewT
        tagTextLogin.rightView = leftViewT
        tagTextLogin.attributedPlaceholder = NSAttributedString(string: "Tag asociado", attributes: [NSForegroundColorAttributeName: UIColor.white])
        tagTextLogin.textColor = UIColor.white
        tagTextLogin.sizeThatFits(CGSize(width:20, height:20))
        tagTextLogin.layer.cornerRadius = 8.0
        tagTextLogin.backgroundColor = UIColor.clear
        tagTextLogin.layer.borderWidth = 1
        tagTextLogin.layer.borderColor = UIColor.white.cgColor
        tagTextLogin.isHidden = true
        
        //CAMARA
        buttonCameraTag.isHidden = true
        
        //DOS BOTONES ABAJO
        buttonGoToRegistry.backgroundColor = UIColor.clear
        buttonGoToRegistryArrow.backgroundColor = UIColor.clear
        
        /*ANTERIOR
        UIDText.isHidden = true
        cameraButton.isHidden = true
        
        //Personalización de botones.
        pregistryButton.layer.cornerRadius = 10
        pregistryButton.clipsToBounds = true
        ploginButton.layer.cornerRadius = 10
        ploginButton.clipsToBounds = true*/

        
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

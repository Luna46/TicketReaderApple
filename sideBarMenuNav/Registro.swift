//
//  Registro.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Firebase

//Interfaz necesaria para la implementación del lector de códigos QR
protocol ScannerViewControllerDelegate {
    
    func codeDetected(code: String)
    
}

public class Registro: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, UITextFieldDelegate {
    
    var checked = false
    
    @IBOutlet weak var etNombreReg: UITextField!
    
    @IBOutlet weak var etApellidoReg: UITextField!
    
    @IBOutlet weak var etEmailReg: UITextField!
    
    @IBOutlet weak var etEdadReg: UITextField!
    
    @IBOutlet weak var radioButtonMen: UIButton!
    
    @IBAction func radioButtonMenAction(_ sender: Any) {
        
        if !checkedH {
            
            var imageH : UIImage = UIImage(named: "rButtonSelected")!
            radioButtonMen.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "rButtonEmpty")!
            radioButtonWomen.setImage(imageM, for: UIControlState())
            checkedH = true
            checkedM = false
            
        }
            
        else if checkedH {
            
            var imageH2 : UIImage = UIImage(named: "rButtonEmpty")!
            radioButtonMen.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "rButtonSelected")!
            radioButtonWomen.setImage(imageM2, for: UIControlState())
            checkedH = false
            checkedM = true
            
        }
        
    }
    
    @IBOutlet weak var radioButtonWomen: UIButton!
    
    @IBAction func radioButtonWomenAction(_ sender: Any) {
        
        if !checkedM {
            
            var imageH : UIImage = UIImage(named: "rButtonSelected")!
            radioButtonWomen.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "rButtonEmpty")!
            radioButtonMen.setImage(imageM, for: UIControlState())
            checkedM = true
            checkedH = false

        }
            
        else if checkedM {
            
            var imageH2 : UIImage = UIImage(named: "rButtonEmpty")!
            radioButtonWomen.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "rButtonSelected")!
            radioButtonMen.setImage(imageM2, for: UIControlState())
            checkedM = false
            checkedH = true

        }
        
    }
    
    @IBOutlet weak var etPasswordReg: UITextField!
    
    @IBOutlet weak var etPasswordRepReg: UITextField!
    
    @IBOutlet weak var buttonAddTag: UIButton!
    
    @IBAction func buttonAddTagAction(_ sender: Any) {
        
        if !checked {
            var image : UIImage = UIImage(named: "selected_trans.png")!
            buttonAddTag.setImage(image, for: UIControlState())
            checked = true
            
            //MOSTRAR
            
            etTagReg.isHidden = false
            buttonCamera.isHidden = false
        }
            
        else if checked {
            var image2 : UIImage = UIImage(named: "no_check_trans.png")!
            buttonAddTag.setImage(image2, for: UIControlState())
            checked = false
            
            //OCULTAR
            
            etTagReg.isHidden = true
            buttonCamera.isHidden = true
        }
        
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        datos.registro = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
    }
    
    @IBOutlet weak var buttonCamera: UIButton!
    
    @IBOutlet weak var etTagReg: UITextField!
    
    @IBOutlet weak var buttonRegistry: UIButton!
    
    @IBAction func buttonRegistryAction(_ sender: Any) {
        
        var usuario = self.etNombreReg.text! + " " + self.etApellidoReg.text!
        
        //Rellenamos nuestras constantes estáticas con los valores introducidos por el usuario.
        TicketConstant.Password = self.etPasswordReg.text!
        TicketConstant.Usuario = usuario
        TicketConstant.Email = self.etEmailReg.text!
        
        //Obligamos al usuario rellenar todos los campos, sino no nos podremos registrar. Enviamos una alerta.
        if ((self.etPasswordReg.text?.isEmpty)! || (self.etPasswordRepReg.text?.isEmpty)! || (self.etNombreReg.text?.isEmpty)! || (self.etApellidoReg.text?.isEmpty)! || (self.etEmailReg.text?.isEmpty)!){
            
            displayMyAlertMessage(userMessage: "Todos los campos deben de estar rellenados")
            
        }
            
        else {
            
            let preferences = UserDefaults.standard
            
            //Dependiendo del botón del UID, el valor de este se rellenará de una manera u otra.
            if !checked {
                
                TicketConstant.UID = String(arc4random_uniform(1999999999) + 1)
                
                //Los "preferences" nos ayudan a guardar unos valores locales en la aplicación, para que cuando esta se cierre no se pierdan y podamos continuar donde estábamos sin volver al principio.
                preferences.set(TicketConstant.Email, forKey: "Email")
                preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                preferences.set(TicketConstant.Password, forKey: "PassWord")
                preferences.set(TicketConstant.UID, forKey: "UID")
                preferences.synchronize()
                
            }
                
            else {
                
                TicketConstant.UID = self.etTagReg.text!
                
                preferences.set(TicketConstant.Email, forKey: "Email")
                preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                preferences.set(TicketConstant.Password, forKey: "PassWord")
                preferences.set(TicketConstant.UID, forKey: "UID")
                preferences.synchronize()
                
            }
            
            //Comprobamos que el usuario no se haya equivocado al escribir la contraseña, por ello en la interfaz gráfica pedimos que la escriba dos veces, la funcionalidad es completar el registro de la manera más correcta posible.
            var isEqual = (self.etPasswordReg.text! == self.etPasswordRepReg.text!)
            
            if isEqual {
                
                let servidor = TicketWebServer()
                //"Tocken de Google" más abajo está la implementación de la función.
                let Tocken = FIRInstanceID.instanceID().token()
                //let refreshedToken =
                var sexo : Int = 0
                //var sexi : int = 0;
                if self.checkedM {
                    sexo = 1
                }
                
                //LLamada al servidor, la llamada se hace de esta manera debido a los "threads" para evitar colisiones.
                servidor.sendUIDtoServer(Usuario: TicketConstant.Usuario, PassWord: TicketConstant.Password, Email: TicketConstant.Email, UID: TicketConstant.UID!, token: Tocken!, edad: Int(etEdadReg.text!)! , sexo: sexo, logoOff: 0, roletype: 0) { message, error in
                    
                    var emailEqual = (message == "Email existente")
                    var UIDEqual = (message == "UID existente")
                    
                    //Caso de UID's iguales.
                    if UIDEqual {
                        
                        //Función asincrona para evitar colisiones, desplegamos un toast informativo.
                        DispatchQueue.main.async {
                            
                            let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                            let toastLabel = UILabel(frame: rect)
                            toastLabel.backgroundColor = UIColor.black
                            toastLabel.textColor = UIColor.white
                            toastLabel.textAlignment = NSTextAlignment.center;
                            self.view.addSubview(toastLabel)
                            toastLabel.text = "El UID insertado ya está en uso"
                            toastLabel.alpha = 1.0
                            toastLabel.layer.cornerRadius = 10;
                            toastLabel.clipsToBounds  =  true
                            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                            
                        }
                        
                        
                        
                    }
                        
                        //Caso de Emails iguales.
                    else if emailEqual {
                        
                        DispatchQueue.main.async {
                            
                            let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                            let toastLabel = UILabel(frame: rect)
                            toastLabel.backgroundColor = UIColor.black
                            toastLabel.textColor = UIColor.white
                            toastLabel.textAlignment = NSTextAlignment.center;
                            self.view.addSubview(toastLabel)
                            toastLabel.text = "El email insertado ya está en uso"
                            toastLabel.alpha = 1.0
                            toastLabel.layer.cornerRadius = 10;
                            toastLabel.clipsToBounds  =  true
                            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                            
                        }
                    }
                        
                        //Registro completado satisfactoriamente.
                    else{
                        
                        print("REGISTRAO")
                        //let camino = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                        DispatchQueue.main.async {
                            TicketConstant.tag.append(TicketConstant.UID)
                            let prueba = TicketWebServer()
                            var t = Ticket()
                            
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            let result = formatter.string(from: date as Date)
                            
                            let dateFrom = Calendar.current.date(byAdding: .day, value: TicketConstant.diasAtras, to: date)
                            let resultResta = formatter.string(from: dateFrom!)
                            
                            /**let date = NSDate()
                             let formatter = DateFormatter()
                             formatter.dateFormat = "dd-MM-yyyy"
                             let result = formatter.string(from: date as Date)
                             let myNSString = result as NSString
                             var day = Int(result.substring(to: result.characters.index(of: "-")!))
                             let startM = result.index(result.startIndex, offsetBy: 3)
                             let endM = result.index(result.endIndex, offsetBy: -5)
                             let rangeM = startM..<endM
                             var month = Int(result.substring(with: rangeM))!
                             let start = result.index(result.startIndex, offsetBy: 6)
                             let end = result.index(result.endIndex, offsetBy: 0)
                             let range = start..<end
                             var year = Int(result.substring(with: range))!
                             var resta10 = day! - 10
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
                             let resultResta = "\(dayT)-\(monthT)-\(yearT)"*/
                            //var month = result.
                            //var name = "Stephen"
                            //var prueba = result.substring(with: NSRange(location: 0, length: 3))
                            //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"
                            
                            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: true, fav: 0)
                            
                            var comp = TicketConstant.ticketList
                            
                            self.performSegue(withIdentifier: "Tab", sender: self)
                        }
                        //self.navigationController?.pushViewController(camino, animated: true)
                        
                    }
                    
                }
                
            }
                
                //Toast informativo, contraseñas no iguales.
            else {
                
                let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                let toastLabel = UILabel(frame: rect)
                toastLabel.backgroundColor = UIColor.black
                toastLabel.textColor = UIColor.white
                toastLabel.textAlignment = NSTextAlignment.center;
                self.view.addSubview(toastLabel)
                toastLabel.text = "Las contraseñas no coinciden"
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 10;
                toastLabel.clipsToBounds  =  true
                UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
            }
        }

        
    }
    
    @IBOutlet weak var radioButtonWomenAction: UIButton!
    
    
    
    
    var UIDFrom: String?
    
    var cont = 0
    /**ANTERIOR
    @IBAction func back(_ sender: Any) {
        
        var camino = (TicketConstant.Email == "")
        
        if camino {
            
            displayMyAlertMessage(userMessage: "No estás registrado")
            
        }
        
        else{
        
            self.performSegue(withIdentifier: "aLosTickets", sender: self)
        }
        
    }*/
    
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    //ANTERIOR
    //@IBOutlet weak var registerButton: UIButton!
    
    
    var delegate: ScannerViewControllerDelegate?
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var session: AVCaptureSession?
    var preview: AVCaptureVideoPreviewLayer?
    
    var codeDetected: Bool = false
    var code:String?
    var canBeDisplayed = true
    
    /**ANTERIOR
    @IBOutlet weak var Usuario: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PassWord: UITextField!
    @IBOutlet weak var PassWordR: UITextField!
    @IBOutlet weak var UID: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var radioButtonMen: UIButton!
    @IBOutlet weak var radioButtonWomen: UIButton!*/
    var checkedH = false
    var checkedM = false
    
    /**ANTERIOR
    @IBAction func checkH(_ sender: Any) {
        if !checkedH {
            var imageH : UIImage = UIImage(named: "radioButton selected")!
            radioButtonMen.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonWomen.setImage(imageM, for: UIControlState())
            checkedH = true
            checkedM = false
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedH {
            var imageH2 : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonMen.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "radioButton selected")!
            radioButtonWomen.setImage(imageM2, for: UIControlState())
            checkedH = false
            checkedM = true
            
            //UIDText.isHidden = true
            //cameraButton.isHidden = true
        }
    }
    
    @IBAction func checkM(_ sender: Any) {
        if !checkedM {
            var imageH : UIImage = UIImage(named: "radioButton selected")!
            radioButtonWomen.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonMen.setImage(imageM, for: UIControlState())
            checkedM = true
            checkedH = false
            
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedM {
            var imageH2 : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonWomen.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "radioButton selected")!
            radioButtonMen.setImage(imageM2, for: UIControlState())
            checkedM = false
            checkedH = true
            //UIDText.isHidden = true
            //cameraButton.isHidden = true
        }
    }
    
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBAction func guardarDatos(_ sender: Any) {
        
        //Rellenamos nuestras constantes estáticas con los valores introducidos por el usuario.
        TicketConstant.Password = self.PassWord.text!
        TicketConstant.Usuario = self.Usuario.text!
        TicketConstant.Email = self.Email.text!
        
        //Obligamos al usuario rellenar todos los campos, sino no nos podremos registrar. Enviamos una alerta.
        if ((self.PassWord.text?.isEmpty)! || (self.PassWordR.text?.isEmpty)! || (self.Usuario.text?.isEmpty)! || (self.Email.text?.isEmpty)!){
            
            displayMyAlertMessage(userMessage: "Todos los campos deben de estar rellenados")
            
        }
        
        else {
        
            let preferences = UserDefaults.standard
        
            //Dependiendo del botón del UID, el valor de este se rellenará de una manera u otra.
            if checked {
            
                TicketConstant.UID = String(arc4random_uniform(1999999999) + 1)
            
                //Los "preferences" nos ayudan a guardar unos valores locales en la aplicación, para que cuando esta se cierre no se pierdan y podamos continuar donde estábamos sin volver al principio.
                preferences.set(TicketConstant.Email, forKey: "Email")
                preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                preferences.set(TicketConstant.Password, forKey: "PassWord")
                preferences.set(TicketConstant.UID, forKey: "UID")
                preferences.synchronize()
            
            }
        
            else {
            
                TicketConstant.UID = self.UID.text!
            
                preferences.set(TicketConstant.Email, forKey: "Email")
                preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                preferences.set(TicketConstant.Password, forKey: "PassWord")
                preferences.set(TicketConstant.UID, forKey: "UID")
                preferences.synchronize()
            
            }
        
            //Comprobamos que el usuario no se haya equivocado al escribir la contraseña, por ello en la interfaz gráfica pedimos que la escriba dos veces, la funcionalidad es completar el registro de la manera más correcta posible.
            var isEqual = (self.PassWord.text! == self.PassWordR.text!)
        
            if isEqual {
            
                let servidor = TicketWebServer()
                //"Tocken de Google" más abajo está la implementación de la función.
                let Tocken = FIRInstanceID.instanceID().token()
                //let refreshedToken =
                var sexo : Int = 0
                //var sexi : int = 0;
                if self.checkedM {
                    sexo = 1
                }
            
                //LLamada al servidor, la llamada se hace de esta manera debido a los "threads" para evitar colisiones.
                servidor.sendUIDtoServer(Usuario: TicketConstant.Usuario, PassWord: TicketConstant.Password, Email: TicketConstant.Email, UID: TicketConstant.UID!, token: Tocken!, edad: Int(Age.text!)! , sexo: sexo, logoOff: 0) { message, error in
                
                    var emailEqual = (message == "Email existente")
                    var UIDEqual = (message == "UID existente")
                
                    //Caso de UID's iguales.
                    if UIDEqual {
                    
                        //Función asincrona para evitar colisiones, desplegamos un toast informativo.
                        DispatchQueue.main.async {
                        
                            let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                            let toastLabel = UILabel(frame: rect)
                            toastLabel.backgroundColor = UIColor.black
                            toastLabel.textColor = UIColor.white
                            toastLabel.textAlignment = NSTextAlignment.center;
                            self.view.addSubview(toastLabel)
                            toastLabel.text = "El UID insertado ya está en uso"
                            toastLabel.alpha = 1.0
                            toastLabel.layer.cornerRadius = 10;
                            toastLabel.clipsToBounds  =  true
                            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                        
                        }
                    
                    
                    
                    }
                
                    //Caso de Emails iguales.
                    else if emailEqual {
                    
                        DispatchQueue.main.async {
                        
                            let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                            let toastLabel = UILabel(frame: rect)
                            toastLabel.backgroundColor = UIColor.black
                            toastLabel.textColor = UIColor.white
                            toastLabel.textAlignment = NSTextAlignment.center;
                            self.view.addSubview(toastLabel)
                            toastLabel.text = "El email insertado ya está en uso"
                            toastLabel.alpha = 1.0
                            toastLabel.layer.cornerRadius = 10;
                            toastLabel.clipsToBounds  =  true
                            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
                        
                        }
                    }
                
                    //Registro completado satisfactoriamente.
                    else{
                    
                        print("REGISTRAO")
                        //let camino = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                        DispatchQueue.main.async {
                            TicketConstant.tag.append(TicketConstant.UID)
                            let prueba = TicketWebServer()
                            var t = Ticket()
                            
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            let result = formatter.string(from: date as Date)
                            
                            let dateFrom = Calendar.current.date(byAdding: .day, value: TicketConstant.diasAtras, to: date)
                            let resultResta = formatter.string(from: dateFrom!)
                            
                            /**let date = NSDate()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            let result = formatter.string(from: date as Date)
                            let myNSString = result as NSString
                            var day = Int(result.substring(to: result.characters.index(of: "-")!))
                            let startM = result.index(result.startIndex, offsetBy: 3)
                            let endM = result.index(result.endIndex, offsetBy: -5)
                            let rangeM = startM..<endM
                            var month = Int(result.substring(with: rangeM))!
                            let start = result.index(result.startIndex, offsetBy: 6)
                            let end = result.index(result.endIndex, offsetBy: 0)
                            let range = start..<end
                            var year = Int(result.substring(with: range))!
                            var resta10 = day! - 10
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
                            let resultResta = "\(dayT)-\(monthT)-\(yearT)"*/
                            //var month = result.
                            //var name = "Stephen"
                            //var prueba = result.substring(with: NSRange(location: 0, length: 3))
                            //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"
                            
                            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: true, fav: 0)
                            
                            var comp = TicketConstant.ticketList

                            self.performSegue(withIdentifier: "Tab", sender: self)
                        }
                        //self.navigationController?.pushViewController(camino, animated: true)
                    
                    }
                
                }
            
            }
        
            //Toast informativo, contraseñas no iguales.
            else {
            
                let rect = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 150,y: self.view.frame.size.height-100), size: CGSize(width: 300, height: 35))
                let toastLabel = UILabel(frame: rect)
                toastLabel.backgroundColor = UIColor.black
                toastLabel.textColor = UIColor.white
                toastLabel.textAlignment = NSTextAlignment.center;
                self.view.addSubview(toastLabel)
                toastLabel.text = "Las contraseñas no coinciden"
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 10;
                toastLabel.clipsToBounds  =  true
                UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0},completion:nil)
            }
        }
        
    }
    
    //Lector códigos QR.
    @IBAction func cameraQR(_ sender: Any) {
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        datos.registro = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        
    }
    
    //Cambiar el botón checkbox de seleccionado a no seleccionado y viceversa.
    @IBAction func checkButton(_ sender: Any) {
        
        if !checked {
            var image : UIImage = UIImage(named: "selected")!
            checkBoxButton.setImage(image, for: UIControlState())
            checked = true
        }
        
        else if checked {
            var image2 : UIImage = UIImage(named: "checkboxD")!
            checkBoxButton.setImage(image2, for: UIControlState())
            checked = false
        }
        
    }*/
    
    public override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Registro"
        navigationController?.navigationBar.tintColor = UIColor.white
        let back = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(goBack(sender:)))
        navigationItem.leftBarButtonItem = back
        
    }
    
    func goBack(sender: UIBarButtonItem) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x, y:y, width: width, height: height)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        var paddingViewNombre = UIView(frame:CGRectMake(0,0,15,15))
        
        etNombreReg.leftViewMode = UITextFieldViewMode.always
        etNombreReg.rightViewMode = UITextFieldViewMode.always
        etNombreReg.leftView = paddingViewNombre
        etNombreReg.rightView = paddingViewNombre
        etNombreReg.attributedPlaceholder = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etNombreReg.textColor = UIColor.white
        let path = UIBezierPath(roundedRect: etNombreReg.bounds, byRoundingCorners:[.topLeft, .bottomLeft], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        etNombreReg.layer.mask = maskLayer
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = etNombreReg.bounds
        etNombreReg.layer.addSublayer(borderLayer)
        etNombreReg.backgroundColor = UIColor.clear
        
        var paddingViewApellido = UIView(frame:CGRectMake(0,0,15,15))
        
        etApellidoReg.leftViewMode = UITextFieldViewMode.always
        etApellidoReg.rightViewMode = UITextFieldViewMode.always
        etApellidoReg.leftView = paddingViewApellido
        etApellidoReg.rightView = paddingViewApellido
        etApellidoReg.attributedPlaceholder = NSAttributedString(string: "Apellidos", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etApellidoReg.textColor = UIColor.white
        let pathA = UIBezierPath(roundedRect: etApellidoReg.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayerA = CAShapeLayer()
        maskLayerA.path = pathA.cgPath
        etApellidoReg.layer.mask = maskLayerA
        let borderLayerA = CAShapeLayer()
        borderLayerA.path = maskLayerA.path
        borderLayerA.fillColor = UIColor.clear.cgColor
        borderLayerA.strokeColor = UIColor.white.cgColor
        borderLayerA.lineWidth = 2
        borderLayerA.frame = etApellidoReg.bounds
        etApellidoReg.layer.addSublayer(borderLayerA)
        etApellidoReg.backgroundColor = UIColor.clear
        
        var paddingViewEdad = UIView(frame:CGRectMake(0,0,15,15))
        
        etEdadReg.leftViewMode = UITextFieldViewMode.always
        etEdadReg.rightViewMode = UITextFieldViewMode.always
        etEdadReg.leftView = paddingViewEdad
        etEdadReg.rightView = paddingViewEdad
        etEdadReg.attributedPlaceholder = NSAttributedString(string: "Edad", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etEdadReg.textColor = UIColor.white
        etEdadReg.layer.cornerRadius = 8.0
        etEdadReg.backgroundColor = UIColor.clear
        etEdadReg.layer.borderWidth = 1
        etEdadReg.layer.borderColor = UIColor.white.cgColor
        
        var paddingViewEmail = UIView(frame:CGRectMake(0,0,15,15))

        etEmailReg.leftViewMode = UITextFieldViewMode.always
        etEmailReg.rightViewMode = UITextFieldViewMode.always
        etEmailReg.leftView = paddingViewEmail
        etEmailReg.rightView = paddingViewEmail
        etEmailReg.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etEmailReg.textColor = UIColor.white
        etEmailReg.layer.cornerRadius = 8.0
        etEmailReg.backgroundColor = UIColor.clear
        etEmailReg.layer.borderWidth = 1
        etEmailReg.layer.borderColor = UIColor.white.cgColor
        
        var paddingViewPassword = UIView(frame:CGRectMake(0,0,15,15))
        
        etPasswordReg.leftViewMode = UITextFieldViewMode.always
        etPasswordReg.rightViewMode = UITextFieldViewMode.always
        etPasswordReg.leftView = paddingViewPassword
        etPasswordReg.rightView = paddingViewPassword
        etPasswordReg.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etPasswordReg.textColor = UIColor.white
        etPasswordReg.layer.cornerRadius = 8.0
        etPasswordReg.backgroundColor = UIColor.clear
        etPasswordReg.layer.borderWidth = 1
        etPasswordReg.layer.borderColor = UIColor.white.cgColor
        
        var paddingViewPasswordRep = UIView(frame:CGRectMake(0,0,15,15))
        
        etPasswordRepReg.leftViewMode = UITextFieldViewMode.always
        etPasswordRepReg.rightViewMode = UITextFieldViewMode.always
        etPasswordRepReg.leftView = paddingViewPasswordRep
        etPasswordRepReg.rightView = paddingViewPasswordRep
        etPasswordRepReg.attributedPlaceholder = NSAttributedString(string: "Repita la contraseña", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etPasswordRepReg.textColor = UIColor.white
        etPasswordRepReg.layer.cornerRadius = 8.0
        etPasswordRepReg.backgroundColor = UIColor.clear
        etPasswordRepReg.layer.borderWidth = 1
        etPasswordRepReg.layer.borderColor = UIColor.white.cgColor
        
        var paddingViewTag = UIView(frame:CGRectMake(0,0,15,15))

        var leftImageViewT = UIImageView()
        var leftImageT = UIImage(named: "nfc.png")
        leftImageViewT.image = leftImageT
        leftImageViewT.frame = CGRect(x: 190, y: 10, width: 20, height: 20)
        let leftViewT = UIView()
        leftViewT.addSubview(leftImageViewT)
        leftViewT.frame = CGRectMake(10,10,30,30)
        etTagReg.addSubview(leftImageViewT)
        etTagReg.leftViewMode = UITextFieldViewMode.always
        etTagReg.rightViewMode = UITextFieldViewMode.always
        etTagReg.leftView = paddingViewTag
        etTagReg.rightView = leftViewT
        etTagReg.attributedPlaceholder = NSAttributedString(string: "Tag asociado", attributes: [NSForegroundColorAttributeName: UIColor.white])
        etTagReg.textColor = UIColor.white
        etTagReg.sizeThatFits(CGSize(width:20, height:20))
        etTagReg.layer.cornerRadius = 8.0
        etTagReg.backgroundColor = UIColor.clear
        etTagReg.layer.borderWidth = 1
        etTagReg.layer.borderColor = UIColor.white.cgColor
        etTagReg.isHidden = true
        
        buttonAddTag.frame = CGRectMake(75, 375, 170, 40)
        buttonAddTag.tintColor = UIColor(hex: 0xa1d884)
        buttonAddTag.setImage(UIImage(named: "no_check_trans.png"), for: UIControlState.normal)
        buttonAddTag.imageEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 90)
        buttonAddTag.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        buttonAddTag.setTitle("   Añadir tag", for: UIControlState.normal)
        buttonAddTag.layer.borderWidth = 1.0
        buttonAddTag.backgroundColor = UIColor(hex: 0x708090)
        buttonAddTag.layer.cornerRadius = 8
        buttonAddTag.clipsToBounds = true
        buttonAddTag.layer.borderColor = UIColor(hex: 0x708090).cgColor
        
        buttonRegistry.layer.cornerRadius = 8
        buttonRegistry.clipsToBounds = true
        buttonRegistry.backgroundColor = UIColor(hex: 0xa1d884)
        
        buttonCamera.isHidden = true
        
        
        
        
        
        
        
        /**
        //Personalización botón.
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        
        if UIDFrom != nil {
            UID.text = UIDFrom
        }*/
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
        //Creación del "tocken de Goolge".
    func tocken(lenght: Int) -> String{
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< lenght {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
        
    }
    
    //Función creadora de alertas.
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Cuidado", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
}

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
    
    
    
    var UIDFrom: String?
    
    var cont = 0
    
    @IBAction func back(_ sender: Any) {
        
        var camino = (TicketConstant.Email == "")
        
        if camino {
            
            displayMyAlertMessage(userMessage: "No estás registrado")
            
        }
        
        else{
        
            self.performSegue(withIdentifier: "aLosTickets", sender: self)
        }
        
    }
    
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    @IBOutlet weak var registerButton: UIButton!
    var checked = false
    
    var delegate: ScannerViewControllerDelegate?
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var session: AVCaptureSession?
    var preview: AVCaptureVideoPreviewLayer?
    
    var codeDetected: Bool = false
    var code:String?
    var canBeDisplayed = true
    
    @IBOutlet weak var Usuario: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PassWord: UITextField!
    @IBOutlet weak var PassWordR: UITextField!
    @IBOutlet weak var UID: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var radioButtonMen: UIButton!
    @IBOutlet weak var radioButtonWomen: UIButton!
    var checkedH = false
    var checkedM = false
    
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
                            let resultResta = "\(dayT)-\(monthT)-\(yearT)"
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
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Personalización botón.
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        
        if UIDFrom != nil {
            UID.text = UIDFrom
        }
        
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

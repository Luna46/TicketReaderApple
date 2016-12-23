//
//  Login.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 14/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Firebase

protocol ScannerViewControllerDelegate2 {
    
    func codeDetected(code: String)
    
}

public class Login: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var loginB: UIButton!
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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    
    //Función utilizada para marcar o no nuestro botón checkbox
    @IBAction func checkbox(_ sender: Any) {
        
        if !checked {
            var image : UIImage = UIImage(named: "selected")!
            checkboxButton.setImage(image, for: UIControlState())
            checked = true
        }
            
        else if checked {
            var image2 : UIImage = UIImage(named: "checkboxD")!
            checkboxButton.setImage(image2, for: UIControlState())
            checked = false
        }
        
    }
    
    //Lector de códigos QR
    @IBAction func cameraButton(_ sender: Any) {
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewControllerLogin") as! CameraViewControllerLogin
        
        datos.login = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
    }
    
    //Funcion para acreditarnos en la aplicación
    @IBAction func login(_ sender: Any) {
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        let servidor = TicketWebServer()
        
        //var token = tocken(lenght: 152)
        //let refreshedToken = FIRInstanceID.instanceID().token()
        //Dependiendo del checkbutton nuestro UID tiene un valor o otro
        if checked {
            
            let UID = String(arc4random_uniform(1999999999) + 1)
            
            let refreshedToken = FIRInstanceID.instanceID().token()
            //LLamamos al servidor con los parámetros introducidos desde la aplicacion
            servidor.loginUser(Email: email, Password: password, UID: UID, tocken: refreshedToken!) { message, error in
                
                let preferences = UserDefaults.standard
                
                var userRejected = (message == "Contraseña incorrecta")
                var UIDRejected = (message == "El dispositivo con el UID especificado no puede registrarse, porque ya está registrado a nombre de otro usuario")
                
                if userRejected {
                    
                    //Evitamos colapso entre los "threads"
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
                    
                    //Evitamos colapso entre los "threads"
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
                    //Evitamos colapso entre los "threads"
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "aLosTickets2", sender: self)
                    }
                    
                }
            
            }
        }
        
        else {
            
            let UID = self.uidTextField.text!
            
            let refreshedToken = FIRInstanceID.instanceID().token()
            
            servidor.loginUser(Email: email, Password: password, UID: UID, tocken: refreshedToken!) { message, error in
                
                let preferences = UserDefaults.standard
                
                var userRejected = (message == "Contraseña incorrecta")
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
                        self.performSegue(withIdentifier: "aLosTickets2", sender: self)
                    }
                    
                }
                
            }

            
        }
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        loginB.layer.cornerRadius = 10
        loginB.clipsToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Función que crea el "Tocken de Google"
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
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        //connectToFcm()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

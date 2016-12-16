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

//Interfaz necesaria para la implementación del lector de códigos QR
protocol ScannerViewControllerDelegate {
    
    func codeDetected(code: String)
    
}

public class Registro: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
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
                preferences.set("Email", forKey: TicketConstant.Email)
                preferences.set("Usuario", forKey: TicketConstant.Usuario)
                preferences.set("PassWord", forKey: TicketConstant.Password)
                preferences.set("UID", forKey: TicketConstant.UID)
                preferences.synchronize()
            
            }
        
            else {
            
                TicketConstant.UID = self.UID.text!
            
                preferences.set("Email", forKey: TicketConstant.Email)
                preferences.set("Usuario", forKey: TicketConstant.Usuario)
                preferences.set("PassWord", forKey: TicketConstant.Password)
                preferences.set("UID", forKey: TicketConstant.UID)
                preferences.synchronize()
            
            }
        
            //Comprobamos que el usuario no se haya equivocado al escribir la contraseña, por ello en la interfaz gráfica pedimos que la escriba dos veces, la funcionalidad es completar el registro de la manera más correcta posible.
            var isEqual = (self.PassWord.text! == self.PassWordR.text!)
        
            if isEqual {
            
                let servidor = TicketWebServer()
                //"Tocken de Google" más abajo está la implementación de la función.
                var Tocken = tocken(lenght: 152)
            
                //LLamada al servidor, la llamada se hace de esta manera debido a los "threads" para evitar colisiones.
                servidor.sendUIDtoServer(Usuario: TicketConstant.Usuario, PassWord: TicketConstant.Password, Email: TicketConstant.Email, UID: TicketConstant.UID, token: Tocken, mensaje: "") { message, error in
                
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
                            self.performSegue(withIdentifier: "aLosTickets", sender: self)
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
        
        setupCamera()
        
        
        let button   = UIButton(type: .system)
        let rect = CGRect(origin: CGPoint(x: 100,y: 100), size: CGSize(width: 120, height: 50))
        button.frame = rect
        button.backgroundColor = UIColor(red: 1.0, green: (127/255.0), blue: 0.0, alpha: 1.0)
        button.setTitle("Cancel", for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "Chalkduster", size: 14)
        button.addTarget(self, action: "cancel:", for: UIControlEvents.touchUpInside)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        self.view.addSubview(button)
        
        //Don't forget this line
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //        var constX = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        //        view.addConstraint(constX)
        //
        //        var constY = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        //        view.addConstraint(constY)
        
        var constTrailingMargin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -50)
        //button.addConstraint(constTrailingMargin)
        view.addConstraint(constTrailingMargin)
        
        var constBottonMargin = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -50)
        //button.addConstraint(constBottonMargin)
        view.addConstraint(constBottonMargin)
        
        var constW = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        button.addConstraint(constW)
        //view.addConstraint(constW) also works
        
        var constH = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        button.addConstraint(constH)
        //view.addConstraint(constH) also works
        
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
        
    }
    
    //FUNCIONES DEL LECTOR DE CÓDIGOS QR.
    func cancel(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.canBeDisplayed{
            self.showAlertError()
            
        }
        
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        if let s = self.session{
            s.stopRunning()
            
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera(){
        
        self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if self.device == nil {
            print("No video camera on this device!")
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.canBeDisplayed = false
            return
        }
        
        if let s = self.session{
            return
            
        }else{
            self.session = AVCaptureSession()
            
            if let s = self.session{
                
                do {
                
                    let input = try AVCaptureDeviceInput(device: self.device)
                    
                }
                
                catch let error as NSError {
                    
                    print("Error QR")
                    
                }
                
                //self.input = AVCaptureDeviceInput.deviceInputWithDevice(self.device, error:nil) as? AVCaptureDeviceInput
                if s.canAddInput(self.input) {
                    s.addInput(self.input)
                }
                
                self.output = AVCaptureMetadataOutput()
                self.output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                if s.canAddOutput(self.output) {
                    s.addOutput(self.output)
                }
                self.output?.metadataObjectTypes = self.output?.availableMetadataObjectTypes
                
                
                self.preview = AVCaptureVideoPreviewLayer(session: s)
                self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.preview?.frame = self.view.frame
                self.view.layer.insertSublayer(self.preview!, at: 0)
                
                s.startRunning()
            }
        }
        
        
        
    }
    
    func showAlertError(){
        
        var alertView = UIAlertView(
            title:"Atention",
            message:"Scanner can't be displayed",
            delegate:self,
            cancelButtonTitle:"OK")
        alertView.tag = 1
        
        alertView.show()
    }
    
    func showAlertCodeDetected(code: String){
        
        var alertView = UIAlertView(
            title:"Code Detected",
            message:"The code is: " + code,
            delegate:self,
            cancelButtonTitle:"Accept",
            otherButtonTitles: "Cancel")
        
        alertView.tag = 0
        
        alertView.show()
    }
    
    
    // MARK:  AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if !self.codeDetected{
            
            for data in metadataObjects {
                let metaData = data as! AVMetadataObject
                let transformed = self.preview?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
                
                if let unwraped = transformed {
                    let code: String = unwraped.stringValue
                    print("CodeBar: " + code)
                    if !(code == ""){
                        self.codeDetected = true
                        self.code = code
                        //self.delegate?.codeDetected(code)
                        
                        //self.dismissViewControllerAnimated(true, completion: nil)
                        self.showAlertCodeDetected(code: code)
                    }
                }
            }
            
        }
    }
    
    // MARK:  UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if(alertView.tag == 0){
            
            if buttonIndex == 0{
                self.delegate?.codeDetected(code: self.code!)
                self.dismiss(animated: true, completion: nil)
            }else if buttonIndex == 1{
                
                self.codeDetected = false
            }
            
            
        }else if(alertView.tag == 1){
            
            self.dismiss(animated: true, completion: nil)
        }
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

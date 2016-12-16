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
    
    //Funcion para acreditarnos en la aplicación
    @IBAction func login(_ sender: Any) {
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        let servidor = TicketWebServer()
        
        var token = tocken(lenght: 152)
        
        
        //Dependiendo del checkbutton nuestro UID tiene un valor o otro
        if checked {
            
            let UID = String(arc4random_uniform(1999999999) + 1)
            
            
            //LLamamos al servidor con los parámetros introducidos desde la aplicacion
            servidor.loginUser(Email: email, Password: password, UID: UID, tocken: token) { message, error in
                
                let preferences = UserDefaults.standard
                
                var userRejected = (message == "Falso")
                var UIDRejected = (message == "Falso UID")
                
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
                    //Evitamos colapso entre los "threads"
                    DispatchQueue.main.async {
                        TicketConstant.Email = email
                        TicketConstant.Password = password
                        TicketConstant.UID = UID
                        preferences.set("Email", forKey: TicketConstant.Email)
                        preferences.set("PassWord", forKey: TicketConstant.Password)
                        preferences.set("UID", forKey: TicketConstant.UID)
                        preferences.synchronize()
                        self.performSegue(withIdentifier: "aLosTickets2", sender: self)
                    }
                    
                }
            
            }
        }
        
        else {
            
            let UID = self.uidTextField.text!
            
            servidor.loginUser(Email: email, Password: password, UID: UID, tocken: token) { message, error in
                
                let preferences = UserDefaults.standard
                
                var userRejected = (message == "Falso")
                var UIDRejected = (message == "Falso UID")
                
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
                    DispatchQueue.main.async {
                        TicketConstant.Email = email
                        TicketConstant.Password = password
                        TicketConstant.UID = UID
                        preferences.set("Email", forKey: TicketConstant.Email)
                        preferences.set("PassWord", forKey: TicketConstant.Password)
                        preferences.set("UID", forKey: TicketConstant.UID)
                        preferences.synchronize()
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
        
    }
    
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
    
    //Evitamos llamar al servidor si todos los campos no están rellenos mediante una alerta
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

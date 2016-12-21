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
            
                //LLamada al servidor, la llamada se hace de esta manera debido a los "threads" para evitar colisiones.
                servidor.sendUIDtoServer(Usuario: TicketConstant.Usuario, PassWord: TicketConstant.Password, Email: TicketConstant.Email, UID: TicketConstant.UID!, token: Tocken!, mensaje: "") { message, error in
                
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
        
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        datos.registro = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        //self.performSegue(withIdentifier: "toCamera", sender: self)
        /**self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()*/
        
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
    
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        //self.view.bringSubview(toFront: lblQRCodeResult)
        //self.view.bringSubview(toFront: lblQRCodeLabel)
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            UID.text = "NO QRCode text detacted"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                UID.text = objMetadataMachineReadableCodeObject.stringValue
                //navigationController?.popViewController(animated: true)

                //var datos = self.storyboard?.instantiateViewController(withIdentifier: "Registro") as! Registro
                
                //self.navigationController?.pushViewController(datos, animated: true)
                
                //datos.UID?.text = objMetadataMachineReadableCodeObject.stringValue
                //datos.UID?.text = "GG"
                objCaptureSession?.stopRunning()
                
                //var prueba = datos.UID.text
                //var hola: String
                //objCaptureSession?.stopRunning()
            }
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

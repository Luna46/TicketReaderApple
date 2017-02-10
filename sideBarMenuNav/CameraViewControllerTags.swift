//
//  CameraViewControllerTags.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 30/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import AVFoundation
import UIKit
import Firebase
class CameraViewControllerTags: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    
    var editUser = EditUser()
    //@IBOutlet weak var lblQRCodeResult: UILabel!
    //@IBOutlet weak var lblQRCodeLabel: UILabel!
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goBack(sender:)))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func goBack(sender: UIBarButtonItem) {
        editUser.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            //lblQRCodeResult.text = "NO QRCode text detacted"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                var tag = Tag()
                tag.setTag(uidTag: objMetadataMachineReadableCodeObject.stringValue)
                editUser.tags.append(tag)
                var servidor = TicketWebServer()
                let refreshedToken = FIRInstanceID.instanceID().token()
                servidor.loginUser(Email: TicketConstant.Email, Password: TicketConstant.Password, UID: objMetadataMachineReadableCodeObject.stringValue, tocken: refreshedToken!){ message, error in print(message)  }              //TicketConstant.tag.append(objMetadataMachineReadableCodeObject.stringValue)
                //loginP.UIDText.text = objMetadataMachineReadableCodeObject.stringValue
                //login.uidTextField.text = objMetadataMachineReadableCodeObject.stringValue
                
                /**var datos = self.storyboard?.instantiateViewController(withIdentifier: "Registro") as! Registro
                 
                 self.navigationController?.pushViewController(datos, animated: true)
                 
                 datos.UIDFrom = objMetadataMachineReadableCodeObject.stringValue*/
                
                //datos.Email.text = "Hola klk"
                
                editUser.cargarListado = false
                
                
                
                navigationController?.popViewController(animated: true)
                
                dismiss(animated: true, completion: nil)
                
                objCaptureSession?.stopRunning()
                //lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
            }
        }
    }
}


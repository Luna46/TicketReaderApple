//
//  UpdatePassword.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 30/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

class UpdatePassWord: UIViewController {
    
    //@IBOutlet weak var repeatPassWord: UITextField!
    //@IBOutlet weak var newPassWord: UITextField!
    //@IBOutlet weak var textActuallyPassWord: UITextField!
    
    @IBOutlet weak var newPassWord: UITextField!
    
    @IBOutlet weak var repeatPassWord: UITextField!
    
    var count = 0
    var editUserViewer = EditUser()
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updatePassword(_ sender: Any) {
        
        var user = Usuario()
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        
            if (newPassWord.text == repeatPassWord.text){
                user.setPassword(password: newPassWord.text!)
                user.setLogOff(logOff: 0)
                servidor.editCuenta(user: user, password: true){message in}
                sleep(2)
                displayMyAlertMessage(userMessage: "Contraseñas cambiadas correctamente")
            }
            else{
                displayMyAlertMessage(userMessage: "Las nuevas contraseñas no coinciden")
            }
        
    }
    
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Cuidado", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        //tabBarController?.navigationController?.navigationBar.isHidden = true
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goToLastTickets(sender:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        //tabBarController?.navigationController?.navigationBar.isHidden = false
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        editUserViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        count += 1

            if count > 1 {
                
                _ = navigationController?.popToRootViewController(animated: true)
            }
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x, y:y, width: width, height: height)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateButton.layer.cornerRadius = 10
        updateButton.clipsToBounds = true
        
        var paddingViewEdad = UIView(frame:CGRectMake(0,0,15,15))
        
        newPassWord.leftViewMode = UITextFieldViewMode.always
        newPassWord.rightViewMode = UITextFieldViewMode.always
        newPassWord.leftView = paddingViewEdad
        newPassWord.rightView = paddingViewEdad
        newPassWord.attributedPlaceholder = NSAttributedString(string: "Nueva contraseña", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        newPassWord.textColor = UIColor(hex: 0x279989)
        newPassWord.layer.cornerRadius = 8.0
        newPassWord.backgroundColor = UIColor.clear
        newPassWord.layer.borderWidth = 1
        newPassWord.layer.borderColor = UIColor(hex: 0x279989).cgColor
        
        var paddingViewEmail = UIView(frame:CGRectMake(0,0,15,15))
        
        repeatPassWord.leftViewMode = UITextFieldViewMode.always
        repeatPassWord.rightViewMode = UITextFieldViewMode.always
        repeatPassWord.leftView = paddingViewEmail
        repeatPassWord.rightView = paddingViewEmail
        repeatPassWord.attributedPlaceholder = NSAttributedString(string: "Repita la contraseña", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        repeatPassWord.textColor = UIColor(hex: 0x279989)
        repeatPassWord.layer.cornerRadius = 8.0
        repeatPassWord.backgroundColor = UIColor.clear
        repeatPassWord.layer.borderWidth = 1
        repeatPassWord.layer.borderColor = UIColor(hex: 0x279989).cgColor
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

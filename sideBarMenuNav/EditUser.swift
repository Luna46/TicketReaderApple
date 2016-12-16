//
//  OurViewController2.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import UIKit

class EditUser: UIViewController {
    
    @IBOutlet weak var quitButton: UIButton!
    
    //Mostramos una alerta.
    @IBAction func removeButton(_ sender: Any) {
        
        displayMyAlertMessage(userMessage: "Cuidado, está apunto de borrar su cuenta, perderá todos los tickets guardados")
        
    }

    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        //Personalización de botones.
        quitButton.layer.cornerRadius = 10
        quitButton.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Implementación de la alerta.
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Atencion", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.removeUser()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    //Eliminamos el usuario.
    func removeUser() {
        
        let servidor = TicketWebServer()
    
        servidor.remove(Email: TicketConstant.Email, UID: TicketConstant.UID) { message, error in
            
            var equal = (message == "Eliminado")
            
            if equal {
                
                DispatchQueue.main.async {
                    
                    exit(0)
                    
                }
                
            }
        
        }
    }

}

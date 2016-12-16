//
//  Presentation.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

public class Presentation: UIViewController {
    @IBOutlet weak var pregistryButton: UIButton!
    @IBOutlet weak var ploginButton: UIButton!
    
    //Conexión de un boton con la interfaz gráfica del registro.
    @IBAction func buttonRegistry(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toRegistry", sender: self)
        
    }
    
    //Conexión de un botón con la interfaz gráfica del login.
    @IBAction func buttonLogin(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        
        //let camino = preferences.object(forKey: "UID") as! String
        
        var isEqual = (TicketConstant.UID == "")
        
        //LEER SHARED PREFERENCES

        //TicketConstant.UID = preferences.object(forKey: "UID") as! String
        //TicketConstant.Email = preferences.object(forKey: "Email") as! String
        //TicketConstant.Usuario = preferences.object(forKey: "Usuario") as! String
        //TicketConstant.Password = preferences.object(forKey: "PassWord") as! String
        
        //Saber si es nuestra primera vez en la aplicación.
        if !isEqual {
            let camino = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            //self.performSegue(withIdentifier: "aLosTickets", sender: self)
            self.navigationController?.pushViewController(camino, animated: true)
        }
        
        //Personalización de botones.
        pregistryButton.layer.cornerRadius = 10
        pregistryButton.clipsToBounds = true
        ploginButton.layer.cornerRadius = 10
        ploginButton.clipsToBounds = true

        
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
    
}
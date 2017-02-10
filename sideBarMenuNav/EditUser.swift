//
//  OurViewController2.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import UIKit

class EditUser: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    var cargarListado = true
    var checkedH = false
    var checkedM = false
    var tags = Array<Tag>()
    
    
    @IBOutlet weak var radioButtonH: UIButton!
    
    @IBOutlet weak var radioButtonM: UIButton!
    
    
    @IBOutlet weak var quitButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func checkH(_ sender: Any) {
        if !checkedH {
            var imageH : UIImage = UIImage(named: "radioButton selected")!
            radioButtonH.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonM.setImage(imageM, for: UIControlState())
            checkedH = true
            
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedH {
            var imageH2 : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonH.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "radioButton selected")!
            radioButtonM.setImage(imageM2, for: UIControlState())
            checkedH = false
            
            //UIDText.isHidden = true
            //cameraButton.isHidden = true
        }
    }
    
    @IBAction func checkM(_ sender: Any) {
        if !checkedM {
            var imageH : UIImage = UIImage(named: "radioButton selected")!
            radioButtonM.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonH.setImage(imageM, for: UIControlState())
            checkedM = true
            
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedM {
            var imageH2 : UIImage = UIImage(named: "empty-radiobutton-128")!
            radioButtonM.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "radioButton selected")!
            radioButtonH.setImage(imageM2, for: UIControlState())
            checkedM = false
            
            //UIDText.isHidden = true
            //cameraButton.isHidden = true
        }
    }
    
    
    /**@IBAction func checkM(_ sender: Any) {
        if !checked {
            var image : UIImage = UIImage(named: "selected")!
            checkboxButton.setImage(image, for: UIControlState())
            checked = true
            
            UIDText.isHidden = false
            cameraButton.isHidden = false
        }
            
        else if checked {
            var image2 : UIImage = UIImage(named: "checkboxD")!
            checkboxButton.setImage(image2, for: UIControlState())
            checked = false
            
            UIDText.isHidden = true
            cameraButton.isHidden = true
        }
    }*/
    
    //Mostramos una alerta.
    @IBAction func removeButton(_ sender: Any) {
        displayMyAlertMessage(userMessage: "Cuidado, está apunto de borrar su cuenta, perderá todos los tickets guardados")
    }
    
    
    /**@IBAction func updatePassword(_ sender: Any) {
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "Update") as! UpdatePassWord
        
        datos.editUserViewer = self
        self.navigationController?.pushViewController(datos, animated: true)
        
    }*/
    
    @IBOutlet weak var textEdad: UITextField?
    
    @IBOutlet weak var diasAtras: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!

    @IBOutlet weak var textNombre: UITextField!
    
    @IBAction func changePassWord(_ sender: Any) {
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "Update") as! UpdatePassWord
        
        datos.editUserViewer = self
        self.navigationController?.pushViewController(datos, animated: true)
        //self.performSegue(withIdentifier: "pass", sender: self)
        
    }
    
    @IBAction func saveData(_ sender: Any) {
        var genero = 2
        let preferences = UserDefaults.standard
        
        TicketConstant.diasAtras = Int(diasAtras.text!)!
        
        preferences.set(TicketConstant.diasAtras, forKey: "diasAtras")
        
        preferences.synchronize()
        
        var user = Usuario()
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        
        var idUsuario = user.getIdUsuario()
        
        let nombre = textNombre.text
        let email = textEmail.text
        let edad = Int(textEmail.text!)
        let sexo  = user.getSexo()
        if sexo == 1 {
            genero = 1
        }
        else{
            genero = 0
        }
        
        if (nombre != user.getNombre() || email != user.getEmail() || edad != user.getEdad() || genero != user.getSexo()){
            
            servidor.editCuenta(idUser: idUsuario, Usuario: nombre!, Email: email!, edad: edad!, sexo: sexo!){ message, error in}
            /**let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(nombre, forKey: "nombre")
            jsonObject.setValue(email, forKey: "email")
            jsonObject.setValue(edad, forKey: "edad")
            jsonObject.setValue(sexo, forKey: "sexo")
            
            let jsonData:NSData
            
            do{
                jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
                let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
                print("json string = \(jsonString)")
            } catch _ {
                print("JSON Failure")*/
            }
        }
        
    
   
    @IBAction func logout(_ sender: Any) {
        displayMyAlertMessage2(userMessage: "¿Seguro que quiere cerrar sesión?")
    }
   
    
    @IBAction func back(_ sender: Any) {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var tableView: UITableView!


    /**@IBAction func back(_ sender: Any) {
        
        self.performSegue(withIdentifier: "aLosT", sender: self)
        
    }*/
    
    
    @IBAction func camera(_ sender: Any) {
        var datos = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewControllerTags") as! CameraViewControllerTags
        
        datos.editUser = self
        
        //datos.loginP = self
        
        self.navigationController?.pushViewController(datos, animated: true)
    }
  
    override public func viewDidAppear(_ animated: Bool) {
        
        if cargarListado {
            
            count += 1
            //var cuenta = count%2
            if count > 1 {
                
                _ = navigationController?.popViewController(animated: true)
            }
            
        }
        
        cargarListado = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        navigationItem.title = "Cuenta"
        //var cell = tableView(tableView, cellForRowAt: IndexPath)
        tableView.reloadData()
    }
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textEmail.text = TicketConstant.Email
        var comp = TicketConstant.diasAtras
        diasAtras.text = String(TicketConstant.diasAtras)
        var user = Usuario()
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        textEmail.text = user.getEmail()
        textNombre.text = user.getNombre()
        var edad = String(describing: user.getEdad())
        let isEqual = (edad == "nil")
        if isEqual == false {
        let edadMod = edad.index(edad.startIndex, offsetBy: 8)
        edad = edad.substring(from: edadMod)
        let newEdad = edad.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        let newEdad2 = newEdad.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
            textEdad?.text = newEdad2
        }
        var sexo : Int? = nil
        sexo = user.getSexo()
        if sexo != nil{
            if (user.getSexo() == 1) {
                let imageM2 : UIImage = UIImage(named: "radioButton selected")!
                radioButtonM.setImage(imageM2, for: UIControlState())
            }
            else if (user.getSexo() == 0){
                let imageH : UIImage = UIImage(named: "radioButton selected")!
                radioButtonH.setImage(imageH, for: UIControlState())
            }
        }
        tags = servidor.getTags(userEmail: TicketConstant.Email)
        
        //diasAtras.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        //Personalización de botones.
        quitButton.layer.cornerRadius = 10
        quitButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true

    }
    
    /**func textFieldDidChange(_ textField: UITextField) {
        setRestaDias(num: Int(diasAtras.text!)!)
    }*/
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    //Configuración de nuestra lista de tickets.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        
        let tagSelected = tags[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        cell.textLabel?.text = tags[indexPath.row].getTag()
        
        
        return cell
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func displayMyAlertMessage2(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Atencion", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.logoutUser()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    func logoutUser() {
        
        TicketConstant.UID = ""
        TicketConstant.Email = ""
        TicketConstant.Usuario = ""
        TicketConstant.Password = ""
        let preferences = UserDefaults.standard
        preferences.set(TicketConstant.Email, forKey: "Email")
        preferences.set(TicketConstant.Usuario, forKey: "Usuario")
        preferences.set(TicketConstant.Password, forKey: "PassWord")
        preferences.set(TicketConstant.UID, forKey: "UID")
        preferences.synchronize()
        exit(0)
        
    }
    
    //Eliminamos el usuario.
    func removeUser() {
        
        let servidor = TicketWebServer()
    
        servidor.remove(Email: TicketConstant.Email, UID: TicketConstant.UID!) { message, error in
            
            var equal = (message == "Eliminado")
            
            if equal {
                
                DispatchQueue.main.async {
                    
                    TicketConstant.UID = ""
                    TicketConstant.Email = ""
                    TicketConstant.Usuario = ""
                    TicketConstant.Password = ""
                    let preferences = UserDefaults.standard
                    preferences.set(TicketConstant.Email, forKey: "Email")
                    preferences.set(TicketConstant.Usuario, forKey: "Usuario")
                    preferences.set(TicketConstant.Password, forKey: "PassWord")
                    preferences.set(TicketConstant.UID, forKey: "UID")
                    preferences.synchronize()
                    exit(0)
                    
                }
                
            }
        
        }
    }

}

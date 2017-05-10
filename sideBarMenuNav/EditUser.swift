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
    var genero = 2
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
            var imageH : UIImage = UIImage(named: "ButtonAccount")!
            radioButtonH.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "buttonEditUserEmpty")!
            radioButtonM.setImage(imageM, for: UIControlState())
            checkedH = true
            genero = 0
            
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedH {
            genero = 1
            var imageH2 : UIImage = UIImage(named: "buttonEditUserEmpty")!
            radioButtonH.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "ButtonAccount")!
            radioButtonM.setImage(imageM2, for: UIControlState())
            checkedH = false
            
            //UIDText.isHidden = true
            //cameraButton.isHidden = true
        }
    }
    
    @IBAction func checkM(_ sender: Any) {
        if !checkedM {
            genero = 1
            var imageH : UIImage = UIImage(named: "ButtonAccount")!
            radioButtonM.setImage(imageH, for: UIControlState())
            var imageM : UIImage = UIImage(named: "buttonEditUserEmpty")!
            radioButtonH.setImage(imageM, for: UIControlState())
            checkedM = true
            
            //UIDText.isHidden = false
            //cameraButton.isHidden = false
        }
            
        else if checkedM {
            var imageH2 : UIImage = UIImage(named: "buttonEditUserEmpty")!
            radioButtonM.setImage(imageH2, for: UIControlState())
            var imageM2 : UIImage = UIImage(named: "ButtonAccount")!
            radioButtonH.setImage(imageM2, for: UIControlState())
            checkedM = false
            genero = 0 
            
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
    
    @IBOutlet weak var textNombre: UITextField!
    
    @IBOutlet weak var textApellido: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textEdad: UITextField!
    
    @IBOutlet weak var diasAtras: UITextField!
    
    //@IBOutlet weak var labelTags: UILabel!
    
    
    //ANTERIOR
    /**@IBOutlet weak var textEdad: UITextField?
    
    @IBOutlet weak var diasAtras: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!

    @IBOutlet weak var textNombre: UITextField!*/
    
    @IBAction func changePassWord(_ sender: Any) {
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "Update") as! UpdatePassWord
        
        datos.editUserViewer = self
        self.navigationController?.pushViewController(datos, animated: true)
        //self.performSegue(withIdentifier: "pass", sender: self)
        
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        let preferences = UserDefaults.standard
        
        TicketConstant.refreshLast = true
        
        TicketConstant.diasAtras = Int(diasAtras.text!)!
        
        preferences.set(TicketConstant.diasAtras, forKey: "diasAtras")
        
        preferences.synchronize()
        
        var user = Usuario()
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        
        var idUsuario = user.getIdUsuario()
        
        let nombre = textNombre.text
        let email = textEmail.text
        let edad = Int((textEdad?.text!)!)
        let sexo  = user.getSexo()
                
        if (nombre != user.getNombre() || email != user.getEmail() || edad != user.getEdad() || genero != user.getSexo()){
            user.setNombre(nombre: nombre!)
            user.setEdad(edad: edad!)
            user.setSexo(sexo: genero)
            user.setPassword(password: TicketConstant.Password)
            user.setIdUsuario(idUsuario: idUsuario)
            user.setEmail(email: email!)
            user.setLogOff(logOff: 0)
            servidor.editCuenta(user: user, password: true){message in}
            TicketConstant.refreshLast = true
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
        
        TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")
        
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
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Cuenta"
        //var cell = tableView(tableView, cellForRowAt: IndexPath)
        tableView.reloadData()
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x, y:y, width: width, height: height)
    }
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var paddingViewNombre = UIView(frame:CGRectMake(0,0,15,15))
        
        textNombre.leftViewMode = UITextFieldViewMode.always
        textNombre.rightViewMode = UITextFieldViewMode.always
        textNombre.leftView = paddingViewNombre
        textNombre.rightView = paddingViewNombre
        textNombre.attributedPlaceholder = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        textNombre.textColor = UIColor(hex: 0x279989)
        textNombre.layer.cornerRadius = 8.0
        textNombre.backgroundColor = UIColor.clear
        textNombre.layer.borderWidth = 1
        textNombre.layer.borderColor = UIColor(hex: 0x279989).cgColor
        /**let path = UIBezierPath(roundedRect: textNombre.bounds, byRoundingCorners:[.topLeft, .bottomLeft], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        textNombre.layer.mask = maskLayer
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(hex: 0x279989).cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = textNombre.bounds
        textNombre.layer.addSublayer(borderLayer)
        textNombre.backgroundColor = UIColor.clear*/
        
        
        var paddingViewApellido = UIView(frame:CGRectMake(0,0,15,15))
        
        textApellido.leftViewMode = UITextFieldViewMode.always
        textApellido.rightViewMode = UITextFieldViewMode.always
        textApellido.leftView = paddingViewApellido
        textApellido.rightView = paddingViewApellido
        textApellido.attributedPlaceholder = NSAttributedString(string: "Apellidos", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        textApellido.textColor = UIColor(hex: 0x279989)
        let pathA = UIBezierPath(roundedRect: textApellido.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayerA = CAShapeLayer()
        maskLayerA.path = pathA.cgPath
        textApellido.layer.mask = maskLayerA
        let borderLayerA = CAShapeLayer()
        borderLayerA.path = maskLayerA.path
        borderLayerA.fillColor = UIColor.clear.cgColor
        borderLayerA.strokeColor = UIColor(hex: 0x279989).cgColor
        borderLayerA.lineWidth = 2
        borderLayerA.frame = textApellido.bounds
        textApellido.layer.addSublayer(borderLayerA)
        textApellido.backgroundColor = UIColor.clear
        
        
        var paddingViewEdad = UIView(frame:CGRectMake(0,0,15,15))
        
        textEdad.leftViewMode = UITextFieldViewMode.always
        textEdad.rightViewMode = UITextFieldViewMode.always
        textEdad.keyboardType = UIKeyboardType.numberPad
        textEdad.leftView = paddingViewEdad
        textEdad.rightView = paddingViewEdad
        textEdad.attributedPlaceholder = NSAttributedString(string: "Edad", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        textEdad.textColor = UIColor(hex: 0x279989)
        textEdad.layer.cornerRadius = 8.0
        textEdad.backgroundColor = UIColor.clear
        textEdad.layer.borderWidth = 1
        textEdad.layer.borderColor = UIColor(hex: 0x279989).cgColor
        
        
        var paddingViewEmail = UIView(frame:CGRectMake(0,0,15,15))
        
        textEmail.leftViewMode = UITextFieldViewMode.always
        textEmail.rightViewMode = UITextFieldViewMode.always
        textEmail.leftView = paddingViewEmail
        textEmail.rightView = paddingViewEmail
        textEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        textEmail.textColor = UIColor(hex: 0x279989)
        textEmail.layer.cornerRadius = 8.0
        textEmail.backgroundColor = UIColor.clear
        textEmail.layer.borderWidth = 1
        textEmail.layer.borderColor = UIColor(hex: 0x279989).cgColor
        
        
        var paddingViewTag = UIView(frame:CGRectMake(0,0,15,15))
        
        var leftImageViewT = UIImageView()
        var leftImageT = UIImage(named: "user_account_diasP.png")
        leftImageViewT.image = leftImageT
        leftImageViewT.frame = CGRect(x: 205, y: 7.5, width: 20, height: 20)
        let leftViewT = UIView()
        leftViewT.addSubview(leftImageViewT)
        leftViewT.frame = CGRectMake(10,10,30,30)
        diasAtras.keyboardType = UIKeyboardType.numberPad
        diasAtras.addSubview(leftImageViewT)
        diasAtras.leftViewMode = UITextFieldViewMode.always
        diasAtras.rightViewMode = UITextFieldViewMode.always
        diasAtras.leftView = paddingViewTag
        diasAtras.rightView = leftViewT
        diasAtras.attributedPlaceholder = NSAttributedString(string: "Días Atrás", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0x279989)])
        diasAtras.textColor = UIColor(hex: 0x279989)
        diasAtras.sizeThatFits(CGSize(width:20, height:20))
        diasAtras.layer.cornerRadius = 8.0
        diasAtras.backgroundColor = UIColor.clear
        diasAtras.layer.borderWidth = 1
        diasAtras.layer.borderColor = UIColor(hex: 0x279989).cgColor
        
        
        
        TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")
        
        //textEmail.text = TicketConstant.Email
        let preferences = UserDefaults.standard
        //TicketConstant.diasAtras = preferences.integer(forKey: "diasAtras")
        var comp = TicketConstant.diasAtras
        if (TicketConstant.diasAtras == 0){
            diasAtras.text = String(10)
        }
        else{
            diasAtras.text = String(TicketConstant.diasAtras)
        }
        var user = Usuario()
        
        var email = TicketConstant.Email
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        textEmail.text = user.getEmail()
        let nombreCompleto = user.getNombre()
        let separado : [String] = nombreCompleto.components(separatedBy: " ")
        if (separado.count == 4) {
            textNombre.text = separado[0] + " " + separado[1]
            textApellido.text = separado[2] + " " + separado[3]
        }
        if (separado.count == 3) {
            textNombre.text = separado[0]
            textApellido.text = separado[1] + " " + separado[2]
        }
        if (separado.count == 2) {
            textNombre.text = separado[0]
            textApellido.text = separado[1]
        }
        if (separado.count == 1) {
            textNombre.text = separado[0]
        }
        var edad = String(user.getEdad())
        textEdad?.text = edad
        var sexo : Int? = nil
        sexo = user.getSexo()
        if sexo != nil{
            if (user.getSexo() == 1) {
                let imageM2 : UIImage = UIImage(named: "ButtonAccount")!
                radioButtonM.setImage(imageM2, for: UIControlState())
            }
            else if (user.getSexo() == 0){
                let imageH : UIImage = UIImage(named: "ButtonAccount")!
                radioButtonH.setImage(imageH, for: UIControlState())
            }
        }
        tags = servidor.getTags(userEmail: TicketConstant.Email)
        
        //diasAtras.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        //labelTags.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = tags[indexPath.row].getTag()
        displayMyAlertMessageTags(userMessage: "¿Seguro que desea borrar el tag seleccionado de su cuenta?", tag: uid)
        
    }
    
    func displayMyAlertMessageTags(userMessage: String, tag: String) {
        
        var myAlert = UIAlertController(title: "Atencion", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.removeTag(tag: tag)})
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: nil)
        
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    func removeTag(tag: String) {
        
        let servidor = TicketWebServer()
        servidor.deleteTag(tag: tag)
        reload()
        
    }
    
    func reload(){
        let servidor = TicketWebServer()
        tags = servidor.getTags(userEmail: TicketConstant.Email)
        tableView.reloadData()
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
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: nil)
        
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    func displayMyAlertMessage2(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Atencion", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.logoutUser()})
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: nil)
        
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    func logoutUser() {
        
        var user = Usuario()
        
        let servidor = TicketWebServer()
        user = servidor.getUser(userEmail: TicketConstant.Email)
        user.setLogOff(logOff: 1)
        servidor.editCuenta(user: user, password: false){message in}
        sleep(2)
        
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

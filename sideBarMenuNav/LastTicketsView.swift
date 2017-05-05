//
//  LastTicketsView.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 26/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

public class LastTicketsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainWindow = AppDelegate()
    
    var indexTouch : Int = 0
    
    static var alarmTicket : Bool = false
    
    var count = 0
    
    @IBOutlet weak var labelInformation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Últimos tickets"
                //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")
        
        count += 1
        if count > 1 {
            
            let preferences = UserDefaults.standard
            TicketConstant.diasAtras = preferences.integer(forKey: "diasAtras")
            
                let prueba = TicketWebServer()
                var t = Ticket()
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let result = formatter.string(from: date)
            let dateFrom = Calendar.current.date(byAdding: .day, value: -TicketConstant.diasAtras, to: date)
            let resultResta = formatter.string(from: dateFrom!)
            
            //if (TicketConstant.ticketList.count == 0 || TicketConstant.refreshLast){
              //  TicketConstant.refreshLast = false
                TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
            //}
              
                

            if TicketConstant.ticketList.count == 0 {
                labelInformation.isHidden = false
                labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
                labelInformation.text = "No existen tickets disponibles\n para este filtro de búsqueda"
                tableView.isHidden = true
            }
            else{
                labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
                labelInformation.text = "ÚLTIMOS TICKETS"
                labelInformation.isHidden = true
                tableView.reloadData()
                tableView.isHidden = false
            }
            
        }
    }
    
    public func mostrarUltimoTicket() {
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        //let navigationController = mainWindow.application.windows[0].rootViewController as! UINavigationController
        //navigationController.setViewControllers(datos, animated: true)
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexTouch = indexTouch
        datos.lastTicketView = true
        
        TicketConstant.tabBar.selectedIndex = 0        //mainWindow.window?.rootViewController = datos
        //mainWindow.window?.makeKeyAndVisible()
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        //TicketConstant.diasAtras = preferences.integer(forKey: "diasAtras")
        tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //panGesture.requireGestureRecognizerToFail(singleTapRecognizer)
        //self.view.gestureRecognizers?.removeAll()
        
        //tabBarController?.hidesBottomBarWhenPushed = true
        
        tabBarController?.navigationController?.navigationBar.isHidden = true
        
        TicketConstant.pageView = self
        
        
        
        let prueba = TicketWebServer()
        var t = Ticket()
        
        var comp = TicketConstant.diasAtras
            
        TicketConstant.diasAtras = preferences.integer(forKey: "diasAtras")
        var compD = TicketConstant.diasAtras
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date as Date)
            let dateFrom : Date
            
            if (compD == 0){
                
                dateFrom = Calendar.current.date(byAdding: .day, value: -10, to: date)!
                
                
            }
            
            else {
                
                dateFrom = Calendar.current.date(byAdding: .day, value: -TicketConstant.diasAtras, to: date)!
                
                
            }
            
            let resultResta = formatter.string(from: dateFrom)
            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
    
        
        
        

        
        
        labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
        labelInformation.text = "ÚLTIMOS TICKETS"
        labelInformation.isHidden = true
        tableView.reloadData()
        tableView.isHidden = false
        

        
        //Sino existen tickets con la búsqueda ofrecida lo informamos.
        if TicketConstant.ticketList.count == 0 {
            labelInformation.isHidden = false
            labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            labelInformation.text = "No existen tickets disponibles\n para este filtro de búsqueda"
            tableView.isHidden = true
            }
        
        if LastTicketsView.alarmTicket {
            

            LastTicketsView.alarmTicket = false
            mostrarUltimoTicket()
            
            
        }
        
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x: x, y: y, width: width, height: height)
    }
  
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TicketConstant.ticketList.count
    }
    
    //Configuración de nuestra lista de tickets.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        
        let ticketSelected = TicketConstant.ticketList[indexPath.row]
        cell.tintColor = UIColor(hex: 0x279989)
        cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12.0)
        cell.textLabel?.textColor = UIColor(hex: 0x279989)
        cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
        let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
        cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
        cell.imageView?.image = UIImage(named: "grande")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        //cell.accessoryView?.frame = CGRectMake(0,0,22,22)
        
        return cell
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexTouch = indexPath.row
        datos.lastTicketView = true
        
    }
    
    
}




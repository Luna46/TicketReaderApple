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
    
    var alarmTicket : Bool = false
    
    var count = 0
    
    @IBOutlet weak var labelInformation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Últimos tickets"
                //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
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
            let dateFrom = Calendar.current.date(byAdding: .day, value: -10, to: date)
            let resultResta = formatter.string(from: dateFrom!)
              /*  let myNSString = result as NSString
                var day = Int(result.substring(to: result.characters.index(of: "-")!))
                let startM = result.index(result.startIndex, offsetBy: 3)
                let endM = result.index(result.endIndex, offsetBy: -5)
                let rangeM = startM..<endM
                var month = Int(result.substring(with: rangeM))!
                month = month - 1
                let start = result.index(result.startIndex, offsetBy: 6)
                let end = result.index(result.endIndex, offsetBy: 0)
                let range = start..<end
                var year = Int(result.substring(with: range))!
                var resta10 = day! - TicketConstant.diasAtras
                if (resta10<=0){
                    resta10 = ((-1)*resta10)/30
                    month = month - resta10
                    if(month <= 0){
                        month = 12 - resta10
                        year = year - 1
                    }
                }
                var dayT = "9"
                var monthT = String(month)
                var yearT = String(year)
                let resultResta = "\(dayT)-\(monthT)-\(yearT)"*/
                //var month = result.
                //var name = "Stephen"
                //var prueba = result.substring(with: NSRange(location: 0, length: 3))
                //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"
                
            TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: "%20", bIncludeAllTicket: true, fav: 0)
            if TicketConstant.ticketList.count == 0 {
                labelInformation.isHidden = false
                labelInformation.font = UIFont.boldSystemFont(ofSize: 16)
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
        
        if alarmTicket {
            
            let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            //let navigationController = mainWindow.application.windows[0].rootViewController as! UINavigationController
            //navigationController.setViewControllers(datos, animated: true)

            self.navigationController?.pushViewController(datos, animated: true)
            
            datos.indexTouch = indexTouch
            datos.lastTicketView = true
            
            mainWindow.window?.rootViewController = datos
            mainWindow.window?.makeKeyAndVisible()//ESTO FUNCIONA
        }
        else{
        
        let prueba = TicketWebServer()
        var t = Ticket()
        
        var comp = TicketConstant.diasAtras
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date as Date)
    
        let dateFrom = Calendar.current.date(byAdding: .day, value: -10, to: date)
        let resultResta = formatter.string(from: dateFrom!)
        
        /*let myNSString = result as NSString
        var day = Int(result.substring(to: result.characters.index(of: "-")!))
        let startM = result.index(result.startIndex, offsetBy: 3)
        let endM = result.index(result.endIndex, offsetBy: -5)
        let rangeM = startM..<endM
        var month = Int(result.substring(with: rangeM))!
        month = month - 1
        let start = result.index(result.startIndex, offsetBy: 6)
        let end = result.index(result.endIndex, offsetBy: 0)
        let range = start..<end
        var year = Int(result.substring(with: range))!
        var resta10 = day! - TicketConstant.diasAtras
        if (resta10<=0){
            resta10 = ((-1)*resta10)/30
            month = month - resta10
            if(month <= 0){
                month = 12 - resta10
                year = year - 1
            }
        }
        var dayT = "1"
        var monthT = String(month)
        var yearT = String(year)
        let resultResta = "\(dayT)-\(monthT)-\(yearT)"*/
        //var month = result.
        //var name = "Stephen"
        //var prueba = result.substring(with: NSRange(location: 0, length: 3))
        //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"
        
        TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
        labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
        labelInformation.text = "ÚLTIMOS TICKETS"
        labelInformation.isHidden = true
        tableView.reloadData()
        tableView.isHidden = false
        
        //navigationController?.isNavigationBarHidden = true
        //navigationItem.leftBarButtonItem?.isEnabled = false
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        //let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        //navigationItem.leftBarButtonItem = backButton
        
        //Sino existen tickets con la búsqueda ofrecida lo informamos.
        if TicketConstant.ticketList.count == 0 {
            labelInformation.isHidden = false
            labelInformation.font = UIFont.boldSystemFont(ofSize: 16)
            labelInformation.text = "No existen tickets disponibles\n para este filtro de búsqueda"
            tableView.isHidden = true
            }}
        
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
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
        let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
        cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
        cell.imageView?.image = UIImage(named: "Imagen1")
        
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

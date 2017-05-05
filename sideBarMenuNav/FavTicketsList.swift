//
//  FavTicketsList.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 1/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation

import UIKit

public class FavTicketsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    
    @IBOutlet weak var labelInformation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Tickets favoritos"
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")
        
        count += 1
        if count > 1 {
            
            let servidor = TicketWebServer()
            //var t = Ticket()
            
            TicketConstant.ticketList = servidor.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: false, fav: 1)
            if TicketConstant.ticketList.count == 0 {
                labelInformation.isHidden = false
                labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
                labelInformation.text = "No existen tickets favoritos"
                tableView.isHidden = true
            }
            else{
                labelInformation.isHidden = true
                labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
                labelInformation.text = "TICKETS FAVORITOS"
                //TicketConstant.ticketList = servidor.ticketFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: true, fav: 1)
                tableView.reloadData()
                tableView.isHidden = false
            }
            
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        TicketConstant.comercio.setComercio(comercio: "")
        TicketConstant.ciudad.setPoblacion(poblacion: "")
        TicketConstant.tipo.setActividad(actividad: "")
        labelInformation.isHidden = true
        let servidor = TicketWebServer()
        TicketConstant.ticketList = servidor.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: false, fav: 1)
        tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //panGesture.requireGestureRecognizerToFail(singleTapRecognizer)
        //self.view.gestureRecognizers?.removeAll()
        
        //tabBarController?.hidesBottomBarWhenPushed = true
        
        tabBarController?.navigationController?.navigationBar.isHidden = true
        
        //navigationController?.isNavigationBarHidden = true
        //navigationItem.leftBarButtonItem?.isEnabled = false
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        //let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        //navigationItem.leftBarButtonItem = backButton
        
        //Sino existen tickets con la búsqueda ofrecida lo informamos.
        if TicketConstant.ticketList.count == 0 {
            labelInformation.isHidden = false
            labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            labelInformation.text = "No existen tickets favoritos"
            tableView.isHidden = true
        }
        
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
        cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12.0)
        cell.textLabel?.textColor = UIColor(hex: 0x279989)
        cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
        let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
        cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
        cell.imageView?.image = UIImage(named: "grande")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexTouch = indexPath.row
        
    }
    
    
}

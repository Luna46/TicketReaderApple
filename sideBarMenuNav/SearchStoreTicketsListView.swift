//
//  SearchStoreTicketsListView.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 1/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

public class SearchStoreTicketsListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    
    var store : String = ""
    
    var comercio : String = ""
    
    var grupo : String = ""
    
    var cargarListado = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goToLastTickets(sender:)))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "\(grupo), \(comercio)"
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //editUserViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        count += 1
        
        if cargarListado {
            
            if count > 1 {
                
                _ = navigationController?.popViewController(animated: true)
                
            }
        
        }
        
        else {
            
            let servidor = TicketWebServer()
            let newGroup = grupo.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let newComercio = comercio.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            //TicketConstant.ticketList = servidor.ticketSearchAndFav(userName: TicketConstant.Email, grupo: newGroup, comercio: newComercio, strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
            TicketConstant.ticketList = servidor.buscarBuena(userName: TicketConstant.Email, idActividad: 0, idComercio: TicketConstant.comercio.getId(), poblacion: "%20", strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
            tableView.reloadData()
            
        }
        
        cargarListado = true
        
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        labelInformation.isHidden = true
        let servidor = TicketWebServer()
        labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
        labelInformation.text = "\(grupo), \(comercio)"
        //let aString = "This is my string"
        let newGroup = grupo.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let newComercio = comercio.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        TicketConstant.ticketList = servidor.buscarBuena(userName: TicketConstant.Email, idActividad: 0, idComercio: TicketConstant.comercio.getId(), poblacion: "%20", strDateFrom: "%20", strDateTo: "%20", bIncludeAllTicket: false, fav: 0)
        tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.navigationController?.navigationBar.isHidden = true
        
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
        
        datos.ticketList = self
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexTouch = indexPath.row
        
    }
    
    
}

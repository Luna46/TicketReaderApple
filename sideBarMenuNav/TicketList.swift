//
//  TicketList.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 7/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

import UIKit

public class TicketList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
        
    @IBOutlet weak var labelinformation: UILabel!
    
    let textCellIdentifier = "TextCell"
    
    override public func viewDidLoad() {

        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        //Sino existen tickets con la búsqueda ofrecida lo informamos.
        if TicketConstant.ticketList.count == 0 {
            labelinformation.font = UIFont.boldSystemFont(ofSize: 16)
            labelinformation.text = "No existen tickets disponibles\n para este filtro de búsqueda"
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
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
        let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
        cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
        cell.imageView?.image = UIImage(named: "TICKETS-NOW")
        
        return cell
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerSearch") as! PageViewControllerSearch
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexSearch = indexPath.row

    }
    

}

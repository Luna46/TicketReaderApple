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
    
    //var back = Busqueda()
    //var count
    var count = 0
    var cargarListado = true
    
    

    @IBOutlet weak var tableView: UITableView!
    
        
    @IBOutlet weak var labelinformation: UILabel!
    
    //let textCellIdentifier = "TextCell"
    
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
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goToLastTickets(sender:)))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Resultado de la búsqueda"
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //editUserViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override public func viewDidLoad() {

        super.viewDidLoad()
        labelinformation.isHidden = true
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "power-icon"), style: .plain, target: nil, action: "some:")
        //tabBarController.
        
        //Sino existen tickets con la búsqueda ofrecida lo informamos.
        if TicketConstant.ticketList.count == 0 {
            labelinformation.isHidden = false
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
        cell.imageView?.image = UIImage(named: "Imagen1")
        
        return cell
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerSearch") as! PageViewControllerSearch
        
        datos.ticketListViewer = self
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.setIndexTouch(index: indexPath.row)
        //datos.indexTouch = indexPath.row

    }
    

}

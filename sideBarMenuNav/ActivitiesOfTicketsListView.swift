//
//  ActivitiesOfTicketsListView.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 6/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

public class ActivitiesOfTicketsListView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    
    @IBOutlet weak var labelInformation: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var activities = Array<Activities>()
    
    var filteredActivities = Array<Activities>()
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        
        filteredActivities = activities.filter{ store in
            return (store.getActividad().lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    
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
        navigationItem.title = "Tipos de comercio"
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //editUserViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        count += 1
        if count > 1 {
            
            
            
            _ = navigationController?.popViewController(animated: true)
            
            
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        labelInformation.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        let servidor = TicketWebServer()
        activities = servidor.activityOfTickets(userName: TicketConstant.Email)
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
        if activities.count == 0 {
            labelInformation.isHidden = false
            labelInformation.font = UIFont.boldSystemFont(ofSize: 16)
            labelInformation.text = "No existen tipos de comercio"
            tableView.isHidden = true
        }
        
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredActivities.count
        }
        
        return activities.count
    }
    
    //Configuración de nuestra lista de tickets.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            //stores = [filteredStores[indexPath.row]]
            //storesSelected = [filteredStores[indexPath.row]]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            cell.textLabel?.text = filteredActivities[indexPath.row].getActividad()
            return cell
        }
        else{
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            cell.textLabel?.text = activities[indexPath.row].getActividad()
            //cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
            //let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
            //cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
            //cell.imageView?.image = UIImage(named: "TICKETS-NOW")
            return cell
        }
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "Busqueda") as! Busqueda
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        //datos.indexTouch = indexPath.row
        if searchController.isActive && searchController.searchBar.text != "" {
            //datos.store = filteredStores[indexPath.row].getTotal()
            TicketConstant.tipo = filteredActivities[indexPath.row]
            datos.idType = filteredActivities[indexPath.row].getId()
            //datos.grupo = filteredStores[indexPath.row].getGrupo()
        }
        else{
            datos.idType = activities[indexPath.row].getId()
            TicketConstant.tipo = activities[indexPath.row]
        }
        
    }
    
    
}

extension ActivitiesOfTicketsListView: UISearchResultsUpdating{
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    

}

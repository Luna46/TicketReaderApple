//
//  StoreOfTicketsListView.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 1/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

public class StoreOfTicketsListView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var count = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelInformation: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var stores = Array<Comercio>()
    
    var filteredStores = Array<Comercio>()
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        
        filteredStores = stores.filter{ store in
            return (store.getGrupo().lowercased().contains(searchText.lowercased())  ||  store.getComercio().lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var labelInformation: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(hex: 0xa1d884)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: 0x5DB860)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 18)!]
        navigationItem.title = "Mis comercios"
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
            
            stores = servidor.storeOfTickets(userName: TicketConstant.Email)
            if stores.count == 0 {
                labelInformation.isHidden = false
                labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
                labelInformation.text = "No hay comercios existentes"
                tableView.isHidden = true
            }
            else{
                labelInformation.isHidden = true
                labelInformation.font = UIFont.boldSystemFont(ofSize: 17)
                labelInformation.text = "MIS COMERCIOS"
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
        self.searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 14)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        //searchController.setValue("Limpiar", forKey: "cancelButton")
        //let searchFont = UIFont(name: "AvenirNext-Regular", size: 11.0)
        //let cancelButton = searchController.searchBar.value(forKey: "_cancelButtonText") as! UIButton
        //cancelButton.setTitle("Limpiar", for: .normal)
        //cancelButton.titleLabel?.font = searchFont
        //var textFieldInsideSearchBar = searchController.searchBar.value(forKey: "cancelButton") as? UITextField
        //textFieldInsideSearchBar?.font = searchFont
        //searchController.searchBar.text
        
        let servidor = TicketWebServer()
        stores = servidor.storeOfTickets(userName: TicketConstant.Email)
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
        if stores.count == 0 {
            labelInformation.isHidden = false
            labelInformation.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            labelInformation.text = "No hay comercios existentes"
            tableView.isHidden = true
        }
        
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStores.count
        }
        
        return stores.count
    }
    
    //Configuración de nuestra lista de tickets.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            //stores = [filteredStores[indexPath.row]]
            //storesSelected = [filteredStores[indexPath.row]]
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
            //cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12.0)
            cell.detailTextLabel?.text = filteredStores[indexPath.row].getComercio()
            cell.detailTextLabel?.textColor = UIColor(hex: 0x279989)
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.textLabel?.text = filteredStores[indexPath.row].getGrupo()
            return cell
        }
        else{
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
            //cell.detailTextLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12.0)
            cell.detailTextLabel?.text = stores[indexPath.row].getComercio()
            cell.detailTextLabel?.textColor = UIColor(hex: 0x279989)
            cell.textLabel?.text = stores[indexPath.row].getGrupo()
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        //cell.textLabel?.text = TicketConstant.ticketList[indexPath.row].getGrupo() + ", " + TicketConstant.ticketList[indexPath.row].getComercio()
        //let fecha = String(describing: TicketConstant.ticketList[indexPath.row].getFecha())
        //cell.detailTextLabel?.text = fecha.substring(to: fecha.characters.index(of: "+")!)
        //cell.imageView?.image = UIImage(named: "TICKETS-NOW")
            return cell
        }
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let datos = self.storyboard?.instantiateViewController(withIdentifier: "SearchStoreTicketsListView") as! SearchStoreTicketsListView
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        //datos.indexTouch = indexPath.row
        if searchController.isActive && searchController.searchBar.text != "" {
            TicketConstant.comercio = filteredStores[indexPath.row]
            datos.store = filteredStores[indexPath.row].getTotal()
            datos.comercio = filteredStores[indexPath.row].getComercio()
            datos.grupo = filteredStores[indexPath.row].getGrupo()
        }
        else{
            TicketConstant.comercio = stores[indexPath.row]
            datos.store = stores[indexPath.row].getTotal()
            datos.comercio = stores[indexPath.row].getComercio()
            datos.grupo = stores[indexPath.row].getGrupo()
        }
        
    }
    
    
}

extension StoreOfTicketsListView: UISearchResultsUpdating{
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

//
//  PageViewControllerSearch.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

import UIKit

//CLASE QUE CREA LOS "FRAGMENTS" CON EL FILTRO DE BÚSQUEDA.
class PageViewControllerSearch: PageViewController {
    
    //var indexTouch: Int?
    //var count = 0
    var ticketListViewer = TicketList()
    
    
    @IBAction override func back(_ sender: Any) {
        
        self.performSegue(withIdentifier: "aLosT", sender: self)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        count += 1
        if count > 1 {
            
            _ = navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        let back = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(goToLastTickets(sender:)))
        navigationItem.leftBarButtonItem = back
        backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(putFavsSearch(sender:)))
        //backButton.tintColor = UIColor.orange
        viewControllerAtIndex(indexTouch!)
        navigationItem.rightBarButtonItem = backButton
        
        //tabBarController?.navigationController?.navigationBar.isHidden = false
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func putFavsSearch(sender: UIBarButtonItem) {
        
        putTicketfav(indexFav!)
        
    }
    
    override func goToLastTickets(sender: UIBarButtonItem) {
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "lastTickets") as! LastTicketsView
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        //TicketConstant.camino += 1
        //let a = self.navigationController?.viewControllers[0] as! TicketList
        //a.camino = 1
        ticketListViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {

        //super.viewDidLoad()
        //navigationItem.leftBarButtonItem = nil
        
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "power-icon"), style: .plain, target: nil, action: "some:")
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self.performSegue(withIdentifier: "aLosT", sender: self), action: "someAction:")
        
        dataSource = self
        setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: Page view controller data source

/**extension PageViewControllerSearch: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        
        if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex, pageIndex > 0 {
            return viewControllerAtIndex(pageIndex - 1, fav: 0)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex, pageIndex < TicketConstant.ticketList.count - 1 {
            return viewControllerAtIndex(pageIndex + 1, fav: 0)
        }
        
        return nil
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}*/

// MARK: View controller provider

/**extension PageViewControllerSearch: ViewControllerProvider {
    
    var initialViewController: UIViewController {
        //Pasamos el indice que nos han seleccionado desde la clase "TicketList"
        return viewControllerAtIndex(indexSearch!, fav: 0)!
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        return nil
    }
    
    func viewControllerAtIndex(_ index: Int, fav: Int) -> UIViewController? {
        
        //Aqui no hacemos comprobaciones de si están los tickets vacios (TicketList.swift)
        if let cardViewControllerSearch = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            let prueba = TicketWebServer()
            var ticket = Ticket()
            ticket = TicketConstant.ticketList[index]
            if fav == 1{
                ticket.setFav(fav: 1)
                //TODO LLamar a servidor
            }
            if ticket.getTicket()==nil{
                ticket = prueba.getTicket(idTicket: TicketConstant.ticketList[index].getIdticket())
            }
            
            cardViewControllerSearch.pageIndex = index
            cardViewControllerSearch.t = ticket
            cardViewControllerSearch.infor = ""
            
            return cardViewControllerSearch
        }
        
        return nil
    }
}*/

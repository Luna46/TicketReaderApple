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
class PageViewControllerSearch: UIPageViewController {
    
    var TableArray = [String]()
    var indexSearch: Int?
    
    @IBAction func back(_ sender: Any) {
        
        self.performSegue(withIdentifier: "aLosT", sender: self)
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self.performSegue(withIdentifier: "aLosT", sender: self), action: "someAction:")
        
        dataSource = self
        setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: Page view controller data source

extension PageViewControllerSearch: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        
        if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex, pageIndex > 0 {
            return viewControllerAtIndex(pageIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex, pageIndex < TicketConstant.ticketList.count - 1 {
            return viewControllerAtIndex(pageIndex + 1)
        }
        
        return nil
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

// MARK: View controller provider

extension PageViewControllerSearch: ViewControllerProvider {
    
    var initialViewController: UIViewController {
        //Pasamos el indice que nos han seleccionado desde la clase "TicketList"
        return viewControllerAtIndex(indexSearch!)!
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        
        //Aqui no hacemos comprobaciones de si están los tickets vacios (TicketList.swift)
        if let cardViewControllerSearch = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            let prueba = TicketWebServer()
            var ticket = Ticket()
            ticket = TicketConstant.ticketList[index]
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
}

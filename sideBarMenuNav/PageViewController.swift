//
//  PageViewController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import UIKit

//CLASE QUE CREA LOS "FRAGMENTS".
class PageViewController: UIPageViewController {
    
    @IBAction func back(_ sender: Any) {
        
        self.viewDidLoad()
        
        //self.performSegue(withIdentifier: "aLosT", sender: self)
        
    }
    var currentIndex : Int = 0
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var label: UILabel!
    var TableArray = [String]()
    
    func goToPage(index: Int) {
        //	viewControllerAtIndex(index)

            setViewControllers([viewControllerAtIndex(index)!], direction: .reverse, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        dataSource = self
        setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: Page view controller data source

extension PageViewController: UIPageViewControllerDataSource {
    
    
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

extension PageViewController: ViewControllerProvider {
    
    var initialViewController: UIViewController {
        
        TicketConstant.pageView = self
        
        let servidor = TicketWebServer()
        TicketConstant.ticketList = servidor.getTicketsByEmail(userEmail: TicketConstant.Email, bincludeAllTicket: false)
        return viewControllerAtIndex(TicketConstant.ticketList.count-1)!
        
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        
        //Existen tickets
        if index != -1 {
            if let cardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
                let prueba = TicketWebServer()
                var ticket = Ticket()
                ticket = TicketConstant.ticketList[index]
                if ticket.getTicket()==nil{
                    ticket = prueba.getTicket(idTicket: TicketConstant.ticketList[index].getIdticket())
                }
                
                cardViewController.pageIndex = index
                cardViewController.t = ticket
                cardViewController.infor = ""
                
                return cardViewController
            }
        }
            
        //No existen tickets y lo informamos.
        else{
            if let cardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
                cardViewController.infor = "No existen tickets para este usuario\nAcerque su teléfono al lector para obtener el ticket"
                return cardViewController
            }
            
        }
        
        
        
        return nil
    }
}

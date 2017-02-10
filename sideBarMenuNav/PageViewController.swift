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
    
    var indexTouch: Int?
    
    var count = 0
    
    var countView = 0
    
    var backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
                                                  style: .plain,
                                                  target: nil,
                                                  action: nil)
    
    var ticketList = SearchStoreTicketsListView()
    
    var indexFav : Int?
    
    var lastTicketView : Bool = false
    
    func getIndexTouch() -> Int {
        return indexTouch!
    }
    
    func setIndexTouch(index : Int) {
        self.indexTouch = index
    }
    
    @IBAction func off(_ sender: Any) {
        
        exit(0)
        
    }
    
    /***/
    
    
    @IBAction func information(_ sender: Any) {
        
        print("Implementar")
        
    }
    
    @IBAction func toEdit(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toEdit", sender: self)
        
    }
    
    @IBAction func toSearch(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toSearch", sender: self)
        
    }
    
    @IBAction func refreshTickets(_ sender: Any) {
        
        self.viewDidLoad()
        
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        countView += 1
        tabBarController?.navigationController?.navigationBar.isHidden = true
        tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let back = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(goToLastTickets(sender:)))
        navigationItem.leftBarButtonItem = back
        backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(putFavs(sender:)))
        if countView == 1{
            viewControllerAtIndex(indexTouch!)
        }
        navigationItem.rightBarButtonItem = backButton
    }
    
    func putFavs(sender: UIBarButtonItem) {
        
        //setViewControllers([initialViewControllerFav], direction: .forward, animated: false, completion: nil)

        putTicketfav(indexFav!)
        //TicketConstant.pageView = self
        
        //return viewControllerAtIndex(indexTouch!,fav: 1)
        
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "lastTickets") as! LastTicketsView
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        ticketList.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        count += 1
        if count > 1 {
            
            _ = navigationController?.popViewController(animated: true)
            
        }
        
         //backButton.tintColor = UIColor.blue
        
        //setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        tabBarController?.navigationController?.navigationBar.isHidden = false
        //let backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
                                         //style: .plain,
                                         //target: navigationController,
                                         //action: nil)        //let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        //navigationItem.leftBarButtonItem = backButton
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        dataSource = self
        //if lastTicketView {
            setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        //}
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
        
        //TicketConstant.pageView = self
        
        
        
        //let servidor = TicketWebServer()
        //TicketConstant.ticketList = servidor.getTicketsByEmail(userEmail: TicketConstant.Email, bincludeAllTicket: false)
        return viewControllerAtIndex(indexTouch!)!
        
    }
    
    
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        //Aqui no hacemos comprobaciones de si están los tickets vacios (TicketList.swift)
        if let cardViewControllerSearch = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            let webServer = TicketWebServer()
            var ticket = Ticket()
            ticket = TicketConstant.ticketList[index]
            
            if ticket.getTicket()==nil{
                ticket = webServer.getTicket(idTicket: TicketConstant.ticketList[index].getIdticket())
                TicketConstant.ticketList[index] = ticket
                
                
                
            }
            
            if (ticket.getFav()==0){
                backButton.tintColor = UIColor.gray
            }
            else{
                backButton.tintColor = UIColor.orange
            }
            
            cardViewControllerSearch.pageIndex = index
            cardViewControllerSearch.t = ticket
            cardViewControllerSearch.infor = ""
            
            indexFav = index
            
            return cardViewControllerSearch
        }
        
        
        
        return nil
    }
    
    
    
    func putTicketfav(_ index: Int) {
        
        //Aqui no hacemos comprobaciones de si están los tickets vacios (TicketList.swift)
        let servidor = TicketWebServer()
        var ticket = Ticket()
        ticket = TicketConstant.ticketList[index]
        //ticket = servidor.getTicket(idTicket: TicketConstant.ticketList[index].getIdticket())
        if (ticket.getFav() == 1){
            
            self.backButton.tintColor = UIColor.gray
            servidor.setTicketFav(idTicket: ticket.getIdticket(), fav: 0)
            ticket.setFav(fav: 0)
            
        }
        else{
            
            self.backButton.tintColor = UIColor.orange
            servidor.setTicketFav(idTicket: ticket.getIdticket(), fav: 1)
            ticket.setFav(fav: 1)
            
        }

        
        }
        
    
    
}

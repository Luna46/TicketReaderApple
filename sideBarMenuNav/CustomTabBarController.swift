//
//  CustomTabBarController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 26/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit
class CustomTabBarController: UITabBarController {
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
        style: .plain,
        target: navigationController,
        action: nil)
        //let back = UIBarButtonItem(title: "Últimos Tickets", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToLastTickets(sender:)))
        //let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.rightBarButtonItem = backButton
        TicketConstant.tabBar = self
        //navigationItem.leftBarButtonItem = back
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "lastTickets") as! LastTicketsView
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        //_ = navigationController?.popViewController(animated: true)
         }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            //self.performSegue(withIdentifier: "busqueda", sender: self)
            //self.tabBarController?.selectedIndex = 1
            NotificationCenter.default.post(name: .reload, object: nil)
        }
        else if(item.tag == 2) {
            print("Quien eres tu")
        }
        else if(item.tag == 0) {
            print("Quien eres 0")
        }
    }
    
};extension Notification.Name {
    static let reload = Notification.Name("reload")
}

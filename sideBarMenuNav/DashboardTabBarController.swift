//
//  DashboardTabBarController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 24/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit
class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.performSegue(withIdentifier: "toT", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = PageViewController()
        let icon1 = UITabBarItem(title: "Tickets", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
        item1.tabBarItem = icon1
        let item2 = Busqueda()
        let icon2 = UITabBarItem(title: "Buscar", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
        item2.tabBarItem = icon2
        let controllers = [item1,item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}

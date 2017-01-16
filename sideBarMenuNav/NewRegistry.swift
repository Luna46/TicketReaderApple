//
//  NewRegistry.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation

public class NewRegistry : UIViewController {
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.navigationController?.barHideOnSwipeGestureRecognizer
        
        //self.navigationController?.isNavigationBarHidden = true
        
        //self.performSegue(withIdentifier: "toRegistry", sender: self)
        
        //self.navigationItem.hidesBackButton = true
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Registro") as! Registro
        self.navigationController?.pushViewController(secondViewController, animated: true)
    
    }
    
}

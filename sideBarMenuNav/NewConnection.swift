//
//  NewConnection.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 12/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation

public class NewConnection : UIViewController {
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
}

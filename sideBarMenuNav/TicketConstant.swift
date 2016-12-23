//
//  TicketConstant.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

//Constantes estáticas de la aplicación.
public class TicketConstant {
    
    
    static var UID: String! = ""
    
    static var Usuario: String! = ""
    
    static var Password: String! = ""
    
    static var Email: String! = ""
    
    static var modeSend: Int = 0x04
    
    static var lastTicket: Ticket?
    
    static var IPAndPort: String = "192.168.1.50"
    
    static var ticketList = Array<Ticket>()
    
    static var colTickets : Ticket = Ticket()
    
    static var pageView : PageViewController = PageViewController()
    
    
}

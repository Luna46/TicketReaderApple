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
    
    static var IPAndPort: String = "212.36.69.111:8099"
    
    static var ticketListLast = Array<Ticket>()
    
    static var ticketListFav = Array<Ticket>()
    
    static var ticketList = Array<Ticket>()
    
    static var colTickets : Ticket = Ticket()
    
    static var pageView : LastTicketsView? = nil
    
    static var userAPIREST : String = "disatec"
    
    static var pwdAPIREST : String = "disatec2016wT316Ky"
    
    static var tag = Array<String>()
    
    static var ticketsFavs = Array<Ticket>()
    
    static var diasAtras : Int = 10
    
    static var fechaDesde : String = ""
    
    static var fechaHasta : String = ""
    
    static var comercio = Comercio()
    
    static var ciudad = City()
    
    static var tipo = Activities()
    
    static var alarmTicket = false
    
    static var tabBar = CustomTabBarController()
    
    static var refreshLast = false
    
}

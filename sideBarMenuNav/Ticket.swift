//
//  Ticket.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

//CLASE TICKET EN LA QUE DEFINIMOS EL OBJETO CON EL QUE VAMOS A TRABAJAR, CON SUS MÉTODOS GET Y SET.

class Ticket {
    var fecha: Date?
    var idTicket: Int?
    var uid: String?
    var grupo: String?
    var comercio: String?
    var ticket: String?
    var fav: Int?
    
    init(){
    }
    
    init(idTicket: Int, uid: String) {
        self.idTicket = idTicket
        self.uid = uid
    }
    
    init(idTicket: Int) {
        self.idTicket = idTicket
    }
    
    func getIdticket() -> Int {
        return idTicket!
    }
    
    func setIdticket(idTicket: Int) {
        self.idTicket = idTicket
    }
    
    func getUid() -> String {
        return uid!
    }
    
    func setUid(uid: String) {
        self.uid = uid
    }
    
    func setFav(fav: Int) {
        self.fav = fav
    }
    
    func getFav() -> Int {
        return fav!
    }
    
    func getGrupo() -> String {
        return grupo!
    }
    
    func setGrupo(grupo: String) {
        self.grupo = grupo
    }
    
    
    func getComercio() -> String {
        return comercio!
    }
    
    func setComercio(comercio: String) {
        self.comercio = comercio
    }
    
    
    func getTicket() -> String?{
        return ticket
    }
    
    func setTicket(ticket: String) {
        self.ticket = ticket
    }
    
    
    func getFecha() -> Date{
        return fecha!
    }
    
    func setFecha(fecha: Date) {
        self.fecha = fecha
    }

}

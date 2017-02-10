//
//  Comercio.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 1/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation


class Comercio {
    
    var grupo: String?
    var comercio: String = ""
    var id : Int! = 0
    
    
    init(){
    }
    
    
    func getGrupo() -> String {
        return grupo!
    }
    
    func setGrupo(grupo: String) {
        self.grupo = grupo
    }
    
    func getId() -> Int {
        return id!
    }
    
    func setId(id: Int) {
        self.id = id
    }
    
    func getComercio() -> String {
        return comercio
    }
    
    func setComercio(comercio: String) {
        self.comercio = comercio
    }
    
    func getTotal() -> String {
        var total = "\(grupo), \(comercio)"
        return total
    }
    
    
}

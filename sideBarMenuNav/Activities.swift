//
//  Activities.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 3/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation

class Activities {
    var id: Int! = 0
    var actividad: String! = ""
    
    
    init(){
    }
    
    
    func getId() -> Int {
        return id!
    }
    
    func setId(id: Int) {
        self.id = id
    }
    
    
    func getActividad() -> String {
        return actividad
    }
    
    func setActividad(actividad: String) {
        self.actividad = actividad
    }
    
}

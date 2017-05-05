//
//  City.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 3/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation

class City {
    
    var poblacion: String! = ""
    
    
    init(){
    }
    
    
    
    func getPoblacion() -> String {
        return poblacion
    }
    
    func setPoblacion(poblacion: String) {
        self.poblacion = poblacion
    }
}

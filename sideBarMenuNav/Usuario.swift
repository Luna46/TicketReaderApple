//
//  Usuario.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 6/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
class Usuario {
    
    var idUsuario: Int?
    var nombre: String?
    var password: String?
    var email: String?
    var sexo: Int!
    var edad: Int!
    
    
    
    func getIdUsuario() -> Int {
        return idUsuario!
    }
    
    func setIdUsuario(idUsuario: Int) {
        self.idUsuario = idUsuario
    }
    
    func getNombre() -> String {
        return nombre!
    }
    
    func setNombre(nombre: String) {
        self.nombre = nombre
    }
    
    func setSexo(sexo: Int) {
        self.sexo = sexo
    }
    
    func getSexo() -> Int? {
        return sexo
    }
    
    func getPassword() -> String {
        return password!
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    
    func getEmail() -> String {
        return email!
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    
    func getEdad() -> Int?{
        return edad
    }
    
    func setEdad(edad: Int) {
        self.edad = edad
    }
    
}

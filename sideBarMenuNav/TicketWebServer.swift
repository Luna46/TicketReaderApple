//
//  TicketWebServer.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

class TicketWebServer {
    
    //Conseguimos todos los tickets del dispositivo enlazado (Sólo UID).
    func getTicketsByEmail(userEmail: String, bincludeAllTicket: Bool) -> Array<Ticket> {
        
        var tickets = Array<Ticket>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/getResourcesByEmail/\(userEmail)/\(bincludeAllTicket)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
   
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count == 0 {
                        return tickets
                    }
                    else {
                        for index in 0...(todo.count)-1 {
                            
                            let t = Ticket()
                            t.setIdticket(idTicket: todo[index]["id"] as! Int)
                            tickets.append(t)
                            
                        }
                        
                    }

                }
            }

        }
        catch {
            print("Error security")
        }
        return tickets
    }
    
    func getUser(userEmail: String) -> Usuario {
        var user = Usuario()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/disatec.ticket.usuario/userEmail/\(userEmail)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? [String: AnyObject] {
                    //print("Synchronous\(todo)")
                    
                    let todoContraseña = todo["contraseña"] as? String
                    let todoEdad = todo["edad"] as? Int
                    let todoEmail = todo["email"] as? String
                    let todoIdUsuario = todo["idUsuario"] as? Int
                    let todoLogOff = todo["logOff"] as? Int
                    let todoNombre = todo["nombre"] as? String
                    let todoSexo = todo["sexo"] as? Int
                    
                    user.setPassword(password: todoContraseña!)
                    if todoEdad != nil{
                        user.setEdad(edad: todoEdad!)
                    }
                    user.setEmail(email: todoEmail!)
                    user.setIdUsuario(idUsuario: todoIdUsuario!)
                    user.setNombre(nombre: todoNombre!)
                    if todoSexo != nil{
                        user.setSexo(sexo: todoSexo!)
                    }
                }
                
            }
        }
        catch {
            print("Error user")
        }
        return user
    }
    
    func deleteTag(tag: String){
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/disatec.ticket.dispositivo/\(tag)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "DELETE";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            
        }
        catch {
            print("Error TAGS")
        }

    }
    
    func getTags(userEmail: String) -> Array<Tag> {
        var tags = Array<Tag>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/disatec.ticket.dispositivo/getByUser/\(userEmail)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count == 0 {
                        return tags
                    }
                    else {
                        for index in 0...(todo.count)-1 {
                            
                            //let t = Ticket()
                            var tag = Tag()
                            tag.setTag(uidTag: todo[index]["uid"] as! String)
                            tags.append(tag)
                            
                        }
                        
                    }
                    
                }
            }
        }
        catch {
            print("Error user")
        }
        return tags
    }
    
    func setTicketFav(idTicket: Int, fav: Int) {
        
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/setTicketFav/\(idTicket)/\(fav)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            var dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(dataVal)
            
        }
        catch {
            print("Error fav")
        }
        
        
    }
    
    //Conseguimos toda la información del ticket.
    func getTicket(idTicket: Int) -> Ticket {
        
        var t = Ticket()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/getTicketId/\(idTicket)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? [String: AnyObject] {
                    //print("Synchronous\(todo)")
                    
                    let todoTicket = todo["ticket"] as? String
                    let todoGrupo = todo["grupo"] as? String
                    let todoComercio = todo["comercio"] as? String
                    let todoFecha = todo["fecha"] as? String
                    let todoFav = todo["fav"] as? Int
                    //var favorito = Int(todoFav!)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    t.setIdticket(idTicket: idTicket)
                    t.setFecha(fecha: formatter.date(from: todoFecha!)!)
                    t.setGrupo(grupo: todoGrupo!)
                    t.setTicket(ticket: todoTicket!)
                    t.setComercio(comercio: todoComercio!)
                    t.setFav(fav: todoFav!)
                }

            }
        }
        catch {
            print("Error print")
        }
        return t
    }
    
    func activityOfTickets(userName: String) -> Array<Activities> {
        var tipos = Array<Activities>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchActivities/\(userName)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count == 0 {
                        return tipos
                    }
                    else {
                        for index in 0...(todo.count)-1 {
                            
                            let type = Activities()
                            type.setId(id: todo[index]["id"] as! Int)
                            type.setActividad(actividad: todo[index]["desActividad"] as! String)
                            tipos.append(type)
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        catch {
            print("Error citys")
        }
        return tipos
    }
    
    func cityOfTickets(userName: String) -> Array<City> {
        var ciudades = Array<City>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchStoresCity/\(userName)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count == 0 {
                        return ciudades
                    }
                    else {
                        for index in 0...(todo.count)-1 {
                            
                            let city = City()
                            city.setPoblacion(poblacion: todo[index]["poblacion"] as! String)
                            ciudades.append(city)
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        catch {
            print("Error citys")
        }
        return ciudades
    }
    
    func storeOfTickets(userName: String) -> Array<Comercio> {
        var comercios = Array<Comercio>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchStores/\(userName)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if let todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count == 0 {
                        return comercios
                    }
                    else {
                        for index in 0...(todo.count)-1 {
                            
                            let store = Comercio()
                            store.setComercio(comercio: todo[index]["comercio"] as! String)
                            store.setId(id: todo[index]["id"] as! Int)
                            store.setGrupo(grupo: todo[index]["grupo"] as! String)
                            comercios.append(store)
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        catch {
            print("Error store")
        }
        return comercios

    }
    
    //Recogemos los tickets filtrados por una búsqueda.
    
    
    func ticketSearchAndFav(userName: String, grupo: String, comercio: String, strDateFrom: String, strDateTo: String, bIncludeAllTicket: Bool, fav: Int) -> Array<Ticket> {
        var tickets = Array<Ticket>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchResources/\(userName)/\(grupo)/\(comercio)/\(strDateFrom)/\(strDateTo)/\(bIncludeAllTicket)/\(fav)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if var todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count != 0 {
                        for index in 0...(todo.count)-1{
                            
                            if todo[index]["id"] == nil {
                                
                                todo[index]["id"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["grupo"] == nil {
                                
                                todo[index]["grupo"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["comercio"] == nil {
                                
                                todo[index]["comercio"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["fecha"] == nil {
                                
                                todo[index]["fecha"] = "" as AnyObject?
                                
                            }
                            
                            let t = Ticket()
                            t.setIdticket(idTicket: todo[index]["id"] as! Int)
                            t.setGrupo(grupo: todo[index]["grupo"] as! String)
                            t.setComercio(comercio: todo[index]["comercio"] as! String)
                            t.setFav(fav: todo[index]["fav"] as! Int)
                            let todoFecha = todo[index]["fecha"] as? String
                            // create dateFormatter with UTC time format
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                            let date = dateFormatter.date(from: todoFecha!)// create   date from string
                            if date != nil {
                                // change to a readable time format and change to local time zone
                                dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm:ss- a"
                                dateFormatter.timeZone = NSTimeZone.local
                                let timeStamp = dateFormatter.string(from: date!)
                                t.setFecha(fecha: dateFormatter.date(from: timeStamp)!)
                                tickets.append(t)
                            }
                            
                        }
                    }
                        
                    else{
                        
                        return tickets
                        
                    }
                    
                }
                
                
                
            }
        }
            
        catch {
            print("Error")
        }
        return tickets
    }
    
    func editCuenta(user : Usuario, password : Bool, completionHandler: @escaping (String, NSError?) -> Void) -> URLSessionTask {
 
        let stringUser = "\(user.getIdUsuario())"
        let stringEdad = "\(user.getEdad())"
        let stringSexo = "\(user.getSexo())"
        let stringLogOff = "\(user.getLogOff())"
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let myUrl = NSURL(string: "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/disatec.ticket.usuario/\(user.getIdUsuario())/\(password)")
        
        
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "PUT";
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let params = ["idUsuario": stringUser, "nombre": user.getNombre(), "email": user.getEmail(), "edad": stringEdad, "sexo": stringSexo, "logOff": stringLogOff, "contraseña": user.getPassword()]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("Error 1")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString =  \(responseString)")
            completionHandler(responseString as! String, nil)
            
        }
        
        task.resume()
        return task
    }
    
    func buscarBuena(userName: String, idActividad: Int, idComercio: Int, poblacion: String, strDateFrom: String, strDateTo: String, bIncludeAllTicket: Bool, fav: Int) -> Array<Ticket> {
        var tickets = Array<Ticket>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchResources2/\(userName)/\(idActividad)/\(idComercio)/\(poblacion)/\(strDateFrom)/\(strDateTo)/\(bIncludeAllTicket)/\(fav)"
        let url: NSURL = NSURL(string: urlPath)!
        var request1 = URLRequest(url: url as URL)
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        
        request1.httpMethod = "GET";
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            
            print(response)
            
            do {
                if var todo = try JSONSerialization.jsonObject(with: dataVal, options: []) as? Array<[String: AnyObject]> {
                    //print("Synchronous\(todo)")
                    if todo.count != 0 {
                        for index in 0...(todo.count)-1{
                            
                            if todo[index]["id"] == nil {
                                
                                todo[index]["id"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["grupo"] == nil {
                                
                                todo[index]["grupo"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["comercio"] == nil {
                                
                                todo[index]["comercio"] = "" as AnyObject?
                                
                            }
                                
                            else if todo[index]["fecha"] == nil {
                                
                                todo[index]["fecha"] = "" as AnyObject?
                                
                            }
                            
                            let t = Ticket()
                            t.setIdticket(idTicket: todo[index]["id"] as! Int)
                            t.setGrupo(grupo: todo[index]["grupo"] as! String)
                            t.setComercio(comercio: todo[index]["comercio"] as! String)
                            t.setFav(fav: todo[index]["fav"] as! Int)
                            let todoFecha = todo[index]["fecha"] as? String
                            // create dateFormatter with UTC time format
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                            let date = dateFormatter.date(from: todoFecha!)// create   date from string
                            if date != nil {
                                // change to a readable time format and change to local time zone
                                dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm:ss- a"
                                dateFormatter.timeZone = NSTimeZone.local
                                let timeStamp = dateFormatter.string(from: date!)
                                t.setFecha(fecha: dateFormatter.date(from: timeStamp)!)
                                tickets.append(t)
                            }
                            
                        }
                    }
                        
                    else{
                        
                        return tickets
                        
                    }
                    
                }
                
                
                
            }
        }
            
        catch {
            print("Error")
        }
        return tickets

    }
    
    //POST's
    
    //Registro
    func sendUIDtoServer(Usuario: String, PassWord: String, Email: String, UID: String, token: String, edad: Int, sexo: Int, logoOff: Int, roletype: Int, completionHandler: @escaping (String, NSError?) -> Void) -> URLSessionTask {

        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let myUrl = NSURL(string: "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/register")

        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST";
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let params = ["Usuario": Usuario, "Contraseña": PassWord, "Email": Email, "UID": UID, "tocken": token, "Edad": edad, "Sexo": sexo, "logoOff": logoOff, "Roletype": roletype] as [String : Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in

            if error != nil {
                print("Error 1")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString =  \(responseString)")
            completionHandler(responseString as! String, nil)
            
        }
        
        task.resume()
        return task

        
    }
    
    //Login
    func loginUser(Email: String, Password: String, UID: String, tocken: String, completionHandler: @escaping (String, NSError?) -> Void) -> URLSessionTask {
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let myUrl = NSURL(string: "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/register/login")

        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST";
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let params = ["Email": Email, "Contraseña": Password, "UID": UID, "tocken": tocken]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("Error 1")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString =  \(responseString)")
            completionHandler(responseString as! String, nil)

        }
        
        task.resume()
        return task

    }
    
    //Eliminar
    func remove(Email: String, UID: String, completionHandler: @escaping (String, NSError?) -> Void) -> URLSessionTask {
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let myUrl = NSURL(string: "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/register/remove")
 
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST";
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let params = ["Email": Email, "UID": UID]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
 
            if error != nil {
                print("Error 1")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString =  \(responseString)")
            completionHandler(responseString as! String, nil)
            
        }
        
        task.resume()
        return task
        
    }
    
}

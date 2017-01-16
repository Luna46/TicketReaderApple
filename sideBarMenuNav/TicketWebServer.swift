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
                    print("Synchronous\(todo)")
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
                    print("Synchronous\(todo)")
                    
                    let todoTicket = todo["ticket"] as? String
                    let todoGrupo = todo["grupo"] as? String
                    let todoComercio = todo["comercio"] as? String
                    let todoFecha = todo["fecha"] as? String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    t.setFecha(fecha: formatter.date(from: todoFecha!)!)
                    t.setGrupo(grupo: todoGrupo!)
                    t.setTicket(ticket: todoTicket!)
                    t.setComercio(comercio: todoComercio!)
                }

            }
        }
        catch {
            print("Error print")
        }
        return t
    }
    
    //Recogemos los tickets filtrados por una búsqueda.
    func ticketsSearch(userName: String, grupo: String, comercio: String, strDateFrom: String, strDateTo: String, bIncludeAllTicket: Bool) -> Array<Ticket> {
        
        var tickets = Array<Ticket>()
        
        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let urlPath: String = "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/ticketPersistence/SearchResources/\(userName)/\(grupo)/\(comercio)/\(strDateFrom)/\(strDateTo)/\(bIncludeAllTicket)"
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
                    print("Synchronous\(todo)")
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
    func sendUIDtoServer(Usuario: String, PassWord: String, Email: String, UID: String, token: String, mensaje: String, completionHandler: @escaping (String, NSError?) -> Void) -> URLSessionTask {

        let loginString = NSString(format: "%@:%@", TicketConstant.userAPIREST, TicketConstant.pwdAPIREST)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        let myUrl = NSURL(string: "http://\(TicketConstant.IPAndPort)/TicketWeb/webresources/register")

        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST";
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let params = ["Usuario": Usuario, "Contraseña": PassWord, "Email": Email, "UID": UID, "tocken": token]
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

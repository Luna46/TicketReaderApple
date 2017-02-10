//
//  TagsListViews.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 26/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

public class TagsListViews: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        //TicketConstant.tag[0] = TicketConstant.UID
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TicketConstant.tag.count
    }
    
    //Configuración de nuestra lista de tickets.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        
        let tagSelected = TicketConstant.tag[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        cell.textLabel?.text = TicketConstant.tag[indexPath.row]
        
        
        return cell
    }
    
    //Conexión con los PageViewControllerSearch.swift
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prueba = TicketWebServer()
        var t = Ticket()
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date as Date)
        let myNSString = result as NSString
        var day = Int(result.substring(to: result.characters.index(of: "-")!))
        let startM = result.index(result.startIndex, offsetBy: 3)
        let endM = result.index(result.endIndex, offsetBy: -5)
        let rangeM = startM..<endM
        var month = Int(result.substring(with: rangeM))!
        let start = result.index(result.startIndex, offsetBy: 6)
        let end = result.index(result.endIndex, offsetBy: 0)
        let range = start..<end
        var year = Int(result.substring(with: range))!
        var resta10 = day! - 10
        if (resta10<=0){
            resta10 = 30 - resta10
            month = month - 1
            if(month == 0){
                month = 12
                year = year - 1
            }
        }
        var dayT = String(resta10)
        var monthT = String(month)
        var yearT = String(year)
        let resultResta = "\(dayT)-\(monthT)-\(yearT)"
        //var month = result.
        //var name = "Stephen"
        //var prueba = result.substring(with: NSRange(location: 0, length: 3))
        //var month = myNSString.substringWithRange(Range<String.Index>(start: myNSString.startIndex.advancedBy(3), end: myNSString.endIndex.advancedBy(-5))) //"llo, playgroun"
        
        TicketConstant.ticketList = prueba.ticketSearchAndFav(userName: TicketConstant.Email, grupo: "%20", comercio: "%20", strDateFrom: resultResta, strDateTo: result, bIncludeAllTicket: true, fav: 0)
        
        var comp = TicketConstant.ticketList
        
        //self.navigationController?.pushViewController(TicketList(), animated: false)
        
        //self.performSegue(withIdentifier: "siguiente", sender: self)
        
        self.performSegue(withIdentifier: "tab", sender: self)
        
        /**let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerSearch") as! PageViewControllerSearch
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexSearch = indexPath.row*/
        
    }
    
    
}

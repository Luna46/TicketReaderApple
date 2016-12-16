//
//  CardViewController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import UIKit

private let revealSequeId = "revealSegue"

//PINTAMOS LOS TICKETS DENTRO DE LOS "FRAGMENTS".
class CardViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var webView: UIWebView!
    
    var pageIndex: Int?
    var t : Ticket?
    var infor : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.label.text = infor
        
        //Hay tickets o no.
        var equal = (self.label.text == "")
        if equal {
            self.webView.loadHTMLString((t?.getTicket())!, baseURL: nil)
        }
  
    }
    
    
    func handleTap() {
        performSegue(withIdentifier: revealSequeId, sender: nil)
    }

}



//
//  CardViewControllerSearch.swift
//  sideBarMenuNav
//
//  Created by Miguel Angel Luna on 12/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

private let revealSequeId = "revealSegue"

class CardViewControllerSearch: UIViewController {
    
    //@IBOutlet fileprivate weak var webView: UIWebView!
    //@IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    //@IBOutlet var webView: UIWebView!
    
    var pageIndex: Int?
    var t : Ticket?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }*/
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //webView.delegate = self
        self.webView.scalesPageToFit = false
        self.webView.contentMode = .scaleAspectFit
        self.webView.loadHTMLString((t?.getTicket())!, baseURL: nil)
        //self.webView.addGestureRecognizer(tapRecognizer)
        //self.webView.loadHTMLString()
        
    }
    
    func handleTap() {
        performSegue(withIdentifier: revealSequeId, sender: nil)
    }
}

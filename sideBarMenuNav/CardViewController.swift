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
        
        let backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(putFavs(sender:)))
        backButton.tintColor = UIColor.orange
        navigationItem.rightBarButtonItem = backButton
        /**navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: "revealToggle:")*/
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.label.text = infor
        
        //Hay tickets o no.
        var equal = (self.label.text == "")
        if equal {
            //self.scrollView.scrollsToTop = true
            self.webView.loadHTMLString((t?.getTicket())!, baseURL: nil)
            webView.scrollView.delegate = self
            //webView.scrollView.contentOffset = CGPoint(x: CGFloat(100), y: CGFloat(100))
            //self.webView.scrollView.delegate = self
            //self.webView.isUserInteractionEnabled = true
            //self.webView.scrollView.isScrollEnabled = true
            //self.webView.scrollView.bounces = false
            //self.webView.scrollView.setContentOffset(self.webView.scrollView.center, animated: true)
            
            //self.webView.scrollView.isScrollEnabled = true
            /**let height = view.frame.height
            //let width = view.frame.width
            webView.autoresizesSubviews = false
            webView.translatesAutoresizingMaskIntoConstraints = true
            webView.scrollView.autoresizesSubviews = false
            webView.scrollView.translatesAutoresizingMaskIntoConstraints = true
            var frame: CGRect = webView.frame
            frame.size.height = height
            webView.frame = frame
            // fix height of scroll view as well
            self.webView.scrollView.translatesAutoresizingMaskIntoConstraints = true
            self.webView.scrollView.contentSize = CGSize(width: CGFloat(320), height: CGFloat((self.webView.frame.origin.y + self.webView.frame.size.height)))*/
            
            
        }
  
    }
    
    func putFavs(sender: UIBarButtonItem) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /**if (self.webView.scrollView.contentOffset.y >= self.webView.scrollView.contentSize.height - self.webView.scrollView.frame.size.height) {
            let bottomOffset = CGPoint(x: self.webView.scrollView.contentOffset.x, y: self.webView.scrollView.contentSize.height - self.webView.scrollView.bounds.size.height)
            self.webView.scrollView.setContentOffset(bottomOffset, animated: false)
        }*/
        /**var height = self.webView.scrollView.contentSize.height
        var frame = self.webView.scrollView.frame.size.height
        if (self.webView.scrollView.contentSize.height < self.webView.scrollView.frame.size.height) {
            self.webView.scrollView.isScrollEnabled = true
        }
        else {
            self.webView.scrollView.isScrollEnabled = true
        }*/
        var y = self.webView.scrollView.contentOffset.y
        var x = self.webView.scrollView.contentOffset.x
        if (y != 0){
            let bottomOffset = CGPoint(x: 0, y: y)
            self.webView.scrollView.setContentOffset(bottomOffset, animated: true)
        }
                
    }
    
    
    func handleTap() {
        performSegue(withIdentifier: revealSequeId, sender: nil)
    }

}



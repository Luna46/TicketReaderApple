//
//  UpdatePassword.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 30/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit

class UpdatePassWord: UIViewController {
    
    var count = 0
    var editUserViewer = EditUser()
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updatePassword(_ sender: Any) {
        
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        //tabBarController?.navigationController?.navigationBar.isHidden = true
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow-back-128"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goToLastTickets(sender:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        //tabBarController?.navigationController?.navigationBar.isHidden = false
        //navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        editUserViewer.cargarListado = false
        _ = navigationController?.popViewController(animated: true)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        
        count += 1

            if count > 1 {
                
                _ = navigationController?.popToRootViewController(animated: true)
            }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateButton.layer.cornerRadius = 10
        updateButton.clipsToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

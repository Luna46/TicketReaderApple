//
//  CustomTabBarController.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 26/1/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
import UIKit
class CustomTabBarController: UITabBarController {
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 94, green: 165, blue: 154, alpha: 0)ç
        var color = hexStringToUIColor(hex: "#279989")
        self.tabBar.barTintColor = UIColor(hex: 0x279989)
        let backButton = UIBarButtonItem(image: UIImage(named: "star_gold_256"),
        style: .plain,
        target: navigationController,
        action: nil)
        //let back = UIBarButtonItem(title: "Últimos Tickets", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToLastTickets(sender:)))
        //let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.rightBarButtonItem = backButton
        TicketConstant.tabBar = self
        //navigationItem.leftBarButtonItem = back
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if(cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6){
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func goToLastTickets(sender: UIBarButtonItem) {
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "lastTickets") as! LastTicketsView
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        //_ = navigationController?.popViewController(animated: true)
         }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            //self.performSegue(withIdentifier: "busqueda", sender: self)
            //self.tabBarController?.selectedIndex = 1
            NotificationCenter.default.post(name: .reload, object: nil)
        }
        else if(item.tag == 2) {
            print("Quien eres tu")
        }
        else if(item.tag == 0) {
            print("Quien eres 0")
        }
    }
    
};extension Notification.Name {
    static let reload = Notification.Name("reload")
}
extension UIColor {
    convenience init(hex: Int) {
        let r = hex / 0x10000
        let g = (hex - r*0x10000) / 0x100
        let b = hex - r*0x10000 - g*0x100
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
}

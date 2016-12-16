//
//  ViewControllerProvider.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import Foundation

import UIKit

//Necesaria para los fragments.
protocol ViewControllerProvider {
    var initialViewController: UIViewController { get }
    func viewControllerAtIndex(_ index: Int) -> UIViewController?
}

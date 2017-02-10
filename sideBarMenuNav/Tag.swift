//
//  Tag.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 7/2/17.
//  Copyright © 2017 Miguel Angel Luna. All rights reserved.
//

import Foundation
class Tag {
    
    var uidTag : String?

    func getTag() -> String {
        return uidTag!
    }
    
    func setTag(uidTag: String) {
        self.uidTag = uidTag
    }
    }

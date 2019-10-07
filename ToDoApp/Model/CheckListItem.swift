//
//  CheckListItem.swift
//  ToDoApp
//
//  Created by user on 03/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

class CheckListItem : NSObject {
    @objc var text = ""
    var checked = false
    
    func check() {
        checked = !checked
    }
}

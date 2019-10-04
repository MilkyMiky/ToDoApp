//
//  ToDoList.swift
//  ToDoApp
//
//  Created by user on 03/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


class ToDoList{
    
    var todos : [CheckListItem] = []
    
    init() {
        let c1 = CheckListItem()
        let c2 = CheckListItem()
        let c3 = CheckListItem()
        let c4 = CheckListItem()
        let c5 = CheckListItem()
        let c6 = CheckListItem()
        
        c1.text = "first"
        c2.text = "second"
        c3.text = "third"
        c4.text = "fourth"
        c5.text = "fifth"
        c6.text = "sixth"
        
        todos.append(c1)
        todos.append(c2)
        todos.append(c3)
        todos.append(c4)
        todos.append(c5)
        todos.append(c6)
    }
    
    func createToDo() -> CheckListItem {
        let item = CheckListItem()
        item.text = "Created item"
        todos.append(item)
        return item
    }
    
    func remove(items : [CheckListItem]) {
        for item in items {
            if let index = todos.firstIndex(of: item){
                todos.remove(at: index)
            }
        }
    }
    
    func move(item : CheckListItem, to index :Int){
        guard let currentIndex = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: currentIndex)
        todos.insert(item, at : index)
        
    }
}

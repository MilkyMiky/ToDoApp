//
//  ToDoList.swift
//  ToDoApp
//
//  Created by user on 03/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


class ToDoList{
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos : [CheckListItem] = []
    private var mediumPriorityTodos : [CheckListItem] = []
    private var lowPriorityTodos : [CheckListItem] = []
    private var noPriorityTodos : [CheckListItem] = []
    
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
        createTodo(c1, for: .medium)
        createTodo(c2, for: .low)
        createTodo(c3, for: .high)
        createTodo(c4, for: .no)
        createTodo(c5, for: .low)
        createTodo(c6, for: .medium)
    }
    
    func createTodo(_ item: CheckListItem, for priority: Priority, at index : Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
            
        case .low:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
            
        case .no:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
            
        }
    }
    
    func todoList(for priority: Priority) -> [CheckListItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func createToDo() -> CheckListItem {
        let item = CheckListItem()
        item.text = "Created item"
        mediumPriorityTodos.append(item)
        return item
    }
    
    func remove(_ item: CheckListItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high: highPriorityTodos.remove(at: index)
        case .medium: mediumPriorityTodos.remove(at: index)
        case .low: lowPriorityTodos.remove(at: index)
        case .no: noPriorityTodos.remove(at: index)
        }
    }
    
    func move(item : CheckListItem, from sourcePriority : Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex : Int){
        
        remove(item, from: sourcePriority, at: sourceIndex)
        createTodo(item, for: destinationPriority, at: destinationIndex)
        
    }
}

//
//  ViewController.swift
//  ToDoApp
//
//  Created by user on 03/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var toDoList : ToDoList
    
    private func priorityForSectionIndex(_ index: Int) -> ToDoList.Priority? {
        return ToDoList.Priority(rawValue: index)
    }
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = toDoList.todoList(for: .medium).count
        _ = toDoList.createToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = toDoList.todoList(for: priority)
                    let deleteRow = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[deleteRow]
                    toDoList.remove(item, from: priority, at: deleteRow)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder: NSCoder) {
        toDoList = ToDoList()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section){
            return toDoList.todoList(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        if let priority = priorityForSectionIndex(indexPath.section){
            let items = toDoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath){
            if let priority = priorityForSectionIndex(indexPath.section){
                let items = toDoList.todoList(for: priority)
                let item = items[indexPath.row]
                item.check()
                configureCheckmark(for : cell, with : item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = toDoList.todoList(for: priority)[indexPath.row]
            toDoList.remove(item, from: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let sourcePriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let item = toDoList.todoList(for: sourcePriority)[sourceIndexPath.row]
            toDoList.move(item: item, from: sourcePriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
    
    
    func configureText(for cell : UITableViewCell, with item: CheckListItem){
        if let checkmarkCell = cell as? ChecklistTableViewCell{
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem){
        guard let checkmarkCell = cell as? ChecklistTableViewCell
            else {
                return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = " + "
        } else {
            checkmarkCell.checkmarkLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todoList = toDoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let prirority = priorityForSectionIndex(indexPath.section)
                {
                    let item = toDoList.todoList(for: prirority)[indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        ToDoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String? = nil
        if  let priority = priorityForSectionIndex(section){
            switch(priority) {
            case .high: title = "High priority"
            case .medium:title = "Medium priority"
            case .low:title = "Low priority"
            case .no:title = "No priority"
            }
        }
        return title
    }
    
}

extension ChecklistViewController : AddItemViewControllerDelegate {
    func addItemViewContollerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = toDoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row : rowIndex, section:  ToDoList.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func editItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        
        for priority in ToDoList.Priority.allCases {
            let currentList = toDoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}


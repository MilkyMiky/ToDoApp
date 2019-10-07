//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by user on 03/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate : class {
    
    func addItemViewContollerDidCancel(_ controller: ItemDetailViewController)
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem)
    
    func editItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem)
}

class ItemDetailViewController: UITableViewController {
    
    weak var delegate: AddItemViewControllerDelegate?
    weak var todoList : ToDoList?
    weak var itemToEdit : CheckListItem?
    
    @IBOutlet weak var cancelBarbutton: UIBarButtonItem!
    @IBOutlet weak var addBar: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textField.text {
            item.text = text
            delegate?.editItemViewController(self, didFinishEditing: item)
        } else {
            if let item = todoList?.createToDo() {
                if let textFieldText = textField.text {
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.addItemViewController(self, didFinishAdding: item)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewContollerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit"
            textField.text = item.text
            addBar.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
}

extension ItemDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBar.isEnabled = false
        } else {
            addBar.isEnabled = true
        }
        
        return true
    }
}

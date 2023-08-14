//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike"
        itemArray.append(newItem2)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: TableViewDataSource
    //when you run tableView.reload you will call this function again
    
    //get amount of data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    //display data from model to cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //initialize item
        let item = itemArray[indexPath.row]
        //set textlabel to item.title
        cell.textLabel?.text = item.title
        //check mark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView Delegate Method
    //func when cell click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add boolean
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //add animation
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    //MARK: Add New Item
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        //initialize UITextField
        var textField = UITextField()
        //initialize alert
        let alert = UIAlertController(title: "Tambahkan Item Baru", message: "", preferredStyle: .alert)
        
        //action when click
        let action = UIAlertAction(title: "Tambah", style: .default) { action in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //encode
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //reload table
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

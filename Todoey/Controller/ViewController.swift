//
//  ViewController.swift
//  Todoey
//
//  Created by Bagus Rizky on 17/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var itemArray = [Entity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit", style: .default){
            action in
            
            //check
            if self.textField.text == "" {
                self.itemArray[indexPath.row].setValue(self.itemArray[indexPath.row].title, forKey: "title")
            }else{
                //set value
                self.itemArray[indexPath.row].setValue(self.textField.text, forKey: "title")
            }
            self.saveItems()
        }
        
        //add checklist
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //add animation
        //tableView.deselectRow(at: indexPath, animated: true)
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = self.itemArray[indexPath.row].title
            self.textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Add New Item
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        showPopUp(tvTitle: "Tambahkan Item Baru", tvButton: "Tambah", tvPlaceHolder: "Belajar")
    }
    
    //MARK: Model Manipulations Method
    func saveItems(){
        do{
            try context.save()
        }catch {
            print("error when save \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        let req : NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
           itemArray = try context.fetch(req)
        }catch {
            print("Error when loading \(error)")
        }
    }
    
    //MARK: PopUp
    func showPopUp(tvTitle:String, tvButton:String, tvPlaceHolder:String){
        //initialize alert
        let alert = UIAlertController(title: tvTitle, message: "", preferredStyle: .alert)
        
        //action when click
        let action = UIAlertAction(title: tvButton, style: .default) { action in
            
            let newItem = Entity(context: self.context)
            newItem.title = self.textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            //save
            self.saveItems()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = tvPlaceHolder
            self.textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

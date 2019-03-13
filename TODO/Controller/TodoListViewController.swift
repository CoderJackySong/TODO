//
//  ViewController.swift
//  TODO
//
//  Created by JackySong on 2019/3/13.
//  Copyright © 2019年 JackySong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
//        let newItem = Item()
//        newItem.title = "购买水杯"
//        itemArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "吃药"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "修改密码"
//        itemArray.append(newItem3)
//        for i in 4...120 {
//            let newItem = Item()
//            newItem.title = "第\(i)件事务"
//            itemArray.append(newItem)
//        }
        
        
    }
    
    //MARK: - Table  View DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none
//        if itemArray[indexPath.row].done == false {
//            cell.accessoryType = .none
//        }else{
//            cell.accessoryType = .checkmark
//        }
        return cell
    }
    //MARK:- Table View Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        self.saveItems()
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with:.none)
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "创建一个新项目..."
            textField = alertTextField
        }
        let action = UIAlertAction(title: "添加项目", style: .cancel) { (ation) in
        
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
           let data =  try encoder.encode(itemArray)
           try data.write(to: dataFilePath!)
        } catch {
            print("编码错误:\(error)")
        }
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf:dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
              itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("解码item错误！")
            }
            
        }
    }
    
}


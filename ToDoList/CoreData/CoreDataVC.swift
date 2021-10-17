//
//  CoreDataVC.swift
//  ToDoList
//
//  Created by Александр Жуков on 30.09.2021.
//

import UIKit
import CoreData

class CoreDataVC: UIViewController {
    
    let coreData = CoreDataInstance()
    var actionToEnableCD: UIAlertAction?
    var filteredItems: [TaskCD] = []

    
    @IBOutlet weak var searchBarCD: UISearchBar!
    @IBOutlet weak var tableViewCD: UITableView!
    
        
    @IBAction func editButtonCD(_ sender: UIBarButtonItem) {
        self.tableViewCD.setEditing(!tableViewCD.isEditing, animated: true)
        sender.title = (self.tableViewCD.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func addButtonCD(_ sender: Any) {
        let alert = UIAlertController(title: "Create new task", message: "Enter task name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            
            guard let textField = alert.textFields?.first, let text = textField.text else { return }

            self?.coreData.addNewTask(with: text)
            self?.filteredItems = self!.coreData.data
            self?.tableViewCD.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Task name..."
            alertTextField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        self.actionToEnableCD = okAction
        okAction.isEnabled = false
        present(alert, animated: true)

    }
        
    @objc func textChanged(_ sender:UITextField) {
        self.actionToEnableCD?.isEnabled  = (sender.text! != "")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredItems = coreData.data
        tableViewCD.delegate = self
        tableViewCD.dataSource = self
        searchBarCD.delegate = self
    }

}

extension CoreDataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coreData") as! CoreDataCell
        cell.nameLabelCD.text = filteredItems[indexPath.row].name
        
        if !filteredItems[indexPath.row].isCompleted {
                cell.accessoryType = .none
            } else if filteredItems[indexPath.row].isCompleted {
                cell.accessoryType = .checkmark
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            coreData.deleteTask(with: coreData.data[indexPath.row].name!)
            filteredItems = coreData.data
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coreData.complete(with: coreData.data[indexPath.row].name!)
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        coreData.changePosition(name: coreData.data[sourceIndexPath.row].name!, source: sourceIndexPath.row, destination: destinationIndexPath.row)
        filteredItems = coreData.data
    }
}


extension CoreDataVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 1 {
            filteredItems = coreData.data.filter {
                ($0.name?.lowercased().contains(searchText.lowercased()))!
            }
        } else {
            filteredItems = coreData.data
        }
        tableViewCD.reloadData()
    }
}

